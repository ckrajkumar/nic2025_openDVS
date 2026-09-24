#!/bin/bash
# build_campaign_prod.sh : campaign-edit20260922prod-v1 on ini = the three-path PVT campaign on the PRODUCTION pixel sources
# (full_pvt_three_path_v1/sources/production_gds_v1), tooling cloned from the r19 campaign, hashes re-frozen; then the Quantus runners.
set -euo pipefail
TAG=prod; REF=r19
B=~/.cache/opencode/opendvs-pex; C="$B/campaign-edit20260922$TAG-v1"; R="$B/campaign-edit20260922$REF-v1"
PROD=~/git/opendvs-pex-cadence-production-v1/pex_campaign_native/full_pvt_three_path_v1; S=$PROD/sources/production_gds_v1
sha() { sha256sum "$1" | cut -c1-64; }
[ -e "$C" ] && { echo "exists: $C"; exit 1; }
echo "== 1. clone tooling from $R"
mkdir -p "$C"/{quantus,sources,runs,logs}; cp -r "$R/tooling" "$C/"; cp "$R/campaign_status.py" "$C/"; cp "$B/campaign_dump.py" "$C/"
echo "== 2. production sources"
cp "$S/openDVS_pixel2x2_magic_rcc_ngspice.spice" "$C/sources/"
cp "$S/openDVS_pixel2x2_magic_rcc_composed.spice" "$C/sources/"
cp "$S/openDVS_pixel2x2_quantus_rcc_spectre.junction_corrected.spice" "$C/sources/"
cd "$C"
BS=$(sha sources/openDVS_pixel2x2_magic_rcc_ngspice.spice)
python3 tooling/v38l/derive_reset_netlist.py --path magic_rcc_ngspice --input sources/openDVS_pixel2x2_magic_rcc_ngspice.spice \
   --output sources/openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.spice --expected-input-sha256 "$BS"
diff <(tail -n +5 sources/openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.spice) sources/openDVS_pixel2x2_magic_rcc_ngspice.spice > /dev/null && echo "   reset body identical to base" || echo "   reset body differs from base (expected: header lines only)"
cmp -s sources/openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.spice "$S/openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.spice" && echo "   derived reset == production reset file" || echo "   derived reset != production reset file (header)"
echo "== 3. re-freeze source hashes in tooling/v38l"
NEWQ=$(sha sources/openDVS_pixel2x2_quantus_rcc_spectre.junction_corrected.spice)
NEWM=$BS
NEWMR=$(sha sources/openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.spice)
OLDQJ=$(sha "$R/sources/openDVS_pixel2x2_quantus_rcc_spectre.junction_corrected.spice")
OLDM=$(sha "$R/sources/openDVS_pixel2x2_magic_rcc_ngspice.spice")
OLDMR=$(sha "$R/sources/openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.spice")
for pair in "$OLDQJ:$NEWQ" "$OLDM:$NEWM" "$OLDMR:$NEWMR"; do
  o=${pair%%:*}; n=${pair##*:}
  cnt=$(grep -c "$o" tooling/v38l/static_campaign.py tooling/v38l/reset_campaign.py | awk -F: '{s+=$2} END{print s}')
  [ "$cnt" -ge 1 ] || { echo "   ERROR: old hash $o not found in the tooling"; exit 1; }
  sed -i "s/$o/$n/g" tooling/v38l/static_campaign.py tooling/v38l/reset_campaign.py; echo "   ${o:0:12} -> ${n:0:12} ($cnt places)"
done
sed -i "s/edit20260922$REF/edit20260922$TAG/g" tooling/v38l/*.py
echo "== 4. source_map.json + manifest"
sed -e "s#campaign-edit20260922$REF-v1#campaign-edit20260922$TAG-v1#g" -e "s#\"purpose\": \".*\"#\"purpose\": \"PRODUCTION pixel (collaborators' openDVS_pixel2x2, production_gds_v1 sources: Magic RCC composed/ngspice, Quantus junction-corrected v2) run through the same v38l three-path campaign as the r19 pixel, for the r19-vs-production comparison\"#" "$R/source_map.json" > source_map.json
python3 tooling/v38l/campaign_manifest.py --write manifest.json | tail -2
python3 tooling/v38l/campaign_manifest.py --validate manifest.json | tail -2
echo "== 5. probe: nominal rows, all three paths (static)"
python3 tooling/v38l/static_campaign.py --manifest manifest.json --sources source_map.json --output $C/runs/probe --rung nominal --jobs 3 > logs/probe.log 2>&1 || true
python3 campaign_status.py runs/probe | tail -8
echo "== built $C"
