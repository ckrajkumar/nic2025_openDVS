#!/usr/bin/env python3
"""Charge-vs-slew check: vary the nRst ramp rate (IRefrBp) and the pixRst edge, keep the DUT netlist.
   slew_sweep.py --src <netlist> --tag <tag>   -> outputs/slew_<tag>/summary.txt"""
import re, subprocess, argparse, os
from concurrent.futures import ThreadPoolExecutor
ap = argparse.ArgumentParser(); ap.add_argument("--src", required=True); ap.add_argument("--tag", required=True); ap.add_argument("--jobs", type=int, default=6); a = ap.parse_args()
OUT = "outputs/slew_%s" % a.tag; os.makedirs(OUT, exist_ok=True)
main = open("main.sp").read()
CASES = {"refr4n": ("4n", "0.00000001"), "refr1n": ("1n", "0.00000001"), "refr16n": ("16n", "0.00000001"), "refr64n": ("64n", "0.00000001"),
         "refr4n_edge1us": ("4n", "0.000001"), "refr4n_edge10us": ("4n", "0.00001")}
def run(name):
    irefr, edge = CASES[name]
    deck = re.sub(r"^\.include source/\S+reset_physical_pd\S*\.spice", ".include %s" % a.src, main, flags=re.M)
    deck = re.sub(r"^IRefrBp RefrBp 0 dc \S+", "IRefrBp RefrBp 0 dc %s" % irefr, deck, flags=re.M)
    deck = re.sub(r"^VresetController pixrst 0 PWL\(0 1.8 0.000 1.8 0.00000001 0", "VresetController pixrst 0 PWL(0 1.8 0.000 1.8 %s 0" % edge, deck, flags=re.M)
    deck = re.sub(r"^write outputs/\S+", "write %s/reset_rise_%s.raw v(vdiffsense) v(onsense) v(noffsense) v(vdsense) v(vsfsense) v(nrstsense) v(pixrst)" % (OUT, name), deck, flags=re.M)
    dp = "%s/main_%s.sp" % (OUT, name); open(dp, "w").write(deck)
    subprocess.run(["ngspice", "-b", "-o", "%s/ngspice_%s.log" % (OUT, name), dp], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    r = subprocess.run(["python3", "analyze_raw.py", "%s/reset_rise_%s.raw" % (OUT, name), "--labels", name], capture_output=True, text=True).stdout
    on = re.search(r"v\(onsense\).*?crossing: (\S+ us \(\S+ us after release\)|none)", r); vd = re.search(r"v\(vdiffsense\) end (\S+) V\s+min (\S+)", r); nr = re.search(r"v\(nrstsense\).*?crossing: (\S+ us \(\S+ us after release\)|none)", r)
    return "%-16s IRefrBp=%-4s edge=%-9s  nRst 90%%: %-32s  vdiff end %s V min %s   ON: %s" % (name, irefr, edge, nr.group(1) if nr else "?", vd.group(1) if vd else "?", vd.group(2) if vd else "?", on.group(1) if on else "?")
with ThreadPoolExecutor(a.jobs) as ex: res = list(ex.map(run, CASES))
open(OUT + "/summary.txt", "w").write("\n".join(res) + "\n"); print("\n".join(res))
