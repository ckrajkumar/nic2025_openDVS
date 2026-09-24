#!/usr/bin/env python3
"""Junction transfer for a re-extracted layout: match fresh Magic MOS cards to the production
composed Magic netlist by (model, ordered terminal nets, W, L) — not by instance number — then reuse the
registered production role map (quantus instance, source/drain swap) to append AD/AS/PD/PS to the
Quantus Spectre view.  Usage:
  transfer_l.py --fresh-magic F --production-magic P --role-map J --quantus Q --output O --report R"""
import argparse, hashlib, json, re, sys
from pathlib import Path
TAIL = re.compile(r"\.(?:t|n)\d+$")
def sha(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def mos(path):
    d = {}
    for line in Path(path).read_text().splitlines():
        f = line.split()
        if f and f[0][0] == "X" and any(x.startswith("sky130_fd_pr__") and "fet" in x for x in f):
            model = [x for x in f if x.startswith("sky130_fd_pr__")][0]; kv = dict(x.split("=") for x in f if "=" in x)
            d[f[0]] = {"model": model, "terms": tuple(TAIL.sub("", x) for x in f[1:5]), "w": kv["w"], "l": kv["l"],
                       "ad": kv["ad"], "as": kv["as"], "pd": kv["pd"], "ps": kv["ps"]}
    return d
def key(v): return (v["model"], v["terms"], v["w"], v["l"])
ap = argparse.ArgumentParser(); ap.add_argument("--fresh-magic", required=True); ap.add_argument("--production-magic", required=True)
ap.add_argument("--role-map", required=True); ap.add_argument("--quantus", required=True); ap.add_argument("--output", required=True); ap.add_argument("--report", required=True)
a = ap.parse_args()
F, P = mos(a.fresh_magic), mos(a.production_magic)
if len(F) != 80 or len(P) != 80: sys.exit("expected 80 MOS cards: fresh %d production %d" % (len(F), len(P)))
pk = {key(v): n for n, v in P.items()}; fk = {key(v): n for n, v in F.items()}
if len(pk) != 80 or len(fk) != 80: sys.exit("terminal keys not unique")
if set(pk) != set(fk): sys.exit("fresh/production MOS structure differs: %s" % sorted(set(pk) ^ set(fk))[:4])
prod_to_fresh = {pk[k]: fk[k] for k in pk}
mapping = json.loads(Path(a.role_map).read_text())["mapping"]
if len(mapping) != 80: sys.exit("role map must have 80 entries")
def strip(v): return re.sub(r"[pu]$", "", v)
SUF = {"": 1.0, "f": 1e-15, "p": 1e-12, "n": 1e-9, "u": 1e-6}
def norm(v, unit):
    m = re.fullmatch(r"([0-9.eE+-]+)([fpnu]?)", v); val = float(m.group(1)) * SUF[m.group(2)]
    return "%g%s" % (val / (1e-12 if unit == "p" else 1e-6), unit)
geo_changed = []; per_q = {}; rolemap_notes = []
for e in mapping:
    pn = e["fresh_magic_instance"]; fn = prod_to_fresh[pn]; g = F[fn]; pg = P[pn]
    sw = {"ad": "as", "as": "ad", "pd": "ps", "ps": "pd"}
    for k in ("ad", "as", "pd", "ps"):
        src = sw[k] if e["source_drain_swapped"] else k
        if strip(pg[src]) != e["geometry"][k]: rolemap_notes.append("%s.%s: role map %s vs production Magic %s (swapped=%s)" % (pn, k, e["geometry"][k], pg[src], e["source_drain_swapped"]))
    if e["source_drain_swapped"]: ad, as_, pd, ps = g["as"], g["ad"], g["ps"], g["pd"]
    else: ad, as_, pd, ps = g["ad"], g["as"], g["pd"], g["ps"]
    ad, as_, pd, ps = norm(ad, "p"), norm(as_, "p"), norm(pd, "u"), norm(ps, "u")
    per_q[e["quantus_instance"]] = (ad, as_, pd, ps, pn, fn, e["source_drain_swapped"])
    if (g["ad"], g["as"], g["pd"], g["ps"]) != (pg["ad"], pg["as"], pg["pd"], pg["ps"]): geo_changed.append({"production": pn, "fresh": fn, "old": [pg["ad"], pg["as"], pg["pd"], pg["ps"]], "new": [g["ad"], g["as"], g["pd"], g["ps"]]})
out = []; n = 0
for line in Path(a.quantus).read_text().splitlines():
    out.append(line); f = line.split()
    if f and f[0] in per_q:
        ad, as_, pd, ps, *_ = per_q[f[0]]; out.append("+ AD=%s AS=%s PD=%s PS=%s" % (ad, as_, pd, ps)); n += 1
if n != 80: sys.exit("appended %d cards, expected 80" % n)
Path(a.output).write_text("\n".join(out) + "\n")
Path(a.report).write_text(json.dumps({"inputs": {k: {"path": str(Path(v).resolve()), "sha256": sha(v)} for k, v in {"fresh_magic": a.fresh_magic, "production_magic": a.production_magic, "role_map": a.role_map, "quantus": a.quantus}.items()},
    "output": {"path": str(Path(a.output).resolve()), "sha256": sha(a.output)}, "checks": {"fresh_mos": 80, "matched_by_terminals": 80, "cards_changed": n, "swaps_applied": sum(1 for v in per_q.values() if v[6])},
    "geometry_changed_vs_production": geo_changed, "rolemap_geometry_notes": rolemap_notes, "mapping": [{"quantus_instance": q, "production_magic_instance": v[4], "fresh_magic_instance": v[5], "source_drain_swapped": v[6], "geometry": {"ad": v[0], "as": v[1], "pd": v[2], "ps": v[3]}} for q, v in per_q.items()]}, indent=2, sort_keys=True) + "\n")
print("ok: %d cards, %d swaps, %d devices with changed junction geometry" % (n, sum(1 for v in per_q.values() if v[6]), len(geo_changed)))
