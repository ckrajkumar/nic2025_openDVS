#!/bin/bash
# Idempotent: create the production KLayout workspace on HPelite.
set -euo pipefail
W="$HOME/research/projects/telluride/2025/nic_eventcam/nic2025_openDVS/analog/klayout/production"
SRC=/tmp/opencode/opendvs-pex-gui-20260921/production-openDVS-pixel-macro.gds
SHA=209d312b041d3c48bd698cb549701a58fee506361b6d133c8d57d08e2bf05101
STAGE="$(dirname "$0")"
echo "== workspace $W"
mkdir -p "$W"
echo "== pristine production GDS"
if [ ! -f "$W/pixel_4tile_mag_9_1_pruned.gds" ]; then
  echo "$SHA  $SRC" | sha256sum -c -
  install -m 0444 "$SRC" "$W/pixel_4tile_mag_9_1_pruned.gds"
fi
echo "$SHA  $W/pixel_4tile_mag_9_1_pruned.gds" | sha256sum -c -
echo "== working copy (only created if absent -- never overwrite edits)"
[ -f "$W/pixel_4tile_work.gds" ] || install -m 0644 "$W/pixel_4tile_mag_9_1_pruned.gds" "$W/pixel_4tile_work.gds"
echo "== scripts"
install -m 0644 "$STAGE/opendvs_l2n.py" "$W/opendvs_l2n.py"
install -m 0755 "$STAGE/open_production.sh" "$W/open_production.sh"
install -m 0644 "$STAGE/opendvs_nets.lym" "$HOME/.klayout/pymacros/opendvs_nets.lym"
cat > "$W/README.md" <<'MD'
# Production openDVS pixel macro -- KLayout workspace

- `pixel_4tile_mag_9_1_pruned.gds` -- pristine production macro (read-only, sha256 209d312b...),
  identical to the PEX campaign's `production_pixel_macro` authority on rpgraca-ini.
- `pixel_4tile_work.gds` -- the editable copy. One file holds the whole hierarchy:
  `pixel_4tile` -> `pixel_layout_tile`/`_bot` -> `openDVS_pixel2x2_top`/`_bot` -> `openDVS_pixel`.
  Edit `openDVS_pixel` once and every 2x2 and the 4-tile view follow.
- `./open_production.sh` -- opens the working copy editable with the sky130 tech.
- Tools -> "openDVS: extract nets" (Ctrl+Shift+N) -- extracts the current cell in memory and opens the
  Netlist Browser; click a net to highlight it. Re-run after edits. Writes `<file>.<cell>.l2n` alongside.
- Batch: `klayout -b -r opendvs_l2n.py -rd gds=pixel_4tile_work.gds -rd top=openDVS_pixel2x2_top`
MD
ls -la "$W" "$HOME/.klayout/pymacros/opendvs_nets.lym"
