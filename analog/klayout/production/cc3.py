#!/usr/bin/env python3
"""Print C(nRst,{vd,vsf,vpr,vdiff,GndA,VddA18}) from Magic pixel netlists:  cc3.py <name>.magic/pixel.spice ..."""
import re, sys
def parse(path):
    c = {}
    for l in open(path):
        f = l.split()
        if f and re.fullmatch(r"C\d+", f[0]) and len(f) >= 4:
            a, b = (re.sub(r"\.t\d+$", "", x) for x in f[1:3]); k = tuple(sorted((a, b))); c[k] = c.get(k, 0) + float(f[3].rstrip("f"))
    return c
print("%-10s %8s %8s %8s %8s %8s %8s" % ("variant", "vd", "vsf", "vpr", "vdiff", "GndA", "VddA18"))
for p in sys.argv[1:]:
    c = parse(p); name = p.split("/")[-2].replace(".magic", "")
    mrst = [l.split() for l in open(p) if l.startswith("X") and "pfet_01v8_hvt" in l and "w=0.42" in l.replace(" ", "").lower() and "l=0.42" in l.replace(" ", "").lower()]
    term = ",".join("%s/%s/%s" % (re.sub(r"\.t\d+$", "", m[1]), re.sub(r"\.t\d+$", "", m[2]), re.sub(r"\.t\d+$", "", m[3])) for m in mrst[:1]) or "Mrst?"
    print("%-10s" % name + "".join(" %8.4f" % c.get(tuple(sorted(("nRst", o))), 0) for o in ("vd", "vsf", "vpr", "vdiff", "GndA", "VddA18")) + "   Mrst D/G/S: " + term)
