#!/usr/bin/env python3
"""All couplings of one net in Magic pixel netlists:  cc_any.py <net> a.magic/pixel.spice ...   (prints the top pairs per file)"""
import re, sys
net = sys.argv[1]
for p in sys.argv[2:]:
    c = {}
    for l in open(p):
        f = l.split()
        if f and re.fullmatch(r"C\d+", f[0]) and len(f) >= 4:
            a, b = (re.sub(r"\.t\d+$", "", x) for x in f[1:3])
            if net in (a, b): o = b if a == net else a; c[o] = c.get(o, 0) + float(f[3].rstrip("f"))
    top = sorted(c.items(), key=lambda kv: -kv[1])
    print("%-16s %s" % (p.split("/")[-2].replace(".magic", ""), "  ".join("%s=%.4f" % kv for kv in top if kv[1] >= 0.003)))
