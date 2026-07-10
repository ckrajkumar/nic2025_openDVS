# Magic extract + Netgen LVS for pixel_4tile (GDS v3 + open lvsfix spice)
set run_dir "/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/git_dvs/openDVS-layout/lvs_run_20260709/netgen"
set gds "/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/git_dvs/openDVS-layout/pixel_4tile_7_9_2026_v3.gds"
set schematic "/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/git_dvs/openDVS-layout/lvs_run_20260709/pixel_4tile_open_lvsfix.spice"
set layout_spice "$run_dir/pixel_4tile_layout_extract.spice"
set report "$run_dir/pixel_4tile_netgen_lvs.report"
set setup "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/netgen/sky130A_setup.tcl"

file mkdir $run_dir

tech load $::env(PDK_ROOT)/$::env(PDK)/libs.tech/magic/sky130A.tech
drc off
crashbackups stop

gds read $gds
load pixel_4tile

# Match top-level port labels used in GDS / schematic
port makeall
port make vssa1
port make vssc1
port make vdda1

puts "=== Magic extract starting (this may take several minutes) ==="
flush stdout
extract all
ext2sim labels on
ext2spice lvs
ext2spice -o $layout_spice
puts "=== Wrote layout extract: $layout_spice ==="

quit -noprompt
