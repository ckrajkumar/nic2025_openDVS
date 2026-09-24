#!/bin/bash
# netgen with the July setup (PDK sky130A_setup.tcl, July xschem pixel_4tile_schem.spice) on Magic 8.3.471 extractions:
# prod = the collaborators' pixel_4tile_layout_lvs2.spice (GS_ stripped), r19 = ~/netgen_r19/layout_vc.spice
set -uo pipefail
W=~/.cache/opencode/opendvs-pex/july_netgen_8347; cd "$W"
REF=~/git/opendvs-pex-cadence-production-v1/pixel_4tile_7_9; PDK=/usr/local/share/pdk/sky130A
sed 's/GS_//g' prod_layout_lvs2.gs.spice > prod_layout.spice
cp ~/netgen_r19/layout_vc.spice r19_layout.spice
for t in prod r19; do
  echo "== netgen $t $(date +%H:%M:%S)"
  ( time netgen -batch lvs "${t}_layout.spice pixel_4tile" "$REF/pixel_4tile_schem.spice pixel_4tile_schem" $PDK/libs.tech/netgen/sky130A_setup.tcl comp_$t.out ) > netgen_$t.log 2>&1
  tail -3 netgen_$t.log; grep -c Mismatch comp_$t.out
done
echo "== verdicts"; for t in prod r19; do echo "$t: $(grep -E 'Final result|Netlists' comp_$t.out | tr '\n' ' ')"; done
echo "== sorted-diff lines prod vs r19: $(diff <(grep -v '^$' comp_prod.out | sed 's/  */ /g' | sort -u) <(grep -v '^$' comp_r19.out | sed 's/  */ /g' | sort -u) | wc -l)"
