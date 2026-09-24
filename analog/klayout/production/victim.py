#!/usr/bin/env python3
"""Crosstalk victims in Rui's reset TB: pixel 1 shares pixRst[0] with pixel 0 (no reset: rowReadON[1]=0),
   pixel 2 shares rowReadON[0] (no reset: pixRst[1]=0).  victim.py RAW [RAW...]"""
import sys, numpy as np
P = "v(xpix2x2.xdiffbn_physical_core.opendvs_pixel_%d.%s)"
WANT = ["time", "v(pixrst)"] + [P % (p, n) for p in (0, 1, 2) for n in ("vdiff", "vsf", "vd", "on", "noff", "nrst")]
def read(path):
    names, idx, data = [], {}, None
    with open(path) as f:
        for line in f:
            if line.startswith("No. Variables:"): nvar = int(line.split(":")[1])
            elif line.startswith("No. Points:"): npts = int(line.split(":")[1])
            elif line.startswith("Variables:"):
                for i in range(nvar): names.append(f.readline().split()[1])
                idx = {w: names.index(w) for w in WANT if w in names}
            elif line.startswith("Values:"):
                data = {w: np.empty(npts) for w in idx}
                lines = (l for l in f if l.strip())
                for k in range(npts):
                    vals = [float(next(lines).split()[-1])] + [float(next(lines)) for _ in range(nvar - 1)]
                    for w, j in idx.items(): data[w][k] = vals[j]
                break
    return data
for path in sys.argv[1:]:
    d = read(path); t = d["time"] * 1e6
    rel = t[np.argmax(d["v(pixrst)"] < 0.9)]  # release = pixRst falling edge
    print("== %s   (pixRst falls at %.3f us; window end %.1f us)" % (path, rel, t[-1]))
    for p in (0, 1, 2):
        role = {0: "reset pixel", 1: "column victim (shares pixRst[0])", 2: "row victim (shares rowReadON[0])"}[p]
        g = lambda n: d[P % (p, n)]
        pre = t < rel - 0.05; post = t > rel + 0.05
        s = "  pixel %d %-34s" % (p, role)
        for n in ("vdiff", "vsf", "vd"):
            v = g(n); s += " %s pre %.4f min %.4f max %.4f end %.4f |" % (n, v[0], v[post].min(), v[post].max(), v[-1])
        print(s)
        for n, lev, rising in (("on", 0.9, True), ("noff", 0.9, False)):
            v = g(n); m = post & ((v > lev) if rising else (v < lev)); 
            print("      %-4s %s" % (n, ("crosses at %.2f us after release (peak %.3f V)" % (t[m][0] - rel, v[post].max() if rising else v[post].min())) if m.any() else "no crossing (extreme %.3f V)" % (v[post].max() if rising else v[post].min())))
