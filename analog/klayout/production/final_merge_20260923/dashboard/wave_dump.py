#!/usr/bin/env python3
"""wave_dump.py <raw> [<raw>...] : decimated reset-TB waveforms (t in us, vdiff/vsf/vpr/vd/on/nrst in V) as JSON on stdout"""
import sys, os, json
os.chdir(os.path.expanduser("~/opendvs-sims/opendvs_reset_rise_20260921")); sys.path.insert(0, ".")
import numpy as np, analyze_raw as A
out = {}
for p in sys.argv[1:]:
    d = A.read(p); t = d["time"] * 1e6
    # keep ~600 points: dense in the first 20 us, coarser after
    idx = np.unique(np.concatenate([np.searchsorted(t, np.linspace(0, 20, 300)), np.searchsorted(t, np.linspace(20, t[-1], 300))]))
    idx = idx[idx < len(t)]
    rec = {"t_us": [round(float(x), 4) for x in t[idx]]}
    for k, n in (("vdiff", "v(vdiffsense)"), ("vsf", "v(vsfsense)"), ("vpr", "v(vprsense)"), ("vd", "v(vdsense)"), ("on", "v(onsense)"), ("nrst", "v(nrstsense)"), ("pixrst", "v(pixrst)")):
        if n in d: rec[k] = [round(float(x), 5) for x in d[n][idx]]
    out[os.path.basename(p)] = rec
json.dump(out, sys.stdout)
