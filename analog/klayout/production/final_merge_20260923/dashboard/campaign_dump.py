#!/usr/bin/env python3
"""campaign_dump.py <label> <runs_dir>... : compact JSON of every result.json (row condition, validity, metrics, spec) on stdout"""
import json, glob, sys
label = sys.argv[1]; rows = []
for d in sys.argv[2:]:
    for f in glob.glob(d + "/*/*/*/attempt-*/result.json"):
        r = json.load(open(f)); c = r.get("condition", {}); p = f.split("/")
        rows.append({"path": p[-5], "analysis": p[-4], "row": p[-3][4:12], "corner": c.get("corner"), "temp": c.get("temperature_c"), "vdd": c.get("vdd_v"),
                     "biases": c.get("biases_a"), "iph": (c.get("optical") or {}).get("photocurrent_a"),
                     "exec": r.get("execution_validity"), "sci": r.get("scientific_validity"), "reason": r.get("scientific_reason"),
                     "metrics": r.get("metrics"), "spec": r.get("spec_result"), "err": (r.get("errors") or [""])[0][:80]})
json.dump({"label": label, "rows": rows}, sys.stdout)
