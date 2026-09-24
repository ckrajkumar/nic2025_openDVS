#!/bin/bash
# Sync the re-frozen reset netlist + tooling to the workstation mirror and relaunch the reset shards on both hosts.
set -uo pipefail
C=~/.cache/opencode/opendvs-pex/campaign-edit20260922r19-v1; cd "$C"; W=10.66.0.207
scp -q sources/openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.spice $W:$C/sources/ && scp -q tooling/v38l/reset_campaign.py $W:$C/tooling/v38l/ && echo "synced to ws"
ssh $W "cd $C && sha256sum sources/openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.spice | cut -c1-16 && python3 tooling/v38l/campaign_manifest.py --validate manifest.json | tail -1"
T=tooling/v38l; A="--manifest manifest.json --sources source_map.json --rung all"
run() { local name=$1; shift; nohup python3 "$@" --output "$C/runs/$name" > "logs/$name.log" 2>&1 < /dev/null & echo "   $name pid $!"; }
for k in 0 1 2; do run reset_quantus_$k $T/reset_campaign.py $A --paths quantus_rcc_spectre --shard $k/3; done
ssh $W "bash ~/launch_reset_ws.sh r19 8"
sleep 15; for k in 0 1 2; do echo "== ini reset_quantus_$k"; tail -c 300 logs/reset_quantus_$k.log; echo; done; pgrep -fa "[r]eset_campaign.py" | wc -l
