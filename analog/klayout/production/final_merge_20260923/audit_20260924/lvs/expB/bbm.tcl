set layout [readnet spice /home/rpgraca/opendvs_final/project/precheck_results/full_r21b_lvs/tmp/ext/user_project_wrapper.gds.spice]
set source [readnet spice /home/rpgraca/opendvs_final/project/lvs/user_project_wrapper/BiasBranchnMasterx11_layout_lvs.spice]
flatten "$layout BiasBranchnMasterx11"
flatten "$source BiasBranchnMasterx11"
lvs "$layout BiasBranchnMasterx11" "$source BiasBranchnMasterx11" /home/rpgraca/opendvs_final/project/precheck_results/full_r21b_lvs/tmp/sky130A_setup.tcl /home/rpgraca/opendvs_final/audit_lvs/expB/bbm_flat.report
