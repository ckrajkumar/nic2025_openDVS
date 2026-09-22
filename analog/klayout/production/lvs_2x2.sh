#!/usr/bin/env -S -u LD_LIBRARY_PATH bash
# LVS of the saved 2x2 (pixel_4tile_work.gds : openDVS_pixel2x2_top) against analog/xschem/openDVS_pixel2x2.sch.
#   ./lvs_2x2.sh              -> verdict + mismatch list; DB in lvs/openDVS_pixel2x2_top.work.deep.lvsdb
#   ./lvs_2x2.sh other_cell   -> same for another 2x2 cell (e.g. openDVS_pixel2x2_bot)
set -euo pipefail
D="$(cd "$(dirname "$0")" && pwd)"; cd "$D"
CELL="${1:-openDVS_pixel2x2_top}"
DB="lvs/$CELL.work.deep.lvsdb"
rm -f "$DB"                                   # never compare a stale database
echo "== layout: pixel_4tile_work.gds saved $(stat -c %y pixel_4tile_work.gds | cut -c1-19)"
# the raw deck always exits 1 on this layout ("Netlists don't match" before the flattened compare), so
# judge the step by its product: a fresh database newer than the layout.
RUN_MODE=deep TAG=.work.deep ./run_lvs_2x2.sh "$CELL" > "lvs/$CELL.run.log" 2>&1 || true
if [ ! -s "$DB" ] || [ "$DB" -ot pixel_4tile_work.gds ]; then
  echo "!! no fresh $DB -- extraction/deck step failed; see lvs/$CELL.run.log and lvs/$CELL.work.deep.lvs.log"; tail -5 "lvs/$CELL.run.log"; exit 1
fi
LD_LIBRARY_PATH="$HOME/git/klayout/bin-release:$HOME/anaconda3/lib" "$HOME/git/klayout/bin-release/klayout" -b -r lvs_compare_flat.py -rd db="$DB" 2>&1 | grep -v libcurl
echo "browse: Tools -> Netlist Browser -> open $DB"
