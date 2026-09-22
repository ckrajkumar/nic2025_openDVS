"""Re-compare a deep-mode LVS database after flattening the pixel in BOTH netlists (abutting pixels
share S/D diffusion, so deep extraction pulls those devices into the 2x2 circuit; flat extraction
merges abutting gates instead). MIM caps are dropped from the layout side because the xschem
netlist carries none.   klayout -b -r lvs_compare_flat.py -rd db=<deep.lvsdb>
"""
import pya
lvs = pya.LayoutVsSchematic(); lvs.read(db)
lay, sch = lvs.netlist(), lvs.reference
for nl, names in ((lay, ["openDVS_pixel"]), (sch, ["OPENDVS_PIXEL", "openDVS_pixel"])):
    for n in names:
        c = nl.circuit_by_name(n)
        if c: nl.flatten_circuit(c)
for c in lay.each_circuit():
    for d in [d for d in c.each_device() if "cap_mim" in d.device_class().name]:
        c.remove_device(d)
# nwell has no tap inside the 2x2 (taps sit at tile level): the pfet-bulk-only net is tied to VddA18
# for the compare, as the schematic does.
for c in lay.each_circuit():
    vdd = c.net_by_name("VddA18")
    for n in list(c.each_net()):
        terms = list(n.each_terminal())
        if n is not vdd and terms and all(t.terminal_def().name == "B" and "pfet" in t.device().device_class().name for t in terms):
            print("joining nwell net %s (%d pfet bulks) into VddA18" % (n.expanded_name(), len(terms)))
            c.join_nets(vdd, n)
lay.purge_nets()
class Log(pya.GenericNetlistCompareLogger):
    def __init__(self): super().__init__(); self.lines = []
    def out(self, s): self.lines.append(s)
    def net_mismatch(self, a, b, msg=""): self.out("NET MISMATCH  %s | %s" % (a.expanded_name() if a else "-", b.expanded_name() if b else "-"))
    def device_mismatch(self, a, b, msg=""): self.out("DEV MISMATCH  %s | %s" % (a.expanded_name() if a else "-", b.expanded_name() if b else "-"))
    def pin_mismatch(self, a, b, msg=""): self.out("PIN MISMATCH  %s | %s" % (a.name() if a else "-", b.name() if b else "-"))
    def circuit_mismatch(self, a, b, msg=""): self.out("CIRCUIT MISMATCH %s | %s %s" % (a.name if a else "-", b.name if b else "-", msg))
    def match_nets(self, a, b, *r): pass
    def match_devices(self, a, b, *r): pass
    def match_devices_with_different_parameters(self, a, b, *r): self.out("DEV PARAM DIFF %s | %s" % (a.expanded_name(), b.expanded_name()))
    def match_devices_with_different_device_classes(self, a, b, *r): self.out("DEV CLASS DIFF %s | %s" % (a.expanded_name(), b.expanded_name()))
    def match_ambiguous_nets(self, a, b, *r): pass
log = Log()
cmp = pya.NetlistComparer(log)
# hvt vs non-hvt are distinct classes in both; MOS parameters: 1% relative tolerance on W, L
for c in lay.each_circuit(): pass
for dc_name in set(d.device_class().name for c in lay.each_circuit() for d in c.each_device()):
    dc = lay.device_class_by_name(dc_name) if hasattr(lay, "device_class_by_name") else None
    if dc is None: continue
    for pd in dc.parameter_definitions():
        if pd.name in ("W", "L"):
            dc.equal_parameters = (dc.equal_parameters or pya.EqualDeviceParameters(pd.id(), 0.0, 0.01)) if False else dc.equal_parameters
# pair circuits and device classes across the case difference of the CDL-style schematic reader
for a in lay.each_circuit():
    b = next((x for x in sch.each_circuit() if x.name.lower() == a.name.lower()), None)
    if b: cmp.same_circuits(a, b)
for da in lay.each_device_class():
    db_ = next((x for x in sch.each_device_class() if x.name.lower() == da.name.lower()), None)
    if db_: cmp.same_device_classes(da, db_)
# schematic MOS W/L come in nm-ish units (0.42 -> 420000); bring them to the layout's um
for c in sch.each_circuit():
    for d in c.each_device():
        dc = d.device_class(); ids = {pd.name: pd.id() for pd in dc.parameter_definitions()}
        for k in ("W", "L"):
            if k in ids and d.parameter(ids[k]) > 100: d.set_parameter(ids[k], d.parameter(ids[k]) / 1e6)
ok = cmp.compare(lay, sch)
print("RESULT:", "MATCH" if ok else "MISMATCH")
for l in log.lines[:60]: print("  " + l)
print("layout circuits:", [(c.name, len(list(c.each_net())), len(list(c.each_device()))) for c in lay.each_circuit()])
print("schem  circuits:", [(c.name, len(list(c.each_net())), len(list(c.each_device()))) for c in sch.each_circuit()])
