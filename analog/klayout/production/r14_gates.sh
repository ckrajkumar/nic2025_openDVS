#!/usr/bin/env -S -u LD_LIBRARY_PATH bash
# round-14 gates: export the 2x2, launch Magic 4x4 DRC top/bot + Magic RCC on ini (background), PDK KLayout deck FEOL+BEOL on the 2x2 and 4x4
set -uo pipefail
TAG="${1:?tag}"
cd ~/research/projects/telluride/2025/nic_eventcam/nic2025_openDVS/analog/klayout/production
K="$HOME/git/klayout/bin-release/klayout"; export LD_LIBRARY_PATH="$HOME/git/klayout/bin-release:$HOME/anaconda3/lib"
mkdir -p logs
echo "== export 2x2"
cat > rcc/export_one.py <<PY
import pya
ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); c = ly.cell("openDVS_pixel2x2_top")
opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(c.cell_index()); ly.write("rcc/openDVS_pixel2x2_top.$TAG.gds", opt)
PY
"$K" -b -r rcc/export_one.py 2>&1 | grep -v libcurl; sha256sum rcc/openDVS_pixel2x2_top.$TAG.gds | cut -c1-12
echo "== launch Magic 4x4 top/bot DRC + RCC (background, logs/)"
nohup ./drc_4x4.sh $TAG > logs/drc_4x4_$TAG.log 2>&1 &
nohup ./drc_4x4_bot.sh $TAG > logs/drc_4x4_bot_$TAG.log 2>&1 &
nohup ./rcc_update.sh $TAG > logs/rcc_update_$TAG.log 2>&1 &
for i in $(seq 1 30); do [ -s rcc/openDVS_pixel_4x4.$TAG.gds ] && break; sleep 1; done
DECK=$(ls ~/.ciel/ciel/sky130/versions/*/sky130A/libs.tech/klayout/drc/sky130A.lydrc | head -1); echo "deck: $DECK"
for cell in openDVS_pixel2x2_top openDVS_pixel_4x4; do
  G=rcc/$cell.$TAG.gds; R=rcc/pdkdrc_$cell.$TAG.lyrdb
  echo "== PDK deck FEOL+BEOL on $G"
  ( time "$K" -b -r "$DECK" -rd input=$G -rd report=$(basename $R) -rd feol=true -rd beol=true -rd offgrid=true -rd seal=false -rd floating_met=false ) 2>&1 | grep -v libcurl | grep -E 'real|ERROR|error' 
  [ -f rcc/$(basename $R) ] && mv rcc/$(basename $R) $R 2>/dev/null; [ -f $(basename $R) ] && mv $(basename $R) $R 2>/dev/null
  printf "   items: %s   categories with items: " "$(grep -c '<item>' $R)"; python3 - "$R" <<'PY'
import sys, re
t = open(sys.argv[1]).read()
cats = re.findall(r"<item>.*?<category>'?([^<']+)'?</category>", t, re.S)
from collections import Counter; c = Counter(cats); print(dict(c) if c else "none")
PY
done
