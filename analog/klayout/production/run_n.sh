#!/bin/bash
# edit20260922n on the workstation: Rui's reset TB (nominal) + crosstalk TB (reset / rowoff / readline aggressors) at I_sf 95 and 5 pA
set -uo pipefail; cd ~/opendvs-sims/opendvs_reset_rise_20260921
SRC=source/openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.n.spice
mkdir -p outputs/n
# 1. Rui's TB, 300 us window, n include
sed -e "s#^\.include source/\S*reset_physical_pd\S*\.spice#.include $SRC#" -e "s#^\.tran .*#.tran 20n 0.300m 0m 20n#" -e "s#^write outputs/\S*#write outputs/n/reset_rise_n.raw v(vdiffsense) v(onsense) v(noffsense) v(vdsense) v(vsfsense) v(nrstsense) v(vprsense) v(pixrst)#" -e "s#^\.save all##" main.sp > outputs/n/main_n.sp
( ngspice -b -o outputs/n/ngspice_reset.log outputs/n/main_n.sp > /dev/null 2>&1; python3 analyze_raw.py outputs/n/reset_rise_n.raw > outputs/n/reset_rise_n.txt 2>&1 ) &
# 2. crosstalk TB
for agg in reset rowoff readline; do python3 xtalk.py --src $SRC --tag n_$agg --agg $agg --sets "IPrSFBp=1n;IPrSFBp=100p" --jobs 2 > outputs/n/run_$agg.log 2>&1 & done
wait
echo "== reset TB"; grep -i "crossing\|end\|min" outputs/n/reset_rise_n.txt | head -12
for agg in reset rowoff readline; do echo "== xtalk $agg"; python3 xtalk_report.py outputs/xtalk/xtalk_n_${agg}_PrSFBp1n.raw outputs/xtalk/xtalk_n_${agg}_PrSFBp100p.raw | grep -v "^      noff"; done
