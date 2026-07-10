#!/usr/bin/env bash
# Magic extract + Netgen LVS for BiasBranchnMasterx11
set -euo pipefail

PDK_ROOT="${PDK_ROOT:-$HOME/.ciel/ciel/sky130/versions/7b70722e33c03fcb5dabcf4d479fb0822d9251c9}"
export PDK=sky130B
RUN="$(cd "$(dirname "$0")" && pwd)"
GDS="$RUN/BiasBranchnMasterx11.gds"
SCHEMATIC="${1:-$HOME/.xschem/simulations/BiasBranchnMasterx11.spice}"
LAYOUT="$RUN/BiasBranchnMasterx11_layout.spice"
REPORT="$RUN/BiasBranchnMasterx11_netgen.report"
LOG="$RUN/BiasBranchnMasterx11_netgen.log"
TOP=BiasBranchnMasterx11

if [[ ! -f "$GDS" ]]; then
  echo "Missing GDS: $GDS" >&2
  exit 1
fi
if [[ ! -f "$SCHEMATIC" ]]; then
  echo "Missing schematic: $SCHEMATIC" >&2
  exit 1
fi

echo "=== Magic extract: $TOP ==="
magic -dnull -noconsole -rcfile "$PDK_ROOT/$PDK/libs.tech/magic/sky130B.magicrc" \
  "$RUN/run_magic_extract_biasbranchnmasterx11.tcl" \
  2>&1 | tee "$RUN/magic_extract.log"

echo "=== Netgen LVS ==="
netgen -batch lvs \
  "$LAYOUT $TOP" \
  "$SCHEMATIC $TOP" \
  "$PDK_ROOT/$PDK/libs.tech/netgen/sky130B_setup.tcl" \
  "$REPORT" \
  2>&1 | tee "$LOG"

echo ""
echo "Report: $REPORT"
grep -E "Final result|property error|failed pin|Mismatch|Circuit .* contains" "$REPORT" | tail -30
