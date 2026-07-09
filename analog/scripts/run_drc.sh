#!/bin/bash
# Run DRC on a GDS file using Magic + sky130 PDK
# Usage: ./run_drc.sh <gds_file> [cell_name]
#   If cell_name is omitted, uses the filename without extension
# Exits 1 if any DRC errors are found.

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <gds_file> [cell_name]"
    exit 1
fi

GDS_FILE="$1"
CELL_NAME="${2:-$(basename "$GDS_FILE" .gds)}"
REPORT_FILE="${CELL_NAME}_drc_report.txt"

if [ -z "$PDK_ROOT" ] || [ -z "$PDK" ]; then
    echo "Error: PDK_ROOT and PDK not set. Run: source cad_setup"
    exit 1
fi

MAGICRC="$PDK_ROOT/$PDK/libs.tech/magic/${PDK}.magicrc"

if [ ! -f "$GDS_FILE" ]; then
    echo "Error: $GDS_FILE not found"
    exit 1
fi

echo "Running DRC on $GDS_FILE (cell: $CELL_NAME)..."

magic -dnull -noconsole -rcfile "$MAGICRC" << EOF
# Flatten KLayout PCell subcells on read. Magic resolves GDS layers into
# its internal types per-cell, but the PCell contact/tap subcells hold
# tap+licon without the implant/nwell layers (those live in the parent
# cell), so unflattened taps are misread as pdiff/pwell and trigger false
# diff/tap.8, nwell.4 and LU.* errors. The fet PCells carry their own
# implants but not taps, so standalone they fail nwell.4/LU.* checks that
# their parent context satisfies; flattening them checks them in context.
gds flatglob *contact*
gds flatglob nfet*
gds flatglob pfet*
gds read $GDS_FILE
load $CELL_NAME
select top cell
drc euclidean on
drc on
drc style drc(full)
drc check
drc catchup

set oscale [cif scale out]

# drc listall count returns {cellname count} pairs for every cell in
# memory that has errors (empty list if clean)
set cellcounts [drc listall count]
set total 0
foreach pair \$cellcounts { incr total [lindex \$pair 1] }

puts "========================================="
puts "DRC Report: $CELL_NAME"
puts "GDS File:   $GDS_FILE"
puts "========================================="
puts "Total DRC errors: \$total"
puts "========================================="

set fout [open $REPORT_FILE w]
puts \$fout "DRC Report: $CELL_NAME"
puts \$fout "GDS File:   $GDS_FILE"
puts \$fout "Total DRC errors: \$total"
puts \$fout "========================================="
foreach pair \$cellcounts {
    puts \$fout "[lindex \$pair 0]: [lindex \$pair 1] errors"
}
puts \$fout "========================================="
puts \$fout "Detailed errors (box coordinates in um):"
puts \$fout "========================================="
foreach pair \$cellcounts {
    set cellname [lindex \$pair 0]
    puts \$fout ""
    puts \$fout "Cell: \$cellname"
    load \$cellname
    select top cell
    # drc listall why returns {why boxlist} pairs for the current cell
    foreach {why boxes} [drc listall why] {
        puts \$fout "  \$why"
        foreach b \$boxes {
            set um {}
            foreach v \$b { lappend um [format %.3f [expr {\$oscale * \$v}]] }
            puts \$fout "    (\$um)"
        }
    }
}
close \$fout
quit -noprompt
EOF

echo ""
echo "DRC complete. Report saved to: $REPORT_FILE"
cat "$REPORT_FILE"

grep -q "^Total DRC errors: 0$" "$REPORT_FILE"
