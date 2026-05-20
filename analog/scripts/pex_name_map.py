#!/usr/bin/env python3
"""Build device and terminal name mappings for PEX netlist.

Maps flat PEX device names (X0, X1, ...) to schematic hierarchical names
(e.g. xPix[1]_xpr_XMpd) and terminal nodes (.tN) to device_pin names
(e.g. xPix[1]_xpr_XMpd_drain).

Uses the layout LVS subcircuit and schematic netlist hierarchy to match
devices by type + net connectivity.
"""
import re, sys, json


# Pin names for Sky130 device types
PIN_NAMES = {
    'sky130_fd_pr__nfet_01v8':      ['drain', 'gate', 'source', 'body'],
    'sky130_fd_pr__pfet_01v8':      ['drain', 'gate', 'source', 'body'],
    'sky130_fd_pr__pfet_01v8_hvt':  ['drain', 'gate', 'source', 'body'],
    'sky130_fd_pr__cap_mim_m3_1':   ['top', 'bot'],
    'sky130_fd_pr__model__parasitic__diode_ps2dn': ['pos', 'neg'],
}


def parse_subcircuit(lines, name):
    """Parse a .subckt block, return {inst: {type, nets, params}}."""
    devices = {}
    ports = []
    in_subckt = False
    reading_ports = False
    for line in lines:
        line = line.strip()
        if line.startswith(f'.subckt {name} '):
            ports = line.split()[2:]
            in_subckt = True
            reading_ports = True
            continue
        if reading_ports and line.startswith('+'):
            ports.extend(line[1:].split())
            continue
        else:
            reading_ports = False
        if in_subckt and line.startswith('.ends'):
            break
        if not in_subckt:
            continue
        if line.startswith(('X', 'x')):
            parts = line.split()
            inst = parts[0]
            nets = []
            dev_type = None
            for p in parts[1:]:
                if p.startswith('sky130'):
                    dev_type = p
                elif '=' in p:
                    break
                elif dev_type is None:
                    nets.append(p)
            devices[inst] = {'type': dev_type, 'nets': nets}
    return ports, devices


def parse_schematic_hierarchy(sch_path):
    """Parse xschem-generated schematic netlist, flatten device hierarchy.

    Returns dict of {flat_path: {type, nets_local}} for all devices
    within one openDVS_pixel instance (using local net names).
    """
    with open(sch_path) as f:
        lines = f.readlines()

    # Parse all subcircuits
    subcircuits = {}
    current_name = None
    current_lines = []
    for line in lines:
        stripped = line.strip()
        m = re.match(r'\.subckt\s+(\S+)\s+(.*)', stripped)
        if m:
            current_name = m.group(1)
            current_lines = [stripped]
            continue
        if current_name and stripped.startswith('.ends'):
            current_lines.append(stripped)
            ports, devices = parse_subcircuit(current_lines, current_name)
            subcircuits[current_name] = {'ports': ports, 'devices': devices}
            current_name = None
            continue
        if current_name:
            current_lines.append(stripped)

    # Flatten openDVS_pixel hierarchy
    flat_devices = {}

    def flatten(subckt_name, prefix, net_map):
        if subckt_name not in subcircuits:
            return
        sc = subcircuits[subckt_name]
        for inst, dev in sc['devices'].items():
            if dev['type']:
                # Leaf device — map nets through hierarchy
                mapped_nets = []
                for n in dev['nets']:
                    mapped = net_map.get(n, n)
                    mapped_nets.append(mapped)
                path = f"{prefix}{inst}" if prefix else inst
                flat_devices[path] = {
                    'type': dev['type'],
                    'nets': mapped_nets,
                }
            else:
                # Subcircuit instance — recurse
                # Find the subcircuit definition
                # The last token in nets is the subcircuit name
                # Actually dev['type'] is None, so the subcircuit name
                # is what we need to find. In xschem netlists, the last
                # net-like token before params is the subcircuit name
                # Let's find it from the original line
                pass

        # Handle subcircuit instances (type is None means it's a subcircuit call)
        for inst, dev in sc['devices'].items():
            if dev['type'] is None:
                # nets contains subcircuit args, last element might be name
                # Actually in our parse, if no sky130 prefix found, type stays None
                # The subcircuit name is the last token that's not a param
                # Let's look at the raw line structure
                # In xschem: "xpr VddA18 PrBp GndA vpd vpr PixelPhotoreceptor"
                # Our parser would have nets = [VddA18, PrBp, GndA, vpd, vpr, PixelPhotoreceptor]
                # The last element is the subcircuit name
                sub_name = dev['nets'][-1]
                sub_nets = dev['nets'][:-1]
                if sub_name in subcircuits:
                    sub_ports = subcircuits[sub_name]['ports']
                    # Build port→net mapping
                    child_map = {}
                    for port, net in zip(sub_ports, sub_nets):
                        mapped = net_map.get(net, net)
                        child_map[port] = mapped
                    flatten(sub_name, f"{prefix}{inst}/", child_map)

    # Start from openDVS_pixel
    if 'openDVS_pixel' in subcircuits:
        # Use identity net mapping (local names are the reference)
        identity = {p: p for p in subcircuits['openDVS_pixel']['ports']}
        flatten('openDVS_pixel', '', identity)

    return flat_devices


def parse_layout_subcircuit(lvs_path):
    """Parse layout LVS netlist for the pixel subcircuit (pix[2]$1).

    Also parses top-level instantiations to build per-pixel port mappings.
    Returns: (pix_name, ports, devices, pixel_port_maps)
    pixel_port_maps: {layout_inst: {top_net: subckt_port}}
    """
    with open(lvs_path) as f:
        lines = f.readlines()

    # Find the pix subcircuit name (may be pix[2]$1$1 or openDVS_pixel)
    pix_name = None
    for line in lines:
        m = re.match(r'\.subckt\s+(pix\[\d+\]\$\S+|openDVS_pixel)\s', line.strip())
        if m:
            pix_name = m.group(1)
            break

    if not pix_name:
        return None, None, None, {}

    ports, devices = parse_subcircuit([l.strip() for l in lines], pix_name)

    # Parse top-level instantiations of pix subcircuit
    # Handle continuation lines (+ prefix)
    pixel_port_maps = {}
    # First join continuation lines
    joined = []
    for line in lines:
        stripped = line.strip()
        if stripped.startswith('+') and joined:
            joined[-1] += ' ' + stripped[1:].strip()
        else:
            joined.append(stripped)

    for line in joined:
        if not line.startswith('X'):
            continue
        parts = line.split()
        if parts[-1] != pix_name:
            continue
        inst = parts[0]
        port_args = parts[1:-1]
        if len(port_args) == len(ports):
            port_map = {}
            for top_net, sub_port in zip(port_args, ports):
                port_map[top_net] = sub_port
            pixel_port_maps[inst] = port_map

    return pix_name, ports, devices, pixel_port_maps


def match_devices(lay_devices, sch_devices):
    """Match layout devices to schematic devices by type + net connectivity.

    Uses multiset (Counter) comparison of all nets including supplies.
    Returns dict: layout_inst → schematic_path
    """
    from collections import Counter
    mapping = {}
    used_sch = set()

    # Group by type
    lay_by_type = {}
    for inst, dev in lay_devices.items():
        lay_by_type.setdefault(dev['type'], []).append((inst, dev))

    sch_by_type = {}
    for path, dev in sch_devices.items():
        sch_by_type.setdefault(dev['type'], []).append((path, dev))

    for dev_type, lay_list in lay_by_type.items():
        sch_list = sch_by_type.get(dev_type, [])
        if not sch_list:
            continue

        for lay_inst, lay_dev in lay_list:
            lay_counts = Counter(lay_dev['nets'])
            best_match = None
            best_score = -1

            for sch_path, sch_dev in sch_list:
                if sch_path in used_sch:
                    continue
                sch_counts = Counter(sch_dev['nets'])
                # Score = sum of min counts for shared nets
                score = sum((lay_counts & sch_counts).values())
                if score > best_score:
                    best_score = score
                    best_match = sch_path

            if best_match and best_score > 0:
                mapping[lay_inst] = best_match
                used_sch.add(best_match)

    # Second pass: allow parallel-split devices (e.g. MIM caps split by Magic)
    # to share the same schematic name with a suffix
    for dev_type, lay_list in lay_by_type.items():
        sch_list = sch_by_type.get(dev_type, [])
        for lay_inst, lay_dev in lay_list:
            if lay_inst in mapping:
                continue
            lay_counts = Counter(lay_dev['nets'])
            best_match = None
            best_score = -1
            for sch_path, sch_dev in sch_list:
                sch_counts = Counter(sch_dev['nets'])
                score = sum((lay_counts & sch_counts).values())
                if score > best_score:
                    best_score = score
                    best_match = sch_path
            if best_match and best_score > 0:
                # Already used — this is a parallel split, add suffix
                count = sum(1 for v in mapping.values()
                            if v == best_match or v.startswith(best_match + '_p'))
                mapping[lay_inst] = f"{best_match}_p{count}"

    return mapping


def build_pex_device_map(pex_path, inst_map, lay_pix_name, lay_ports,
                         lay_devices, sch_devices, pixel_port_maps=None):
    """Match PEX flat devices to schematic names via layout subcircuit.

    PEX devices have nets like Pix[N].signal. We extract the pixel instance
    and local signal to match against layout subcircuit devices.

    Returns dict: pex_inst → schematic_hierarchical_name
    """
    # Build layout→schematic device mapping within one pixel
    lay_sch_map = match_devices(lay_devices, sch_devices)

    # Parse PEX netlist devices
    with open(pex_path) as f:
        pex_lines = f.readlines()

    pex_devices = []
    for line in pex_lines:
        if not line.startswith('X'):
            continue
        parts = line.split()
        inst = parts[0]
        nets = []
        dev_type = None
        for p in parts[1:]:
            if p.startswith('sky130'):
                dev_type = p
            elif '=' in p:
                break
            elif dev_type is None:
                nets.append(p)
        pex_devices.append({'inst': inst, 'type': dev_type, 'nets': nets})

    # For each PEX device, determine which pixel and match to layout device
    # Reverse inst_map: Pix[N] → pix[2]$1_M
    rev_inst = {v: k for k, v in inst_map.items()}

    # Build port mapping for layout subcircuit
    # We need to know which layout port corresponds to which net
    # This comes from the top-level layout netlist instantiation

    pex_map = {}  # pex_inst → schematic name
    unmapped = []  # devices with no Pix[N] in nets

    from collections import Counter

    for pex_dev in pex_devices:
        # Determine pixel instance from net names
        pixel = None
        for n in pex_dev['nets']:
            m = re.match(r'(x?Pix\[\d+\])\.', n)
            if m:
                pixel = m.group(1)
                break

        if pixel is None:
            unmapped.append(pex_dev)
            continue

        # Find matching layout device by type + local nets
        all_local = []
        for n in pex_dev['nets']:
            m2 = re.match(r'x?Pix\[\d+\]\.(.*)', n)
            if m2:
                all_local.append(re.sub(r'\.t\d+$', '', m2.group(1)))
            else:
                all_local.append(re.sub(r'\.t\d+$', '', n))

        pex_counts = Counter(all_local)
        best_lay = None
        best_score = -1

        for lay_inst, lay_dev in lay_devices.items():
            if lay_dev['type'] != pex_dev['type']:
                continue
            lay_counts = Counter(lay_dev['nets'])
            score = sum((pex_counts & lay_counts).values())
            if score > best_score:
                best_score = score
                best_lay = lay_inst

        if best_lay and best_lay in lay_sch_map:
            sch_path = lay_sch_map[best_lay]
            # pixel is already xPix[N] or Pix[N]; ensure x prefix
            pix_prefix = pixel if pixel.startswith('x') else f'x{pixel}'
            hier_name = f"{pix_prefix}.{sch_path}".replace('/', '.')
            pex_map[pex_dev['inst']] = hier_name

    # Second pass: determine pixel for unmapped devices via shared anonymous nets.
    # Build net→pixel map from already-mapped devices: anonymous nets (a_xxx)
    # that connect to mapped devices inherit that device's pixel.
    net_pixel = {}  # anonymous_net_base → xPix[N]
    for pex_dev in pex_devices:
        inst = pex_dev['inst']
        if inst not in pex_map:
            continue
        # Extract pixel from mapped name (xPix[N]....)
        m = re.match(r'(x?Pix\[\d+\])\.', pex_map[inst])
        if not m:
            continue
        pixel = m.group(1)
        for n in pex_dev['nets']:
            base = re.sub(r'\.t\d+$', '', n)
            if base.startswith('a_'):
                net_pixel[base] = pixel

    # Also scan R lines for anonymous net connectivity to Pix[N] nets
    for line in pex_lines:
        if not line.startswith('R'):
            continue
        parts = line.split()
        if len(parts) < 3:
            continue
        n1_base = re.sub(r'\.t\d+$', '', parts[1])
        n2_base = re.sub(r'\.t\d+$', '', parts[2])
        # If one side has Pix[N] and the other is anonymous, propagate
        for na, nb in [(n1_base, n2_base), (n2_base, n1_base)]:
            m = re.match(r'(x?Pix\[\d+\])\.', na)
            if m and nb.startswith('a_'):
                net_pixel[nb] = m.group(1)

    # Second pass: determine pixel for unmapped devices via shared anonymous nets,
    # then use per-pixel port mappings to translate PEX nets → subcircuit-local names.
    #
    # Build per-pixel port map: for each Pix[N], map top-level net → subcircuit port
    # using the layout LVS instantiations and the inst_map (layout_inst → Pix[N]).
    per_pixel_portmap = {}  # Pix[N] → {top_net: subckt_port}
    if pixel_port_maps:
        rev_inst = {v: k for k, v in inst_map.items()}
        for pixel_name, lay_inst_short in rev_inst.items():
            # Find the matching Xpix[2]$1_N instantiation
            x_inst = 'X' + lay_inst_short  # e.g. Xpix[2]$1_0
            if x_inst in pixel_port_maps:
                per_pixel_portmap[pixel_name] = pixel_port_maps[x_inst]

    for pex_dev in unmapped:
        pixel = None
        for n in pex_dev['nets']:
            base = re.sub(r'\.t\d+$', '', n)
            if base in net_pixel:
                pixel = net_pixel[base]
                break

        if pixel is None:
            continue

        # Translate PEX nets to subcircuit-local names using port mapping
        port_map = per_pixel_portmap.get(pixel, {})
        all_local = []
        for n in pex_dev['nets']:
            base = re.sub(r'\.t\d+$', '', n)
            # Strip Pix[N]. prefix if present
            m2 = re.match(r'x?Pix\[\d+\]\.(.*)', base)
            if m2:
                all_local.append(m2.group(1))
            elif base in port_map:
                all_local.append(port_map[base])
            else:
                all_local.append(base)

        pex_counts = Counter(all_local)

        # Only consider layout devices not yet used for this pixel
        pix_prefix = pixel if pixel.startswith('x') else f'x{pixel}'
        used_for_pixel = set()
        for inst, name in pex_map.items():
            if name.startswith(f'{pix_prefix}.'):
                lay_part = name[len(f'{pix_prefix}.'):]
                used_for_pixel.add(lay_part.replace('.', '/'))

        best_lay = None
        best_score = -1
        for lay_inst, lay_dev in lay_devices.items():
            if lay_dev['type'] != pex_dev['type']:
                continue
            sch_path = lay_sch_map.get(lay_inst)
            if sch_path and sch_path in used_for_pixel:
                continue
            lay_counts = Counter(lay_dev['nets'])
            score = sum((pex_counts & lay_counts).values())
            if score > best_score:
                best_score = score
                best_lay = lay_inst

        if best_lay and best_lay in lay_sch_map:
            sch_path = lay_sch_map[best_lay]
            pix_prefix = pixel if pixel.startswith('x') else f'x{pixel}'
            hier_name = f"{pix_prefix}.{sch_path}".replace('/', '.')
            pex_map[pex_dev['inst']] = hier_name

    # Third pass: handle diodes and other XD devices by matching vpd[N] to pixel
    # The schematic has xPix[N] with vpd[N], so vpd[N] → Pix[N]
    # But the mapping depends on the top-level netlist (openDVS_pixel2x2.spice)
    for pex_dev in pex_devices:
        if pex_dev['inst'] in pex_map:
            continue
        if not pex_dev['inst'].startswith('XD'):
            continue
        # Find vpd[N] in nets
        pixel = None
        for n in pex_dev['nets']:
            m = re.match(r'vpd\[(\d+)\]', n)
            if m:
                vpd_idx = int(m.group(1))
                pixel = f"xPix[{vpd_idx}]"
                break
        if pixel and ('XD0' in lay_sch_map.values() or any(
                v.endswith('/XD1') for v in lay_sch_map.values())):
            # Find the diode in lay_sch_map
            for lay_inst, sch_path in lay_sch_map.items():
                if 'XD' in sch_path:
                    hier_name = f"{pixel}.{sch_path}".replace('/', '.')
                    pex_map[pex_dev['inst']] = hier_name
                    break

    return pex_map, lay_sch_map


def rename_pex_netlist(pex_path, out_path, inst_map, lay_pix_name,
                       lay_ports, lay_devices, sch_devices,
                       res_ext_path, sim_path, pixel_port_maps=None):
    """Rename devices and terminal nodes in PEX netlist."""

    # Build device name mapping
    pex_dev_map, lay_sch_map = build_pex_device_map(
        pex_path, inst_map, lay_pix_name, lay_ports,
        lay_devices, sch_devices, pixel_port_maps)

    print(f"Device name mappings: {len(pex_dev_map)}")
    for old, new in list(pex_dev_map.items())[:8]:
        print(f"  {old} -> {new}")
    if len(pex_dev_map) > 8:
        print(f"  ... and {len(pex_dev_map) - 8} more")

    # Build terminal node rename map by scanning device lines for .tN references
    # For each device pin that uses a .tN node, rename to {device_name}_{pin_name}
    terminal_rename = {}

    with open(pex_path) as f:
        for line in f:
            if not line.startswith(('X', 'x')):
                continue
            parts = line.split()
            inst = parts[0]
            nets = []
            dev_type = None
            for p in parts[1:]:
                if p.startswith('sky130'):
                    dev_type = p
                elif '=' in p:
                    break
                elif dev_type is None:
                    nets.append(p)

            # Get schematic device name
            sch_name = pex_dev_map.get(inst, inst)
            pin_names = PIN_NAMES.get(dev_type, [])

            for pin_idx, net in enumerate(nets):
                if '.t' in net and re.search(r'\.t\d+$', net):
                    if pin_idx < len(pin_names):
                        pin_name = pin_names[pin_idx]
                    else:
                        pin_name = f"p{pin_idx}"
                    # Keep original net as prefix: net_base..device_pin
                    net_base = re.sub(r'\.t\d+$', '', net)
                    new_name = f"{net_base}.{sch_name}_{pin_name}"
                    if net not in terminal_rename:
                        terminal_rename[net] = new_name

    print(f"Terminal renames: {len(terminal_rename)}")
    for old, new in list(terminal_rename.items())[:8]:
        print(f"  {old} -> {new}")
    if len(terminal_rename) > 8:
        print(f"  ... and {len(terminal_rename) - 8} more")

    # Read PEX netlist and apply all renames
    with open(pex_path) as f:
        pex = f.read()

    # Apply terminal renames first (longest first to avoid partial matches)
    for old in sorted(terminal_rename.keys(), key=len, reverse=True):
        new = terminal_rename[old]
        pex = pex.replace(old, new)

    # Apply device instance renames on device lines, adding suffixes for duplicates
    lines = pex.splitlines(keepends=True)
    out_lines = []
    used_names = {}  # track how many times each name has been used
    for line in lines:
        if line.startswith('X') or line.startswith('x'):
            parts = line.split(None, 1)
            inst = parts[0]
            if inst in pex_dev_map:
                new_name = pex_dev_map[inst]
                count = used_names.get(new_name, 0)
                used_names[new_name] = count + 1
                if count > 0:
                    new_name = f"{new_name}_p{count}"
                line = new_name + ' ' + parts[1]
        out_lines.append(line)

    # Also rename in tie resistors and R_tie lines
    pex_out = ''.join(out_lines)

    with open(out_path, 'w') as f:
        f.write(pex_out)

    print(f"Wrote {out_path}")


if __name__ == '__main__':
    import argparse
    p = argparse.ArgumentParser()
    p.add_argument('pex_spice', help='PEX SPICE netlist to rename')
    p.add_argument('layout_lvs', help='Layout LVS SPICE netlist')
    p.add_argument('schematic', help='Schematic SPICE netlist')
    p.add_argument('output', help='Output renamed PEX netlist')
    p.add_argument('--res-ext', help='.res.ext file for terminal mapping')
    p.add_argument('--sim', help='.sim file for terminal mapping')
    p.add_argument('--lvs-report', help='LVS report for instance mapping')
    args = p.parse_args()

    # Parse instance mapping from LVS report
    inst_map = {}
    if args.lvs_report:
        with open(args.lvs_report) as f:
            for line in f:
                m = re.match(r'(\S+)/sky130_\S+ vs\. \S+:(Pix\[\d+\])/', line)
                if m and m.group(1) not in inst_map:
                    inst_map[m.group(1)] = m.group(2)
    # Fallback: match layout pixel instances to schematic by vpd connectivity
    if not inst_map:
        with open(args.pex_spice) as f:
            pex_text = f.read()
        # Try original layout names first, then already-renamed Pix/xPix names
        lay_prefixes = sorted(set(re.findall(r'((?:openDVS_pixel|pix\[\d+\]\$\S+)_\d+)(?=\.)', pex_text)))
        if not lay_prefixes:
            # Already renamed by Step 3 — extract Pix[N] or xPix[N] as identity mapping
            pix_prefixes = sorted(set(re.findall(r'((?:x?Pix)\[\d+\])(?=\.)', pex_text)))
            for prefix in pix_prefixes:
                inst_map[prefix] = prefix
        else:
            for prefix in lay_prefixes:
                for line in pex_text.splitlines():
                    if prefix + '.' in line and 'vpd[' in line:
                        vm = re.search(r'vpd\[(\d+)\]', line)
                        if vm:
                            inst_map[prefix] = f'xPix[{vm.group(1)}]'
                            break
    print(f"Instance mapping: {inst_map}")

    # Parse layout subcircuit
    lay_pix_name, lay_ports, lay_devices, pixel_port_maps = parse_layout_subcircuit(args.layout_lvs)
    if lay_devices is None:
        print(f"Warning: Could not find pixel subcircuit in layout LVS netlist, skipping device renaming")
        # Copy input to output unchanged
        import shutil
        shutil.copy(args.pex_spice, args.output)
        sys.exit(0)
    print(f"Layout subcircuit: {lay_pix_name} ({len(lay_devices)} devices)")
    print(f"Pixel port maps: {len(pixel_port_maps)} instantiations")

    # Parse schematic hierarchy
    sch_devices = parse_schematic_hierarchy(args.schematic)
    print(f"Schematic flattened devices: {len(sch_devices)}")
    for path, dev in sch_devices.items():
        print(f"  {path}: {dev['type']} {dev['nets']}")

    # Match layout → schematic
    lay_sch = match_devices(lay_devices, sch_devices)
    print(f"\nLayout → Schematic device mapping ({len(lay_sch)}):")
    for lay, sch in sorted(lay_sch.items()):
        print(f"  {lay} -> {sch}")

    rename_pex_netlist(args.pex_spice, args.output, inst_map,
                      lay_pix_name, lay_ports, lay_devices, sch_devices,
                      args.res_ext, args.sim, pixel_port_maps)
