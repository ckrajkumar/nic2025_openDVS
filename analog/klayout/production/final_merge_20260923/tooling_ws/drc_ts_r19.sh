#!/bin/bash
# precheck decks on the test-structure subtree of the r19 wrapper vs the untouched final's
set -uo pipefail
cd ~/opendvs_final; mkdir -p drc_ts_r19
D=~/opendvs_final/precheck_scripts/drc_scripts/sky130A_mr.drc
run() { local gds=$1 mode=$2 tag=$3; ( s=$(date +%s); klayout -b -r $D -rd input=$gds -rd topcell=pixel_test_structure -rd report=$HOME/opendvs_final/drc_ts_r19/${tag}_${mode}.xml -rd thr=4 -rd $mode=true > drc_ts_r19/${tag}_${mode}.log 2>&1; echo "== $tag $mode $(( $(date +%s) - s )) s: $(grep -c "<item>" $HOME/opendvs_final/drc_ts_r19/${tag}_${mode}.xml 2>/dev/null) items" >> drc_ts_r19/${tag}_${mode}.log ) & }
for mode in feol beol offgrid; do run r19/pixel_test_structure.merged.gds $mode r19_ts; run drc/pixel_test_structure.final.gds $mode final_ts; done; wait
for f in drc_ts_r19/*.log; do echo "$f: $(tail -n1 $f)"; done
for mode in feol beol offgrid; do echo "-- $mode categories r19 | final"; diff <(grep -o "<category>[^<]*" drc_ts_r19/r19_ts_$mode.xml | sort | uniq -c) <(grep -o "<category>[^<]*" drc_ts_r19/final_ts_$mode.xml | sort | uniq -c) && echo "   identical category counts"; done
