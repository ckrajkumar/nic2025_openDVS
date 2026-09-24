#!/bin/bash
# ini: Magic RCC (frozen production pipeline) + PVS/Quantus replay for the merged 2x2 (tag r18)
set -uo pipefail
TAG=r18; C=~/.cache/opencode/opendvs-pex; G=$C/edited-pixel-magic-20260921-v1/openDVS_pixel2x2_top.$TAG.gds
echo "== $(date +%H:%M:%S) gds $(sha256sum $G | cut -c1-16)"
rm -rf $C/edited-pixel-magic-20260921-v1/$TAG
( cd $C/edited-pixel-magic-20260921-v1 && bash ../rcc_pipeline_ini.sh $TAG openDVS_pixel2x2_top.$TAG.gds > rcc_$TAG.log 2>&1; echo "== rcc done $(date +%H:%M:%S)"; grep -E "inventory|sha256|caps:|Nets" rcc_$TAG.log | tail -5; ls -la $TAG/*.spice | cut -c24-;
  P=~/git/opendvs-pex-cadence-production-v1/pex_campaign_native/full_pvt_three_path_v1/sources/production_gds_v1
  python3 ../cc_diff.py $P/openDVS_pixel2x2_magic_rcc_ngspice.spice $TAG/openDVS_pixel2x2_magic_rcc_ngspice.spice --nets vsf,vd,nRst --pixel 0 > $TAG/cc_diff_vsf_vd_nRst.pixel0.txt 2>&1; head -30 $TAG/cc_diff_vsf_vd_nRst.pixel0.txt ) &
( rm -rf $C/edited-quantus-stage-20260921-v1/$TAG; bash $C/mk_quantus_stage.sh $TAG $G > $C/quantus_$TAG.log 2>&1 && bash $C/quantus_replay_local.sh $TAG >> $C/quantus_$TAG.log 2>&1; echo "== quantus done $(date +%H:%M:%S)"; tail -5 $C/quantus_$TAG.log ) &
wait; echo "STAGE DONE $(date +%H:%M:%S)"
