#!/usr/bin/env python3
"""cace_tables.py [cond]  — collect the CACE 2x2 results of every source root (~/opendvs-cace/root_<src>/runs) into one JSON:
   {"params": {<param>: {"display", "testbench", "variables": [{name, display, unit, min, max}], "rows": [{source, run, cond: {...}, values: {name: display-unit value}}]}}}
   Values are converted from the .data base SI units to the yaml display unit (CACE convention: mV, us, ms, pA …)."""
import os, sys, glob, json, yaml
HOME = os.path.expanduser("~"); BASE = f"{HOME}/opendvs-cace"; cond = sys.argv[1] if len(sys.argv) > 1 else "typ"
SRC = sys.argv[2].split(",") if len(sys.argv) > 2 else ["schem", "r19"]
YAML = {"dc_sweep": "PixelPhotoreceptor", "pixel_ac_gain": "PixelGainAC", "reset_tran": "PixelResetTran", "comparator_dc": "PixelComparators", "autoread_tran": "PixelAutoReadLine"}
SCALE = {"mV": 1e3, "us": 1e6, "ms": 1e3, "pA": 1e12, "nA": 1e9, "V": 1, "Hz": 1, "V/A": 1, "": 1, None: 1}
RESERVED = {"N", "filename", "root", "simpath", "xPexType", "templates", "DUT_name", "DUT_path", "netlist_source", "PDK_ROOT", "PDK", "include_DUT", "random"}
def lim(spec, key):
    v = spec.get(key, {}).get("value") if isinstance(spec.get(key), dict) else None
    return None if v in (None, "any") else v
out = {"cond": cond, "params": {}}
for param, tb in YAML.items():
    y = yaml.safe_load(open(f"{BASE}/analog/cace/{tb}_2x2_{cond}_schem.yaml"))
    pd = y["parameters"][param]; names = pd["tool"]["ngspice"]["variables"]
    variables = [{"name": n, "display": pd["spec"][n].get("display", n), "unit": pd["spec"][n].get("unit", ""), "description": pd["spec"][n].get("description", ""),
                  "min": lim(pd["spec"][n], "minimum"), "max": lim(pd["spec"][n], "maximum"), "fail": bool(any(isinstance(pd["spec"][n].get(k), dict) and pd["spec"][n][k].get("fail") for k in ("minimum", "maximum")))} for n in names]
    rows = []
    for src in SRC:
        for run in sorted(glob.glob(f"{BASE}/root_{src}/runs/RUN_*/parameters/{param}/run_*")):
            data = glob.glob(f"{run}/*.data")
            c = yaml.safe_load(open(f"{run}/conditions.yaml")); cc = {k: v for k, v in c.items() if k not in RESERVED}
            vals = None
            if data:
                raw = open(data[0]).read().split()
                if len(raw) == len(names):
                    vals = {n: float(v) * SCALE.get(variables[i]["unit"], 1) for i, (n, v) in enumerate(zip(names, raw))}
            err = ""
            if not vals:
                so = f"{run}/ngspice_stderr.out"; err = open(so).read()[-300:].strip() if os.path.exists(so) else "no data"
            rows.append({"source": src, "run": run.split("/runs/")[1], "cond": cc, "values": vals, "error": err})
    out["params"][param] = {"display": pd.get("display", param), "testbench": tb + "_2x2", "variables": variables, "rows": rows}
json.dump(out, sys.stdout)
