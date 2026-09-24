#!/usr/bin/env python3
"""Threshold-programmability table from a pvt_sweep OnBn x PrSFBp grid.
   thr_table.py outputs/pvt_thr_l [outputs/pvt_thr_k ...]  -> per tag: rows OnBn, cols PrSFBp; cell = ON time / trip level, or dip."""
import sys, glob, re, numpy as np, analyze_raw as A
ISF = {"100p": "5 pA", "300p": "19 pA", "1n": "95 pA", "3.5n": "~510 pA"}
def key(v):
    m = re.match(r"([0-9.]+)([pnu]?)", v); return float(m.group(1)) * {"p": 1e-12, "n": 1e-9, "u": 1e-6, "": 1}[m.group(2)]
for d in sys.argv[1:]:
    rows = {}
    for f in glob.glob(d + "/*.raw"):
        m = re.search(r"OnBn([0-9.]+[pnu]?)_PrSFBp([0-9.]+[pnu]?)", f)
        if not m: continue
        on, sf = m.group(1), m.group(2); r = A.read(f); t = r["time"]; tu = t * 1e6
        vd = r["v(vdiffsense)"]; onv = r["v(onsense)"]
        reset = vd[(tu > 0.3) & (tu < 0.6)].mean(); early = (tu > 0.5) & (tu < 25); dip = vd[early].min(); end = vd[-1]
        c = A.cross(t, onv, 0.9, True, 0)
        if c: i = np.searchsorted(t, c); trip = vd[max(i - 1, 0)]; cell = "ON %5.1f us (trip %.3f)" % (c * 1e6, trip)
        else: cell = "ok  dip %.3f end %.3f" % (dip, end)
        rows.setdefault(on, {})[sf] = (cell, reset)
    sfs = sorted({s for r in rows.values() for s in r}, key=key)
    print("== %s   (reset level ~%.3f V)" % (d, np.mean([v[1] for r in rows.values() for v in r.values()])))
    print("   %-8s" % "OnBn" + "".join("%-30s" % ("PrSFBp %s (I_sf %s)" % (s, ISF.get(s, "?"))) for s in sfs))
    for on in sorted(rows, key=key):
        print("   %-8s" % on + "".join("%-30s" % rows[on].get(s, ("-",))[0] for s in sfs))
