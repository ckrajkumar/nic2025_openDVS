#!/usr/bin/env python3
"""Scale selected nRst coupling caps of the DUT netlist and run the reset TB for each case (parallel ngspice).
   cap_scale.py --src <netlist> --tag <tag>   -> outputs/scale_<tag>/summary.txt"""
import re, sys, subprocess, argparse, os, shutil
from concurrent.futures import ThreadPoolExecutor
ap = argparse.ArgumentParser(); ap.add_argument("--src", required=True); ap.add_argument("--tag", required=True); ap.add_argument("--jobs", type=int, default=6); a = ap.parse_args()
OUT = "outputs/scale_%s" % a.tag; os.makedirs(OUT, exist_ok=True)
src = open(a.src).read().splitlines()
def find(a_, b_):
    for i, l in enumerate(src):
        f = l.split()
        if f and re.fullmatch(r"C\d+", f[0]) and len(f) >= 4:
            x, y = (re.sub(r"\.t\d+$", "", n) for n in f[1:3])
            if {x, y} == {"openDVS_pixel_0." + a_, "openDVS_pixel_0." + b_}: return i
    raise SystemExit("no card for %s-%s" % (a_, b_))
ivd, ivsf = find("nRst", "vd"), find("nRst", "vsf")
def val(i): return float(src[i].split()[3].rstrip("f"))
print("pixel_0 cards: nRst-vd %.3f fF (line %d), nRst-vsf %.3f fF (line %d)" % (val(ivd), ivd + 1, val(ivsf), ivsf + 1))
CASES = {"base": (1, 1), "vd0.5": (0.5, 1), "vd0.25": (0.25, 1), "vd0": (0, 1), "vsf0.5": (1, 0.5), "vsf0": (1, 0), "both0.5": (0.5, 0.5), "both0.25": (0.25, 0.25), "both0": (0, 0), "vd0_vsf0.5": (0, 0.5), "vd0.25_vsf0": (0.25, 0)}
main = open("main.sp").read()
def run(name):
    kvd, kvsf = CASES[name]; lines = list(src)
    for i, k in ((ivd, kvd), (ivsf, kvsf)):
        f = lines[i].split(); f[3] = "%.6gf" % max(val(i) * k, 1e-6); lines[i] = " ".join(f)
    nl = "%s/dut_%s.spice" % (OUT, name); open(nl, "w").write("\n".join(lines) + "\n")
    deck = re.sub(r"^\.include source/\S+reset_physical_pd\S*\.spice", ".include %s" % nl, main, flags=re.M)
    deck = re.sub(r"^write outputs/\S+", "write %s/reset_rise_%s.raw sense_only" % (OUT, name), deck, flags=re.M)
    deck = deck.replace("sense_only", "v(vdiffsense) v(onsense) v(noffsense) v(vdsense) v(vsfsense) v(nrstsense) v(pixrst)")
    dp = "%s/main_%s.sp" % (OUT, name); open(dp, "w").write(deck)
    subprocess.run(["ngspice", "-b", "-o", "%s/ngspice_%s.log" % (OUT, name), dp], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    r = subprocess.run(["python3", "analyze_raw.py", "%s/reset_rise_%s.raw" % (OUT, name), "--labels", name], capture_output=True, text=True).stdout
    on = re.search(r"v\(onsense\).*?crossing: (\S+)", r); vd = re.search(r"v\(vdiffsense\) end (\S+)", r)
    return "%-12s k_vd=%-5s k_vsf=%-5s  vdiff end %s V   ON crossing %s" % (name, kvd, kvsf, vd.group(1) if vd else "?", on.group(1) if on else "?")
with ThreadPoolExecutor(a.jobs) as ex: res = list(ex.map(run, CASES))
open(OUT + "/summary.txt", "w").write("\n".join(res) + "\n"); print("\n".join(res))
