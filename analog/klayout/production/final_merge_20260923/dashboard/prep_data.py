#!/usr/bin/env python3
"""prep_data.py : assemble data.json for the dashboard from the collected pieces in this directory"""
import json, re, os, collections, statistics as st
def load(p, default=None):
    try: return json.load(open(p))
    except Exception: return default
D = {"generated": "2026-09-23", "layouts": {"prod": "production pixel (collaborators' openDVS_pixel2x2, Magic RCC 660 caps / Quantus)", "r19": "r19 pixel (edit20260922r19, in the r20 wrapper; Magic RCC 1007 caps with fill shunts / Quantus)"}}
# --- benches
bench = {"r19": load("bench_r19.json", {}), "prod": load("bench_prod.json") or load("bench_prod_partial.json", {})}
D["bench"] = {}
for tag, b in bench.items():
    e = {}
    if b.get("reset"): r = b["reset"]; e["reset"] = {k: r[k] for k in ("nrst90_us", "on_us", "vdiff_end", "vdiff_min", "vdiff_max")}
    if b.get("pvt"): e["pvt"] = b["pvt"]
    if b.get("gain"): e["gain"] = b["gain"]
    if b.get("thr"): e["thr"] = b["thr"]
    if b.get("xtalk"):
        e["xtalk"] = {}
        for k, v in b["xtalk"].items():
            px = v["pixels"]
            e["xtalk"][k] = [{"pixel": p["pixel"], "dip_mv": round((p["vdiff_min"] - p["vdiff_pre"]) * 1e3, 1), "rise_mv": round((p["vdiff_max"] - p["vdiff_pre"]) * 1e3, 1), "end_mv": round((p["vdiff_end"] - p["vdiff_pre"]) * 1e3, 1), "on": p["on_after"]} for p in px]
    if b.get("stress"):
        e["stress"] = {}
        for k, v in b["stress"].items():
            px = v["pixels"]
            e["stress"][k] = {"gndd_peak": v["gndd_peak"], "pixels": [{"pixel": p["pixel"], "dip_mv": round((p["vdiff_min"] - p["vdiff_pre"]) * 1e3, 1), "rise_mv": round((p["vdiff_max"] - p["vdiff_pre"]) * 1e3, 1), "on": p["on"], "on_peak": p["on_peak"]} for p in px]}
    D["bench"][tag] = e
# --- crosstalk (per pixel + waveforms) from xtalk_dump.py; waveforms kept for the 95 pA sets only
D["xtalk"] = {}
for tag in ("r19", "prod"):
    x = load("xtalk_%s.json" % tag, {}); D["xtalk"][tag] = {}
    for k, v in x.items():
        e = {"pixels": v["pixels"]}
        if k.endswith("_1n"):
            for w in ("win_release", "win_pulse"):
                src = v[w]; e[w] = {kk: src[kk] for kk in src if not kk.startswith("on") or kk in ("on0", "on3", "on2")}
        D["xtalk"][tag][k] = e
# --- realistic-edge pulse-train bench (xtalk3.py on ini: every digital edge a linear ramp of trise; read lines start low;
#     3 pulses of 1 us at 50 us pitch from 0.4 ms) from xtalk3_dump.py: xtalk3_e<trise>_<layout>.json
D["xtalk3"] = {}
for tag in ("r19", "prod"):
    D["xtalk3"][tag] = {}
    for tr in ("e100n", "e1u", "e10u", "e100u"):
        x = load("xtalk3_%s_%s.json" % (tr, tag), {})
        if not x: continue
        D["xtalk3"][tag][tr] = {}
        for k, v in x.items():
            e = {k2: v[k2] for k2 in ("pixels", "tagg_us", "pitch_us", "npulse", "width_us", "trise_us")}
            if k.endswith("_1n") or k.endswith("_100p"): e["win"] = {kk: v["win"][kk] for kk in v["win"] if kk.startswith(("t_us", "line", "vdiff0", "vdiff3", "vdiff1", "vdiff2", "vsf0", "vsf1", "on0", "on3"))}
            D["xtalk3"][tag][tr][k] = e
# --- CACE 2x2 testbenches on ini (cace_tables.py): schem / r19 / prod / calibre
D["cace"] = load("cace_tables.json")
# (the campaign's reset rows = the CACE reset_tran testbench, same metrics and 45 conditions; merged as r19q/r19m at the end)
# --- static analyses (campaign raws, 27 C 1.8 V) from static_dump.py: one row per (path, analysis) per layout
def pick(rows, corner, **bias):
    for r in rows:
        if (corner is None or r["corner"] == corner) and all(abs(r["biases"].get(k, -1) - v) <= abs(v) * 1e-6 for k, v in bias.items()): return r
    return None
D["static"] = {}
for tag in ("r19", "prod"):
    st = load("static_%s.json" % tag, {}); out = {}
    def put(name, key, corner, **bias):
        r = pick(st.get(key, []), corner, **bias)
        if r: out[name] = {"corner": r["corner"], "biases": r["biases"], "names": r["names"], "cols": r["cols"]}
    put("pr_magic", "magic_rcc_ngspice/photoreceptor_dc", "tt", PrBp=1e-9, PrSFBp=1e-10)
    put("pr_schem", "schematic_ngspice/photoreceptor_dc", "tt", PrBp=1e-9, PrSFBp=1e-10)
    put("cmp_schem", "schematic_ngspice/comparator_dc", "tt")
    put("cmp_magic", "magic_rcc_ngspice/comparator_dc", None)
    put("ac_schem", "schematic_ngspice/ac_gain", "tt", DiffBn=1e-8)
    put("ac_magic", "magic_rcc_ngspice/ac_gain", None, DiffBn=1e-8)
    D["static"][tag] = out
D["pvt_window_us"] = 110
# --- waveforms
W = {}
for tag, f in (("r19", "wave_r19.json"), ("prod", "wave_prod.json")):
    w = load(f)
    if w: W[tag] = list(w.values())[0]
D["waves"] = W
# --- Quantus couplings (r19 = q, production = ref)
cc = {}; cur = None
for l in open("cc_r19_vs_prod.txt"):
    m = re.match(r"== openDVS_pixel_0\.(\S+)\s+total: q (\S+) fF\s+ref (\S+) fF", l)
    if m: cur = m.group(1); cc[cur] = {"total_r19": float(m.group(2)), "total_prod": float(m.group(3)), "pairs": []}; continue
    m = re.match(r"\s+(\S+)\s+([0-9.]+)\s+([0-9.]+)\s*$", l)
    if m and cur and m.group(1) not in ("coupled", "q"): cc[cur]["pairs"].append({"agg": m.group(1).replace("px0.", ""), "r19": float(m.group(2)), "prod": float(m.group(3))})
D["cc"] = cc
# --- campaign
def rows_of(*files):
    out = []
    for f in files:
        if not os.path.exists(f): continue
        for line in open(f).read().strip().split("\n"):
            if line.strip(): out += json.loads(line)["rows"]
    return out
def summarize(rows):
    S = {"reset": [], "static": {}, "counts": {}}
    for r in rows:
        key = "%s/%s" % (r["path"], r["analysis"]); c = S["counts"].setdefault(key, {"n": 0, "valid": 0, "exec_fail": 0, "pass": 0, "fail": 0})
        c["n"] += 1; c["valid"] += r["sci"] == "valid"; c["exec_fail"] += r["exec"] != "pass"; c["pass"] += r["spec"] == "pass"; c["fail"] += r["spec"] == "fail"
        if r["analysis"] == "reset_transient" and r["metrics"]:
            m = r["metrics"]
            S["reset"].append({"path": r["path"].split("_")[0], "corner": r["corner"], "temp": r["temp"], "vdd": r["vdd"], "valid": r["sci"] == "valid", "spec": r["spec"],
                               "dvdiff": round(m.get("delta_vdiff_ci", float("nan")), 4), "refr_us": round(m.get("refractory_period", float("nan")) * 1e6, 2), "leak_s": m.get("leak_event_period"), "vafter": round(m.get("vdiff_after_ci", float("nan")), 4)})
    return S
C = {}
C["r19"] = summarize(rows_of("r19_ws.json", "r19_ini_both.json"))
prodrows = rows_of("prod_ws.json", "prod_ini.json")
C["prod"] = summarize(prodrows) if prodrows else None
# production nominal three-path (2026-09-10)
txt = open("r19_ini_both.json").read().strip().split("\n")
C["prod_nominal"] = summarize(json.loads(txt[1])["rows"]) if len(txt) > 1 else None
# AC gain summaries (text from ac_summary.py)
def ac(f):
    if not os.path.exists(f): return None
    out = {}
    for l in open(f):
        m = re.match(r"-- (\S+)\s+rows (\d+)\s+\|vdiff/vsf\| at 1 kHz: min (\S+) median (\S+) max (\S+)", l)
        if m: out[m.group(1)] = {"rows": int(m.group(2)), "g1k_min": float(m.group(3)), "g1k_med": float(m.group(4)), "g1k_max": float(m.group(5)), "g100": []}
        m = re.match(r"\s+(\S+)\s+27 C 1.80 V\s+G@1kHz\s+(\S+)\s+G@100Hz\s+(\S+)", l)
        if m and out: list(out.values())[-1]["g100"].append(float(m.group(3)))
    return out
C["ac"] = {"r19": ac("ac_r19.txt"), "prod": ac("ac_prod.txt")}
D["campaign"] = C
if D.get("cace") and "reset_tran" in D["cace"]["params"]:
    P = D["cace"]["params"]["reset_tran"]; P["rows"] = [r for r in P["rows"] if r["source"] not in ("r19q", "r19m")]
    for r in C["r19"]["reset"]:
        src = {"quantus": "r19q", "magic": "r19m"}.get(r["path"])
        if not src or not r["valid"]: continue
        leak = r.get("leak_s"); P["rows"].append({"source": src, "run": "campaign-edit20260922r19-v1", "error": "",
            "cond": {"corner": r["corner"], "temperature": str(r["temp"]), "vdd": str(r["vdd"])},
            "values": {"refractory_period": r["refr_us"], "delta_vdiff_ci": r["dvdiff"] * 1e3, "leak_event_period": (leak * 1e3 if isinstance(leak, (int, float)) else None),
                       "min_reset_time": None, "vdiff_before_ci": None, "vdiff_after_ci": r["vafter"] * 1e3}})
json.dump(D, open("data.json", "w")); print("data.json", os.path.getsize("data.json"), "bytes;", {k: (len(v) if hasattr(v, "__len__") else v) for k, v in D["bench"]["r19"].items()}, "| prod bench:", list(D["bench"]["prod"].keys()), "| cc nets", list(cc), "| r19 reset rows", len(C["r19"]["reset"]), "| prod campaign", bool(C["prod"]), "| xtalk3", {t: list(v) for t, v in D["xtalk3"].items()}, "| cace", bool(D["cace"]))
