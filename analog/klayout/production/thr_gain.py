#!/usr/bin/env python3
"""Photocurrent-step runs on Rui's reset TB: reset released at t=0, pixel-0 photocurrent stepped x<ratio> at T_STEP,
   comparator biases per case.  thr_gain.py --src <netlist> --tag <tag> --cases "name:ratio:IOnBn=..,IOffBn=..,IPrSFBp=..;..."
   -> outputs/gain_<tag>/summary.txt with: vdiff before the step, after settling, delta, ON/OFF trip level and time."""
import re, subprocess, argparse, os, math
from concurrent.futures import ThreadPoolExecutor
ap = argparse.ArgumentParser(); ap.add_argument("--src", required=True); ap.add_argument("--tag", required=True); ap.add_argument("--cases", required=True)
ap.add_argument("--jobs", type=int, default=10); ap.add_argument("--tstep", default="150u"); ap.add_argument("--tend", default="450u"); a = ap.parse_args()
OUT = "outputs/gain_%s" % a.tag; os.makedirs(OUT, exist_ok=True)
main = open("main.sp").read()
CASES = []
for c in a.cases.split(";"):
    name, ratio, sets = c.split(":"); CASES.append((name, float(ratio), dict(kv.split("=") for kv in sets.split(",")) if sets else {}))
def run(i):
    name, ratio, st = CASES[i]
    deck = re.sub(r"^\.include source/\S+reset_physical_pd\S*\.spice", ".include %s" % a.src, main, flags=re.M)
    for k, v in st.items():
        deck, n = re.subn(r"^(%s\s+\S+\s+\S+\s+dc\s+)\S+" % k, r"\g<1>%s" % v, deck, flags=re.M)
        if n != 1: raise SystemExit("source %s not found once" % k)
    deck, n = re.subn(r"^Iipd0 vpd0 0 dc 1n", "Iipd0 vpd0 0 PWL(0 1n %s 1n %s %.6gn %s %.6gn)" % (a.tstep, a.tstep.replace("u", ".1u"), ratio, a.tend, ratio), deck, flags=re.M)
    if n != 1: raise SystemExit("Iipd0 line not found")
    deck = re.sub(r"^\.tran .*", ".tran 20n %s 0m 20n" % a.tend, deck, flags=re.M)
    deck = re.sub(r"^write outputs/\S+", "write %s/%s.raw v(vdiffsense) v(onsense) v(noffsense) v(vdsense) v(vsfsense) v(vprsense) v(pixrst)" % (OUT, name), deck, flags=re.M)
    dp = "%s/main_%s.sp" % (OUT, name); open(dp, "w").write(deck)
    subprocess.run(["ngspice", "-b", "-o", "%s/ng_%s.log" % (OUT, name), dp], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    import numpy as np, analyze_raw as A
    d = A.read("%s/%s.raw" % (OUT, name)); t = d["time"]; tu = t * 1e6
    ts = float(a.tstep.rstrip("u")); te = float(a.tend.rstrip("u"))
    before = d["v(vdiffsense)"][(tu > ts - 5) & (tu < ts - 0.5)].mean(); after = d["v(vdiffsense)"][(tu > te - 5)].mean()
    vsf_b = d["v(vsfsense)"][(tu > ts - 5) & (tu < ts - 0.5)].mean(); vsf_a = d["v(vsfsense)"][tu > te - 5].mean()
    vpr_b = d["v(vprsense)"][(tu > ts - 5) & (tu < ts - 0.5)].mean(); vpr_a = d["v(vprsense)"][tu > te - 5].mean()
    on = A.cross(t, d["v(onsense)"], 0.9, True, ts * 1e-6); off = A.cross(t, d["v(noffsense)"], 0.9, False, ts * 1e-6)
    on0 = A.cross(t, d["v(onsense)"], 0.9, True, 0); off0 = A.cross(t, d["v(noffsense)"], 0.9, False, 0)
    def trip(c):
        if not c: return "none"
        i = np.searchsorted(t, c); return "%.4f @ %.1f us" % (d["v(vdiffsense)"][max(i - 1, 0)], c * 1e6)
    return "%-28s ratio %-5g vdiff before %.4f after %.4f delta %+.4f (per e-fold %+.3f)  vsf %+.4f vpr %+.4f  ON trip %s  OFF trip %s  [events before step: ON %s OFF %s]" % (
        name, ratio, before, after, after - before, (after - before) / math.log(ratio) if ratio != 1 else float("nan"), vsf_a - vsf_b, vpr_a - vpr_b, trip(on), trip(off),
        "%.1f" % (on0 * 1e6) if on0 and on0 < ts * 1e-6 else "-", "%.1f" % (off0 * 1e6) if off0 and off0 < ts * 1e-6 else "-")
with ThreadPoolExecutor(a.jobs) as ex: res = list(ex.map(run, range(len(CASES))))
open(OUT + "/summary.txt", "w").write("\n".join(res) + "\n"); print("\n".join(res))
