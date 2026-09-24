#!/usr/bin/env -S -u LD_LIBRARY_PATH bash
# Magic DRC of a 4x4 window of pixel_layout_tile_BOT (openDVS_pixel2x2_bot context) built from a COPY of the GDS.
#   ./drc_4x4_bot.sh <tag>   [GDS=<file>]   -> rcc/openDVS_pixel_4x4_bot.<tag>.gds ; rule list from ini
# Baseline (pristine pixel_4tile_mag_9_1_pruned.gds): capm.11 + "can't abut or partially overlap between subcells" only.
set -euo pipefail
TAG="${1:?tag}"; GDS="${GDS:-pixel_4tile_work.gds}"; D="$(cd "$(dirname "$0")" && pwd)"; cd "$D"
K="$HOME/git/klayout/bin-release/klayout"; export LD_LIBRARY_PATH="$HOME/git/klayout/bin-release:$HOME/anaconda3/lib"
INI=rpgraca-ini.wg0; W=".cache/opencode/opendvs-pex/edited-pixel-magic-20260921-v1"
cp "$GDS" "rcc/work_bot4x4.$TAG.gds"
"$K" -b -r add_4x4.py -rd "gds=rcc/work_bot4x4.$TAG.gds" -rd name=openDVS_pixel_4x4_bot -rd tile=pixel_layout_tile_bot 2>&1 | grep -v libcurl | head -1 || true
cat > rcc/export_4x4_bot.py <<PY
import pya
ly = pya.Layout(); ly.read("rcc/work_bot4x4.$TAG.gds"); c = ly.cell("openDVS_pixel_4x4_bot")
opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(c.cell_index()); ly.write("rcc/openDVS_pixel_4x4_bot.$TAG.gds", opt)
PY
"$K" -b -r rcc/export_4x4_bot.py 2>&1 | grep -v libcurl || true
rm -f "rcc/work_bot4x4.$TAG.gds"
ssh -o BatchMode=yes $INI "mkdir -p ~/$W && cat > ~/$W/openDVS_pixel_4x4_bot.$TAG.gds" < "rcc/openDVS_pixel_4x4_bot.$TAG.gds"
ssh -o BatchMode=yes $INI "cd ~/$W && rm -rf drc4x4bot_$TAG && bash ../magic_drc.sh openDVS_pixel_4x4_bot.$TAG.gds openDVS_pixel_4x4_bot drc4x4bot_$TAG > /dev/null 2>&1; echo '   rules flagged (bot 4x4):'; grep -v '^{' drc4x4bot_$TAG/drc_why.txt | grep -v '^ *[0-9]* {' | sort -u"
