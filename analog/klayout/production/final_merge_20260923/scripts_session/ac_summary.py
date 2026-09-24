# python3 ac_summary.py <campaign dir>... : ac_gain rows from ngspice ASCII raw files — change-amp gain |vdiff/vsf| peak and its frequency,
# photoreceptor |vsf/vpd0_in| at 1 Hz, per path; medians and per-corner table at 27 C
import sys, glob, json, os, math, statistics as st, collections
def read_raw(p):
    names=[]; vals=[]; cur=None
    with open(p) as f:
        it=iter(f)
        for l in it:
            if l.startswith("Variables:"):
                for l2 in it:
                    if l2.startswith("Values:"): break
                    parts=l2.split(); names.append(parts[1])
                break
        for l in it:
            parts=l.split()
            if not parts: continue
            if len(parts)==2 and parts[0].isdigit():
                cur=[]; vals.append(cur); tok=parts[1]
            else: tok=parts[0]
            re_,im_=tok.split(","); cur.append(complex(float(re_),float(im_)))
    return names, vals
for C in sys.argv[1:]:
    print("=====", os.path.basename(C))
    rows=collections.defaultdict(list)
    for f in glob.glob(C+"/runs/*/*/ac_gain/row-*/attempt-*/result.json"):
        d=json.load(open(f))
        if d.get("scientific_validity")!="valid": continue
        raw=d["raw_output"]
        if not raw.endswith(".raw") or not os.path.exists(raw): continue
        names,vals=read_raw(raw); ix={n:i for i,n in enumerate(names)}
        def find(key):
            for n in names:
                if key in n.lower(): return n
            raise KeyError((key, names))
        ix["v(vdiff_probe)"]=ix[find("vdiff")]; ix["v(vsf_probe)"]=ix[find("vsf")]; ix["v(vpd0_in)"]=ix[find("vpd0")]
        fr=[v[0].real for v in vals]
        g=[abs(v[ix["v(vdiff_probe)"]]/v[ix["v(vsf_probe)"]]) if abs(v[ix["v(vsf_probe)"]])>0 else 0 for v in vals]
        def at(f0): return min(range(len(fr)), key=lambda i:abs(fr[i]-f0))
        k=at(1000.0); g1k=g[k]; g100=g[at(100.0)]
        hi=[i for i in range(k,len(fr)) if g[i] < g1k/math.sqrt(2)]
        f3=fr[hi[0]] if hi else float("inf")
        c=d["condition"]; rows[c["path"]].append((c["corner"],c["temperature_c"],c["vdd_v"],g1k,g100,f3, c["biases_a"]["PrSFBp"], c["optical"]["photocurrent_a"]["vpd[0]"]))
    for path,L in sorted(rows.items()):
        gp=[r[3] for r in L]; fp=[r[5] for r in L]
        print("-- %-20s rows %d  |vdiff/vsf| at 1 kHz: min %.2f median %.2f max %.2f   -3 dB above 1 kHz: median %.3g Hz (min %.3g max %.3g)" % (path,len(L),min(gp),st.median(gp),max(gp),st.median(fp),min(fp),max(fp)))
        for r in sorted(L):
            if r[1]==27 and r[2]==1.8: print("     %-3s %3s C %4.2f V  G@1kHz %6.2f  G@100Hz %6.2f  f-3dB %8.3g Hz  PrSFBp %.0e Iph %.0e" % r)
