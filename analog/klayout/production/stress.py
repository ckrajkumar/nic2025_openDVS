#!/usr/bin/env python3
"""64-pixel row/column stress bench on the 2x2 RCC netlist (Rui 2026-09-22 20:20).
   The 2x2 sits at the FAR end of a 64-pixel GndD row line (RC ladder to the periphery ground) and of 64-pixel readLine columns
   (RC ladders to the periphery driver).  Scenario 'bounce': at t=tagg every other pixel of the row (npix-2) pulls its readLine
   down through GndD at once (current pulses injected along the ladder).  'bounce_reset': the same while row 0 is being reset
   (pixRst[0]+rowReadON[0] pulse at tagg, as the read of that row would do).
   stress.py --src <netlist> --tag <t> --scenario bounce|bounce_reset [--npix 64 --nseg 16 --gndd-rpix 2.2 --gndd-cpix 3f
            --col-rpix 0.11 --col-cpix 3.5f --ipk 60u --tpulse 7n --sets "IPrSFBp=1n;IPrSFBp=100p"]"""
import re, os, subprocess, argparse
from concurrent.futures import ThreadPoolExecutor
ap = argparse.ArgumentParser(); ap.add_argument("--src", required=True); ap.add_argument("--tag", required=True)
ap.add_argument("--scenario", default="bounce", choices=("bounce", "bounce_reset")); ap.add_argument("--sets", default="IPrSFBp=1n;IPrSFBp=100p")
ap.add_argument("--npix", type=int, default=64); ap.add_argument("--nseg", type=int, default=16)
ap.add_argument("--gndd-rpix", default="2.2"); ap.add_argument("--gndd-cpix", default="3f"); ap.add_argument("--col-rpix", default="0.11"); ap.add_argument("--col-cpix", default="3.5f")
ap.add_argument("--ipk", default="60u"); ap.add_argument("--tpulse", default="7n"); ap.add_argument("--tagg", default="1.0m"); ap.add_argument("--tend", default="1.3m"); ap.add_argument("--step", default="50n"); ap.add_argument("--jobs", type=int, default=2)
a = ap.parse_args(); OUT = "outputs/stress"; os.makedirs(OUT, exist_ok=True)
main = open("main.sp").read()
def tval(s):
    m = {"m": 1e-3, "u": 1e-6, "n": 1e-9, "p": 1e-12, "f": 1e-15}; return float(s[:-1]) * m[s[-1]] if s[-1] in m else float(s)
TA, TE, TP = tval(a.tagg), tval(a.tend), tval(a.tpulse); per = a.npix / a.nseg
P = "v(xpix2x2.xdiffbn_physical_core.opendvs_pixel_%d.%s)"
save = " ".join(["v(pixrst)", "v(rowon0)", "v(gnddf)", "v(gd%d)" % (a.nseg // 2), "v(rl0)"] + [P % (p, n) for p in range(4) for n in ("vdiff", "vsf", "vd", "on", "noff", "nrst")])
def run(i):
    st = dict(kv.split("=") for kv in a.sets.split(";")[i].split(","))
    name = "%s_%s" % (a.scenario, "_".join("%s%s" % (k.replace("I", "", 1), v) for k, v in st.items()))
    deck = re.sub(r"^\.include source/\S+reset_physical_pd\S*\.spice", ".include %s" % a.src, main, flags=re.M)
    for k, v in st.items():
        deck, n = re.subn(r"^(%s\s+\S+\s+\S+\s+dc\s+)\S+" % k, r"\g<1>%s" % v, deck, flags=re.M); assert n == 1, k
    quiet = "PWL(0 1.8 10n 1.8 20n 0 %g 0)" % TE
    agg = "PWL(0 1.8 10n 1.8 20n 0 %g 0 %g 1.8 %g 1.8 %g 0 %g 0)" % (TA, TA + 10e-9, TA + 1e-6, TA + 1e-6 + 10e-9, TE)   # 1 us read/reset pulse at tagg
    pr0 = agg if a.scenario == "bounce_reset" else quiet; ro0 = agg if a.scenario == "bounce_reset" else quiet
    lines = ["* --- stress bench: %d-pixel GndD row ladder (%d segments) + readLine column ladders, 2x2 at the far end" % (a.npix, a.nseg),
             "Vpixrst0 pixrst 0 %s" % pr0, "Vpixrst1 pixrst1 0 %s" % quiet, "Vrowon0 rowon0 0 %s" % ro0, "Vrowon1 rowon1 0 %s" % quiet,
             "Vrowoff0 rowoff0 0 dc 0", "Vrowoff1 rowoff1 0 dc 0", "Vrl0p rl0p 0 dc 0", "Vrl1p rl1p 0 dc 0"]
    rs = per * float(a.gndd_rpix); cs = per * tval(a.gndd_cpix); rc = per * float(a.col_rpix); cc = per * tval(a.col_cpix)
    ip = tval(a.ipk) * per   # every segment's other pixels pull down at once (the 2x2's two row-0 pixels are real and excluded from the last segment)
    for k in range(1, a.nseg + 1):
        prev = "0" if k == 1 else "gd%d" % (k - 1); node = "gnddf" if k == a.nseg else "gd%d" % k
        lines.append("Rg%d %s %s %.4g" % (k, prev, node, rs)); lines.append("Cg%d %s 0 %.4g" % (k, node, cs))
        ipk = ip * ((per - 2) / per if k == a.nseg else 1.0)
        lines.append("Ig%d 0 %s PWL(0 0 %.12g 0 %.12g %.4g %.12g %.4g %.12g 0)" % (k, node, TA, TA + 1e-9, ipk, TA + TP, ipk, TA + TP + 1e-9))
        for c in (0, 1):
            prevc = "rl%dp" % c if k == 1 else "rc%d_%d" % (c, k - 1); nodec = "rl%d" % c if k == a.nseg else "rc%d_%d" % (c, k)
            lines.append("Rc%d_%d %s %s %.4g" % (c, k, prevc, nodec, rc)); lines.append("Cc%d_%d %s 0 %.4g" % (c, k, nodec, cc))
    deck, n = re.subn(r"^VresetController .*$", "\n".join(lines), deck, flags=re.M); assert n == 1
    deck, n = re.subn(r"^xpix2x2 0 pixrst 0 pixrst 0 0 0 0 (.*) VddA18 0 0 ", r"xpix2x2 pixrst1 pixrst rowon1 rowon0 rowoff1 rowoff0 rl1 rl0 \1 VddA18 0 gnddf ", deck, flags=re.M); assert n == 1
    deck = re.sub(r"^\.save all\s*$", "", deck, flags=re.M)
    deck, n = re.subn(r"^\.save .*$", ".save " + save, deck, flags=re.M); assert n == 1
    deck, n = re.subn(r"^\.tran .*$", ".tran %s %s 0 %s" % (a.step, a.tend, a.step), deck, flags=re.M); assert n == 1
    deck, n = re.subn(r"^write outputs/\S+.*$", "write %s/stress_%s_%s.raw" % (OUT, a.tag, name), deck, flags=re.M); assert n == 1
    dp = "%s/stress_%s_%s.sp" % (OUT, a.tag, name); open(dp, "w").write(deck)
    subprocess.run(["ngspice", "-b", "-o", "%s/ngspice_%s_%s.log" % (OUT, a.tag, name), dp], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return "%s/stress_%s_%s.raw" % (OUT, a.tag, name)
with ThreadPoolExecutor(a.jobs) as ex: print("\n".join(ex.map(run, range(len(a.sets.split(";"))))))
