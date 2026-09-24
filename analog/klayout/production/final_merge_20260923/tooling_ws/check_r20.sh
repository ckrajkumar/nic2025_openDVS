#!/bin/bash
# r20 checks on the workstation: native precheck BEOL deck (32 thr) + cf_precheck non-LVS and LVS/OEB stages in two containers
set -uo pipefail
W=~/opendvs_final; P=$W/project; R=$P/precheck_results
ln -sfn $W/r20/user_project_wrapper.gds $P/gds/user_project_wrapper.gds; readlink -f $P/gds/user_project_wrapper.gds
rm -rf $R/full_r20_nonlvs $R/full_r20_lvs; mkdir -p $W/drc_r20
run() { local name=$1; shift; nohup podman run --rm --name pc_$name -e PDK_ROOT=$HOME/pdk -e PDK=sky130A -v $W:$W:Z -v $HOME/pdk:$HOME/pdk:Z -w $P docker.io/chipfoundry/mpw_precheck:latest \
  python3 -m cf_precheck -i $P -p $HOME/pdk/sky130A -o $R/full_r20_$name "$@" > $W/precheck_full_r20_$name.log 2>&1 < /dev/null & echo "   $name pid $!"; }
run nonlvs --skip-checks lvs oeb magic_drc
run lvs lvs oeb
D=~/opendvs_final/precheck_scripts/drc_scripts/sky130A_mr.drc
( s=$(date +%s); klayout -b -r $D -rd input=$W/r20/user_project_wrapper.gds -rd topcell=user_project_wrapper -rd report=$W/drc_r20/beol.xml -rd thr=32 -rd beol=true > $W/drc_r20/beol.log 2>&1; echo "== beol $(( $(date +%s) - s )) s: $(grep -c "<item>" $W/drc_r20/beol.xml) items" >> $W/drc_r20/beol.log ) > /dev/null 2>&1 &
sleep 5; podman ps --format "{{.Names}} {{.Status}}"
