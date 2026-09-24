"""Per .subckt block: every node that appears only in capacitor cards of that block (floating dummy-fill metal) gets a 1e15-ohm
shunt to ground inserted before the block's .ends, so ngspice's operating point is not singular.  In place; idempotent.
usage: add_fill_shunts.py <netlist.spice> [...]"""
import sys
for path in sys.argv[1:]:
    lines = open(path).read().split("\n")
    if any("* fill shunts" in l for l in lines): print(path, "already patched"); continue
    # join continuation lines logically
    blocks = []; start = None
    for i, l in enumerate(lines):
        if l.lower().startswith(".subckt"): start = i
        if l.lower().startswith(".ends") and start is not None: blocks.append((start, i)); start = None
    total = 0; inserts = []
    for s, e in blocks:
        ports = set(lines[s].split()[2:]); j = s + 1
        while lines[j].startswith("+"): ports |= set(lines[j][1:].split()); j += 1
        cap, other = set(), set()
        for l in lines[j:e]:
            if not l or l[0] in "*+.": continue
            t = l.split()
            if t[0][0] in "Cc": cap |= {t[1], t[2]}
            else: other |= set(x for x in t[1:] if "=" not in x)
        fl = sorted(n for n in cap if n not in other and n not in ports and n != "0")
        if fl: inserts.append((e, ["* fill shunts: %d floating capacitor-only nodes of %s tied to ground with 1e15 ohm (dummy fill)" % (len(fl), lines[s].split()[1])] + ["Rfs%d %s 0 1e15" % (k, n) for k, n in enumerate(fl)])); total += len(fl)
    for e, add in sorted(inserts, reverse=True): lines[e:e] = add
    open(path, "w").write("\n".join(lines)); print(path, "shunts added:", total, "in", len(inserts), "block(s)")
