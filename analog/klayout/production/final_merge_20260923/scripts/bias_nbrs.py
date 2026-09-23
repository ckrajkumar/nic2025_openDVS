# klayout -b -r bias_nbrs.py -rd gds=<wrapper> : for each bias net, the top-level wires of other nets running within 0.35 um on the same layer,
# their parallel length and their net class (clock / digital signal / supply / analog)
import pya, re, collections
ly = pya.Layout(); ly.read(gds); top = ly.top_cell()
L = {"li":(67,20),"mcon":(67,44),"met1":(68,20),"via1":(68,44),"met2":(69,20),"via2":(69,44),"met3":(70,20),"via3":(70,44),"met4":(71,20),"via4":(71,44),"met5":(72,20)}
Tx = {"li":(67,5),"met1":(68,5),"met2":(69,5),"met3":(70,5),"met4":(71,5),"met5":(72,5)}
l2n = pya.LayoutToNetlist(pya.RecursiveShapeIterator(ly, top, [])); reg = {}
for k,(a,b) in L.items():
    li = ly.find_layer(a,b); reg[k] = l2n.make_layer(li, k) if li is not None else l2n.make_layer(k)
for k,(a,b) in Tx.items():
    li = ly.find_layer(a,b)
    if li is not None: l2n.connect(reg[k], l2n.make_text_layer(li, k+"_lbl"))
for k in ["li","met1","met2","met3","met4","met5"]: l2n.connect(reg[k])
for a,v,b in [("li","mcon","met1"),("met1","via1","met2"),("met2","via2","met3"),("met3","via3","met4"),("met4","via4","met5")]:
    l2n.connect(reg[a],reg[v]); l2n.connect(reg[v],reg[b])
l2n.extract_netlist(); nl = l2n.netlist(); c = nl.circuit_by_name(top.name); tile = nl.circuit_by_name("pixel_4tile")
topl = {k: pya.Region(top.shapes(ly.layer(*L[k]))) for k in ["met1","met2","met3","met4"]}
def cls(net):
    if net is None: return "?"
    nm = net.expanded_name()
    pins = [sp.subcircuit().circuit_ref().name + ":" + (sp.subcircuit().circuit_ref().net_for_pin(sp.pin().id()).expanded_name() if sp.subcircuit().circuit_ref().net_for_pin(sp.pin().id()) else "") for sp in list(net.each_subcircuit_pin())[:6]]
    s = " ".join(pins) + " " + nm
    if re.search(r"vssd|vccd|vdda|vssa|VGND|VPWR|VPB|VNB", s): return "supply"
    if re.search(r"clk|CLK", s): return "clock"
    if re.search(r"dac_config|Bias\[", s): return "bias"
    if re.search(r"pixel_4tile:|BiasBranch|photodiode|pixel_test", s): return "analog-macro-pin"
    return "digital"
for sc in c.each_subcircuit():
    if sc.circuit_ref().name != "pixel_4tile": continue
    for pin in tile.each_pin():
        inner = tile.net_for_pin(pin.id()); nm = inner.expanded_name() if inner else ""
        if not nm.startswith("dac_config"): continue
        outer = sc.net_for_pin(pin.id())
        tot = collections.Counter(); examples = collections.defaultdict(set)
        for k in ["met1","met2","met3","met4"]:
            own = l2n.shapes_of_net(outer, reg[k], False)
            if not own.count(): continue
            nbr = (topl[k] & own.sized(350)) - own
            for p in nbr.each():
                b = p.bbox(); n = l2n.probe_net(reg[k], pya.DPoint(b.center().x*ly.dbu, b.center().y*ly.dbu))
                kind = cls(n); tot[(k, kind)] += max(b.width(), b.height())/1e3
                if n and len(examples[kind]) < 3: examples[kind].add(n.expanded_name()[:30])
        print("== %s: parallel neighbour length (um) by layer/class: %s" % (nm, {("%s/%s" % k): round(v) for k, v in sorted(tot.items())}))
        print("      examples:", {k: sorted(v) for k, v in examples.items()})
