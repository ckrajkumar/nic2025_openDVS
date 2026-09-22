#!/usr/bin/env -S -u LD_LIBRARY_PATH bash
# Magic DRC (drc(full), frozen production magic on rpgraca-ini) of the 4x4 cell of the saved work GDS.
#   ./drc_4x4.sh <tag>      -> rcc/openDVS_pixel_4x4.<tag>.gds ; report from ini printed (rule counts)
set -euo pipefail
TAG="${1:?tag}"; GDS="${GDS:-pixel_4tile_work.gds}"     # GDS=<file> ./drc_4x4.sh <tag> to check another file; D="$(cd "$(dirname "$0")" && pwd)"; cd "$D"
K="$HOME/git/klayout/bin-release/klayout"; export LD_LIBRARY_PATH="$HOME/git/klayout/bin-release:$HOME/anaconda3/lib"
INI=rpgraca-ini.wg0; W=".cache/opencode/opendvs-pex/edited-pixel-magic-20260921-v1"
cat > rcc/export_4x4.py <<PY
import pya
ly = pya.Layout(); ly.read("$GDS"); c = ly.cell("openDVS_pixel_4x4")
opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(c.cell_index()); ly.write("rcc/openDVS_pixel_4x4.$TAG.gds", opt)
PY
"$K" -b -r rcc/export_4x4.py 2>&1 | grep -v libcurl || true
ssh -o BatchMode=yes $INI "mkdir -p ~/$W && cat > ~/$W/openDVS_pixel_4x4.$TAG.gds" < "rcc/openDVS_pixel_4x4.$TAG.gds"
ssh -o BatchMode=yes $INI "cd ~/$W && rm -rf drc4x4_$TAG && bash ../magic_drc.sh openDVS_pixel_4x4.$TAG.gds openDVS_pixel_4x4 drc4x4_$TAG | grep -v '^ *[0-9]* {' ; echo '   rules flagged:'; grep -v '^{' drc4x4_$TAG/drc_why.txt | sort | uniq -c"
