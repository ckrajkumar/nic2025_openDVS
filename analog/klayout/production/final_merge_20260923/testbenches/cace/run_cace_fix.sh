#!/bin/bash
set -uo pipefail
export PDK=sky130B PDK_ROOT=/usr/local/share/pdk PATH=$HOME/.venvs/cace/bin:/usr/local/bin:$PATH
export OMP_NUM_THREADS=2 SPICE_LIB_DIR=$HOME/opendvs-cace/ngspice_lib
COND=typ
cd ~/opendvs-cace/analog/cace
run() { local src=$1 tb=$2 par=$3; local y=Pixel${tb}_2x2_${COND}_${src}.yaml
  echo "$(date +%T) start $src $tb"; timeout 6h cace $y -s schematic -p $par --run-path ~/opendvs-cace/root_$src/runs -j 3 -l INFO --no-progress-bar --nofail > ~/opendvs-cace/logs/cace_${COND}_${src}_${tb}.log 2>&1; echo "$(date +%T) done $src $tb exit $?"; }
for src in r19 prod; do run $src Photoreceptor dc_sweep; run $src GainAC pixel_ac_gain; run $src ResetTran reset_tran; run $src Comparators comparator_dc; done
echo "$(date +%T) ALL DONE"
