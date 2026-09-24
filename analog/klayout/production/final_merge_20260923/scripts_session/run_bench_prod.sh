#!/bin/bash
# workstation: the r19 bench set on the PRODUCTION Magic RCC netlist (campaign reset source, 660 caps), tag prod; plus the OnBn x PrSFBp threshold grid on r19
set -uo pipefail; cd ~/opendvs-sims/opendvs_reset_rise_20260921
SRC=source/openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.spice; sha256sum $SRC | cut -c1-16
R19=source/openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.r19.spice
mkdir -p outputs/prod outputs/ws_prod
sed -e "s#reset_physical_pd\.r19\.spice#reset_physical_pd.spice#" -e "s#outputs/r19#outputs/prod#g" -e "s#reset_rise_r19#reset_rise_prod#g" -e "s#--tag r19_#--tag prod_#" -e "s#xtalk_r19_#xtalk_prod_#g" -e "s#--jobs 2#--jobs 1#" run_r19.sh > run_prod.sh; chmod +x run_prod.sh
grep -n "SRC=\|--tag\|outputs/prod" run_prod.sh | head -5
nohup ./run_prod.sh > outputs/run_prod.log 2>&1 < /dev/null &
nohup python3 thr_gain.py --src $SRC --tag gain_prod --cases "g2_95p:2:IPrSFBp=1n;g05_95p:0.5:IPrSFBp=1n" > outputs/ws_prod/gain.log 2>&1 < /dev/null &
nohup python3 xtalk.py --src $SRC --tag prod_te20n_rowoff --agg rowoff --tedge 20n --sets "IPrSFBp=1n;IPrSFBp=100p" --jobs 1 > outputs/ws_prod/te20n.log 2>&1 < /dev/null &
SETS=$(grep -o "^corner[a-z]*_temp[0-9-]*[a-zA-Z0-9_]*" outputs/pvt_l/summary.txt | python3 -c '
import sys, re
out = []
for n in sys.stdin.read().split():
    kv = []
    for tok in n.split("_"):
        m = re.match(r"(corner|temp)(.*)", tok)
        if m: kv.append("%s=%s" % (m.group(1), m.group(2))); continue
        m = re.match(r"([A-Za-z]+)([0-9]+[a-z])", tok); kv.append("I%s=%s" % (m.group(1), m.group(2)))
    out.append(",".join(kv))
print(";".join(out))')
echo "pvt sets: $(echo "$SETS" | tr ";" "\n" | wc -l)"
nohup python3 pvt_sweep.py --src $SRC --tag prod --sets "$SETS" --jobs 4 > outputs/pvt_prod.log 2>&1 < /dev/null &
for sc in bounce bounce_reset; do nohup python3 stress.py --src $SRC --tag prod --scenario $sc --jobs 1 > outputs/ws_prod/stress_$sc.log 2>&1 < /dev/null & done
THR=$(python3 -c 'print(";".join("IOnBn=%s,IPrSFBp=%s" % (o, p) for o in ("10n","20n","30n","50n","70n","100n","200n","500n") for p in ("100p","300p","1n","3.5n")))')
nohup python3 pvt_sweep.py --src $R19 --tag thr_r19 --sets "$THR" --jobs 3 > outputs/pvt_thr_r19.log 2>&1 < /dev/null &
sleep 5; echo "ngspice: $(pgrep -c ngspice)"; uptime | cut -d, -f3-
