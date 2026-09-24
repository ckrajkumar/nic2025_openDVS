#!/bin/bash
# Run LVS using Magic (extraction) + Netgen (comparison) with sky130 PDK
# Usage: ./run_lvs.sh <gds_file> <schematic_spice> [cell_name] [netgen_setup] [vc_sed_file]
#   cell_name:    Top cell name (default: GDS filename without .gds)
#   netgen_setup: Custom netgen setup TCL (default: PDK setup)
#   vc_sed_file:  File with sed expressions for virtual connects (one per line)
#                 Applied to layout netlist before LVS comparison.
#                 Example contents:
#                   s/DiffBn_uq[0-9]*/DiffBn/g
#                   s/^D0 /XD0 /

set -e

GDS_FILE="$1"
SCHEMATIC="$2"
CELL_NAME="${3:-$(basename "$GDS_FILE" .gds)}"
CUSTOM_SETUP="$4"
VC_SED_FILE="$5"

PDK_ROOT="${PDK_ROOT:-/usr/local/share/pdk}"
PDK="${PDK:-sky130A}"
MAGICRC="$PDK_ROOT/$PDK/libs.tech/magic/$PDK.magicrc"

if [ -n "$CUSTOM_SETUP" ]; then
    NETGEN_SETUP="$(realpath "$CUSTOM_SETUP")"
else
    NETGEN_SETUP="$PDK_ROOT/$PDK/libs.tech/netgen/${PDK}_setup.tcl"
fi

if [ -z "$GDS_FILE" ] || [ -z "$SCHEMATIC" ]; then
    echo "Usage: $0 <gds_file> <schematic_spice> [cell_name] [netgen_setup] [vc_sed_file]"
    echo ""
    echo "  gds_file:        Layout GDS file"
    echo "  schematic_spice: Schematic netlist (SPICE)"
    echo "  cell_name:       Top cell name (default: GDS filename)"
    echo "  netgen_setup:    Custom netgen setup TCL (default: PDK setup)"
    echo "  vc_sed_file:     File with sed expressions for virtual connects"
    exit 1
fi

for f in "$GDS_FILE" "$SCHEMATIC" "$MAGICRC" "$NETGEN_SETUP"; do
    if [ ! -f "$f" ]; then
        echo "Error: $f not found"
        exit 1
    fi
done

GDS_FULL="$(realpath "$GDS_FILE")"
SCH_FULL="$(realpath "$SCHEMATIC")"
LAYOUT_SPICE="${CELL_NAME}_layout.spice"
LVS_REPORT="${CELL_NAME}_lvs.out"
LVS_JSON="${CELL_NAME}_lvs.json"

echo "==========================================="
echo "LVS: Magic extraction + Netgen comparison"
echo "==========================================="
echo "GDS:       $GDS_FILE"
echo "Schematic: $SCHEMATIC"
echo "Cell:      $CELL_NAME"
echo "PDK:       $PDK"
echo "Setup:     $NETGEN_SETUP"
[ -n "$VC_SED_FILE" ] && echo "VC rules:  $VC_SED_FILE"
echo ""

# Step 1: Extract layout netlist with Magic
echo "--- Step 1: Extracting layout netlist with Magic ---"
magic -dnull -noconsole -rcfile "$MAGICRC" << EOF
drc off
crashbackups stop
gds readonly true
gds read $GDS_FULL
load $CELL_NAME
select top cell
extract do local
extract all
ext2spice lvs
ext2spice -o $LAYOUT_SPICE
quit -noprompt
EOF
rm -f *.ext

if [ ! -f "$LAYOUT_SPICE" ]; then
    echo "Error: Magic extraction failed — $LAYOUT_SPICE not generated"
    exit 1
fi
echo "Extracted: $LAYOUT_SPICE"

# Step 2: Apply virtual connects (sed rules) if provided
LVS_SPICE="$LAYOUT_SPICE"
if [ -n "$VC_SED_FILE" ] && [ -f "$VC_SED_FILE" ]; then
    LVS_SPICE="${CELL_NAME}_layout_vc.spice"
    sed -f "$VC_SED_FILE" "$LAYOUT_SPICE" > "$LVS_SPICE"
    echo "Virtual connects applied: $LVS_SPICE"
fi
echo ""

# Step 3: Run LVS with Netgen
echo "--- Step 2: Running LVS with Netgen ---"
netgen -batch lvs "$LVS_SPICE $CELL_NAME" "$SCH_FULL $CELL_NAME" \
    "$NETGEN_SETUP" "$LVS_REPORT" -json

echo ""
echo "==========================================="
if grep -q "Circuits match uniquely" "$LVS_REPORT" 2>/dev/null; then
    echo "RESULT: LVS CLEAN — Circuits match"
else
    echo "RESULT: LVS MISMATCH — Check $LVS_REPORT for details"
fi
echo "==========================================="
echo "Report: $LVS_REPORT"
echo "JSON:   $LVS_JSON"
