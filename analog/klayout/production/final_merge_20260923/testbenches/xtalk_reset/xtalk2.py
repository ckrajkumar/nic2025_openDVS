#!/usr/bin/env python3
"""Crosstalk TB v2 (pulse train, read lines start LOW so no edge coincides with the release): reset all four pixels at t=0 (settle), then at T_AGG re-reset pixel (pixRst[0]&rowReadON[0]) only.
   Column neighbour (shares pixRst[0]) gets the pixRst kick, row neighbour (shares rowReadON[0]) the rowReadON kick,
   the diagonal is the control.  xtalk.py --src <netlist> --tag <tag> [--sets "IPrSFBp=1n;IPrSFBp=100p"] [--tagg 1.0m] [--tend 1.5m]"""
import re, subprocess, argparse, os
from concurrent.futures import ThreadPoolExecutor
ap = argparse.ArgumentParser(); ap.add_argument("--src", required=True); ap.add_argument("--tag", required=True)
ap.add_argument("--sets", default="IPrSFBp=1n;IPrSFBp=100p"); ap.add_argument("--tagg", default="1.0m"); ap.add_argument("--tend", default="1.5m"); ap.add_argument("--step", default="50n")
ap.add_argument("--jobs", type=int, default=2); ap.add_argument("--tedge", default="20n"); ap.add_argument("--npulse", type=int, default=3); ap.add_argument("--pitch", default="50u"); ap.add_argument("--width", default="1u"); ap.add_argument("--agg", default="reset", choices=("reset", "rowoff", "readline", "pixrst_only", "rowon_only")); a = ap.parse_args()
OUT = "outputs/xtalk"; os.makedirs(OUT, exist_ok=True)
main = open("main.sp").read()
def tval(s):  # '1.0m' -> float seconds
    m = {"m": 1e-3, "u": 1e-6, "n": 1e-9}; return float(s[:-1]) * m[s[-1]] if s[-1] in m else float(s)
TA, TE = tval(a.tagg), tval(a.tend)
P = "v(xpix2x2.xdiffbn_physical_core.opendvs_pixel_%d.%s)"
save = " ".join(["v(pixrst)", "v(rowon0)", "v(rowoff0)", "v(readline0)"] + [P % (p, n) for p in range(4) for n in ("vdiff", "vsf", "vd", "on", "noff", "nrst")])
def run(i):
    st = dict(kv.split("=") for kv in a.sets.split(";")[i].split(","))
    name = "_".join("%s%s" % (k.replace("I", "", 1), v) for k, v in st.items())
    deck = re.sub(r"^\.include source/\S+reset_physical_pd\S*\.spice", ".include %s" % a.src, main, flags=re.M)
    for k, v in st.items():
        deck, n = re.subn(r"^(%s\s+\S+\s+\S+\s+dc\s+)\S+" % k, r"\g<1>%s" % v, deck, flags=re.M); assert n == 1, k
    TG = tval(a.tedge); PI, PW = tval(a.pitch), tval(a.width)
    def train(start_high):
        pts = [(0, 1.8), (TG - 10e-9, 1.8), (TG, 0)] if start_high else [(0, 0)]
        for k in range(a.npulse):
            t0 = TA + k * PI; pts += [(t0, 0), (t0 + 10e-9, 1.8), (t0 + PW, 1.8), (t0 + PW + 10e-9, 0)]
        pts.append((TE, 0)); return "PWL(" + " ".join("%g %g" % q for q in pts) + ")"
    agg = train(True); agg_low = train(False)   # reset-type lines start high (they release the pixel at tedge); read lines start low
    quiet = "PWL(0 1.8 10n 1.8 20n 0 %g 0)" % TE      # initial reset of every pixel (pixRst[1], rowReadON[1])
    zero = "dc 0"                                       # rowReadOFF[0] / readLine[0] stay low unless they are the aggressor
    A = {"reset": ("agg", "agg", "zero", "zero"), "pixrst_only": ("agg", "quiet", "zero", "zero"), "rowon_only": ("quiet", "agg", "zero", "zero"),
         "rowoff": ("quiet", "quiet", "agg", "zero"), "readline": ("quiet", "quiet", "zero", "agg")}[a.agg]   # pixrst0, rowon0, rowoff0, readline0
    W = {"agg": agg, "quiet": quiet, "zero": zero, "agg_low": agg_low}
    if a.agg in ("rowoff", "readline"): A = tuple("agg_low" if v == "agg" else v for v in A)
    src_lines = "Vpixrst0 pixrst 0 %s\nVpixrst1 pixrst1 0 %s\nVrowon0 rowon0 0 %s\nVrowon1 rowon1 0 %s\nVrowoff0 rowoff0 0 %s\nVreadline0 readline0 0 %s" % (W[A[0]], quiet, W[A[1]], quiet, W[A[2]], W[A[3]])
    deck, n = re.subn(r"^VresetController .*$", src_lines, deck, flags=re.M); assert n == 1
    deck, n = re.subn(r"^xpix2x2 0 pixrst 0 pixrst 0 0 0 0 ", "xpix2x2 pixrst1 pixrst rowon1 rowon0 0 rowoff0 0 readline0 ", deck, flags=re.M); assert n == 1
    deck = re.sub(r"^\.save all\s*$", "", deck, flags=re.M)
    deck, n = re.subn(r"^\.save .*$", ".save " + save, deck, flags=re.M); assert n == 1
    deck, n = re.subn(r"^\.tran .*$", ".tran %s %s 0 %s" % (a.step, a.tend, a.step), deck, flags=re.M); assert n == 1
    deck, n = re.subn(r"^write outputs/\S+.*$", "write %s/xtalk_%s_%s.raw" % (OUT, a.tag, name), deck, flags=re.M); assert n == 1
    dp = "%s/xtalk_%s_%s.sp" % (OUT, a.tag, name); open(dp, "w").write(deck)
    subprocess.run(["ngspice", "-b", "-o", "%s/ngspice_%s_%s.log" % (OUT, a.tag, name), dp], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return "%s/xtalk_%s_%s.raw" % (OUT, a.tag, name)
with ThreadPoolExecutor(a.jobs) as ex: print("\n".join(ex.map(run, range(len(a.sets.split(";"))))))
