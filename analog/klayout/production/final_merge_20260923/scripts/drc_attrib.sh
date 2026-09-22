#!/bin/bash
# workstation: MR deck (feol+beol) on the prod / r17b / r18 tile exports (production cell names) to attribute the new items
set -uo pipefail; cd ~/opendvs_final; mkdir -p drc
D=~/opendvs_final/precheck_scripts/drc_scripts/sky130A_mr.drc
run() { local gds=$1 mode=$2 tag=$3; ( klayout -b -r $D -rd input=$gds -rd topcell=pixel_4tile -rd report=$HOME/opendvs_final/drc/${tag}_${mode}.xml -rd thr=5 -rd $mode=true > drc/${tag}_${mode}.log 2>&1; echo "== $tag $mode: $(grep -c '<item>' drc/${tag}_${mode}.xml 2>/dev/null) items: $(grep -o '<category>[^<]*</category>' drc/${tag}_${mode}.xml | sort | uniq -c | sort -rn | head -5 | tr '\n' ' ')" >> drc/${tag}_${mode}.log ) & }
for mode in feol beol; do run $HOME/tile_r15a/pixel_4tile.prod.gds $mode prod_tile; run $HOME/tile_r15a/pixel_4tile.r17b.gds $mode r17b_tile; run merged/pixel_4tile.r18.gds $mode r18_tile; done
wait; echo "ATTRIB DONE $(date +%H:%M:%S)"; for t in prod_tile r17b_tile r18_tile; do for m in feol beol; do tail -n 1 drc/${t}_${m}.log; done; done
