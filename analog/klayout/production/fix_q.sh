#!/bin/bash
# kill the mis-tagged q crosstalk run (it was writing xtalk_p_* files), fix the tag, relaunch
cd ~/opendvs-sims/opendvs_reset_rise_20260921
pkill -f "^/bin/bash ./run_q.sh" ; pkill -f "^bash ./run_q.sh"
pkill -f "xtalk.py --src source/openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.q"
pkill -f "ngspice -b -o outputs/xtalk/ngspice_p_"
pkill -f "ngspice -b -o outputs/q/ngspice_reset.log"
sleep 1
echo "== survivors:"; pgrep -fa "ngspice|xtalk|run_q" | grep -v pgrep
echo "== p raws:"; ls -la --time-style=+%H:%M:%S outputs/xtalk/xtalk_p_*.raw
sed -i 's/--tag p_\$agg/--tag q_$agg/' run_q.sh
echo "== tags:"; grep -n -- "--tag" run_q.sh
nohup ./run_q.sh > outputs/run_q.log 2>&1 < /dev/null &
sleep 3
echo "== running ngspice:"; pgrep -fa "ngspice -b" | grep -v pgrep | wc -l
