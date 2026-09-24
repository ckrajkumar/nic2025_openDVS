#!/usr/bin/env python3
"""Post-process Magic PEX netlist to connect device pins to extresist terminal nodes.

Magic's ext2spice extresist adds R networks with .tN terminal nodes representing
device connection points, but doesn't rewrite device pins to use them. This script
matches device pin locations (from .sim) to .tN coordinates (from .res.ext) and
rewrites the SPICE netlist so devices connect through the resistance network.
"""
import re, sys, math

def parse_res_ext(path):
    """Parse .res.ext for terminal node coordinates."""
    rnodes = {}
    with open(path) as f:
        for line in f:
            m = re.match(r'rnode "(.+)" \d+ [\d.e+-]+ (-?\d+) (-?\d+)', line.strip())
            if m:
                rnodes[m.group(1)] = (int(m.group(2)), int(m.group(3)))
    return rnodes

def parse_sim(path):
    """Parse .sim for device pin connections and coordinates."""
    devices = []
    for line in open(path):
        line = line.strip()
        if not line.startswith('x '):
            continue
        parts = line.split()
        x = y = None
        dev_type = parts[-1]  # last token is device type
        for p in parts:
            if p.startswith('x='): x = int(p[2:])
            elif p.startswith('y='): y = int(p[2:])
        if x is None or y is None:
            continue
        # Extract net names (between 'x' and first param with '=')
        # Strip '#' suffix from anonymous nets to match normalized SPICE names
        nets = []
        for p in parts[1:]:
            if '=' in p or p.startswith('sky130'):
                break
            nets.append(p.rstrip('#'))
        devices.append({'nets': nets, 'x': x, 'y': y, 'type': dev_type})
    return devices

def parse_spice_devices(path):
    """Parse SPICE netlist for device lines with their nets."""
    devices = []
    with open(path) as f:
        for line in f:
            if not line.startswith(('X', 'XD')):
                continue
            parts = line.split()
            inst = parts[0]
            nets = []
            dev_type = None
            params = {}
            for i, p in enumerate(parts[1:], 1):
                if p.startswith('sky130'):
                    dev_type = p
                elif '=' in p:
                    k, v = p.split('=', 1)
                    params[k] = v
                elif dev_type is None:
                    nets.append(p)
            devices.append({
                'inst': inst, 'nets': nets, 'type': dev_type,
                'params': params, 'line': line.rstrip()
            })
    return devices

def match_sim_to_spice(sim_devs, spice_devs, inst_map):
    """Match .sim devices to SPICE devices by net names (after applying inst_map)."""
    def remap_net(name):
        for lay, sch in inst_map.items():
            if name.startswith(lay + '.'):
                return sch + name[len(lay):]
        return name

    matched = {}  # spice_idx -> sim_idx
    used_sim = set()

    for sp_idx, sp_dev in enumerate(spice_devs):
        sp_type = sp_dev['type']
        sp_nets = set(sp_dev['nets'])

        for si_idx, si_dev in enumerate(sim_devs):
            if si_idx in used_sim:
                continue
            if si_dev['type'] != sp_type:
                continue
            # Remap sim nets to schematic names and compare
            si_nets = set(remap_net(n) for n in si_dev['nets'])
            if sp_nets == si_nets:
                matched[sp_idx] = si_idx
                used_sim.add(si_idx)
                break

    return matched

def build_terminal_map(rnodes):
    """Group terminal nodes by base net."""
    terminals = {}
    for name, (x, y) in rnodes.items():
        m = re.match(r'(.+)\.(t\d+)$', name)
        if m:
            base = m.group(1)
            terminals.setdefault(base, []).append((name, x, y))
    return terminals

def find_pin_remaps(sim_devs, spice_devs, matched, terminals, inst_map, max_dist=100):
    """For matched device pairs, find terminal nodes for each pin."""
    def remap_net(name):
        for lay, sch in inst_map.items():
            if name.startswith(lay + '.'):
                return sch + name[len(lay):]
        return name

    pin_remap = {}  # (spice_idx, pin_idx) -> remapped_tN_name

    for sp_idx, si_idx in matched.items():
        si_dev = sim_devs[si_idx]
        sp_dev = spice_devs[sp_idx]
        dx, dy = si_dev['x'], si_dev['y']

        # Build mapping from sim net position to spice net position
        # Sim and spice may have different net ordering for same device
        si_nets_remapped = [remap_net(n) for n in si_dev['nets']]

        for si_pin, sim_net_raw in enumerate(si_dev['nets']):
            sim_net_sch = remap_net(sim_net_raw)
            # Find which spice pin has this net
            sp_pin = None
            for j, sn in enumerate(sp_dev['nets']):
                if sn == sim_net_sch:
                    sp_pin = j
                    break
            if sp_pin is None:
                continue

            # Check if this net has terminals
            if sim_net_raw not in terminals:
                continue

            # Find closest terminal
            best = None
            best_dist = float('inf')
            for tname, tx, ty in terminals[sim_net_raw]:
                dist = math.sqrt((dx - tx)**2 + (dy - ty)**2)
                if dist < best_dist:
                    best_dist = dist
                    best = tname
            if best and best_dist < max_dist:
                pin_remap[(sp_idx, sp_pin)] = remap_net(best)

    return pin_remap

def rewrite_spice(spice_path, out_path, spice_devs, pin_remap):
    """Rewrite SPICE netlist with terminal node connections."""
    with open(spice_path) as f:
        lines = f.readlines()

    dev_idx = 0
    out = []
    for line in lines:
        if line.startswith(('X', 'XD')):
            sp_dev = spice_devs[dev_idx]
            parts = line.split()
            inst = parts[0]

            # Find where nets end
            param_start = len(parts)
            for i, p in enumerate(parts[1:], 1):
                if '=' in p or p.startswith('sky130'):
                    param_start = i
                    break

            net_parts = list(parts[1:param_start])
            rest = parts[param_start:]

            # Apply remaps
            for pin_idx in range(len(net_parts)):
                key = (dev_idx, pin_idx)
                if key in pin_remap:
                    net_parts[pin_idx] = pin_remap[key]

            out.append(f"{inst} {' '.join(net_parts)} {' '.join(rest)}\n")
            dev_idx += 1
        else:
            out.append(line)

    with open(out_path, 'w') as f:
        f.writelines(out)

if __name__ == '__main__':
    res_ext = sys.argv[1]
    sim_file = sys.argv[2]
    spice_in = sys.argv[3]
    spice_out = sys.argv[4]
    lvs_report = sys.argv[5] if len(sys.argv) > 5 else None

    # Parse instance mapping from LVS report
    inst_map = {}
    if lvs_report:
        with open(lvs_report) as f:
            for line in f:
                m = re.match(r'(\S+)/sky130_\S+ vs\. \S+:(Pix\[\d+\])/', line)
                if m and m.group(1) not in inst_map:
                    inst_map[m.group(1)] = m.group(2)

    rnodes = parse_res_ext(res_ext)
    sim_devs = parse_sim(sim_file)
    spice_devs = parse_spice_devices(spice_in)
    terminals = build_terminal_map(rnodes)

    print(f"Terminal nodes: {sum(len(v) for v in terminals.values())}")
    print(f"Devices in .sim: {len(sim_devs)}")
    print(f"Devices in SPICE: {len(spice_devs)}")

    matched = match_sim_to_spice(sim_devs, spice_devs, inst_map)
    print(f"Matched devices: {len(matched)}")

    pin_remap = find_pin_remaps(sim_devs, spice_devs, matched, terminals, inst_map)
    print(f"Pin remaps: {len(pin_remap)}")

    for (si, pi), tname in list(pin_remap.items())[:8]:
        sp_dev = spice_devs[si]
        orig = sp_dev['nets'][pi]
        print(f"  {sp_dev['inst']} pin {pi}: {orig} -> {tname}")
    if len(pin_remap) > 8:
        print(f"  ... and {len(pin_remap) - 8} more")

    rewrite_spice(spice_in, spice_out, spice_devs, pin_remap)
    print(f"Wrote {spice_out}")
