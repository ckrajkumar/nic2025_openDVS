#!/bin/bash
# Run CACE for PixelComparators DC threshold characterization
# Requires: PixelGainAC and PixelResetTran runs to exist for cross-block lookups
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ANALOG_DIR="$(dirname "$SCRIPT_DIR")"

export PDK=sky130B
export PDK_ROOT=/usr/local/share/pdk/

# No extra dependencies to netlist — PixelComparators is the DUT
# (CACE handles DUT netlisting)

# Run CACE (pass all args through)
cd "$SCRIPT_DIR"
YAML="${1:-PixelComparators.yaml}"
shift 2>/dev/null || true
exec cace "$YAML" "$@"
