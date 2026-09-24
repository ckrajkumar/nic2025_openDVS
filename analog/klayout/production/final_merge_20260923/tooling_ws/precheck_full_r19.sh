#!/bin/bash
# Full cf_precheck 1.3.7 on the r19 wrapper, three containers in parallel: all non-LVS checks (KLayout decks at 32 threads),
# the LVS+OEB stage, and the optional Magic DRC. Outputs under project/precheck_results/full_r19_{nonlvs,lvs,magicdrc}.
set -uo pipefail
W=~/opendvs_final; P=$W/project; R=$P/precheck_results
echo "gds: $(readlink -f $P/gds/user_project_wrapper.gds)  sha $(sha256sum $(readlink -f $P/gds/user_project_wrapper.gds) | cut -c1-16)"
rm -rf $R/full_r19_nonlvs $R/full_r19_lvs $R/full_r19_magicdrc; mkdir -p $R
run() { local name=$1; shift; nohup podman run --rm --name pc_$name -e PDK_ROOT=$HOME/pdk -e PDK=sky130A -v $W:$W:Z -v $HOME/pdk:$HOME/pdk:Z -w $P docker.io/chipfoundry/mpw_precheck:latest \
  python3 -m cf_precheck -i $P -p $HOME/pdk/sky130A -o $R/full_r19_$name "$@" > $W/precheck_full_r19_$name.log 2>&1 < /dev/null & echo "   $name pid $!"; }
run nonlvs --skip-checks lvs oeb magic_drc
run lvs lvs oeb
run magicdrc --magic-drc magic_drc
sleep 20; podman ps --format "{{.Names}} {{.Status}}"; nproc; uptime
