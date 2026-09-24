#!/bin/bash
set -euo pipefail
W=$HOME/opendvs_final; P=$W/project_audit_orig; R=$P/precheck_results
podman run --rm --name pc_audit_orig -e PDK_ROOT=$HOME/pdk -e PDK=sky130A -v $W:$W:Z -v $HOME/pdk:$HOME/pdk:Z -w $P docker.io/chipfoundry/mpw_precheck:latest python3 -m cf_precheck -i $P -p $HOME/pdk/sky130A -o $R/baseline_lvs lvs oeb
