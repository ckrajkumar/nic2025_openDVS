"""Print the non-matching part of a KLayout LVS database.
  klayout -b -r lvs_report.py -rd db=<file.lvsdb>
"""
import pya

lvs = pya.LayoutVsSchematic()
lvs.read(db)
xref = lvs.xref()
ST = {pya.NetlistCrossReference.Match: "Match", pya.NetlistCrossReference.NoMatch: "NoMatch",
      pya.NetlistCrossReference.Mismatch: "Mismatch", pya.NetlistCrossReference.MatchWithWarning: "MatchWithWarning",
      pya.NetlistCrossReference.Skipped: "Skipped", pya.NetlistCrossReference.None_: "None"} if hasattr(pya.NetlistCrossReference, "None_") else {}
def st(s):
    return ST.get(s, str(s))
def nm(o, f="name"):
    if o is None: return "-"
    try: return o.expanded_name()
    except Exception: return getattr(o, f)
pairs = list(xref.each_circuit_pair())
for cp in pairs:
    a, b = cp.first(), cp.second()
    print("CIRCUIT layout=%s schematic=%s : %s" % (a.name if a else "-", b.name if b else "-", st(cp.status())))
print("---- details")
for cp in pairs:
    a, b = cp.first(), cp.second()
    print("CIRCUIT layout=%s schematic=%s : %s" % (a.name if a else "-", b.name if b else "-", st(cp.status())))
    if cp.status() == pya.NetlistCrossReference.Match:
        continue
    for label, it in (("pin", xref.each_pin_pair(cp)), ("net", xref.each_net_pair(cp)),
                      ("device", xref.each_device_pair(cp)), ("subckt", xref.each_subcircuit_pair(cp))):
        bad = [(p.first(), p.second(), p.status()) for p in it if p.status() != pya.NetlistCrossReference.Match]
        for f, s, s2 in bad:
            extra = ""
            if label == "device":
                def dsc(d):
                    if d is None: return "-"
                    return "%s(%s) %s" % (d.expanded_name(), d.device_class().name, " ".join("%s=%s" % (pd.name, d.parameter(pd.id())) for pd in d.device_class().parameter_definitions() if pd.name in ("W", "L")))
                extra = "  %s | %s" % (dsc(f), dsc(s))
            elif label == "net":
                def ndc(n):
                    if n is None: return "-"
                    return "%s [%d pins,%d term,%d subc]" % (n.expanded_name(), n.pin_count(), n.terminal_count(), n.subcircuit_pin_count())
                extra = "  %s | %s" % (ndc(f), ndc(s))
            else:
                extra = "  %s | %s" % (nm(f), nm(s))
            print("   %-7s %-16s%s" % (label, st(s2), extra))
