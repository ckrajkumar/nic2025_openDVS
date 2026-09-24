#!/bin/bash
# FEOL deck inside the precheck image (KLayout 0.29.12) on the r19 wrapper with 32 and with 8 threads
set -uo pipefail
W=~/opendvs_final; cd $W; mkdir -p drc_feol_rerun
D=/usr/local/lib/python3.9/site-packages/cf_precheck/drc_scripts/sky130A_mr.drc
for t in 32 8; do
  s=$(date +%s)
  podman run --rm --name feol_t$t -v $W:$W:Z -w $W docker.io/chipfoundry/mpw_precheck:latest \
    klayout -b -r $D -rd input=$W/r19/user_project_wrapper.gds -rd topcell=user_project_wrapper -rd report=$W/drc_feol_rerun/feol_c$t.xml -rd thr=$t -rd feol=true > drc_feol_rerun/feol_c$t.log 2>&1
  echo "== container feol thr=$t $(( $(date +%s) - s )) s: $(grep -c "<item>" drc_feol_rerun/feol_c$t.xml) items; $(grep -o "<category>[^<]*" drc_feol_rerun/feol_c$t.xml | sort | uniq -c | sort -rn | head -3 | tr '\n' ' ')"
done
