#!/bin/bash
# workstation: extract the FIXED merged pixel_4tile (r18b) in lvs/tile_b and run the macro LVS with the diode stub; also the test structure
set -uo pipefail
W=~/opendvs_final; IMG=docker.io/chipfoundry/mpw_precheck:latest
run_in() { local dir=$1; shift; podman run --rm -e PDK_ROOT=$HOME/pdk -e PDK=sky130A -v $W:$W:Z -v $HOME/pdk:$HOME/pdk:Z -w $dir --entrypoint /bin/bash $IMG -c "$*"; }
extract() { local dir=$1 gds=$2 top=$3 out=$4; mkdir -p $dir
  printf 'drc off\ncrashbackups stop\ngds readonly true\ngds read %s\nload %s\nselect top cell\nextract do local\nextract all\next2spice lvs\next2spice -o %s\nquit -noprompt\n' "$gds" "$top" "$out" > $dir/extract.tcl
  echo "== magic extract $top -> $out $(date +%H:%M:%S)"; run_in $dir "magic -dnull -noconsole -rcfile $HOME/pdk/sky130A/libs.tech/magic/sky130A.magicrc extract.tcl > magic.log 2>&1; tail -2 magic.log"; ls -la $out | cut -c24-; }
STUB='\n.subckt sky130_fd_pr__model__parasitic__diode_ps2dn anode cathode\n.ends\n'
extract $W/lvs/tile_b $W/merged/pixel_4tile.merged.gds pixel_4tile $W/lvs/tile_b/pixel_4tile_layout_lvs2.spice &
extract $W/lvs/ts_b $W/merged/pixel_test_structure.merged.gds pixel_test_structure $W/lvs/ts_b/pixel_test_structure_layout_lvs.spice &
wait
cd $W/lvs/ts_b && sed -e 's/S7_//g' -f $W/lvs_vc_TestPixel.sed pixel_test_structure_layout_lvs.spice > layout_vc.spice && printf "$STUB" >> layout_vc.spice
echo "== netgen test structure (r18b) $(date +%H:%M:%S)"
run_in $W/lvs/ts_b "netgen -batch lvs 'layout_vc.spice pixel_test_structure' '$W/drive/lvs_individual_macros/pixel_test_structure_schem_lvs.spice openDVS2x2_test_pixel' $W/lvs_setup_TestPixel.tcl comp.out -json > lvs.log 2>&1; grep -E 'Final result|Number of (devices|nets)' comp.out | tail -3"
cd $W/lvs/tile_b && sed -e 's/GS_//g' -f $W/lvs_vc_2x2.sed pixel_4tile_layout_lvs2.spice > layout_vc.spice && printf "$STUB" >> layout_vc.spice
echo "== netgen pixel_4tile (r18b) $(date +%H:%M:%S)"
run_in $W/lvs/tile_b "netgen -batch lvs 'layout_vc.spice pixel_4tile' '$W/drive/lvs_individual_macros/pixel_4tile_schem_lvs.spice pixel_4tile' $W/lvs_setup_2x2.tcl comp.out -json > lvs.log 2>&1; grep -E 'Final result' comp.out; grep -E 'Number of (devices|nets)' comp.out | tail -2"
echo "TILE_B DONE $(date +%H:%M:%S)"
