#!/bin/bash
# CACE 2x2 testbenches over the full yaml enumerations (5 corners x 3 temps x 3 vdd x biases), schem and r19 (Magic RCC).
set -uo pipefail
export PDK=sky130B PDK_ROOT=/usr/local/share/pdk PATH=$HOME/.venvs/cace/bin:/usr/local/bin:$PATH
export OMP_NUM_THREADS=1 SPICE_LIB_DIR=$HOME/opendvs-cace/ngspice_lib
cd ~/opendvs-cace/analog/cace
run() { local src=$1 tb=$2 par=$3 j=$4; local y=Pixel${tb}_2x2_full_${src}.yaml
  echo "$(date +%T) start $src $tb"; timeout 10h cace $y -s schematic -p $par --run-path ~/opendvs-cace/root_$src/runs -j $j -l INFO --no-progress-bar --nofail --no-plot > ~/opendvs-cace/logs/cace_full_${src}_${tb}.log 2>&1; echo "$(date +%T) done $src $tb exit $?"; }
run schem Photoreceptor dc_sweep 8
run schem GainAC pixel_ac_gain 8
run schem ResetTran reset_tran 8
run schem Comparators comparator_dc 8
run r19 Photoreceptor dc_sweep 8
run r19 Comparators comparator_dc 8
run schem AutoReadLine autoread_tran 8
echo "$(date +%T) ALL DONE"
