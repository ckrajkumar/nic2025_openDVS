#!/usr/bin/env bash
# Reproduce the production Magic RCC pipeline on rpgraca-ini for a 2x2 GDS (top cell openDVS_pixel2x2_top):
#   magic extract_full_array.tcl -> top-name normalize -> compose DiffBn wrapper -> ngspice unit adapter
#   -> reset_physical_pd derivation.   Usage: rcc_pipeline_ini.sh <tag> <gds>
set -euo pipefail
TAG="$1"; GDS="$(readlink -f "$2")"
P=~/.cache/opencode/opendvs-pex/latest-production-pixel-magic-v1        # frozen production tool set
W=~/.cache/opencode/opendvs-pex/edited-pixel-magic-20260921-v1/$TAG; mkdir -p "$W"; cd "$W"
TOOL=~/git/opendvs-pex-cadence-production-v1/pex_campaign_native/full_pvt_three_path_v1
echo "== [$TAG] magic RCC extraction of $GDS"
cp "$P/extract_full_array.tcl" "$P/run_checked.tcl" .
sha256sum "$GDS" extract_full_array.tcl "$P/prefix/bin/magic" /usr/local/share/pdk/sky130A/libs.tech/magic/sky130A.magicrc > input-hashes.txt
env CAD_ROOT="$P/prefix/lib" CAMPAIGN_TCL="$W/extract_full_array.tcl" INPUT_GDS="$GDS" TOP_CELL=openDVS_pixel2x2_top OUTPUT_SPICE="$W/openDVS_pixel2x2_top_rcc.spice" \
  "$P/prefix/bin/magic" -dnull -noconsole -rcfile /usr/local/share/pdk/sky130A/libs.tech/magic/sky130A.magicrc run_checked.tcl > magic.stdout 2> magic.stderr
grep -E "Nets extracted|Nets output|exttospice" magic.stdout | tail -3
echo "== normalize top name"
sed 's/^\.subckt openDVS_pixel2x2_top /.subckt openDVS_pixel2x2 /' openDVS_pixel2x2_top_rcc.spice > openDVS_pixel2x2_rcc.top_name_normalized.spice
echo "== compose DiffBn wrapper"
python3 "$P/compose_diffbn_virtual.latest_production_v1.py" openDVS_pixel2x2_rcc.top_name_normalized.spice openDVS_pixel2x2_rcc_diffbn_virtual.spice --report composition_report.json
echo "== ngspice unit adapter (production_v2 transforms, hash/inventory gates lifted)"
python3 - <<'PY'
import importlib.util, sys, re, hashlib
from collections import Counter
spec = importlib.util.spec_from_file_location("adapt", "/home/rpgraca/git/opendvs-pex-cadence-production-v1/pex_campaign_native/full_pvt_three_path_v1/extraction/production_top_v1/adapt_ngspice.production_v2.py")
m = importlib.util.module_from_spec(spec); sys.modules["adapt"] = m; spec.loader.exec_module(m)
src = open("openDVS_pixel2x2_rcc_diffbn_virtual.spice", encoding="utf-8").read()
counts = Counter(); out = []
for ln, line in enumerate(src.splitlines(keepends=True), 1):
    body, ending = m._line_parts(line); tokens = body.split(); t = body
    if tokens and tokens[0].startswith("X"):
        if [x for x in m.MOS_MODELS if x in tokens]: t, _ = m._transform_mos_line(body, ln, counts)
        elif m.MIM_MODEL in tokens: t, _ = m._transform_mim_line(body, ln, counts)
    elif tokens and tokens[0].startswith("D"):
        tail = f" {m.DIODE_MODEL} area=32.49p"
        if not body.endswith(tail): raise SystemExit(f"unexpected diode tail line {ln}: {body!r}")
        t = body.removesuffix(" area=32.49p") + " area=32.49 pj=22.8 m=1"; counts["diode_tail"] += 1
    out.append(t + ending)
data = "".join(out).encode(); open("openDVS_pixel2x2_magic_rcc_ngspice.spice", "wb").write(data)
txt = "".join(out); inv = {"capacitors": sum(1 for l in txt.splitlines() if l.startswith("C")), "resistors": sum(1 for l in txt.splitlines() if l.startswith("R")),
       "mos": sum(1 for l in txt.splitlines() if l.startswith("X") and any(x in l for x in m.MOS_MODELS)), "mim": sum(1 for l in txt.splitlines() if m.MIM_MODEL in l), "diodes": sum(1 for l in txt.splitlines() if l.startswith("D"))}
print("   replacements", dict(counts)); print("   inventory", inv); print("   sha256", hashlib.sha256(data).hexdigest())
PY
echo "== reset_physical_pd derivation"
python3 "$TOOL/tooling_v37/derive_reset_netlist.py" --path magic_rcc_ngspice --input openDVS_pixel2x2_magic_rcc_ngspice.spice \
  --output openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.spice --expected-input-sha256 "$(sha256sum openDVS_pixel2x2_magic_rcc_ngspice.spice | cut -d' ' -f1)"
sha256sum openDVS_pixel2x2_magic_rcc_ngspice.spice openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.spice | tee output-hashes.txt
echo "   caps: $(grep -c '^C' openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.spice)  res: $(grep -c '^R' openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.spice)"
