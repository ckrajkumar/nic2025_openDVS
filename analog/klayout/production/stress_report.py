#!/usr/bin/env python3
"""stress_report.py RAW... --tagg 1.0m : GndD far-end bounce and the victims' excursions after the event."""
import sys, argparse, numpy as np
ap = argparse.ArgumentParser(); ap.add_argument("raw", nargs="+"); ap.add_argument("--tagg", default="1.0m"); a = ap.parse_args()
m = {"m": 1e-3, "u": 1e-6, "n": 1e-9}; TA = float(a.tagg[:-1]) * m[a.tagg[-1]]
P = "v(xpix2x2.xdiffbn_physical_core.opendvs_pixel_%d.%s)"
WANT = ["time", "v(gnddf)", "v(rl0)"] + [P % (p, n) for p in range(4) for n in ("vdiff", "vsf", "vd", "on", "nrst")]
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
                data = {w: np.empty(npts) for w in idx}; lines = (l for l in f if l.strip())
                for k in range(npts):
                    vals = [float(next(lines).split()[-1])] + [float(next(lines)) for _ in range(nvar - 1)]
                    for w, j in idx.items(): data[w][k] = vals[j]
                break
    return data
for path in a.raw:
    d = read(path); t = d["time"]; pre = (t > TA - 20e-6) & (t < TA - 1e-9); post = t > TA
    print("== %s  GndD far end: pre %.4f V, peak %.4f V (at %.3f us after tagg), end %.4f" % (path.split("/")[-1], d["v(gnddf)"][pre][-1], d["v(gnddf)"][post].max(), (t[post][np.argmax(d["v(gnddf)"][post])] - TA) * 1e6, d["v(gnddf)"][-1]))
    for p in range(4):
        g = lambda n: d[P % (p, n)]; s = "  pixel_%d |" % p
        for n in ("vdiff", "vsf", "vd"):
            v = g(n); s += " %s pre %.4f min %.4f max %.4f end %.4f |" % (n, v[pre][-1], v[post].min(), v[post].max(), v[-1])
        on = g("on"); mm = post & (on > 0.9)
        s += " ON %s" % ("EVENT at %.1f us (peak %.2f V)" % ((t[mm][0] - TA) * 1e6, on[post].max()) if mm.any() else "none (peak %.3f V)" % on[post].max())
        print(s)
