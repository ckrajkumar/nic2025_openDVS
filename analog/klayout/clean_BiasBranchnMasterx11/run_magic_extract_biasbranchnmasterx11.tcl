# Magic extract for BiasBranchnMasterx11 Netgen LVS (clean_gds)
set run_dir "/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/git_dvs/openDVS-layout/BiasBranchnMasterx11_v9/clean_gds"
set gds "$run_dir/BiasBranchnMasterx11.gds"
set layout_spice "$run_dir/BiasBranchnMasterx11_layout.spice"

tech load $::env(PDK_ROOT)/$::env(PDK)/libs.tech/magic/sky130B.tech
drc off
crashbackups stop

gds read $gds
load BiasBranchnMasterx11

port makeall

puts "=== Magic extract starting ==="
flush stdout
extract all
ext2sim labels on
ext2spice lvs
ext2spice -o $layout_spice
puts "=== Wrote layout extract: $layout_spice ==="

quit -noprompt
