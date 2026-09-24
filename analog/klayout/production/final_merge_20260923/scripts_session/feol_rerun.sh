#!/bin/bash
# FEOL precheck deck on the r19 wrapper, native KLayout, 32 threads, twice (a and b) to test determinism
set -uo pipefail
cd ~/opendvs_final; mkdir -p drc_feol_rerun
D=~/opendvs_final/precheck_scripts/drc_scripts/sky130A_mr.drc
for t in a b; do
  s=$(date +%s); klayout -b -r $D -rd input=$HOME/opendvs_final/r19/user_project_wrapper.gds -rd topcell=user_project_wrapper -rd report=$HOME/opendvs_final/drc_feol_rerun/feol_$t.xml -rd thr=32 -rd feol=true > drc_feol_rerun/feol_$t.log 2>&1
  echo "== feol $t $(( $(date +%s) - s )) s: $(grep -c "<item>" drc_feol_rerun/feol_$t.xml) items; $(grep -o "<category>[^<]*" drc_feol_rerun/feol_$t.xml | sort | uniq -c | sort -rn | head -3 | tr '\n' ' ')"
done
