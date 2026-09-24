#!/bin/bash
# workstation: macro LVS of the merged pixel_4tile and pixel_test_structure, the collaborators' way
# (Magic 8.3.471 from the precheck image, netgen with lvs_setup_2x2.tcl / lvs_setup_TestPixel.tcl + virtual-connect sed), vs the xschem netlists from Drive.
# Also produces the GS_/S7_-named layout netlists that the wrapper LVS uses as sources (lvs2.spice replacements).
set -uo pipefail
cd ~/opendvs_final; mkdir -p lvs; W=~/opendvs_final
IMG=docker.io/chipfoundry/mpw_precheck:latest
PODMAN="podman run --rm -e PDK_ROOT=$HOME/pdk -e PDK=sky130A -v $W:$W:Z -v $HOME/pdk:$HOME/pdk:Z -w $W/lvs --entrypoint /bin/bash $IMG -c"
export PDK_ROOT=$HOME/pdk PDK=sky130A
extract() { local gds=$1 top=$2 out=$3
  cat > lvs/extract_$top.tcl <<TCL
drc off
crashbackups stop
gds readonly true
gds read $gds
load $top
select top cell
extract do local
extract all
ext2spice lvs
ext2spice -o $out
quit -noprompt
TCL
  echo "== magic extract $top $(date +%H:%M:%S)"
  $PODMAN "cd $W/lvs && magic -dnull -noconsole -rcfile $HOME/pdk/sky130A/libs.tech/magic/sky130A.magicrc extract_$top.tcl > magic_$top.log 2>&1; rm -f *.ext; tail -3 magic_$top.log"
  ls -la $out | cut -c24-
}
extract $W/merged/pixel_4tile.merged.gds pixel_4tile $W/lvs/pixel_4tile_layout_lvs2.spice &
extract $W/merged/pixel_test_structure.merged.gds pixel_test_structure $W/lvs/pixel_test_structure_layout_lvs.spice &
wait
cd lvs
# macro LVS with production cell names: strip the GS_/S7_ prefixes, apply the virtual-connect rules
sed -e 's/GS_//g' -f ../lvs_vc_2x2.sed pixel_4tile_layout_lvs2.spice > pixel_4tile_layout_vc.spice
sed -e 's/S7_//g' -f ../lvs_vc_TestPixel.sed pixel_test_structure_layout_lvs.spice > pixel_test_structure_layout_vc.spice
echo "== netgen pixel_4tile $(date +%H:%M:%S)"
$PODMAN "cd $W/lvs && export PDK_ROOT=$HOME/pdk PDK=sky130A && netgen -batch lvs 'pixel_4tile_layout_vc.spice pixel_4tile' '$W/drive/lvs_individual_macros/pixel_4tile_schem_lvs.spice pixel_4tile' ../lvs_setup_2x2.tcl pixel_4tile_comp.out -json > pixel_4tile_lvs.log 2>&1; tail -3 pixel_4tile_comp.out"
echo "== netgen pixel_test_structure $(date +%H:%M:%S)"
$PODMAN "cd $W/lvs && export PDK_ROOT=$HOME/pdk PDK=sky130A && netgen -batch lvs 'pixel_test_structure_layout_vc.spice pixel_test_structure' '$W/drive/lvs_individual_macros/pixel_test_structure_schem_lvs.spice openDVS2x2_test_pixel' ../lvs_setup_TestPixel.tcl pixel_test_structure_comp.out -json > pixel_test_structure_lvs.log 2>&1; tail -3 pixel_test_structure_comp.out"
echo "== verdicts"; grep -H "Final result" pixel_4tile_comp.out pixel_test_structure_comp.out
grep -A1 -E "^Circuit 1 cell .* and Circuit 2 cell" pixel_4tile_comp.out | grep -E "Number of devices|Number of nets" | head -12
echo "MACRO LVS DONE $(date +%H:%M:%S)"
