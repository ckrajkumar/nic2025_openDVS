#!/bin/bash
# Parasitic extraction using Magic + Netgen LVS name mapping
# Extracts ALL modes in one run and produces one file per type.
#
# Usage: ./run_pex.sh <gds_file> <schematic_spice> [cell_name]
#
# Output files: {cell_name}_{mode}.spice for each mode:
#   simple  — no parasitics (devices only)
#   c       — parasitic caps to ground/substrate only
#   cc      — all parasitic caps (ground + coupling)
#   r       — parasitic resistance only
#   rc      — resistance + caps to ground
#   rcc     — resistance + all caps (ground + coupling)

set -e

GDS_FILE="$1"
SCHEMATIC="$2"
CELL_NAME="${3:-$(basename "$GDS_FILE" .gds)}"

PDK_ROOT="${PDK_ROOT:-/usr/local/share/pdk}"
PDK="${PDK:-sky130A}"
MAGICRC="$PDK_ROOT/$PDK/libs.tech/magic/$PDK.magicrc"
NETGEN_SETUP="$PDK_ROOT/$PDK/libs.tech/netgen/${PDK}_setup.tcl"

if [ -z "$GDS_FILE" ] || [ -z "$SCHEMATIC" ]; then
    echo "Usage: $0 <gds_file> <schematic_spice> [cell_name]"
    echo ""
    echo "  gds_file:        Layout GDS file"
    echo "  schematic_spice: Schematic netlist (SPICE)"
    echo "  cell_name:       Top cell name (default: GDS filename)"
    echo ""
    echo "Produces: {cell_name}_{mode}.spice for simple, c, cc, r, rc, rcc"
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
ORIG_DIR="$(pwd)"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FLAT="${CELL_NAME}_flat"

echo "==========================================="
echo "PEX: all modes (simple, c, cc, r, rc, rcc)"
echo "==========================================="
echo "GDS:       $GDS_FILE"
echo "Schematic: $SCHEMATIC"
echo "Cell:      $CELL_NAME"
echo "PDK:       $PDK"
echo ""

WORKDIR=$(mktemp -d)
trap "rm -rf $WORKDIR" EXIT
cd "$WORKDIR"

###############################################################################
# Step 1a: Read GDS, flatten, extract + extresist
###############################################################################
echo "--- Step 1a: Flatten + extract + extresist ---"
magic -dnull -noconsole -rcfile "$MAGICRC" << EOF || true
drc off
crashbackups stop
gds readonly true
gds rescale false
gds read $GDS_FULL
load $CELL_NAME
select top cell
flatten $FLAT
load $FLAT
select top cell
extract do local
extract no unique
extract all
ext2sim labels on
ext2sim
extresist tolerance 10
extresist all
quit -noprompt
EOF

if [ ! -f "${FLAT}.ext" ]; then
    echo "Error: Extraction failed — no .ext file"
    exit 1
fi
echo "Done."
echo ""

###############################################################################
# Step 1b: Generate base SPICE netlists from Magic
#   pex_simple.spice  — devices only (no parasitics)
#   pex_cc.spice      — devices + all caps (ground + coupling)
#   pex_extresist.spice — devices + R + all caps (from extresist, may drop devices)
###############################################################################
echo "--- Step 1b: Generate base SPICE netlists ---"

# Simple: devices only, no parasitics
magic -dnull -noconsole -rcfile "$MAGICRC" << EOF
drc off
crashbackups stop
load $FLAT
ext2spice format ngspice
ext2spice cthresh infinite
ext2spice -o pex_simple.spice
quit -noprompt
EOF
sed -i 's/^D\(.*sky130_fd_pr__model__parasitic__diode_ps2dn\)/XD\1/' pex_simple.spice

# CC: devices + all parasitic caps (ground + coupling)
magic -dnull -noconsole -rcfile "$MAGICRC" << EOF
drc off
crashbackups stop
load $FLAT
ext2spice format ngspice
ext2spice cthresh 0.01
ext2spice -o pex_cc.spice
quit -noprompt
EOF
sed -i 's/^D\(.*sky130_fd_pr__model__parasitic__diode_ps2dn\)/XD\1/' pex_cc.spice

# Extresist: R+C (may drop devices like MIM caps)
if [ -f "${FLAT}.res.ext" ]; then
    echo "Found ${FLAT}.res.ext ($(grep -c '^resist' ${FLAT}.res.ext) resistors)"
    magic -dnull -noconsole -rcfile "$MAGICRC" << EOF
drc off
crashbackups stop
load $FLAT
ext2spice format ngspice
ext2spice extresist on
ext2spice cthresh 0.01
ext2spice rthresh 1
ext2spice -o pex_extresist.spice
quit -noprompt
EOF
    sed -i 's/^D\(.*sky130_fd_pr__model__parasitic__diode_ps2dn\)/XD\1/' pex_extresist.spice 2>/dev/null
fi

echo "Done."
echo ""

###############################################################################
# Step 1c: Build all 6 variants from the base netlists
###############################################################################
echo "--- Step 1c: Building all 6 extraction variants ---"
python3 - "$CELL_NAME" << 'PYEOF'
import re, sys

cell_name = sys.argv[1]

# Read base netlists
with open('pex_simple.spice') as f:
    simple_lines = f.readlines()

with open('pex_cc.spice') as f:
    cc_lines = f.readlines()

# Collect R lines from extresist extraction
r_lines = []
try:
    with open('pex_extresist.spice') as f:
        for line in f:
            if line.startswith('R'):
                r_lines.append(line)
except FileNotFoundError:
    pass

# --- Normalize anonymous net '#' suffix for R network compatibility ---
r_nets = set()
for line in r_lines:
    for token in line.split()[1:3]:
        base = re.sub(r'\.[tn]\d+$', '', token)
        r_nets.add(base)

hash_nets = set()
for line in cc_lines:
    for m in re.finditer(r'(a_\S+)#', line):
        if m.group(1) in r_nets:
            hash_nets.add(m.group(1))

if hash_nets:
    print(f"Normalizing {len(hash_nets)} anonymous net names (strip '#')")

def normalize(lines):
    out = []
    for line in lines:
        for net in hash_nets:
            line = line.replace(net + '#', net)
        out.append(line)
    return out

simple_lines = normalize(simple_lines)
cc_lines = normalize(cc_lines)

# --- Classify lines ---
def split_lines(lines):
    """Split netlist into devices, ground caps, coupling caps, and other."""
    devices = []  # X lines
    c_gnd = []    # C lines with one terminal = GND or substrate (0)
    c_cc = []     # C lines between two signal nets
    other = []    # comments, etc.
    gnd_names = {'0', 'gnd', 'GND', 'GND!', 'Gnd', 'GndA', 'GndD', 'vss', 'VSS', 'VSUBS'}
    for line in lines:
        if line.startswith('X') or line.startswith('x'):
            devices.append(line)
        elif line.startswith('C'):
            parts = line.split()
            if len(parts) >= 3:
                n1, n2 = parts[1], parts[2]
                if n1 in gnd_names or n2 in gnd_names:
                    c_gnd.append(line)
                else:
                    c_cc.append(line)
            else:
                other.append(line)
        else:
            other.append(line)
    return devices, c_gnd, c_cc, other

cc_devs, cc_c_gnd, cc_c_cc, cc_other = split_lines(cc_lines)

# --- Generate tie resistors for R network ---
# Only needed when bare net appears in devices/caps but is NOT already
# connected in the R network (i.e. bare net never appears as a node in R lines).
# If the R network already has R from bare_net -> .nX -> .tN, a tie would
# bypass the actual parasitic resistance with 0.01 ohm.
tie_nets = {}
for line in r_lines:
    tokens = line.split()
    for token in tokens[1:3]:
        m = re.match(r'(.+)\.t0$', token)
        if m:
            tie_nets[m.group(1)] = token

# Collect all node names that appear in R lines
r_nodes = set()
for line in r_lines:
    tokens = line.split()
    if len(tokens) >= 3:
        r_nodes.add(tokens[1])
        r_nodes.add(tokens[2])

all_content = cc_devs + cc_c_gnd + cc_c_cc
tie_r = []
for base, t0 in sorted(tie_nets.items()):
    # Skip if bare net already appears in R network — it's already connected
    if base in r_nodes:
        continue
    for line in all_content:
        pat = re.compile(r'(?<!\.)(?<!\w)' + re.escape(base) + r'(?!\.\w)(?!\w)')
        if pat.search(line):
            tie_r.append(f'R_tie_{base} {base} {t0} 0.01\n')
            break

n_dev = len(cc_devs)
n_c_gnd = len(cc_c_gnd)
n_c_cc = len(cc_c_cc)
n_r = len(r_lines)
n_tie = len(tie_r)
print(f"Devices:      {n_dev}")
print(f"Caps to GND:  {n_c_gnd}")
print(f"Coupling caps: {n_c_cc}")
print(f"Resistors:    {n_r}")
print(f"Tie resistors: {n_tie}")

# --- Assemble variants ---
def write_variant(filename, devices, caps_gnd, caps_cc, resistors, ties):
    with open(filename, 'w') as f:
        for line in cc_other:
            f.write(line)
        for line in devices:
            f.write(line)
        if caps_gnd:
            f.write('* --- Parasitic caps to ground ---\n')
            for line in caps_gnd:
                f.write(line)
        if caps_cc:
            f.write('* --- Coupling caps ---\n')
            for line in caps_cc:
                f.write(line)
        if resistors:
            f.write('* --- Parasitic resistors from extresist ---\n')
            for line in resistors:
                f.write(line)
        if ties:
            f.write('* --- Tie bare nets to R network terminals ---\n')
            for line in ties:
                f.write(line)

# simple: devices only
write_variant('pex_raw_simple.spice', cc_devs, [], [], [], [])

# c: devices + ground caps
write_variant('pex_raw_c.spice', cc_devs, cc_c_gnd, [], [], [])

# cc: devices + all caps
write_variant('pex_raw_cc.spice', cc_devs, cc_c_gnd, cc_c_cc, [], [])

# r: devices + R
write_variant('pex_raw_r.spice', cc_devs, [], [], r_lines, tie_r)

# rc: devices + R + ground caps
write_variant('pex_raw_rc.spice', cc_devs, cc_c_gnd, [], r_lines, tie_r)

# rcc: devices + R + all caps
write_variant('pex_raw_rcc.spice', cc_devs, cc_c_gnd, cc_c_cc, r_lines, tie_r)

print("All 6 variants written.")
PYEOF

echo "Done."
echo ""

###############################################################################
# Step 2: Run Netgen LVS
###############################################################################
echo "--- Step 2: LVS verification ---"
magic -dnull -noconsole -rcfile "$MAGICRC" << EOF
drc off
crashbackups stop
gds readonly true
gds rescale false
gds read $GDS_FULL
load $CELL_NAME
select top cell
extract do local
extract no unique
extract all
ext2spice lvs
ext2spice -o layout_lvs.spice
quit -noprompt
EOF

sed -i 's/^D\(.*sky130_fd_pr__model__parasitic__diode_ps2dn\)/XD\1/' layout_lvs.spice

netgen -batch lvs \
    "layout_lvs.spice $CELL_NAME" \
    "$SCH_FULL $CELL_NAME" \
    "$NETGEN_SETUP" \
    lvs_report.out \
    -json 2>&1 | tail -3
echo ""

###############################################################################
# Step 3–5: For each mode, apply net names, fix terminals, rename devices
###############################################################################

for MODE in simple c cc r rc rcc; do
    PEX_SPICE="${CELL_NAME}_${MODE}.spice"
    RAW="pex_raw_${MODE}.spice"
    HAS_R=false
    case "$MODE" in r|rc|rcc) HAS_R=true ;; esac

    echo "=========== $MODE ==========="

    # Step 3: Apply schematic net names + wrap in .subckt
    python3 - "$CELL_NAME" "$SCH_FULL" "$RAW" "$PEX_SPICE" lvs_report.out "$MODE" << 'PYEOF'
import re, sys

cell_name = sys.argv[1]
sch_file  = sys.argv[2]
pex_in    = sys.argv[3]
pex_out   = sys.argv[4]
lvs_file  = sys.argv[5]
mode      = sys.argv[6]

inst_map = {}
# Try LVS report first (works when subcircuits match hierarchically)
with open(lvs_file, "r") as f:
    for line in f:
        m = re.match(r'(\S+)/sky130_\S+ vs\. \S+:(Pix\[\d+\])/', line)
        if m and m.group(1) not in inst_map:
            inst_map[m.group(1)] = m.group(2)
# Fallback: match layout pixel instances to schematic by vpd connectivity
if not inst_map:
    with open(pex_in) as f:
        pex_text = f.read()
    # Find layout pixel prefixes
    lay_prefixes = sorted(set(re.findall(r'((?:openDVS_pixel|pix\[\d+\]\$\S+)_\d+)(?=\.)', pex_text)))
    # For each layout prefix, find which vpd[N] it connects to
    for prefix in lay_prefixes:
        pat = re.compile(re.escape(prefix) + r'\.\w+.*?vpd\[(\d+)\]|vpd\[(\d+)\].*?' + re.escape(prefix) + r'\.\w+')
        for line in pex_text.splitlines():
            if prefix + '.' in line and 'vpd[' in line:
                vm = re.search(r'vpd\[(\d+)\]', line)
                if vm:
                    inst_map[prefix] = f'xPix[{vm.group(1)}]'
                    break

ports = []
with open(sch_file, "r") as f:
    in_subckt = False
    for line in f:
        line = line.rstrip()
        if line.startswith(f'.subckt {cell_name} '):
            ports.extend(line.split()[2:])
            in_subckt = True
        elif in_subckt and line.startswith('+'):
            ports.extend(line[1:].split())
        elif in_subckt:
            break

with open(pex_in, "r") as f:
    pex = f.read()

name_map = {}
for lay_inst, sch_inst in inst_map.items():
    escaped = re.escape(lay_inst)
    for m in re.finditer(escaped + r'\.(\w+)', pex):
        lay_net = m.group(0)
        signal = m.group(1)
        sch_net = f"{sch_inst}.{signal}"
        if lay_net not in name_map:
            name_map[lay_net] = sch_net

for lay in sorted(name_map.keys(), key=len, reverse=True):
    pex = pex.replace(lay, name_map[lay])

header = f".subckt {cell_name} {' '.join(ports)}\n"
footer = f".ends {cell_name}\n"

with open(pex_out, "w") as f:
    f.write(f"* PEX netlist: {cell_name} (mode={mode}, extracted by Magic)\n")
    f.write(header)
    for line in pex.splitlines(keepends=True):
        f.write(line)
    f.write(footer)

print(f"  {mode}: net names applied")
PYEOF

    if [ ! -f "$PEX_SPICE" ]; then
        echo "  Warning: Name mapping failed for $MODE, using raw"
        PORTS=$(grep "^\.subckt $CELL_NAME " "$SCH_FULL" | sed "s/^\.subckt $CELL_NAME //")
        echo ".subckt $CELL_NAME $PORTS" > "$PEX_SPICE"
        sed "s/${FLAT}/${CELL_NAME}/g" "$RAW" >> "$PEX_SPICE"
        echo ".ends $CELL_NAME" >> "$PEX_SPICE"
    fi

    # Step 4: Fix device-to-terminal connections (R modes only)
    if $HAS_R; then
        set +e
        if [ -f "${FLAT}.res.ext" ] && [ -f "${FLAT}.sim" ]; then
            python3 "$SCRIPT_DIR/pex_fix_terminals.py" \
                "${FLAT}.res.ext" "${FLAT}.sim" "$PEX_SPICE" "${PEX_SPICE}.tmp" lvs_report.out
            if [ -f "${PEX_SPICE}.tmp" ]; then
                mv "${PEX_SPICE}.tmp" "$PEX_SPICE"
                echo "  $MODE: terminals fixed"
            fi
        fi
        set -e
    fi

    # Step 5: Rename devices and terminals
    set +e
    if $HAS_R && [ -f "layout_lvs.spice" ] && [ -f "${FLAT}.res.ext" ] && [ -f "${FLAT}.sim" ]; then
        python3 "$SCRIPT_DIR/pex_name_map.py" \
            "$PEX_SPICE" layout_lvs.spice "$SCH_FULL" "${PEX_SPICE}.named" \
            --res-ext "${FLAT}.res.ext" --sim "${FLAT}.sim" --lvs-report lvs_report.out
    elif [ -f "layout_lvs.spice" ]; then
        python3 "$SCRIPT_DIR/pex_name_map.py" \
            "$PEX_SPICE" layout_lvs.spice "$SCH_FULL" "${PEX_SPICE}.named" \
            --lvs-report lvs_report.out
    fi
    if [ -f "${PEX_SPICE}.named" ]; then
        mv "${PEX_SPICE}.named" "$PEX_SPICE"
        echo "  $MODE: devices renamed"
    fi
    set -e

    cp "$PEX_SPICE" "$ORIG_DIR/"
done

echo ""
echo "==========================================="
if grep -q "Circuits match" lvs_report.out 2>/dev/null; then
    echo "LVS:    MATCH"
else
    echo "LVS:    MISMATCH"
    cp lvs_report.out "$ORIG_DIR/${CELL_NAME}_lvs.out"
    echo "Report: $ORIG_DIR/${CELL_NAME}_lvs.out"
fi
echo ""
echo "Output files:"
for MODE in simple c cc r rc rcc; do
    f="$ORIG_DIR/${CELL_NAME}_${MODE}.spice"
    if [ -f "$f" ]; then
        devs=$(grep -cE '^[Xx]' "$f" || true)
        caps=$(grep -cE '^C' "$f" || true)
        res=$(grep -cE '^R' "$f" || true)
        printf "  %-30s  %3d dev  %3d cap  %3d res\n" "${CELL_NAME}_${MODE}.spice" "$devs" "$caps" "$res"
    fi
done
echo "==========================================="
