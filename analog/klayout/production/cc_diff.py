#!/usr/bin/env python3
"""Compare the capacitor (and resistor) content of two Magic RCC ngspice netlists as sets,
independent of card order and terminal-suffix numbering; then report the coupling
capacitances of selected nets.   cc_diff.py OLD NEW [--nets vsf,vd,nRst] [--pixel 0|all]
Commented-out '*C' cards in OLD are read as if active (they carry the original values)."""
import re, sys, argparse
from collections import defaultdict

def strip_t(n):            # resistor-split node names: openDVS_pixel_0.vd.t3 -> openDVS_pixel_0.vd
    return re.sub(r"\.t\d+$", "", n)

def parse(path):
    caps, res, commented = {}, [], set()
    for line in open(path):
        s = line.strip(); star = s.startswith("*C")
        if star: s = s[1:]
        f = s.split()
        if not f: continue
        if re.fullmatch(r"C\d+", f[0]) and len(f) >= 4:
            a, b = strip_t(f[1]), strip_t(f[2]); v = float(f[3].rstrip("f")) * 1e-15 if f[3].endswith("f") else float(f[3])
            key = tuple(sorted((a, b)))
            caps[key] = caps.get(key, 0.0) + v
            if star: commented.add(key)
        elif re.fullmatch(r"R\d+", f[0]) and len(f) >= 4:
            res.append((tuple(sorted((strip_t(f[1]), strip_t(f[2])))), float(f[3])))
    return caps, res, commented

ap = argparse.ArgumentParser(); ap.add_argument("old"); ap.add_argument("new")
ap.add_argument("--nets", default="vsf,vd,nRst"); ap.add_argument("--pixel", default="0")
ap.add_argument("--min", type=float, default=0.005, help="fF threshold to list a pair")
a = ap.parse_args()
co, ro, commented = parse(a.old); cn, rn, _ = parse(a.new)
print("== inventory: caps old %d new %d (%.3f fF -> %.3f fF total); res old %d new %d" % (
    len(co), len(cn), sum(co.values()) * 1e15, sum(cn.values()) * 1e15, len(ro), len(rn)))
same = sum(1 for k in co if k in cn and abs(co[k] - cn[k]) <= 1e-19)
print("   identical pairs %d; only-old %d; only-new %d; value-changed %d" % (
    same, len(set(co) - set(cn)), len(set(cn) - set(co)), sum(1 for k in co if k in cn and abs(co[k] - cn[k]) > 1e-19)))
if commented: print("   note: %d cap cards were commented out ('*C') in OLD; their original values are used here" % len(commented))
pix = [a.pixel] if a.pixel != "all" else ["0", "1", "2", "3"]
for p in pix:
    for net in a.nets.split(","):
        full = "openDVS_pixel_%s.%s" % (p, net)
        rows = {}
        for src, tag in ((co, "old"), (cn, "new")):
            for (x, y), v in src.items():
                if full in (x, y):
                    other = y if x == full else x
                    rows.setdefault(other, {})[tag] = v
        tot_o = sum(r.get("old", 0) for r in rows.values()); tot_n = sum(r.get("new", 0) for r in rows.values())
        print("\n== %s   total: %.3f fF -> %.3f fF  (%+.3f fF, %+.1f%%)" % (full, tot_o * 1e15, tot_n * 1e15, (tot_n - tot_o) * 1e15, 100 * (tot_n - tot_o) / tot_o if tot_o else 0))
        print("   %-34s %9s %9s %9s" % ("coupled to", "old fF", "new fF", "delta fF"))
        for other, r in sorted(rows.items(), key=lambda kv: -abs(kv[1].get("new", 0) - kv[1].get("old", 0))):
            o, n = r.get("old", 0) * 1e15, r.get("new", 0) * 1e15
            if max(abs(o), abs(n)) < a.min: continue
            flag = " *" if (full, other) in commented or (other, full) in commented or tuple(sorted((full, other))) in commented else ""
            print("   %-34s %9.3f %9.3f %+9.3f%s" % (other.replace("openDVS_pixel_", "px"), o, n, n - o, flag))
