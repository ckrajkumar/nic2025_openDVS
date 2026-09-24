#!/usr/bin/env bash
# Stage a 2x2 variant GDS for quantus_replay_local.sh:  mk_quantus_stage.sh <tag> <openDVS_pixel2x2_top.*.gds>
# Copies the mrst_z3 stage inputs (PVL deck, CDL, pin order, tech) and writes the GDS with its top cell renamed openDVS_pixel2x2.
set -euo pipefail
TAG="${1:?tag}"; GDS="$(readlink -f "${2:?gds}")"
B=~/.cache/opencode/opendvs-pex/edited-quantus-stage-20260921-v1; N="$B/$TAG"
[ -e "$N" ] && { echo "stage $N exists"; exit 1; }
mkdir -p "$N"; cp -r "$B/mrst_z3/inputs" "$N/inputs"; rm -f "$N/inputs/openDVS_pixel2x2.gds"
python3 - "$GDS" "$N/inputs/openDVS_pixel2x2.gds" <<'PY'
import pya, sys
ly = pya.Layout(); ly.read(sys.argv[1]); top = ly.top_cell(); assert top.name == "openDVS_pixel2x2_top", top.name
top.name = "openDVS_pixel2x2"; ly.write(sys.argv[2]); print("wrote", sys.argv[2], "cells", ly.cells())
PY
cp "$GDS" "$B/openDVS_pixel2x2_top.$TAG.gds"
sha256sum "$N/inputs/openDVS_pixel2x2.gds" "$B/mrst_z3/inputs/openDVS_pixel2x2.gds" | cut -c1-16
echo "staged $TAG; run: bash ~/.cache/opencode/opendvs-pex/quantus_replay_local.sh $TAG"
