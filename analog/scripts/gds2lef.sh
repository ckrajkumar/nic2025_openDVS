#!/bin/bash
# Generate LEF from GDS using Magic + sky130 PDK
# Usage: ./gds2lef.sh <gds_file> [cell_name] [output_dir]

set -e

GDS_FILE="$1"
CELL_NAME="${2:-$(basename "$GDS_FILE" .gds)}"
OUTPUT_DIR="${3:-.}"

PDK_ROOT="${PDK_ROOT:-/usr/local/share/pdk}"
PDK="${PDK:-sky130A}"
MAGICRC="$PDK_ROOT/$PDK/libs.tech/magic/$PDK.magicrc"

if [ -z "$GDS_FILE" ]; then
    echo "Usage: $0 <gds_file> [cell_name] [output_dir]"
    echo "  If cell_name is omitted, uses filename without .gds extension"
    exit 1
fi

if [ ! -f "$GDS_FILE" ]; then
    echo "Error: $GDS_FILE not found"
    exit 1
fi

if [ ! -f "$MAGICRC" ]; then
    echo "Error: Magic RC file not found: $MAGICRC"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"
GDS_FULL="$(realpath "$GDS_FILE")"
OUT_FULL="$(realpath "$OUTPUT_DIR")"
LEF_FILE="$OUT_FULL/${CELL_NAME}.lef"

echo "GDS file:  $GDS_FILE"
echo "Cell name: $CELL_NAME"
echo "Output:    $LEF_FILE"
echo "PDK:       $PDK"
echo ""

magic -dnull -noconsole -rcfile "$MAGICRC" << EOF
drc off
crashbackups stop
gds readonly true
gds labels yes
gds read $GDS_FULL
load $CELL_NAME
select top cell
port makeall
lef write $LEF_FILE -hide
quit -noprompt
EOF

if [ -f "$LEF_FILE" ]; then
    echo ""
    echo "SUCCESS: Generated $LEF_FILE"
    echo "Size: $(wc -c < "$LEF_FILE") bytes"
    echo "Lines: $(wc -l < "$LEF_FILE")"
else
    echo ""
    echo "ERROR: LEF file was not generated"
    exit 1
fi
