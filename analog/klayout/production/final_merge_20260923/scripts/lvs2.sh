#!/bin/bash
# workstation: (a) Magic extraction of the merged pixel_4tile (own dir, no rm race), (b) control: LVS of the ORIGINAL final pixel_test_structure with the same flow, (c) netgen for the merged tile
set -uo pipefail
W=~/opendvs_final; IMG=docker.io/chipfoundry/mpw_precheck:latest
run_in() { local dir=$1; shift; podman run --rm -e PDK_ROOT=$HOME/pdk -e PDK=sky130A -v $W:$W:Z -v $HOME/pdk:$HOME/pdk:Z -w $dir --entrypoint /bin/bash $IMG -c "$*"; }
extract() { local dir=$1 gds=$2 top=$3 out=$4; mkdir -p $dir
  printf 'drc off\ncrashbackups stop\ngds readonly true\ngds read %s\nload %s\nselect top cell\nextract do local\nextract all\next2spice lvs\next2spice -o %s\nquit -noprompt\n' "$gds" "$top" "$out" > $dir/extract.tcl
  echo "== magic extract $top -> $out $(date +%H:%M:%S)"; run_in $dir "magic -dnull -noconsole -rcfile $HOME/pdk/sky130A/libs.tech/magic/sky130A.magicrc extract.tcl > magic.log 2>&1; tail -2 magic.log"; ls -la $out | cut -c24-; }
extract $W/lvs/tile $W/merged/pixel_4tile.merged.gds pixel_4tile $W/lvs/tile/pixel_4tile_layout_lvs2.spice &
extract $W/lvs/ts_final $W/drc/pixel_test_structure.final.gds pixel_test_structure $W/lvs/ts_final/pixel_test_structure_layout_lvs.spice &
wait
cd $W/lvs/ts_final && sed -e 's/S7_//g' -f $W/lvs_vc_TestPixel.sed pixel_test_structure_layout_lvs.spice > layout_vc.spice
echo "== netgen control (final test structure) $(date +%H:%M:%S)"
run_in $W/lvs/ts_final "netgen -batch lvs 'layout_vc.spice pixel_test_structure' '$W/drive/lvs_individual_macros/pixel_test_structure_schem_lvs.spice openDVS2x2_test_pixel' $W/lvs_setup_TestPixel.tcl comp.out -json > lvs.log 2>&1; grep 'Final result' comp.out"
cd $W/lvs/tile && sed -e 's/GS_//g' -f $W/lvs_vc_2x2.sed pixel_4tile_layout_lvs2.spice > layout_vc.spice
echo "== netgen merged pixel_4tile $(date +%H:%M:%S)"
run_in $W/lvs/tile "netgen -batch lvs 'layout_vc.spice pixel_4tile' '$W/drive/lvs_individual_macros/pixel_4tile_schem_lvs.spice pixel_4tile' $W/lvs_setup_2x2.tcl comp.out -json > lvs.log 2>&1; grep 'Final result' comp.out; grep -B1 -A3 'Circuit 1 cell pixel_4tile ' comp.out | head; tail -4 comp.out"
echo "LVS2 DONE $(date +%H:%M:%S)"
