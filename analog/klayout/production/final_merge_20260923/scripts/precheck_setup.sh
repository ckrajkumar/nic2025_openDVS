#!/bin/bash
# workstation: build the caravel-style project dir for cf_precheck from the Drive files + the merged GDS, and run the non-LVS checks
set -uo pipefail
W=~/opendvs_final; P=$W/project; D=$W/drive/lvs_final_submission_run
mkdir -p $P/gds $P/verilog/gl $P/verilog/rtl $P/lvs/user_project_wrapper
ln -sf $W/merged/user_project_wrapper.gds $P/gds/user_project_wrapper.gds
cp -f $D/user_project_wrapper.v $P/verilog/gl/; cp -f $D/user_defines.v $P/verilog/rtl/
cp -f $D/lvs_config.json $D/BiasBranchnMasterx11_layout_lvs.spice $D/photodiode_test_structure_layout_lvs.spice $P/lvs/user_project_wrapper/
cp -f $D/pixel_4tile_layout_lvs2.spice $P/lvs/user_project_wrapper/pixel_4tile_layout_lvs2.spice.orig
cp -f $D/pixel_test_structure_layout_lvs.spice $P/lvs/user_project_wrapper/pixel_test_structure_layout_lvs.spice.orig
cp -f $W/drive/evidence/cvc.power.user_project_wrapper $P/lvs/user_project_wrapper/
ls -la $P/gds $P/verilog/gl $P/verilog/rtl $P/lvs/user_project_wrapper | cut -c24-
mkdir -p $P/precheck_results
echo "== cf_precheck (non-LVS checks) $(date +%H:%M:%S)"
podman run --rm -e PDK_ROOT=$HOME/pdk -e PDK=sky130A -v $W:$W:Z -v $HOME/pdk:$HOME/pdk:Z -w $P docker.io/chipfoundry/mpw_precheck:latest \
  python3 -m cf_precheck -i $P -p $HOME/pdk/sky130A -o $P/precheck_results/nonlvs --skip-checks lvs oeb 2>&1 | tail -40
echo "== done $(date +%H:%M:%S)"; ls $P/precheck_results/nonlvs 2>/dev/null; cat $P/precheck_results/nonlvs/logs/precheck.log 2>/dev/null | grep -E "INFO|ERROR|WARN" | cut -c1-180 | tail -30
