#!/usr/bin/env bash
# Magic DRC of a GDS top cell with the frozen production magic.  magic_drc.sh <gds> <top> <outdir>
set -euo pipefail
P=~/.cache/opencode/opendvs-pex/latest-production-pixel-magic-v1
GDS="$(readlink -f "$1")"; TOP="$2"; OUT="$3"; mkdir -p "$OUT"; cd "$OUT"
cat > drc.tcl <<TCL
drc off
crashbackups stop
gds readonly true
gds rescale false
gds read $GDS
load $TOP
select top cell
drc style drc(full)
drc euclidean on
drc on
drc check
puts "DRC_COUNT [drc count total]"
set fh [open drc_why.txt w]
foreach e [drc listall why] { puts \$fh \$e }
close \$fh
quit -noprompt
TCL
CAD_ROOT="$P/prefix/lib" "$P/prefix/bin/magic" -dnull -noconsole -rcfile /usr/local/share/pdk/sky130A/libs.tech/magic/sky130A.magicrc drc.tcl > magic_drc.stdout 2> magic_drc.stderr || true
grep "DRC_COUNT" magic_drc.stdout; sort drc_why.txt | uniq -c | sort -rn | head -20
