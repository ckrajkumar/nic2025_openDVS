#!/bin/bash
# Run KLayout + Netgen LVS for pixel_4tile v3 / lvsfix netlist
set -euo pipefail

ROOT="/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/git_dvs/openDVS-layout"
RUN="$ROOT/lvs_run_20260709"
export PDK_ROOT="/home/alienfalcon/.ciel/ciel/sky130/versions/7b70722e33c03fcb5dabcf4d479fb0822d9251c9"
export PDK=sky130A
export MAGTYPE=mag

GDS="$ROOT/pixel_4tile_7_9_2026_v3.gds"
NET="$RUN/pixel_4tile_open_lvsfix.spice"
KLAYOUT_DIR="$RUN/klayout"
NETGEN_DIR="$RUN/netgen"
mkdir -p "$KLAYOUT_DIR" "$NETGEN_DIR"

echo "=== KLayout LVS ==="
python3 "$PDK_ROOT/$PDK/libs.tech/klayout/lvs/run_lvs.py" \
  --design="$GDS" \
  --net="$NET" \
  --report="$KLAYOUT_DIR/pixel_4tile" \
  --run_mode=deep \
  --thr=8 \
  2>&1 | tee "$KLAYOUT_DIR/run.log"

python3 "$RUN/lvsdb_to_txt.py" \
  "$KLAYOUT_DIR/pixel_4tile.lvsdb" \
  "$KLAYOUT_DIR/pixel_4tile_lvs.report"

echo "=== Magic extract ==="
magic -dnull -noconsole -rcfile "$PDK_ROOT/$PDK/libs.tech/magic/sky130A.magicrc" \
  "$RUN/run_magic_extract.tcl" 2>&1 | tee "$NETGEN_DIR/magic_extract.log"

echo "=== Netgen LVS ==="
netgen -batch lvs \
  "$NETGEN_DIR/pixel_4tile_layout_extract.spice" \
  "$NET" \
  "$PDK_ROOT/$PDK/libs.tech/netgen/sky130A_setup.tcl" \
  "$NETGEN_DIR/pixel_4tile_netgen_lvs.report" \
  pixel_4tile \
  2>&1 | tee "$NETGEN_DIR/netgen_run.log"

echo "=== Done ==="
