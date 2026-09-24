#!/usr/bin/env python3
"""Scale every parasitic C card between two pixel nets (all four pixels) and write a what-if netlist.
   whatif_pair.py --src <netlist> --out <netlist> --pairs "vsf:vdiff=0;vd:vdiff=0.5" """
import re, argparse
ap = argparse.ArgumentParser(); ap.add_argument("--src", required=True); ap.add_argument("--out", required=True); ap.add_argument("--pairs", required=True); a = ap.parse_args()
src = open(a.src).read().splitlines(); tot = {}
rules = []
for p in a.pairs.split(";"):
    ab, k = p.split("="); x, y = ab.split(":"); rules.append((x, y, float(k))); tot[(x, y)] = [0.0, 0]
def net(n):
    m = re.match(r"openDVS_pixel_(\d)\.(\w+)(\.t\d+)?$", n); return (m.group(1), m.group(2)) if m else None
for i, l in enumerate(src):
    f = l.split()
    if not (f and re.fullmatch(r"C\d+", f[0]) and len(f) >= 4): continue
    na, nb = net(f[1]), net(f[2])
    if not na or not nb or na[0] != nb[0]: continue
    for x, y, k in rules:
        if {na[1], nb[1]} == {x, y}:
            v = float(f[3].rstrip("f")); tot[(x, y)][0] += v if na[0] == "0" else 0; tot[(x, y)][1] += 1
            f[3] = "%.6gf" % max(v * k, 1e-6); src[i] = " ".join(f)
open(a.out, "w").write("\n".join(src) + "\n")
for (x, y), (v, n) in tot.items(): print("%s-%s: %d cards (all pixels), pixel_0 sum %.3f fF" % (x, y, n, v))
