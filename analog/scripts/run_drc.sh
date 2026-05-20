#!/bin/bash
# Run DRC on a GDS file using Magic + sky130 PDK
# Usage: ./run_drc.sh <gds_file> [cell_name]
#   If cell_name is omitted, uses the filename without extension

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
gds read $GDS_FILE
load $CELL_NAME
select top cell
drc on
drc style drc(full)
drc catchup
set count [drc list count total]
puts "========================================="
puts "DRC Report: $CELL_NAME"
puts "GDS File:   $GDS_FILE"
puts "========================================="
puts "Total DRC errors: \$count"
puts "========================================="

set fout [open $REPORT_FILE w]
puts \$fout "DRC Report: $CELL_NAME"
puts \$fout "GDS File:   $GDS_FILE"
puts \$fout "Total DRC errors: \$count"
puts \$fout "========================================="
select top cell
set errors [drc listall count]
foreach {cellname num} \$errors {
    puts \$fout "\$cellname: \$num errors"
}
puts \$fout "========================================="
puts \$fout "Detailed errors:"
puts \$fout "========================================="
set whylist [drc listall why]
foreach {cellname why} \$whylist {
    puts \$fout ""
    puts \$fout "Cell: \$cellname"
    foreach msg \$why {
        puts \$fout "  \$msg"
    }
}
close \$fout
quit
EOF

echo ""
echo "DRC complete. Report saved to: $REPORT_FILE"
cat "$REPORT_FILE"
