"""Structural diff of a flat LVS circuit pair: device inventory + net terminal signatures.
  klayout -b -r lvs_diff.py -rd db=<lvsdb> -rd circuit=<layout circuit name>
"""
import pya
from collections import Counter
lvs = pya.LayoutVsSchematic(); lvs.read(db)
def short(dc):
    return dc.name.lower().replace("sky130_fd_pr__", "").replace("model__", "")
def dev_key(d):
    dc = d.device_class(); names = {p.name for p in dc.parameter_definitions()}
    W = d.parameter("W") if "W" in names else None; L = d.parameter("L") if "L" in names else None
    if W and W > 100: W, L = W / 1e6, L / 1e6      # schematic side may carry nm
    return "%s %s" % (short(dc), ("%g/%g" % (W, L)) if W else "")
def analyse(c):
    devs = Counter(dev_key(d) for d in c.each_device())
    sigs = Counter()
    for n in c.each_net():
        terms = sorted("%s.%s" % (dev_key(t.device()), t.terminal_def().name) for t in n.each_terminal())
        sigs[(n.pin_count() > 0, tuple(terms))] += 1
    return devs, sigs
L = [c for c in lvs.netlist().each_circuit() if c.name == circuit][0]
S = [c for c in lvs.reference.each_circuit() if c.name.lower() == circuit.lower()][0]
dl, sl = analyse(L); ds, ss = analyse(S)
print("== device inventory (layout | schematic)")
for k in sorted(set(dl) | set(ds)):
    flag = "" if dl[k] == ds[k] else "   <-- DIFF"
    print("  %-28s %3d | %3d%s" % (k, dl[k], ds[k], flag))
print("== nets: %d layout, %d schematic; signatures only on one side:" % (sum(sl.values()), sum(ss.values())))
for k in sorted(set(sl) | set(ss), key=str):
    if sl[k] != ss[k]:
        print("  layout x%d | schematic x%d  pin=%s  %s" % (sl[k], ss[k], k[0], "  ".join(k[1]) if k[1] else "(no terminals)"))
