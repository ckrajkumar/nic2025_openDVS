#!/bin/bash
# Run Netgen LVS on pixel_4tile v4 after Magic extract completes.
set -euo pipefail

ROOT="/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/git_dvs/openDVS-layout"
RUN="$ROOT/lvs_run_20260709"
export PDK_ROOT="/home/alienfalcon/.ciel/ciel/sky130/versions/7b70722e33c03fcb5dabcf4d479fb0822d9251c9"
export PDK=sky130A
NET="$RUN/pixel_4tile_open_lvsfix.spice"
NETGEN_DIR="$RUN/netgen"
LAYOUT="$NETGEN_DIR/pixel_4tile_layout_extract.spice"

if [[ ! -f "$LAYOUT" ]]; then
  echo "Missing $LAYOUT — run Magic extract first (run_magic_extract_v4.tcl)."
  exit 1
fi

python3 "$RUN/add_ps2dn_lvs_stub.py" "$LAYOUT" "$NETGEN_DIR/pixel_4tile_layout_extract_stub.spice"

netgen -batch lvs \
  "$NETGEN_DIR/pixel_4tile_layout_extract_stub.spice pixel_4tile" \
  "$NET pixel_4tile" \
  "$PDK_ROOT/$PDK/libs.tech/netgen/sky130A_setup.tcl" \
  "$NETGEN_DIR/pixel_4tile_netgen_v4.report" \
  2>&1 | tee "$NETGEN_DIR/netgen_v4_run.log"

grep -E "openDVS_pixel|Number of nets: 26|Number of nets: 24|dummy_25|dummy_26|Final result" \
  "$NETGEN_DIR/pixel_4tile_netgen_v4.report" | head -40
