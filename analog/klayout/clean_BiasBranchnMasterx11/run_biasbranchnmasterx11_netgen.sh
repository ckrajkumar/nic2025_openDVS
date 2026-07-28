#!/usr/bin/env bash
# Magic extract + Netgen LVS for BiasBranchnMasterx11 (clean_gds)
set -euo pipefail

PDK_ROOT="${PDK_ROOT:-$HOME/.ciel/ciel/sky130/versions/7b70722e33c03fcb5dabcf4d479fb0822d9251c9}"
export PDK=sky130B
RUN="$(cd "$(dirname "$0")" && pwd)"
GDS="$RUN/BiasBranchnMasterx11.gds"
LAYOUT="$RUN/BiasBranchnMasterx11_layout.spice"
SCHEMATIC="$RUN/BiasBranchnMasterx11_netgen.spice"
REPORT="$RUN/BiasBranchnMasterx11_netgen.report"
LOG="$RUN/BiasBranchnMasterx11_netgen.log"
TOP=BiasBranchnMasterx11

if [[ ! -f "$GDS" ]]; then
  echo "Missing GDS: $GDS" >&2
  exit 1
fi

echo "=== Magic extract: $TOP ==="
magic -dnull -noconsole -rcfile "$PDK_ROOT/$PDK/libs.tech/magic/sky130B.magicrc" \
  "$RUN/run_magic_extract_biasbranchnmasterx11.tcl" \
  2>&1 | tee "$RUN/magic_extract.log"

echo "=== Build Netgen schematic (layout pin order) ==="
python3 "$RUN/fix_biasbranchnmasterx11_netgen.py" "$LAYOUT" \
  "$RUN/BiasBranchnMasterx11_schem.spice" "$SCHEMATIC"

if [[ ! -f "$SCHEMATIC" ]]; then
  echo "Missing schematic: $SCHEMATIC" >&2
  exit 1
fi

echo "=== Netgen LVS ==="
netgen -batch lvs \
  "$LAYOUT $TOP" \
  "$SCHEMATIC $TOP" \
  "$PDK_ROOT/$PDK/libs.tech/netgen/sky130B_setup.tcl" \
  "$REPORT" \
  2>&1 | tee "$LOG"

echo ""
echo "Report: $REPORT"
grep -E "Final result|property error|failed pin|Mismatch|Circuit .* contains|Netlists match" "$REPORT" | tail -40
