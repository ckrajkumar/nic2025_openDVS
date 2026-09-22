#!/usr/bin/env -S -u LD_LIBRARY_PATH bash
# Re-extract the saved 2x2 (Magic RCC on rpgraca-ini, frozen production pipeline), install the
# reset_physical_pd netlist into the reset-rise simulation package and point its decks at it,
# and print the coupling-capacitance diff for vsf/vd/nRst vs the production netlist.
#   ./rcc_update.sh <tag>        e.g. ./rcc_update.sh edit20260921b
set -euo pipefail
TAG="${1:?tag}"; D="$(cd "$(dirname "$0")" && pwd)"; cd "$D"
SIM=~/research/projects/telluride/2025/nic_eventcam/openDVS-layout/debug/opendvs_reset_rise_20260921
INI=rpgraca-ini.wg0; W=".cache/opencode/opendvs-pex/edited-pixel-magic-20260921-v1"
K="$HOME/git/klayout/bin-release/klayout"; export LD_LIBRARY_PATH="$HOME/git/klayout/bin-release:$HOME/anaconda3/lib"
echo "== layout saved $(stat -c %y pixel_4tile_work.gds | cut -c1-19)"
echo "== 1. export openDVS_pixel2x2_top -> rcc/openDVS_pixel2x2_top.$TAG.gds"
cat > rcc/export_one.py <<PY
import pya
ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); c = ly.cell("openDVS_pixel2x2_top")
opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(c.cell_index()); ly.write("rcc/openDVS_pixel2x2_top.$TAG.gds", opt)
PY
"$K" -b -r rcc/export_one.py 2>&1 | grep -v libcurl || true
echo "== 2. Magic RCC on $INI"
ssh -o BatchMode=yes $INI "mkdir -p ~/$W && cat > ~/$W/openDVS_pixel2x2_top.$TAG.gds" < "rcc/openDVS_pixel2x2_top.$TAG.gds"
ssh -o BatchMode=yes $INI "cd ~/$W && bash ../rcc_pipeline_ini.sh $TAG openDVS_pixel2x2_top.$TAG.gds 2>&1 | grep -E 'inventory|sha256|caps:' ; \
  P=~/git/opendvs-pex-cadence-production-v1/pex_campaign_native/full_pvt_three_path_v1/sources/production_gds_v1; \
  python3 ../cc_diff.py \$P/openDVS_pixel2x2_magic_rcc_ngspice.spice $TAG/openDVS_pixel2x2_magic_rcc_ngspice.spice --nets vsf,vd,nRst --pixel 0 > $TAG/cc_diff_vsf_vd_nRst.pixel0.txt; \
  python3 ../cc_diff.py \$P/openDVS_pixel2x2_magic_rcc_ngspice.spice $TAG/openDVS_pixel2x2_magic_rcc_ngspice.spice --nets vsf,vd,nRst --pixel all > $TAG/cc_diff_vsf_vd_nRst.all_pixels.txt"
mkdir -p "$SIM/source/rcc_$TAG"
ssh -o BatchMode=yes $INI "cd ~/$W/$TAG && tar cf - openDVS_pixel2x2_magic_rcc_ngspice.spice openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.spice cc_diff_vsf_vd_nRst.*.txt output-hashes.txt input-hashes.txt composition_report.json magic.stdout magic.stderr" | tar xf - -C "$SIM/source/rcc_$TAG"
NEW="source/openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.$TAG.spice"
cp "$SIM/source/rcc_$TAG/openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.spice" "$SIM/$NEW"
echo "== 3. install into $SIM as $NEW"
cd "$SIM"
OLD=$(grep -o '^\.include source/[^ ]*' main.sp | head -1 | sed 's/^\.include //')
SHA=$(sha256sum "$NEW" | cut -d' ' -f1); NC=$(grep -c '^C' "$NEW"); NR=$(grep -c '^R' "$NEW")
VDN=$(grep -m1 '^C[0-9]* openDVS_pixel_0.vd openDVS_pixel_0.nRst ' "$NEW" || grep -m1 '^C[0-9]* openDVS_pixel_0.nRst openDVS_pixel_0.vd ' "$NEW")
VDIFFN=$(grep -m1 '^C[0-9]* openDVS_pixel_0.vdiff openDVS_pixel_0.nRst ' "$NEW" || grep -m1 '^C[0-9]* openDVS_pixel_0.nRst openDVS_pixel_0.vdiff ' "$NEW")
for f in main.sp batch.sp; do sed -i "s|^\.include $OLD|.include $NEW|" $f; done
python3 - "$NEW" "$SHA" "$NC" "$NR" "$VDN" "$VDIFFN" "$TAG" <<'PY'
import re, sys
new, sha, nc, nr, vdn, vdiffn, tag = sys.argv[1:]
p = "validate_package.py"; s = open(p).read()
s = re.sub(r"SOURCE = ROOT / '[^']*'[^\n]*", "SOURCE = ROOT / '%s'  # %s" % (new, tag), s)
s = re.sub(r"SOURCE: '[0-9a-f]{64}'", "SOURCE: '%s'" % sha, s)
s = re.sub(r"NEW_SOURCE = '[^']*'", "NEW_SOURCE = '%s'" % new, s)
s = re.sub(r"len\(caps\) == \d+\)[^\n]*", "len(caps) == %s)  # %s" % (nc, tag), s)
s = re.sub(r"len\(resistors\) == \d+\)[^\n]*", "len(resistors) == %s)  # %s" % (nr, tag), s)
s = re.sub(r"require\('vd-nRst direct card missing or changed', source.count\('[^']*'\) == 1\)", "require('vd-nRst direct card missing or changed', source.count('%s') == 1)" % vdn, s)
s = re.sub(r"require\('vdiff-nRst direct card missing or changed', source.count\('[^']*'\) == 1\)", "require('vdiff-nRst direct card missing or changed', source.count('%s') == 1)" % vdiffn, s)
# every earlier source path must still normalise to <DUT_SOURCE> for the claim-comment comparison
old_paths = set(re.findall(r"source/openDVS_pixel2x2_magic_rcc_ngspice\.reset_physical_pd[^' \n]*\.spice", s)) - {new}
anchor = ".replace(NEW_SOURCE, '<DUT_SOURCE>')"
extra = "".join("\n                .replace('%s', '<DUT_SOURCE>')" % o for o in sorted(old_paths) if ".replace('%s'" % o not in s)
s = s.replace(anchor, anchor + extra, 1)
open(p, "w").write(s)
PY
./validate_package.py --parse > /dev/null && echo "   validate_package.py --parse: OK" || { echo "!! validate_package.py failed"; ./validate_package.py --parse 2>&1 | tail -3; }
sha256sum README.md batch.sp main.sp provenance/*.json provenance/original_control.deck provenance/settings_comparison.diff run.sh source/*.spice "source/rcc_$TAG/openDVS_pixel2x2_magic_rcc_ngspice.spice" validate_package.py > SHA256SUMS
printf '\n- %s: decks switched to `%s` (sha256 %s; %s caps, %s res); previous sources kept; extraction artefacts in `source/rcc_%s/`.\n' "$(date +%F\ %H:%M)" "$NEW" "${SHA:0:12}…" "$NC" "$NR" "$TAG" >> README.md
grep -n '^\.include source' main.sp batch.sp
echo "== 4. coupling caps, pixel_0 (vs production netlist)"; cat "source/rcc_$TAG/cc_diff_vsf_vd_nRst.pixel0.txt"
