#!/usr/bin/env python3
"""2-D map: scale the pixel-0 nRst-vd / nRst-vsf cards AND vary IRefrBp (nRst ramp rate).  Parallel ngspice, sense-only raws.
   cap_scale2.py --src <netlist> --tag <tag> [--jobs 8]   -> outputs/scale2_<tag>/summary.txt"""
import re, subprocess, argparse, os, itertools
from concurrent.futures import ThreadPoolExecutor
ap = argparse.ArgumentParser(); ap.add_argument("--src", required=True); ap.add_argument("--tag", required=True); ap.add_argument("--jobs", type=int, default=8)
ap.add_argument("--scales", default="1,1;0.5,0.5;0.25,0.25;0,0;0,1;1,0"); ap.add_argument("--refr", default="1n,4n,8n,16n,64n"); a = ap.parse_args()
OUT = "outputs/scale2_%s" % a.tag; os.makedirs(OUT, exist_ok=True)
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
print("pixel_0 cards: nRst-vd %.4f fF, nRst-vsf %.4f fF" % (val(ivd), val(ivsf)))
SC = [tuple(float(v) for v in s.split(",")) for s in a.scales.split(";")]; RF = a.refr.split(",")
CASES = {"vd%g_vsf%g_refr%s" % (k[0], k[1], r): (k, r) for k, r in itertools.product(SC, RF)}
main = open("main.sp").read()
def run(name):
    (kvd, kvsf), refr = CASES[name]; lines = list(src)
    for i, k in ((ivd, kvd), (ivsf, kvsf)):
        f = lines[i].split(); f[3] = "%.6gf" % max(val(i) * k, 1e-6); lines[i] = " ".join(f)
    nl = "%s/dut_%s.spice" % (OUT, name); open(nl, "w").write("\n".join(lines) + "\n")
    deck = re.sub(r"^\.include source/\S+reset_physical_pd\S*\.spice", ".include %s" % nl, main, flags=re.M)
    deck = re.sub(r"^IRefrBp RefrBp 0 dc \S+", "IRefrBp RefrBp 0 dc %s" % refr, deck, flags=re.M)
    deck = re.sub(r"^write outputs/\S+", "write %s/reset_rise_%s.raw v(vdiffsense) v(onsense) v(noffsense) v(vdsense) v(vsfsense) v(nrstsense) v(vprsense) v(pixrst)" % (OUT, name), deck, flags=re.M)
    dp = "%s/main_%s.sp" % (OUT, name); open(dp, "w").write(deck)
    subprocess.run(["ngspice", "-b", "-o", "%s/ngspice_%s.log" % (OUT, name), dp], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    r = subprocess.run(["python3", "analyze_raw.py", "%s/reset_rise_%s.raw" % (OUT, name), "--labels", name], capture_output=True, text=True).stdout
    on = re.search(r"v\(onsense\).*?crossing: (?:\S+ us \((\S+) us after release\)|(none))", r); vd = re.search(r"v\(vdiffsense\) end (\S+) V\s+min (\S+)", r)
    os.remove("%s/reset_rise_%s.raw" % (OUT, name)) if os.path.exists("%s/reset_rise_%s.raw" % (OUT, name)) and name.startswith("keepnone") else None
    return "%-26s k_vd=%-4g k_vsf=%-4g IRefrBp=%-4s  vdiff end %s V  min %s   ON after release: %s" % (name, kvd, kvsf, refr, vd.group(1) if vd else "?", vd.group(2) if vd else "?", (on.group(1) or on.group(2)) if on else "?")
with ThreadPoolExecutor(a.jobs) as ex: res = list(ex.map(run, CASES))
open(OUT + "/summary.txt", "w").write("\n".join(res) + "\n"); print("\n".join(res))
