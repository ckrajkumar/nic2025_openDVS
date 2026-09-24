#!/bin/bash
# workstation: precheck DRC decks (sky130A_mr.drc feol/beol/offgrid) on the merged tile + test structure, and on the original final tile as baseline
set -uo pipefail
cd ~/opendvs_final; mkdir -p drc
D=~/opendvs_final/precheck_scripts/drc_scripts/sky130A_mr.drc
[ -s drc/pixel_4tile.final.gds ] || klayout -b -r ~/opendvs_final/final_subtree.py 2>&1 | grep -v xschem | tail -2
run() { local gds=$1 top=$2 mode=$3 tag=$4; ( s=$(date +%s); klayout -b -r $D -rd input=$gds -rd topcell=$top -rd report=$HOME/opendvs_final/drc/${tag}_${mode}.xml -rd thr=6 -rd $mode=true > drc/${tag}_${mode}.log 2>&1; echo "== $tag $mode done in $(( $(date +%s) - s )) s: $(grep -c "<item>" $HOME/opendvs_final/drc/${tag}_${mode}.xml 2>/dev/null) items" >> drc/${tag}_${mode}.log ) & }
for mode in feol beol offgrid; do
  run merged/pixel_4tile.merged.gds pixel_4tile $mode merged_tile
  run drc/pixel_4tile.final.gds pixel_4tile $mode final_tile
  run merged/pixel_test_structure.merged.gds pixel_test_structure $mode merged_ts
  run drc/pixel_test_structure.final.gds pixel_test_structure $mode final_ts
done
wait
echo "ALL DRC DONE $(date +%H:%M:%S)"
for f in drc/*_feol.log drc/*_beol.log drc/*_offgrid.log; do echo "$f: $(tail -n 1 $f)"; done
