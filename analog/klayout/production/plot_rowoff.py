#!/usr/bin/env python3
"""Waveforms of the rowReadOFF crosstalk runs: aggressor line, victim (row 0) and reference (row 1) pixel nodes, ON output.
usage: plot_rowoff.py TAG... (tags: n p q) -> outputs/xtalk/rowoff_waveforms_<tags>.png + printed event conditions"""
import sys, numpy as np, matplotlib; matplotlib.use("Agg"); import matplotlib.pyplot as plt
tags = [t for t in sys.argv[1:]]
P = "v(xpix2x2.xdiffbn_physical_core.opendvs_pixel_%d.%s)"
WANT = ["time", "v(rowoff0)", "v(pixrst)", "v(rowon0)"] + [P % (p, n) for p in range(4) for n in ("vdiff", "vsf", "vd", "on", "noff", "nrst")]
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
runs = [(t, b) for t in tags for b in ("PrSFBp1n", "PrSFBp100p")]
fig, axs = plt.subplots(len(runs), 3, figsize=(18, 3.2 * len(runs)), squeeze=False)
for r, (t, b) in enumerate(runs):
    d = read("outputs/xtalk/xtalk_%s_rowoff_%s.raw" % (t, b)); tm = d["time"] * 1e6
    for c, (lo, hi, title) in enumerate(((0, 1500, "full run"), (-1, 60, "initial reset release + rowReadOFF falling edge (t=0.02 us)"), (995, 1060, "aggressor pulse 1000-1001 us"))):
        ax = axs[r][c]; m = (tm >= lo) & (tm <= hi)
        ax.plot(tm[m], d["v(rowoff0)"][m], color="0.6", lw=0.8, label="rowReadOFF[0] (aggressor)")
        ax.plot(tm[m], d[P % (0, "vdiff")][m], "C0", label="pixel_0 vdiff (row 0, victim)")
        ax.plot(tm[m], d[P % (1, "vdiff")][m], "C0", ls="--", label="pixel_1 vdiff (row 1, reference)")
        ax.plot(tm[m], d[P % (0, "vsf")][m] - 0.4, "C2", label="pixel_0 vsf - 0.4 V")
        ax.plot(tm[m], d[P % (0, "on")][m], "C3", label="pixel_0 ON")
        ax.plot(tm[m], d[P % (0, "nrst")][m], "C1", lw=0.8, alpha=0.6, label="pixel_0 nRst")
        ax.set_ylim(-0.1, 1.9); ax.set_xlabel("t [us]"); ax.set_title("%s, I_sf %s: %s" % (t, "95 pA" if b == "PrSFBp1n" else "5 pA", title), fontsize=9); ax.grid(alpha=0.3)
        if r == 0 and c == 0: ax.legend(fontsize=7, loc="center right")
    # event conditions
    on0 = d[P % (0, "on")]; on1 = d[P % (1, "on")]; v0 = d[P % (0, "vdiff")]
    def crossings(v, t0, t1):
        m = (tm >= t0) & (tm <= t1); tt = tm[m]; vv = v[m] > 0.9; k = np.where(vv[1:] & ~vv[:-1])[0]; return tt[k + 1]
    print("%s %s: pixel_0 ON rising crossings (us): initial window %s | pulse window %s ; pixel_1: %s | %s ; vdiff pixel_0 at 999 us %.4f, min after pulse %.4f (at %.2f us); pixel_1 %.4f"
          % (t, b, np.round(crossings(on0, 0, 900), 2), np.round(crossings(on0, 990, 1500), 2), np.round(crossings(on1, 0, 900), 2), np.round(crossings(on1, 990, 1500), 2),
             v0[np.searchsorted(tm, 999)], v0[tm > 1000].min(), tm[tm > 1000][np.argmin(v0[tm > 1000])], d[P % (1, "vdiff")][np.searchsorted(tm, 999)]))
plt.tight_layout(); out = "outputs/xtalk/rowoff_waveforms_%s.png" % "_".join(tags); plt.savefig(out, dpi=110); print("wrote", out)
