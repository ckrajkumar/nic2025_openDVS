#!/bin/bash
# Tile-level checks on the workstation: PDK KLayout deck (FEOL+BEOL) and Magic+netgen LVS of pixel_4tile.<tag>.gds vs the July xschem netlist.
# tile_ws.sh <tag>   (in ~/tile_r15a/; expects pixel_4tile.<tag>.gds and july_pixel_4tile_schem.spice)
set -uo pipefail; TAG="${1:?tag}"; cd ~/tile_r15a
CIEL=$(ls -d ~/.ciel/ciel/sky130/versions/*/sky130A | head -1)
sed "s#/home/rpgraca/work/open_pdks/open_pdks/root/ciel/sky130/build/[0-9a-f]*/sky130A#$CIEL#g" $CIEL/libs.tech/magic/sky130A.magicrc > sky130A.magicrc
# --- DRC (background)
( echo "== PDK deck FEOL+BEOL on pixel_4tile.$TAG.gds  $(date +%H:%M:%S)"; ( time klayout -b -r $CIEL/libs.tech/klayout/drc/sky130A.lydrc -rd input=pixel_4tile.$TAG.gds -rd report=pdkdrc_tile.$TAG.lyrdb -rd feol=true -rd beol=true -rd offgrid=true -rd seal=false -rd floating_met=false ) 2>&1 | grep -E "real|ERROR|error"; R=pdkdrc_tile.$TAG.lyrdb; echo "items: $(grep -c '<item>' $R)"; python3 - "$R" <<'PY'
import sys, re
from collections import Counter
t = open(sys.argv[1]).read(); print(dict(Counter(re.findall(r"<item>.*?<category>'?([^<']+)'?</category>", t, re.S))) or "none")
PY
) > tile_drc.log 2>&1 &
# --- LVS (background)
( cat > extract.tcl <<TCL
gds read pixel_4tile.$TAG.gds
load pixel_4tile
select top cell
extract all
ext2spice lvs
ext2spice -o pixel_4tile_layout.spice
quit -noprompt
TCL
echo "== magic extract $(date +%H:%M:%S)"; ( time magic -dnull -noconsole -rcfile sky130A.magicrc extract.tcl ) > magic.log 2>&1; tail -2 magic.log
ls -la pixel_4tile_layout.spice | cut -c25-; echo "X cards: $(grep -c '^X' pixel_4tile_layout.spice)"
echo "== netgen $(date +%H:%M:%S)"; ( time netgen -batch lvs "pixel_4tile_layout.spice pixel_4tile" "july_pixel_4tile_schem.spice pixel_4tile_schem" $CIEL/libs.tech/netgen/sky130A_setup.tcl comp.out ) > netgen.log 2>&1; tail -3 netgen.log
echo "== verdicts $(date +%H:%M:%S)"; grep -E "^Final result|are equivalent|do not match|Netlists match" comp.out | sort | uniq -c | sort -rn | head -20
echo "mismatch lines: $(grep -c Mismatch comp.out)   (July: $(grep -c Mismatch july_comp.out); July final: $(grep '^Final result' july_comp.out))"
) > tile_lvs.log 2>&1 &
sleep 15; echo "--- drc:"; cat tile_drc.log; echo "--- lvs:"; cat tile_lvs.log; tail -3 magic.log 2>/dev/null | cut -c1-100
