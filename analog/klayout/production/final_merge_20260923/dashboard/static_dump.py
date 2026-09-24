#!/usr/bin/env python3
"""static_dump.py <runs_dir>... : for every valid photoreceptor_dc / comparator_dc / ac_gain row at tt 27 C 1.8 V (ngspice paths, ASCII raw), all raw
   variables decimated to <= 400 points (magnitude for complex AC data). JSON on stdout keyed path/analysis."""
import sys, os, json, glob, math
def read_raw(p):
    names = []; vals = []; cplx = False
    with open(p) as f:
        it = iter(f)
        for l in it:
            if l.startswith("Flags:") and "complex" in l: cplx = True
            if l.startswith("Variables:"):
                for l2 in it:
                    if l2.startswith("Values:"): break
                    names.append(l2.split()[1])
                cur = []
                for l3 in it:
                    s = l3.strip()
                    if not s: continue
                    parts = s.split()
                    tok = parts[-1]
                    if len(parts) == 2 and cur: vals.append(cur); cur = []
                    if cplx: re_, im_ = tok.split(","); cur.append(math.hypot(float(re_), float(im_)))
                    else: cur.append(float(tok))
                if cur: vals.append(cur)
    return names, vals
out = {}
for d in sys.argv[1:]:
    for f in glob.glob(d + "/*/*/*/attempt-*/result.json"):
        r = json.load(open(f)); c = r.get("condition", {}); p = f.split("/"); path, ana = p[-5], p[-4]
        if ana not in ("photoreceptor_dc", "comparator_dc", "ac_gain") or r.get("scientific_validity") != "valid": continue
        if not (abs(c.get("vdd_v", 0) - 1.8) < 1e-6 and c.get("temperature_c") == 27): continue
        raw = r.get("raw_output")
        if not raw or not raw.endswith(".raw") or not os.path.exists(raw): continue
        names, vals = read_raw(raw)
        if not vals: continue
        step = max(1, len(vals) // 400); vals = vals[::step]
        key = "%s/%s" % (path, ana); out.setdefault(key, [])
        out[key].append({"corner": c.get("corner"), "biases": c.get("biases_a"), "iph": str((c.get("optical") or {}).get("photocurrent_a"))[:60], "names": names, "cols": [[float("%.6g" % v[i]) for v in vals] for i in range(len(names))]})
json.dump(out, sys.stdout)
