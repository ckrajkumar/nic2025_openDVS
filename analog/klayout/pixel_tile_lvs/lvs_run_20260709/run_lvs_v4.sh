#!/bin/bash
# Full LVS on pixel_4tile v4 GDS (openDVS_pixel ps2dn shorts + v3 vssc1 straps)
set -euo pipefail

ROOT="/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/git_dvs/openDVS-layout"
RUN="$ROOT/lvs_run_20260709"
export PDK_ROOT="/home/alienfalcon/.ciel/ciel/sky130/versions/7b70722e33c03fcb5dabcf4d479fb0822d9251c9"
export PDK=sky130A
export MAGTYPE=mag

GDS="$ROOT/pixel_4tile_7_9_2026_v4.gds"
NET="$RUN/pixel_4tile_open_lvsfix.spice"
NETGEN_DIR="$RUN/netgen"
mkdir -p "$NETGEN_DIR"

echo "=== Step 0: verify openDVS_pixel unit extract (TCL) ==="
python3 "$RUN/flatten_openDVS_pixel_schematic.py"
magic -dnull -noconsole -rcfile "$PDK_ROOT/$PDK/libs.tech/magic/sky130A.magicrc" \
  "$RUN/verify_openDVS_pixel_diode_short.tcl" 2>&1 | tee "$NETGEN_DIR/verify_openDVS_pixel.log"
grep -q "PASS: D0 GndA vpd" "$NETGEN_DIR/verify_openDVS_pixel.log"

echo "=== Step 0b: openDVS_pixel unit Netgen (with ps2dn 2-pin stub) ==="
python3 "$RUN/add_ps2dn_lvs_stub.py" \
  "$NETGEN_DIR/openDVS_pixel_diode_short.spice" \
  "$NETGEN_DIR/openDVS_pixel_diode_short_stub.spice"
python3 "$RUN/add_ps2dn_lvs_stub.py" \
  "$NETGEN_DIR/openDVS_pixel_flat.spice" \
  "$NETGEN_DIR/openDVS_pixel_flat_stub.spice"
netgen -batch lvs \
  "$NETGEN_DIR/openDVS_pixel_diode_short_stub.spice openDVS_pixel" \
  "$NETGEN_DIR/openDVS_pixel_flat_stub.spice openDVS_pixel" \
  "$PDK_ROOT/$PDK/libs.tech/netgen/sky130A_setup.tcl" \
  "$NETGEN_DIR/openDVS_pixel_diode_short.report" \
  2>&1 | tee "$NETGEN_DIR/verify_openDVS_pixel_netgen.log"
grep -E "Circuit 1 contains 24 nets,    Circuit 2 contains 24 nets" "$NETGEN_DIR/openDVS_pixel_diode_short.report"

echo "=== Step 1: Magic extract pixel_4tile v4 ==="
sed "s|pixel_4tile_7_9_2026_v3.gds|pixel_4tile_7_9_2026_v4.gds|g" \
  "$RUN/run_magic_extract.tcl" > "$RUN/run_magic_extract_v4.tcl"
magic -dnull -noconsole -rcfile "$PDK_ROOT/$PDK/libs.tech/magic/sky130A.magicrc" \
  "$RUN/run_magic_extract_v4.tcl" 2>&1 | tee "$NETGEN_DIR/magic_extract_v4.log"

echo "=== Step 2: Netgen LVS pixel_4tile v4 (ps2dn stub on layout netlist) ==="
python3 "$RUN/add_ps2dn_lvs_stub.py" \
  "$NETGEN_DIR/pixel_4tile_layout_extract.spice" \
  "$NETGEN_DIR/pixel_4tile_layout_extract_stub.spice"
netgen -batch lvs \
  "$NETGEN_DIR/pixel_4tile_layout_extract_stub.spice pixel_4tile" \
  "$NET pixel_4tile" \
  "$PDK_ROOT/$PDK/libs.tech/netgen/sky130A_setup.tcl" \
  "$NETGEN_DIR/pixel_4tile_netgen_v4.report" \
  2>&1 | tee "$NETGEN_DIR/netgen_v4_run.log"

echo "=== Done ==="
grep -E "openDVS_pixel|Number of nets: 26|Number of nets: 24|dummy_25|dummy_26|Final result" \
  "$NETGEN_DIR/pixel_4tile_netgen_v4.report" | head -40
