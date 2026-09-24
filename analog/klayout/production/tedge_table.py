#!/usr/bin/env python3
"""tedge_table.py RAW... : per raw file, ON crossings of the row-0 victim (pixel_0) before/after the 1 ms pulse, vdiff levels."""
import sys, numpy as np
P = "v(xpix2x2.xdiffbn_physical_core.opendvs_pixel_%d.%s)"
WANT = ["time"] + [P % (p, n) for p in (0, 1) for n in ("vdiff", "vsf", "on")]
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
print("%-36s %-22s %-22s %8s %8s %8s %8s %8s" % ("raw", "ON>0.9 before 1 ms (us)", "ON>0.9 after (us)", "vd0@999", "vd1@999", "off(mV)", "ONbase", "min0>1ms"))
for path in sys.argv[1:]:
    d = read(path); tm = d["time"] * 1e6; on0 = d[P % (0, "on")]; v0 = d[P % (0, "vdiff")]; v1 = d[P % (1, "vdiff")]
    def cross(t0, t1):
        m = (tm >= t0) & (tm <= t1); vv = on0[m] > 0.9; k = np.where(vv[1:] & ~vv[:-1])[0]; return list(np.round(tm[m][k + 1], 1))
    i = np.searchsorted(tm, 999); base = np.median(on0[(tm > 900) & (tm < 999)])
    print("%-36s %-22s %-22s %8.4f %8.4f %8.1f %8.3f %8.4f" % (path.split("/")[-1].replace("xtalk_", "").replace("_rowoff_PrSFBp1n.raw", ""), str(cross(0, 999))[:22], str(cross(999, 1500))[:22], v0[i], v1[i], (v0[i] - v1[i]) * 1e3, base, v0[tm > 1000].min()))
