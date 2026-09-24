#!/usr/bin/env python3
"""Aggregate result.json files of the edit20260922l campaign runs: campaign_status.py [runs_dir ...]"""
import json, glob, sys, collections, os, time
dirs = sys.argv[1:] or ["runs/full_static", "runs/full_reset"]
tot = collections.Counter(); bad = []
for d in dirs:
    for f in glob.glob(d + "/*/*/*/attempt-*/result.json"):
        r = json.load(open(f)); p = f.split("/"); path, ana = p[-5], p[-4]
        key = (path, ana, r.get("execution_validity"), r.get("scientific_validity")); tot[key] += 1
        if r.get("execution_validity") != "pass" or r.get("scientific_validity") != "valid":
            bad.append((path, ana, r.get("condition", {}).get("corner"), r.get("condition", {}).get("temperature_c"), r.get("condition", {}).get("vdd_v"), r.get("scientific_reason"), (r.get("errors") or [""])[0][:60]))
print(time.strftime("%H:%M:%S"), "results:", sum(tot.values()))
for k, v in sorted(tot.items()): print("  %4d  %-22s %-16s exec=%-5s sci=%s" % (v, *k))
reasons = collections.Counter((b[0], b[1], b[5] or b[6]) for b in bad)
for k, v in reasons.most_common(12): print("  not-valid %4d  %s %s : %s" % (v, *k))
