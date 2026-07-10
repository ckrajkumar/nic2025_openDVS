# Regenerate BiasBuffers.gds and extract netlist for verification
set mag_dir "/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/git_dvs/openDVS-layout/BiasBranchnMasterx11_v9"
set out_gds "$mag_dir/BiasBuffers.gds"
set out_spice "$mag_dir/BiasBuffers_magic_extract.spice"

tech load $::env(PDK_ROOT)/$::env(PDK)/libs.tech/magic/sky130A.tech
drc off
crashbackups stop

cd $mag_dir
load BiasBuffers

gds labels yes
gds write $out_gds
puts "=== Wrote $out_gds ==="

extract
set fp [open $out_spice w]
puts $fp [extract all]
close $fp
puts "=== Wrote $out_spice ==="

quit -noprompt
