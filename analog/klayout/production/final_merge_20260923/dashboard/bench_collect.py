#!/usr/bin/env python3
"""bench_collect.py <tag> : gather the bench results of one layout tag from ~/opendvs-sims/opendvs_reset_rise_20260921/outputs into JSON on stdout
   (reset TB summary, PVT/bias matrix, gain, crosstalk, coincident-edge control, GndD stress, OnBn x PrSFBp threshold grid)"""
import sys, os, re, json, subprocess, glob
tag = sys.argv[1]; os.chdir(os.path.expanduser("~/opendvs-sims/opendvs_reset_rise_20260921")); out = {"tag": tag}
def txt(p): return open(p).read() if os.path.exists(p) else None
def run(args):
    try: return subprocess.run(args, capture_output=True, text=True, timeout=600).stdout
    except Exception as e: return "ERR %s" % e
# 1. reset TB
t = txt("outputs/%s/reset_rise_%s.txt" % (tag, tag))
if t:
    m = re.search(r"nrstsense\).*?crossing: (?:\S+ us \((\S+) us after release\)|(none))", t); on = re.search(r"onsense\).*?crossing: (?:\S+ us \((\S+) us after release\)|(none))", t)
    vd = re.search(r"vdiffsense\) end (\S+) V\s+min (\S+)\s+max (\S+)", t)
    out["reset"] = {"nrst90_us": m.group(1) or m.group(2), "on_us": on.group(1) or on.group(2), "vdiff_end": float(vd.group(1)), "vdiff_min": float(vd.group(2)), "vdiff_max": float(vd.group(3)), "text": t}
# 2. PVT matrix
t = txt("outputs/pvt_%s/summary.txt" % tag)
if t:
    rows = []
    for l in t.strip().split("\n"):
        m = re.match(r"(\S+)\s+nRst90% (\S+) us\s+vdiff end (\S+) min (\S+)\s+ON: (\S+)", l)
        if m: rows.append({"case": m.group(1), "nrst90_us": m.group(2), "vdiff_end": (float(m.group(3)) if m.group(3) != "?" else None), "vdiff_min": (float(m.group(4)) if m.group(4) != "?" else None), "on_us": m.group(5)})
    out["pvt"] = rows
# 3. gain
t = txt("outputs/gain_gain_%s/summary.txt" % tag) or txt("outputs/gain_%s/summary.txt" % tag)
if t:
    rows = []
    for l in t.strip().split("\n"):
        m = re.match(r"(\S+)\s+ratio (\S+)\s+vdiff before (\S+) after (\S+) delta (\S+) \(per e-fold (\S+)\)\s+vsf (\S+) vpr (\S+)\s+ON trip (\S+)(?: @ (\S+) us)?\s+OFF trip (\S+)(?: @ (\S+) us)?", l)
        if m: rows.append({"case": m.group(1), "ratio": float(m.group(2)), "before": float(m.group(3)), "after": float(m.group(4)), "delta": float(m.group(5)), "per_efold": float(m.group(6)), "vsf": m.group(7), "vpr": m.group(8), "on_trip": m.group(9), "on_us": m.group(10), "off_trip": m.group(11), "off_us": m.group(12)})
    out["gain"] = rows
# 4. crosstalk + coincident edge
def xt(raw):
    r = run(["python3", "xtalk_report.py", raw]); pix = []
    for m in re.finditer(r"pixel_(\d) nRst-dip (\S+)\s+\| vdiff pre (\S+) post-min (\S+) max (\S+) end (\S+) \| vsf pre (\S+) post-min (\S+) max (\S+) end (\S+).*?\n\s+on\s+before-agg:(\S+)\s+after-agg: (.*?)\n\s+noff\s+before-agg:(\S+)\s+after-agg: (.*?)\n", r, re.S):
        pix.append({"pixel": int(m.group(1)), "nrst_dip": m.group(2), "vdiff_pre": float(m.group(3)), "vdiff_min": float(m.group(4)), "vdiff_max": float(m.group(5)), "vdiff_end": float(m.group(6)), "vsf_pre": float(m.group(7)), "vsf_min": float(m.group(8)), "vsf_max": float(m.group(9)), "on_after": m.group(12).strip(), "noff_after": m.group(14).strip()})
    return {"pixels": pix, "text": r}
out["xtalk"] = {}
for agg in ("reset", "rowoff", "readline", "te20n_rowoff"):
    for s in ("1n", "100p"):
        raw = "outputs/xtalk/xtalk_%s_%s_PrSFBp%s.raw" % (tag, agg, s)
        if os.path.exists(raw): out["xtalk"]["%s_%s" % (agg, s)] = xt(raw)
# 5. stress
out["stress"] = {}
for sc in ("bounce", "bounce_reset"):
    for s in ("1n", "100p"):
        raw = "outputs/stress/stress_%s_%s_PrSFBp%s.raw" % (tag, sc, s)
        if not os.path.exists(raw): continue
        r = run(["python3", "stress_report.py", raw]); m = re.search(r"GndD far end: pre (\S+) V, peak (\S+) V.*?end (\S+)", r); pix = []
        for pm in re.finditer(r"pixel_(\d) \| vdiff pre (\S+) min (\S+) max (\S+) end (\S+) \| vsf pre (\S+) min (\S+) max (\S+) end (\S+) \| vd pre (\S+) min (\S+) max (\S+) end (\S+) \| ON (.*?) \(peak (\S+) V\)", r):
            pix.append({"pixel": int(pm.group(1)), "vdiff_pre": float(pm.group(2)), "vdiff_min": float(pm.group(3)), "vdiff_max": float(pm.group(4)), "vsf_pre": float(pm.group(6)), "vsf_min": float(pm.group(7)), "vsf_max": float(pm.group(8)), "on": pm.group(14), "on_peak": float(pm.group(15))})
        out["stress"]["%s_%s" % (sc, s)] = {"gndd_peak": float(m.group(2)) if m else None, "pixels": pix, "text": r}
# 6. threshold grid
d = "outputs/pvt_thr_%s" % tag
t = txt(d + "/summary.txt")
if t:
    rows = []
    for l in t.strip().split("\n"):
        m = re.match(r"(\S+)\s+nRst90% (\S+) us\s+vdiff end (\S+) min (\S+)\s+ON: (\S+)", l)
        if m:
            c = m.group(1); ob = re.search(r"OnBn([0-9.]+n)", c); pb = re.search(r"PrSFBp([0-9.]+[pn])", c)
            rows.append({"onbn": ob.group(1) if ob else None, "prsfbp": pb.group(1) if pb else None, "vdiff_end": (float(m.group(3)) if m.group(3) != "?" else None), "vdiff_min": (float(m.group(4)) if m.group(4) != "?" else None), "on_us": m.group(5)})
    out["thr"] = rows
json.dump(out, sys.stdout)
