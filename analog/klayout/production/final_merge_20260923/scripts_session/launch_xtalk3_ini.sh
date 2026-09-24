#!/bin/bash
# Slow-edge pulse-train crosstalk bench on ini (Rui 2026-09-23 15:45: realistic, slow digital edges).
# 3 lanes, each lane runs its invocations sequentially; each invocation = 2 ngspice runs (PrSFBp 1n / 100p), OMP 2 threads.
set -euo pipefail
cd ~/opendvs-sims/opendvs_reset_rise_20260921
export OMP_NUM_THREADS=2
export PATH=/usr/local/bin:$PATH
R19=source/openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.r19.spice
PROD=source/openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.spice
mkdir -p outputs/logs
run() {  # run <trise> <layout> <agg>
  local tr=$1 lay=$2 agg=$3 src
  [ "$lay" = r19 ] && src=$R19 || src=$PROD
  echo "$(date +%T) start e${tr}_${lay}_${agg}"
  python3 xtalk3.py --src $src --tag e${tr}_${lay}_${agg} --agg $agg --trise $tr --pdk /usr/local/share/pdk --jobs 2 > outputs/logs/xtalk3_e${tr}_${lay}_${agg}.log 2>&1 || echo "FAILED e${tr}_${lay}_${agg}"
  echo "$(date +%T) done  e${tr}_${lay}_${agg}"
}
lane1() { run 1u r19 rowoff;   run 10u r19 readline; run 100n r19 rowoff;   run 1u r19 pixrst_only;  run 1u prod rowoff; run 1u r19 rowon_only; }
lane2() { run 1u r19 readline; run 10u r19 rowoff;   run 100n r19 readline; run 10u r19 pixrst_only; run 10u prod rowoff; }
lane3() { run 100n r19 pixrst_only; run 100n prod rowoff; run 10u prod readline; run 1u prod readline; }
lane1 > outputs/logs/lane1.log 2>&1 &
lane2 > outputs/logs/lane2.log 2>&1 &
lane3 > outputs/logs/lane3.log 2>&1 &
wait
echo "$(date +%T) all lanes done" >> outputs/logs/lane1.log
