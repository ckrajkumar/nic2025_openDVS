#!/bin/bash
set -euo pipefail
W=$HOME/opendvs_final
podman run --rm --name pc_audit_expA -v $W:$W:Z -v $HOME/pdk:$HOME/pdk:Z -w /home/rpgraca/opendvs_final/audit_lvs/expA docker.io/chipfoundry/mpw_precheck:latest bash -c "netgen -batch source /home/rpgraca/opendvs_final/audit_lvs/expA/lvs.script > /home/rpgraca/opendvs_final/audit_lvs/expA/netgen.log 2>&1"
