#!/bin/bash
# Run CACE for PixelPhotoreceptor with auto-netlisting of dependencies
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ANALOG_DIR="$(dirname "$SCRIPT_DIR")"

export PDK=sky130B
export PDK_ROOT=/usr/local/share/pdk/

# Netlist DUT dependencies that CACE doesn't handle
cd "$ANALOG_DIR/xschem"
for block in PixelSourceFollower PixelComparators PixelResetGen PixelChangeAmplifier; do
    echo "Netlisting $block..."
    xschem -n -s -x -q --tcl "set top_is_subckt 1" -N "$block.spice" "$block.sch"
    cp "simulation/$block.sch/$block.spice" "$ANALOG_DIR/netlist/schematic/"
done

# Run CACE (pass all args through)
cd "$SCRIPT_DIR"
YAML="${1:-PixelPhotoreceptor.yaml}"
shift 2>/dev/null || true
exec cace "$YAML" "$@"
