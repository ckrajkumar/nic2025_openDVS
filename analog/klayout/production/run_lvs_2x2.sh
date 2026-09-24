#!/usr/bin/env -S -u LD_LIBRARY_PATH bash
# LVS of openDVS_pixel2x2_top (from pixel_4tile_work.gds) against the xschem schematic
# analog/xschem/openDVS_pixel2x2.sch, with the ciel sky130A KLayout LVS deck.
#   ./run_lvs_2x2.sh [cell]     default cell: openDVS_pixel2x2_top
# Outputs in ./lvs/: <cell>.gds (exported, top renamed openDVS_pixel2x2), schematic netlist,
# <cell>.lvsdb (open in KLayout: Tools -> Netlist Browser), <cell>_extracted.cir, <cell>.lvs.log
set -euo pipefail
D="$(cd "$(dirname "$0")" && pwd)"
CELL="${1:-openDVS_pixel2x2_top}"   # env: GDS=<other.gds> RUN_MODE=deep|flat TAG=<suffix>
XS="$D/../../xschem"
export PDK_ROOT="$HOME/.ciel" PDK=sky130A
K="$HOME/git/klayout/bin-release/klayout"
KLD="$HOME/git/klayout/bin-release:$HOME/anaconda3/lib"
DECK="$PDK_ROOT/$PDK/libs.tech/klayout/lvs/sky130.lvs"
OUT="$D/lvs"; mkdir -p "$OUT"

echo "== 1. export $CELL from pixel_4tile_work.gds as top cell openDVS_pixel2x2"
cat > "$OUT/export.py" <<PY
import pya
ly = pya.Layout(); ly.read("${GDS:-$D/pixel_4tile_work.gds}")
c = ly.cell("$CELL"); c.name = "openDVS_pixel2x2"
opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(c.cell_index())
ly.write("$OUT/$CELL${TAG:-}.gds", opt)
print("wrote $OUT/$CELL.gds  child cells:", sorted(ly.cell(i).name for i in c.each_child_cell()))
PY
LD_LIBRARY_PATH="$KLD" "$K" -b -r "$OUT/export.py" 2>&1 | grep -v libcurl

echo "== 2. xschem LVS netlist of openDVS_pixel2x2.sch"
( cd "$XS" && xschem -n -q -x --rcfile "$XS/xschemrc" --tcl "set lvs_netlist 1" -o "$OUT" openDVS_pixel2x2.sch ) 2>&1 | grep -v "^PDK" | tail -3 || true
test -s "$OUT/openDVS_pixel2x2.spice"
grep -c "^[xXmM]" "$OUT/openDVS_pixel2x2.spice" | sed 's/^/   device+subckt lines: /'

echo "== 3. KLayout LVS (run_mode=${RUN_MODE:-flat}; flat because abutting pixels share S/D diffusion, which deep mode pulls up into the 2x2 circuit)"
LD_LIBRARY_PATH="$KLD" "$K" -b -r "$DECK" \
  -rd input="$OUT/$CELL${TAG:-}.gds" -rd top_cell=openDVS_pixel2x2 \
  -rd schematic="$OUT/openDVS_pixel2x2.spice" \
  -rd report="$OUT/$CELL${TAG:-}.lvsdb" -rd target_netlist="$OUT/${CELL}${TAG:-}_extracted.cir" \
  -rd run_mode="${RUN_MODE:-flat}" -rd thr=8 -rd spice_net_names=true -rd spice_comments=false -rd scale=false \
  -rd verbose=false -rd schematic_simplify=false -rd net_only=false -rd top_lvl_pins=false \
  -rd combine=false -rd purge=false -rd purge_nets=false -rd convert_subckts=true -rd lvs_sub=GndA \
  2>&1 | grep -v libcurl | tee "$OUT/$CELL${TAG:-}.lvs.log" | grep -i "error\|final\|match\|warning" | tail -15
echo "== log: $OUT/$CELL.lvs.log"
