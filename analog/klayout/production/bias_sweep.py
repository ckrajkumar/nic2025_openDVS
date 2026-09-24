#!/usr/bin/env python3
"""Bias sweep on Rui's reset TB, DUT netlist unchanged.  bias_sweep.py --src <netlist> --tag <tag> --sets "IRefrBp=4n,IPrSFBp=300p;IRefrBp=4n,IPrSFBp=1n;..."
   Each set is a comma list of <source name>=<value>; sources are the top-level I*/V* dc sources of main.sp.  -> outputs/bias_<tag>/summary.txt"""
import re, subprocess, argparse, os
from concurrent.futures import ThreadPoolExecutor
ap = argparse.ArgumentParser(); ap.add_argument("--src", required=True); ap.add_argument("--tag", required=True); ap.add_argument("--sets", required=True); ap.add_argument("--jobs", type=int, default=8); a = ap.parse_args()
OUT = "outputs/bias_%s" % a.tag; os.makedirs(OUT, exist_ok=True)
main = open("main.sp").read()
SETS = [dict(kv.split("=") for kv in s.split(",")) for s in a.sets.split(";")]
def run(i):
    st = SETS[i]; name = "_".join("%s%s" % (k.replace("I", "", 1), v) for k, v in st.items())
    deck = re.sub(r"^\.include source/\S+reset_physical_pd\S*\.spice", ".include %s" % a.src, main, flags=re.M)
    for k, v in st.items():
        deck, n = re.subn(r"^(%s\s+\S+\s+\S+\s+dc\s+)\S+" % k, r"\g<1>%s" % v, deck, flags=re.M)
        if n != 1: raise SystemExit("source %s not found once (%d)" % (k, n))
    deck = re.sub(r"^write outputs/\S+", "write %s/reset_rise_%s.raw v(vdiffsense) v(onsense) v(noffsense) v(vdsense) v(vsfsense) v(nrstsense) v(vprsense) v(pixrst)" % (OUT, name), deck, flags=re.M)
    dp = "%s/main_%s.sp" % (OUT, name); open(dp, "w").write(deck)
    subprocess.run(["ngspice", "-b", "-o", "%s/ngspice_%s.log" % (OUT, name), dp], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    r = subprocess.run(["python3", "analyze_raw.py", "%s/reset_rise_%s.raw" % (OUT, name), "--labels", name], capture_output=True, text=True).stdout
    on = re.search(r"v\(onsense\).*?crossing: (?:\S+ us \((\S+) us after release\)|(none))", r); vd = re.search(r"v\(vdiffsense\) end (\S+) V\s+min (\S+)", r)
    vs = re.search(r"v\(vsfsense\) end (\S+) V\s+min (\S+)\s+max (\S+)", r); nr = re.search(r"v\(nrstsense\).*?crossing: (?:\S+ us \((\S+) us after release\)|(none))", r)
    return "%-34s nRst90%% %s us  vdiff end %s min %s  vsf end %s min %s max %s   ON: %s" % (name, (nr.group(1) or nr.group(2)) if nr else "?", vd.group(1) if vd else "?", vd.group(2) if vd else "?", vs.group(1) if vs else "?", vs.group(2) if vs else "?", vs.group(3) if vs else "?", (on.group(1) or on.group(2)) if on else "?")
with ThreadPoolExecutor(a.jobs) as ex: res = list(ex.map(run, range(len(SETS))))
open(OUT + "/summary.txt", "w").write("\n".join(res) + "\n"); print("\n".join(res))
