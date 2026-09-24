#!/bin/bash
# workstation: fetch the Drive submission files (public links) into ~/opendvs_final/drive/
set -uo pipefail
G=~/.venvs/gdown/bin/gdown; D=~/opendvs_final/drive; mkdir -p $D/lvs_final_submission_run $D/lvs_individual_macros $D/evidence; cd $D
dl() { local id=$1 out=$2; [ -s "$out" ] && { echo "have $out"; return; }; timeout 900 $G --no-cookies "https://drive.google.com/uc?id=$id" -O "$out" >/dev/null 2>&1 || echo "FAIL $out"; ls -la "$out" 2>/dev/null | cut -c24-; }
dl 1gi_4MjfVa04y9z8_XNtG9_IIB3p4QqvG project.json
dl 1F1UfSYyx-XbEfDK8NX93pFz8kBsqXfYy lvs_final_submission_run/21_SEP_2026___22_03_01_final.zip
dl 1ePjuGldTWHNAzP5KF4rHFS9bPueQvPPN lvs_final_submission_run/pixel_test_structure_layout_lvs.spice
dl 10dGJrsmf7U5sm9tzx8QkbvLRytbo4Bce lvs_final_submission_run/BiasBranchnMasterx11_layout_lvs.spice
dl 1T5JuUuYti4JYc-GJupkDNC1h3HIdy-Qs lvs_final_submission_run/user_defines.v
dl 1lSlAp30FuTGralmKPmhu7uOBZ6J7PDNv lvs_final_submission_run/user_project_wrapper.v
dl 1GAx9tXTG6zy1x9JRcNNpYwCWOI9uyFFL lvs_final_submission_run/photodiode_test_structure_layout_lvs.spice
dl 1_UkvP4-CLZSt72hhMOsczi4_37v_-qYP lvs_final_submission_run/pixel_4tile_layout_lvs2.spice
dl 1l3ouybDElwNTxgLL0nzEUiBffTTxh2sX lvs_final_submission_run/lvs_config.json
dl 1KrnTTdw6G3Z67zNVY3lHZLXgBdsRKxvd lvs_individual_macros/macro_lvs_runs.zip
dl 1r8dxrsklrdXaYMfsu4vC8h0GWC_BDUqa lvs_individual_macros/pixel_4tile_layout_lvs.spice
dl 1ffzcJx5mOO4XLQq6ZahBq3bAvf2wYu9Y lvs_individual_macros/pixel_4tile_schem_lvs.spice
dl 1byvkVTcuKXR89eAEq3Gf3_LbeeAEl_la lvs_individual_macros/pixel_test_structure_schem_lvs.spice
dl 1bv9-HbdEOdYuv4vOWarFDJePbCHx1XpF lvs_individual_macros/photodiode_test_structure_schem_lvs.spice
dl 1Cma-gp6f9kWH8eOgXRaIqoP1PzRG3J-5 lvs_individual_macros/BiasBranchnMasterx11_schem_lvs.spice
dl 16gSMUOQmHrcuvs6szTh1z_Vs1_aU9ryQ evidence/OEB_check.log
dl 1YzFWdxxCWPcStC0HFMI4F9DZkf6jv81j evidence/cvc.oeb.log
dl 1dhpoOtYaDJr_XeGZ-_CZohkixgV9YBc5 evidence/cvc.oeb.report
dl 1uzxBjn7VPdudgYS5LYvLvCWl3sie1Xyc evidence/cvc_failure.oeb.log
dl 1fm-jFuBkqfI4K5IBlLMgYZYiE2iT_wzz evidence/cvc.power.user_project_wrapper
dl 11yUvE5EN0VMvW0vcL1HFnyVL_dPXmZRV evidence/OEB_failure_check.log
dl 1rEKk_QEnKCI24FVxHHpbQKVD3fT0d9yr evidence/lvs.clean.log
dl 1qwBAS1oa0Jnrzlo7bScgDc2U8b5LGhQS evidence/lvs.report
mv -f ~/opendvs_final/user_project_wrapper.gds lvs_final_submission_run/ 2>/dev/null; sha256sum lvs_final_submission_run/user_project_wrapper.gds
cd lvs_final_submission_run && unzip -l 21_SEP_2026___22_03_01_final.zip | tail -40
cd ../lvs_individual_macros && unzip -l macro_lvs_runs.zip | tail -20
cat ../evidence/cvc.power.user_project_wrapper
