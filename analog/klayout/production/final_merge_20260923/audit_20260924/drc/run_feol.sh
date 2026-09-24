#!/bin/bash
set -uo pipefail
for m in feol offgrid; do
  s=$(date +%s); klayout -b -r /home/rpgraca/opendvs_final/precheck_scripts/drc_scripts/sky130A_mr.drc -rd input=$HOME/opendvs_final/r21b/user_project_wrapper.gds -rd topcell=user_project_wrapper -rd report=/home/rpgraca/opendvs_final/audit_drc/${m}_r21b.xml -rd thr=16 -rd $m=true > /home/rpgraca/opendvs_final/audit_drc/${m}_r21b.log 2>&1
  echo "== $m $(( $(date +%s) - s )) s: $(grep -c "<item>" /home/rpgraca/opendvs_final/audit_drc/${m}_r21b.xml) items" >> /home/rpgraca/opendvs_final/audit_drc/${m}_r21b.log
done
