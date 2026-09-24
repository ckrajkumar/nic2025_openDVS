#!/bin/bash
# One-shot collector of the r17b validation state (run from the server; foreground only).
echo "== $(date +%H:%M:%S) =="
ssh -o BatchMode=yes -o ConnectTimeout=8 rpgraca-workstation.wg0 'setopt +o nomatch 2>/dev/null; cd ~/opendvs-sims/opendvs_reset_rise_20260921
echo "ws load: $(cut -d" " -f1-3 /proc/loadavg)  ngspice: $(pgrep -c ngspice)"
echo "run_r17b.log lines: $(wc -l < outputs/run_r17b.log)"; grep -E "vdiff|ON |OFF |event|offset|row" outputs/run_r17b.log | tail -20
echo "gain: $(grep -c . outputs/ws_r17b/gain.log)"; grep -i "e-fold" outputs/ws_r17b/gain.log | tail -3
echo "te20n raws: $(ls outputs/xtalk/xtalk_r17b_te20n_rowoff_PrSFBp*.raw 2>/dev/null | wc -l)  xtalk raws: $(ls outputs/xtalk/xtalk_r17b_*.raw 2>/dev/null | wc -l)/8"
echo "pvt: raws $(ls outputs/pvt_r17b/*.raw 2>/dev/null | wc -l) summary: $(test -f outputs/pvt_r17b/summary.txt && echo yes || echo no)"
echo "stress raws: $(ls outputs/stress/stress_r17b_*.raw 2>/dev/null | wc -l)/4   r15a: $(ls outputs/stress/stress_r15a_*.raw 2>/dev/null | wc -l)/4"
echo "--- ws campaign ---"; cd ~/.cache/opencode/opendvs-pex/campaign-edit20260922r17b-v1 && python3 campaign_status.py runs/* 2>&1 | grep -E "results:|not-valid" '
ssh -o BatchMode=yes -o ConnectTimeout=8 rpgraca-ini.wg0 'cd ~/.cache/opencode/opendvs-pex/campaign-edit20260922r17b-v1
echo "--- ini campaign ---"; python3 campaign_status.py runs/* 2>&1 | grep -E "results:|not-valid|reset"
echo "--- tile lvs ---"; for t in prod r17b; do d=~/.cache/opencode/opendvs-pex/tile_lvs_$t; echo "$t: $(tail -n 1 $d/tile_lvs.log 2>/dev/null | cut -c1-100) | comp.out: $(test -f $d/comp.out && echo yes || echo no)"; done
pgrep -af "magicdnull|netgen" | grep -v pgrep | cut -c1-80'
