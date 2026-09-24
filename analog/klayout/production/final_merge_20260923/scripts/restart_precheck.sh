#!/bin/bash
# workstation: stop only the cf_precheck container (leave Magic extractions alone) and restart the non-LVS precheck on the current merged wrapper
for id in $(podman ps --format '{{.ID}} {{.Command}}' | grep -i "cf_pre" | cut -d' ' -f1); do podman kill $id >/dev/null 2>&1 && echo "killed $id"; done
sleep 2; rm -rf ~/opendvs_final/project/precheck_results/nonlvs
nohup bash ~/precheck_setup.sh > ~/precheck_nonlvs.log 2>&1 < /dev/null &
sleep 3; echo restarted
