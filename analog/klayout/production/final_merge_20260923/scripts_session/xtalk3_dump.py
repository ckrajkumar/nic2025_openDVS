#!/usr/bin/env python3
"""xtalk3_dump.py <tag-prefix> [--tagg 400] [--pitch 50] [--npulse 3] [--width 1] [--trise <us>]
   Reads outputs/xtalk/xtalk_<prefix>_<agg>_PrSFBp{1n,100p}.raw (ASCII) of the slow-edge pulse-train bench and reports, per pixel:
   the levels before the train (vdiff, vsf), per pulse the vsf and vdiff excursions (max/min deviation from the pre-train level
   inside the pulse window), the net vdiff/vsf shift after the train, ON events; plus decimated waveforms of the train window.
   JSON on stdout: {"<agg>_<set>": {"pixels": [...], "win": {...}}}.  Times in us, voltages in V, deviations in mV."""
import sys, os, json, argparse, numpy as np
ap = argparse.ArgumentParser(); ap.add_argument("prefix"); ap.add_argument("--tagg", type=float, default=400); ap.add_argument("--pitch", type=float, default=50)
ap.add_argument("--npulse", type=int, default=3); ap.add_argument("--width", type=float, default=1); ap.add_argument("--trise", type=float, default=0); ap.add_argument("--dir", default=os.path.expanduser("~/opendvs-sims/opendvs_reset_rise_20260921"))
a = ap.parse_args(); os.chdir(a.dir)
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
P = "v(xpix2x2.xdiffbn_physical_core.opendvs_pixel_%d.%s)"
AGG = {"reset": "v(pixrst)", "rowoff": "v(rowoff0)", "readline": "v(readline0)", "pixrst_only": "v(pixrst)", "rowon_only": "v(rowon0)"}
def dec(t, y, t0, t1, n):
    m = (t >= t0) & (t <= t1); tt = t[m]; yy = y[m]
    if not len(tt): return [], []
    idx = np.unique(np.searchsorted(tt, np.linspace(tt[0], tt[-1], n))); idx = idx[idx < len(tt)]
    return [round(float(x), 3) for x in tt[idx]], [round(float(x), 5) for x in yy[idx]]
out = {}
span = 2 * a.trise + a.width           # one pulse, 0 -> 100 % ramps included
for agg, line in AGG.items():
    for s in ("1n", "100p"):
        p = "outputs/xtalk/xtalk_%s_%s_PrSFBp%s.raw" % (a.prefix, agg, s)
        if not os.path.exists(p): continue
        d = read(p, ["time", line] + [P % (k, n) for k in range(4) for n in ("vdiff", "vsf", "on", "nrst")]); t = d["time"] * 1e6
        rec = {"pixels": [], "win": {}, "tagg_us": a.tagg, "pitch_us": a.pitch, "npulse": a.npulse, "width_us": a.width, "trise_us": a.trise}
        pre = (t > a.tagg - 40) & (t < a.tagg - 1)
        tend_train = a.tagg + (a.npulse - 1) * a.pitch + span
        for k in range(4):
            v = d[P % (k, "vdiff")]; vs = d[P % (k, "vsf")]; on = d[P % (k, "on")]
            v0 = float(np.median(v[pre])); s0 = float(np.median(vs[pre])); pulses = []
            for j in range(a.npulse):
                t0 = a.tagg + j * a.pitch; w = (t >= t0) & (t < t0 + a.pitch)    # pulse + its recovery until the next pulse
                pulses.append({"vsf_max_mv": round(float((vs[w] - s0).max()) * 1e3, 2), "vsf_min_mv": round(float((vs[w] - s0).min()) * 1e3, 2),
                               "vdiff_max_mv": round(float((v[w] - v0).max()) * 1e3, 2), "vdiff_min_mv": round(float((v[w] - v0).min()) * 1e3, 2)})
            post = t > tend_train + 20; ton = t[(t > a.tagg) & (on > 0.9)]
            rec["pixels"].append({"pixel": k, "vdiff_pre": round(v0, 4), "vsf_pre": round(s0, 4), "pulses": pulses,
                                  "vdiff_end_mv": round((float(v[-1]) - v0) * 1e3, 2), "vsf_end_mv": round((float(vs[-1]) - s0) * 1e3, 2),
                                  "vdiff_min_train_mv": round(float((v[(t >= a.tagg) & (t <= tend_train + 20)] - v0).min()) * 1e3, 2),
                                  "on_after_us": round(float(ton[0] - a.tagg), 2) if len(ton) else None, "on_before": bool((on[(t > 30) & (t < a.tagg - 1)] > 0.9).any())})
        t0, t1 = a.tagg - 10, tend_train + 40
        w = {}; tt, w["line"] = dec(t, d[line], t0, t1, 400); w["t_us"] = tt
        for k in range(4):
            _, w["vdiff%d" % k] = dec(t, d[P % (k, "vdiff")], t0, t1, 400); _, w["vsf%d" % k] = dec(t, d[P % (k, "vsf")], t0, t1, 400); _, w["on%d" % k] = dec(t, d[P % (k, "on")], t0, t1, 400)
        rec["win"] = w
        out["%s_%s" % (agg, s)] = rec
json.dump(out, sys.stdout)
