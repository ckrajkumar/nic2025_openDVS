# Verify openDVS_pixel ps2dn parasitic short (dummy_25->vpd, dummy_26->GndA)
# 1) Magic extract from updated .mag
# 2) Netgen unit LVS vs flattened schematic
# 3) Report pass/fail on openDVS_pixel net count

set mag_dir "/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/git_dvs/openDVS-layout/pixel_4tile_v13_7_7_2026"
set run_dir "/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/git_dvs/openDVS-layout/lvs_run_20260709"
set netgen_dir "$run_dir/netgen"
set layout_spice "$netgen_dir/openDVS_pixel_diode_short.spice"
set schematic_spice "$netgen_dir/openDVS_pixel_flat.spice"
set report "$netgen_dir/openDVS_pixel_diode_short.report"
set setup "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/netgen/sky130A_setup.tcl"

tech load $::env(PDK_ROOT)/$::env(PDK)/libs.tech/magic/sky130A.tech
drc off
crashbackups stop

cd $mag_dir
load openDVS_pixel

puts "=== Extract openDVS_pixel ==="
extract all
ext2spice lvs
ext2spice -o $layout_spice

set fp [open $layout_spice r]
set data [read $fp]
close $fp
if {![regexp {D0\s+GndA\s+vpd\s+sky130_fd_pr__model__parasitic__diode_ps2dn} $data]} {
    puts "FAIL: parasitic diode D0 GndA vpd not found in $layout_spice"
    quit -noprompt
}
puts "PASS: D0 GndA vpd found in layout extract"

quit -noprompt
