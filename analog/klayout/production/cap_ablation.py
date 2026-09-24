#!/usr/bin/env python3
"""Capacitor ablation on the reset-rise TB: comment out chosen pixel_0 coupling caps in a copy of the
DUT netlist, run main.sp (as edited) against each copy, and tabulate the vdiff drop / ON event.
  cap_ablation.py [--src source/....spice] [--jobs 4] [--pixel 0]
Results: outputs/ablation/<exp>.{spice,sp,raw,log} and outputs/ablation/summary.txt"""
import argparse, os, re, subprocess, sys
from concurrent.futures import ThreadPoolExecutor
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
ap = argparse.ArgumentParser()
ap.add_argument("--src", default="source/openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.edit20260921b.spice")
ap.add_argument("--deck", default="main.sp"); ap.add_argument("--jobs", type=int, default=4); ap.add_argument("--pixel", default="0")
ap.add_argument("--only", default="", help="comma list of experiment names to run")
a = ap.parse_args()
P = "openDVS_pixel_%s." % a.pixel
def N(x): return x if ("[" in x or x in ("GndA", "GndD", "VddA18", "RefrBp", "PrBp", "PrSFBp", "OnBn", "OffBn", "DiffBn", "DiffBn_uq1")) else P + x
# experiments: name -> list of (netA, netB) pairs whose cap cards get commented
EXP = {
    "baseline": [],
    "nRst-vd": [("nRst", "vd")],
    "nRst-vsf": [("nRst", "vsf")],
    "nRst-vdiff": [("nRst", "vdiff")],
    "nRst-vpr": [("nRst", "vpr")],
    "vsf-vd": [("vsf", "vd")],
    "vsf-vdiff": [("vsf", "vdiff")],
    "vd-vdiff": [("vd", "vdiff")],
    "vd-vpr": [("vd", "vpr")],
    "nRst-GndA": [("nRst", "GndA")],
    "nRst-VddA18": [("nRst", "VddA18")],
    "nRst-readLine0": [("nRst", "readLine[0]")],
    "nRst-RefrBp": [("nRst", "RefrBp")],
    "nRst-ON": [("nRst", "ON")],
    "nRst-nOFF": [("nRst", "nOFF")],
    "set1641=nRst-vd+nRst-vsf+vsf-vd": [("nRst", "vd"), ("nRst", "vsf"), ("vsf", "vd")],
    "nRst-vd+nRst-vsf": [("nRst", "vd"), ("nRst", "vsf")],
    "nRst-{vd,vsf,vdiff,vpr}": [("nRst", "vd"), ("nRst", "vsf"), ("nRst", "vdiff"), ("nRst", "vpr")],
    "nRst-{vd,vsf,vdiff,vpr,ON,nOFF}": [("nRst", x) for x in ("vd", "vsf", "vdiff", "vpr", "ON", "nOFF")],
    "nRst-ALL": [("nRst", "*")],
    "vsf-vdiff+vd-vdiff": [("vsf", "vdiff"), ("vd", "vdiff")],
    "set1641+vsf-vdiff": [("nRst", "vd"), ("nRst", "vsf"), ("vsf", "vd"), ("vsf", "vdiff")],
}
if a.only: EXP = {k: v for k, v in EXP.items() if k in a.only.split(",")}
def strip(n): return re.sub(r"\.t\d+$", "", n)
src = open(a.src).read().splitlines()
def make(name, pairs):
    out, hit = [], {}
    for line in src:
        f = line.split()
        if f and re.fullmatch(r"C\d+", f[0]) and len(f) >= 4:
            x, y = strip(f[1]), strip(f[2])
            for pa, pb in pairs:
                A, B = N(pa), (None if pb == "*" else N(pb))
                if (B is None and A in (x, y)) or ({x, y} == {A, B}):
                    line = "*" + line + "   $ ablation " + name; hit.setdefault((pa, pb), []).append((f[0], f[3])); break
        out.append(line)
    return "\n".join(out) + "\n", hit
os.makedirs("outputs/ablation", exist_ok=True)
deck = open(a.deck).read()
VEC = "v(VddA18) v(pixrst) v(onSense) v(nrstSense) v(vdiffSense) v(vdSense) v(vsfSense) v(vprSense) v(vpd0) v(noffSense)"
def run(item):
    name, pairs = item; safe = re.sub(r"[^A-Za-z0-9_.+=-]", "_", name).replace("{", "").replace("}", "")
    net, hit = make(name, pairs)
    npath = "outputs/ablation/%s.spice" % safe; open(npath, "w").write(net)
    d = re.sub(r"^\.include source/\S+", ".include " + npath, deck, count=1, flags=re.M)
    d = re.sub(r"^\.save all\s*$", "", d, flags=re.M)
    d = re.sub(r"^write \S+.*$", "write outputs/ablation/%s.raw %s" % (safe, VEC), d, count=1, flags=re.M)
    dpath = "outputs/ablation/%s.sp" % safe; open(dpath, "w").write(d)
    subprocess.run(["ngspice", "-b", "-o", "outputs/ablation/%s.log" % safe, dpath], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                   env={**os.environ, "OMP_NUM_THREADS": "1"})
    return name, safe, hit
with ThreadPoolExecutor(a.jobs) as ex: results = list(ex.map(run, EXP.items()))
import analyze_raw as AR   # reuse the raw reader / crossing helpers
lines = ["%-36s %8s %8s %9s %10s   %s" % ("experiment", "vdiff_end", "vdiff_min", "ON_at_us", "nRst90_us", "commented cards (fF)")]
for name, safe, hit in results:
    d = AR.read("outputs/ablation/%s.raw" % safe); t = d["time"]
    rel = AR.cross(t, d["v(pixrst)"], 0.18, rising=False) or 0
    on = AR.cross(t, d["v(onsense)"], 1.62, True, rel); nr = AR.cross(t, d["v(nrstsense)"], 1.62, True, rel)
    cards = "; ".join("%s-%s:%s" % (pa, pb, ",".join("%s=%s" % c for c in cs)) for (pa, pb), cs in hit.items())
    lines.append("%-36s %8.4f %8.4f %9s %10.3f   %s" % (name, d["v(vdiffsense)"][-1], d["v(vdiffsense)"].min(), "%.3f" % ((on - rel) * 1e6) if on else "none", (nr - rel) * 1e6 if nr else -1, cards[:160]))
open("outputs/ablation/summary.txt", "w").write("\n".join(lines) + "\n"); print("\n".join(lines))
