#!/bin/bash
# CACE 2x2 testbenches, typical conditions, four DUT sources (schem, r19, prod, calibre) on ini.
# Order per source: Photoreceptor, GainAC, ResetTran, Comparators (its input-referred thresholds look up the gain and reset
# results in the same root), then AutoReadLine last (long transient) for schem and r19 only.
set -uo pipefail
export PDK=sky130B PDK_ROOT=/usr/local/share/pdk PATH=$HOME/.venvs/cace/bin:/usr/local/bin:$PATH
export OMP_NUM_THREADS=2 SPICE_LIB_DIR=$HOME/opendvs-cace/ngspice_lib
COND=${1:-typ}
cd ~/opendvs-cace/analog/cace
run() {  # run <src> <TB> <param>
  local src=$1 tb=$2 par=$3
  local y=Pixel${tb}_2x2_${COND}_${src}.yaml
  echo "$(date +%T) start $src $tb ($par)"
  timeout 6h cace $y -s schematic -p $par --run-path ~/opendvs-cace/root_$src/runs -j 3 -l INFO --no-progress-bar --nofail \
      > ~/opendvs-cace/logs/cace_${COND}_${src}_${tb}.log 2>&1
  echo "$(date +%T) done  $src $tb exit $?"
}
mkdir -p ~/opendvs-cace/logs
for src in schem r19 prod calibre; do
  run $src Photoreceptor dc_sweep
  run $src GainAC pixel_ac_gain
  run $src ResetTran reset_tran
  run $src Comparators comparator_dc
done
for src in schem r19 prod calibre; do
  run $src AutoReadLine autoread_tran
done
echo "$(date +%T) ALL DONE"
