#!/usr/bin/env python3
"""lvs_mismatch_summary.py <lvs.report> : every '**Mismatch**' line of a netgen lvs.report with the circuit pair it belongs to
(the last 'Circuit 1: A | Circuit 2: B' header before it) and the section kind (pin / net count / device count)."""
import sys, re
circ = ("?", "?"); out = []
for n, line in enumerate(open(sys.argv[1], errors="replace"), 1):
    if line.startswith("Circuit 1:"):
        l, _, r = line.partition("|"); circ = (l.replace("Circuit 1:", "").strip(), r.replace("Circuit 2:", "").strip())
    elif "**Mismatch**" in line:
        l, _, r = line.partition("|")
        out.append((n, circ, l.replace("**Mismatch**", "").strip(), r.replace("**Mismatch**", "").strip()))
print("%d Mismatch lines in %s" % (len(out), sys.argv[1]))
last = None
for n, c, l, r in out:
    if c != last: print("\n== %s  |  %s" % c); last = c
    print("  line %-8d layout: %-45s netlist: %s" % (n, l, r))
