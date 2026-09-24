#!/usr/bin/env python3
"""xtalk_report.py RAW --tagg 1.0m : per pixel, values just before the aggressor edge and extremes after it, ON/nOFF crossings."""
import sys, argparse, numpy as np
ap = argparse.ArgumentParser(); ap.add_argument("raw", nargs="+"); ap.add_argument("--tagg", default="1.0m"); a = ap.parse_args()
m = {"m": 1e-3, "u": 1e-6, "n": 1e-9}; TA = float(a.tagg[:-1]) * m[a.tagg[-1]]
P = "v(xpix2x2.xdiffbn_physical_core.opendvs_pixel_%d.%s)"
WANT = ["time", "v(pixrst)", "v(rowon0)"] + [P % (p, n) for p in range(4) for n in ("vdiff", "vsf", "vd", "on", "noff", "nrst")]
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
for path in a.raw:
    d = read(path); t = d["time"]
    pre = (t > TA - 20e-6) & (t < TA - 1e-9); post = t > TA + 1.02e-6   # after the aggressor's falling edge
    print("== %s  (points %d, end %.3f ms; aggressor pulse at %.3f ms)" % (path, len(t), t[-1] * 1e3, TA * 1e3))
    for p in range(4):
        g = lambda n: d[P % (p, n)]
        s = "  pixel_%d nRst-dip %s |" % (p, "YES" if g("nrst")[post & (t < TA + 5e-6)].min() < 0.9 else "no ")
        for n in ("vdiff", "vsf", "vd"):
            v = g(n); s += " %s pre %.4f post-min %.4f max %.4f end %.4f |" % (n, v[pre][-1], v[post].min(), v[post].max(), v[-1])
        print(s)
        for n, lev, rising in (("on", 0.9, True), ("noff", 0.9, False)):
            v = g(n); before = pre & ((v > lev) if rising else (v < lev)); mm = post & ((v > lev) if rising else (v < lev))
            print("      %-4s before-agg:%s  after-agg: %s" % (n, "ACTIVE" if before.any() else "idle", ("event at %.1f us (extreme %.3f V)" % ((t[mm][0] - TA) * 1e6, v[post].max() if rising else v[post].min())) if mm.any() else "none (extreme %.3f V)" % (v[post].max() if rising else v[post].min())))
