#!/usr/bin/env python3
"""xtalk_dump.py <tag> : per aggressor (reset/rowoff/readline) and I_sf (1n/100p): per-pixel vdiff levels around the 1 ms pulse and after the release,
   plus decimated waveforms of the four vdiff, the aggressor line and the ON outputs in two windows (release, pulse). JSON on stdout."""
import sys, os, json, numpy as np
os.chdir(os.path.expanduser("~/opendvs-sims/opendvs_reset_rise_20260921")); sys.path.insert(0, ".")
def read(path, want):
    names, idx, data = [], {}, None
    with open(path) as f:
        for line in f:
            if line.startswith("No. Variables:"): nvar = int(line.split(":")[1])
            elif line.startswith("No. Points:"): npts = int(line.split(":")[1])
            elif line.startswith("Variables:"):
                for i in range(nvar): names.append(f.readline().split()[1])
                idx = {w: names.index(w) for w in want if w in names}
            elif line.startswith("Values:"):
                data = {w: np.empty(npts) for w in idx}; lines = (l for l in f if l.strip())
                for k in range(npts):
                    vals = [float(next(lines).split()[-1])] + [float(next(lines)) for _ in range(nvar - 1)]
                    for w, j in idx.items(): data[w][k] = vals[j]
                break
    return data
tag = sys.argv[1]; P = "v(xpix2x2.xdiffbn_physical_core.opendvs_pixel_%d.%s)"; out = {}
def dec(t, y, t0, t1, n):
    m = (t >= t0) & (t <= t1); tt = t[m]; yy = y[m]
    if not len(tt): return [], []
    idx = np.unique(np.searchsorted(tt, np.linspace(tt[0], tt[-1], n))); idx = idx[idx < len(tt)]
    return [round(float(x), 4) for x in tt[idx]], [round(float(x), 5) for x in yy[idx]]
AGG = {"reset": "v(pixrst)", "rowoff": "v(rowoff0)", "readline": "v(readline0)", "pixrst_only": "v(pixrst)", "rowon_only": "v(rowon0)"}
WIN = (("win_release", (0, 40)), ("win_pulse", (995, 1060)))
if len(sys.argv) > 2: WIN = (("win_release", (0, 40)), ("win_pulse", (990, float(sys.argv[2]))))
for agg, line in AGG.items():
    for s in ("1n", "100p"):
        p = "outputs/xtalk/xtalk_%s_%s_PrSFBp%s.raw" % (tag, agg, s)
        if not os.path.exists(p): continue
        d = read(p, ["time", line] + [P % (k, n) for k in range(4) for n in ("vdiff", "on", "nrst", "vsf")]); t = d["time"] * 1e6; rec = {"pixels": [], "win_release": {}, "win_pulse": {}}
        for k in range(4):
            v = d[P % (k, "vdiff")]; on = d[P % (k, "on")]
            pre = float(np.median(v[(t > 990) & (t < 999.5)])); post = v[t > 1000]; ton = t[(t > 1000) & (on > 0.9)]
            rel = float(np.median(v[(t > 150) & (t < 300)]))
            rec["pixels"].append({"pixel": k, "vdiff_300us": round(rel, 4), "vdiff_pre": round(pre, 4), "dip_mv": round((post.min() - pre) * 1e3, 1), "rise_mv": round((post.max() - pre) * 1e3, 1),
                                  "end_mv": round((float(v[-1]) - pre) * 1e3, 1), "on_after_us": round(float(ton[0] - 1000), 2) if len(ton) else None, "on_before": bool((on[(t > 30) & (t < 999)] > 0.9).any())})
        for name, (t0, t1) in WIN:
            w = {}; tt, w["line"] = dec(t, d[line], t0, t1, 260); w["t_us"] = tt
            for k in range(4): _, w["vdiff%d" % k] = dec(t, d[P % (k, "vdiff")], t0, t1, 260); _, w["on%d" % k] = dec(t, d[P % (k, "on")], t0, t1, 260); _, w["nrst%d" % k] = dec(t, d[P % (k, "nrst")], t0, t1, 260); _, w["vsf%d" % k] = dec(t, d[P % (k, "vsf")], t0, t1, 260)
            rec[name] = w
        out["%s_%s" % (agg, s)] = rec
json.dump(out, sys.stdout)
