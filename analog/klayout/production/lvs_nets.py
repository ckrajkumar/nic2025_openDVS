"""Dump layout vs schematic nets of one circuit pair with their device terminals.
  klayout -b -r lvs_nets.py -rd db=<lvsdb> -rd circuit=<layout circuit name>
"""
import pya
lvs = pya.LayoutVsSchematic(); lvs.read(db)
def dump(c, label):
    print("==", label, c.name, "| pins:", ", ".join(p.name() or "?" for p in c.each_pin()))
    for n in c.each_net():
        terms = []
        for t in n.each_terminal():
            d = t.device(); dc = d.device_class()
            W = d.parameter("W") if any(p.name == "W" for p in dc.parameter_definitions()) else None
            L = d.parameter("L") if any(p.name == "L" for p in dc.parameter_definitions()) else None
            short = dc.name.replace("sky130_fd_pr__", "").replace("model__", "")
            terms.append("%s.%s%s" % (short, t.terminal_def().name, "(%g/%g)" % (W, L) if W else ""))
        print("  %-22s pin=%d  %s" % (n.expanded_name(), n.pin_count(), "  ".join(sorted(terms))))
for c in lvs.netlist().each_circuit():
    if c.name == circuit: dump(c, "LAYOUT")
for c in lvs.reference.each_circuit():
    if c.name.lower() == circuit.lower(): dump(c, "SCHEMATIC")
