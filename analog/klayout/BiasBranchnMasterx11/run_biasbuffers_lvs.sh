#!/usr/bin/env bash
# KLayout LVS for BiasBuffers — must match GUI defaults in run_lvs.lym.
# Critical: -rd scale=true (without it, device sizes mismatch and LVS fails catastrophically).
set -euo pipefail

PDK_ROOT="${PDK_ROOT:-$HOME/.ciel/ciel/sky130/versions/7b70722e33c03fcb5dabcf4d479fb0822d9251c9}"
RUN="$(cd "$(dirname "$0")" && pwd)"
SCHEMATIC="${1:-$HOME/.xschem/simulations/BiasBuffers.spice}"
REPORT="${2:-$RUN/BiasBuffers.lvsdb}"

klayout -b -r "$PDK_ROOT/sky130A/libs.tech/klayout/lvs/sky130.lvs" \
  -rd "input=$RUN/BiasBuffers.gds" \
  -rd top_cell=BiasBuffers \
  -rd "schematic=$SCHEMATIC" \
  -rd "report=$REPORT" \
  -rd scale=true \
  -rd lvs_sub=sky130_gnd \
  -rd convert_subckts=true \
  -rd schematic_simplify=true \
  -rd net_only=true \
  -rd top_lvl_pins=true \
  -rd combine=true \
  -rd purge=true \
  -rd purge_nets=true

echo "Report: $REPORT"
