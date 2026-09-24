#!/usr/bin/env python3
"""Pull a few vectors out of an ngspice ASCII raw file, report reset-release metrics, plot.
   analyze_raw.py RAW [RAW2] --png out.png"""
import sys, argparse, numpy as np
WANT = ["time","v(pixrst)","v(nrstsense)","v(onsense)","v(vdiffsense)","v(vdsense)","v(vsfsense)","v(vprsense)","v(noffsense)"]
def read(path):
    names, idx, data, n = [], {}, None, 0
    with open(path) as f:
        for line in f:
            if line.startswith("No. Variables:"): nvar = int(line.split(":")[1])
            elif line.startswith("No. Points:"): npts = int(line.split(":")[1])
            elif line.startswith("Variables:"):
                for i in range(nvar):
                    p = f.readline().split(); names.append(p[1])
                idx = {w: names.index(w) for w in WANT if w in names}
            elif line.startswith("Values:"):
                data = {w: np.empty(npts) for w in idx}
                lines = (l for l in f if l.strip())
                for k in range(npts):
                    vals = [float(next(lines).split()[-1])] + [float(next(lines)) for _ in range(nvar - 1)]
                    for w, j in idx.items(): data[w][k] = vals[j]
                break
    return data
def cross(t, v, level, rising=True, tmin=0):
    m = t >= tmin
    t, v = t[m], v[m]
    for i in range(1, len(t)):
        if (rising and v[i-1] < level <= v[i]) or (not rising and v[i-1] > level >= v[i]):
            return t[i-1] + (level - v[i-1]) * (t[i] - t[i-1]) / (v[i] - v[i-1])
    return None
if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("raw", nargs="+"); ap.add_argument("--png"); ap.add_argument("--labels", default="")
    a = ap.parse_args(); labels = a.labels.split(",") if a.labels else [p.split("/")[-1] for p in a.raw]
    runs = [(lab, read(p)) for lab, p in zip(labels, a.raw)]
    for lab, d in runs:
        t = d["time"]; rel = cross(t, d["v(pixrst)"], 0.18, rising=False)
        print("== %s: %d pts, %.1f us; pixRst falls below 10%% at %s" % (lab, len(t), t[-1]*1e6, "%.3f us" % (rel*1e6) if rel else "-"))
        for name in ("v(nrstsense)", "v(onsense)", "v(noffsense)"):
            c = cross(t, d[name], 1.62, True, rel or 0)
            print("   %-13s 90%% (1.62 V) rising crossing: %s   end value %.4f V  min after release %.4f V" % (name, "%.4f us (%.3f us after release)" % (c*1e6, (c-(rel or 0))*1e6) if c else "none", d[name][-1], d[name][t >= (rel or 0)].min()))
        for name in ("v(vdiffsense)", "v(vdsense)", "v(vsfsense)", "v(vprsense)"):
            print("   %-13s end %.4f V   min %.4f  max %.4f" % (name, d[name][-1], d[name].min(), d[name].max()))
    if a.png:
        import matplotlib; matplotlib.use("Agg"); import matplotlib.pyplot as plt
        fig, ax = plt.subplots(3, 1, figsize=(11, 9), sharex=True)
        for lab, d in runs:
            t = d["time"] * 1e6; ls = "-" if lab == labels[0] else "--"
            for k, (names, ttl) in enumerate(((("v(pixrst)", "v(nrstsense)", "v(onsense)"), "reset / event"), (("v(vdiffsense)", "v(vdsense)", "v(vsfsense)"), "change amp"), (("v(vprsense)", "v(noffsense)"), "photoreceptor / nOFF"))):
                for n in names: ax[k].plot(t, d[n], ls, lw=1, label="%s %s" % (n, lab))
                ax[k].set_ylabel("V"); ax[k].set_title(ttl); ax[k].grid(alpha=.3); ax[k].legend(fontsize=7, ncol=3)
        ax[-1].set_xlabel("time (us)"); fig.tight_layout(); fig.savefig(a.png, dpi=110); print("wrote", a.png)
