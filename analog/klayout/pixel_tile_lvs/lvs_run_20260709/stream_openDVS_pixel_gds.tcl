# Stream updated openDVS_pixel.mag to GDS (Calma).
set mag_dir "/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/git_dvs/openDVS-layout/pixel_4tile_v13_7_7_2026"
set out_gds "/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/git_dvs/openDVS-layout/lvs_run_20260709/openDVS_pixel_lvsfix.gds"

tech load $::env(PDK_ROOT)/$::env(PDK)/libs.tech/magic/sky130A.tech
drc off
crashbackups stop

cd $mag_dir
load openDVS_pixel

gds labels yes
gds write $out_gds
puts "=== Wrote $out_gds ==="

quit -noprompt
