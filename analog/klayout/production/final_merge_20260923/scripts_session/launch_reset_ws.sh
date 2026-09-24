#!/bin/bash
# launch_reset_ws.sh <tag> <reset_shards> : only the reset shards (magic_rcc x N + schematic) of campaign-edit20260922<tag>-v1 on the workstation
set -uo pipefail
TAG="${1:?tag}"; NR="${2:-8}"; C=~/.cache/opencode/opendvs-pex/campaign-edit20260922$TAG-v1; cd "$C"
T=tooling/v38l; A="--manifest manifest.json --sources source_map.json --rung all"
run() { local name=$1; shift; nohup python3 "$@" --output "$C/runs/$name" > "logs/$name.log" 2>&1 < /dev/null & echo "   $name pid $!"; }
for k in $(seq 0 $((NR-1))); do run reset_magic_r$k $T/reset_campaign.py $A --paths magic_rcc_ngspice --shard $k/$NR; done
run reset_schematic $T/reset_campaign.py $A --paths schematic_ngspice
sleep 20; pgrep -fa "[r]eset_campaign.py" | wc -l; for f in logs/reset_magic_r0.log logs/reset_schematic.log; do echo "== $f"; tail -c 300 $f; echo; done
