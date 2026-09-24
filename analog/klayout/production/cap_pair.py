#!/usr/bin/env python3
"""Scale arbitrary pixel-0 coupling cards and run Rui's reset TB.  cap_pair.py --src <netlist> --tag <tag> --cases "name:a-b=k,c-d=k;name2:..."
   Net names without a dot are taken as openDVS_pixel_0.<name>; use 'VddA18'/'GndA' with a leading '@' for globals (@GndA)."""
import re, subprocess, argparse, os
from concurrent.futures import ThreadPoolExecutor
ap = argparse.ArgumentParser(); ap.add_argument("--src", required=True); ap.add_argument("--tag", required=True); ap.add_argument("--cases", required=True); ap.add_argument("--jobs", type=int, default=8); a = ap.parse_args()
OUT = "outputs/pair_%s" % a.tag; os.makedirs(OUT, exist_ok=True)
src = open(a.src).read().splitlines()
def nn(n): return n[1:] if n.startswith("@") else "openDVS_pixel_0." + n
def find(x, y):
    idx = []
    for i, l in enumerate(src):
        f = l.split()
        if f and re.fullmatch(r"C\d+", f[0]) and len(f) >= 4:
            p, q = (re.sub(r"\.t\d+$", "", n) for n in f[1:3])
            if {p, q} == {nn(x), nn(y)}: idx.append(i)
    if not idx: raise SystemExit("no card for %s-%s" % (x, y))
    return idx
CASES = {}
for c in a.cases.split(";"):
    name, spec = c.split(":"); CASES[name] = [(kv.split("=")[0].split("-"), float(kv.split("=")[1])) for kv in spec.split(",")]
main = open("main.sp").read()
def run(name):
    lines = list(src); note = []
    for (x, y), k in CASES[name]:
        for i in find(x, y):
            f = lines[i].split(); v = float(f[3].rstrip("f")); f[3] = "%.6gf" % max(v * k, 1e-6); lines[i] = " ".join(f); note.append("%s-%s %.3f->%.3f" % (x, y, v, v * k))
    nl = "%s/dut_%s.spice" % (OUT, name); open(nl, "w").write("\n".join(lines) + "\n")
    deck = re.sub(r"^\.include source/\S+reset_physical_pd\S*\.spice", ".include %s" % nl, main, flags=re.M)
    deck = re.sub(r"^write outputs/\S+", "write %s/reset_rise_%s.raw v(vdiffsense) v(onsense) v(noffsense) v(vdsense) v(vsfsense) v(nrstsense) v(vprsense) v(pixrst)" % (OUT, name), deck, flags=re.M)
    dp = "%s/main_%s.sp" % (OUT, name); open(dp, "w").write(deck)
    subprocess.run(["ngspice", "-b", "-o", "%s/ngspice_%s.log" % (OUT, name), dp], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    r = subprocess.run(["python3", "analyze_raw.py", "%s/reset_rise_%s.raw" % (OUT, name), "--labels", name], capture_output=True, text=True).stdout
    on = re.search(r"v\(onsense\).*?crossing: (?:\S+ us \((\S+) us after release\)|(none))", r); vd = re.search(r"v\(vdiffsense\) end (\S+) V", r)
    return "%-22s %-50s vdiff end %s   ON: %s" % (name, "; ".join(note), vd.group(1) if vd else "?", (on.group(1) or on.group(2)) if on else "?")
with ThreadPoolExecutor(a.jobs) as ex: res = list(ex.map(run, CASES))
open(OUT + "/summary.txt", "w").write("\n".join(res) + "\n"); print("\n".join(res))
