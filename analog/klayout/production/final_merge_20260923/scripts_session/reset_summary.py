# python3 reset_summary.py <campaign dir>... : reset_transient rows per path — validity, spec result, metric ranges, and the failing corners
import json, sys, glob, os, statistics as st
for C in sys.argv[1:]:
    print("=====", os.path.basename(C))
    rows = {}
    for f in glob.glob(C + "/runs/*/*/reset_transient/row-*/attempt-*/result.json"):
        d = json.load(open(f)); rows.setdefault(d["condition"]["path"], []).append(d)
    for path, L in sorted(rows.items()):
        valid = [d for d in L if d.get("scientific_validity") == "valid"]
        spec = {}
        for d in valid: spec[d.get("spec_result")] = spec.get(d.get("spec_result"), 0) + 1
        print("-- %-22s rows %d  valid %d  spec %s" % (path, len(L), len(valid), spec))
        for m in ["delta_vdiff_ci", "vdiff_after_ci", "refractory_period", "min_reset_time", "leak_event_period"]:
            v = [d["metrics"][m] for d in valid if d.get("metrics") and d["metrics"].get(m) is not None]
            if v: print("   %-18s n %2d  min %10.4g  median %10.4g  max %10.4g" % (m, len(v), min(v), st.median(v), max(v)))
        for d in valid:
            if d.get("spec_result") == "fail":
                c = d["condition"]; b = c["biases_a"]; ev = d.get("event_evidence", {}).get("leak_event_period", {})
                print("   FAIL %-3s %4s C %5.2f V  Iph %.0e  OnBn %.0e DiffBn %.0e RefrBp %.0e  dVdiff %+.3f  leak %.3g s  health %s" % (
                    c["corner"], c["temperature_c"], c["vdd_v"], c["optical"]["photocurrent_a"]["vpd[0]"], b["OnBn"], b["DiffBn"], b["RefrBp"],
                    d["metrics"]["delta_vdiff_ci"], d["metrics"]["leak_event_period"], d.get("event_evidence", {}).get("simulation_health", {}).get("status")))
        inval = [d for d in L if d.get("scientific_validity") != "valid"]
        if inval: print("   invalid:", sorted(set((d["condition"]["corner"], d["condition"]["temperature_c"], d["condition"]["vdd_v"]) for d in inval))[:12])
