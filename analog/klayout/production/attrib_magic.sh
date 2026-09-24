#!/usr/bin/env bash
# Magic RCC of a pixel-only GDS, print C between two labelled nets.  attrib_magic.sh <gds> <netA> <netB>
set -euo pipefail
P=~/.cache/opencode/opendvs-pex/latest-production-pixel-magic-v1
GDS="$(readlink -f "$1")"; A="$2"; B="$3"; W="${GDS%.gds}.magic"; mkdir -p "$W"; cd "$W"
cp "$P/extract_full_array.tcl" "$P/run_checked.tcl" .
env CAD_ROOT="$P/prefix/lib" CAMPAIGN_TCL="$W/extract_full_array.tcl" INPUT_GDS="$GDS" TOP_CELL=openDVS_pixel OUTPUT_SPICE="$W/pixel.spice" \
  "$P/prefix/bin/magic" -dnull -noconsole -rcfile /usr/local/share/pdk/sky130A/libs.tech/magic/sky130A.magicrc run_checked.tcl > magic.stdout 2> magic.stderr
python3 - "$A" "$B" <<'PY'
import re, sys
A, B = sys.argv[1:]; tot = 0.0; n = 0
for l in open("pixel.spice"):
    f = l.split()
    if f and re.fullmatch(r"C\d+", f[0]) and len(f) >= 4:
        x, y = (re.sub(r"\.t\d+$", "", f[1]), re.sub(r"\.t\d+$", "", f[2]))
        if {x, y} == {A, B}: tot += float(f[3].rstrip("f")); n += 1
print("C(%s,%s) = %.4f fF (%d cards)" % (A, B, tot, n))
PY
