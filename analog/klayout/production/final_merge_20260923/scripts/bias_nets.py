# klayout -b -r bias_nets.py -rd gds=<wrapper> : the wrapper nets on the tile's dac_config_* pins — layers, lengths, widths, vias, attached cells
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
l2n.extract_netlist(); nl = l2n.netlist(); c = nl.circuit_by_name(top.name)
tile = nl.circuit_by_name("pixel_4tile")
for sc in c.each_subcircuit():
    if sc.circuit_ref().name != "pixel_4tile": continue
    for pin in tile.each_pin():
        inner = tile.net_for_pin(pin.id()); nm = inner.expanded_name() if inner else ""
        if not nm.startswith("dac_config"): continue
        outer = sc.net_for_pin(pin.id())
        if outer is None: print(nm, "<unconnected>"); continue
        cells = collections.Counter()
        for sp in outer.each_subcircuit_pin():
            cr = sp.subcircuit().circuit_ref(); inner2 = cr.net_for_pin(sp.pin().id()); cells[cr.name + ":" + (inner2.expanded_name() if inner2 else "?")] += 1
        parts = []
        for k in ["li","met1","met2","met3","met4"]:
            r = l2n.shapes_of_net(outer, reg[k], False); r.merge()
            if not r.count(): continue
            # length estimate: sum over pieces of the longer side; min width = smaller side
            length = sum(max(p.bbox().width(), p.bbox().height()) for p in r.each())/1e3
            wmin = min(min(p.bbox().width(), p.bbox().height()) for p in r.each())/1e3
            parts.append("%s %d pcs %.0f um (min w %.2f)" % (k, r.count(), length, wmin))
        vias = {k: l2n.shapes_of_net(outer, reg[k], False).count() for k in ["mcon","via1","via2","via3","via4"]}
        print("== tile pin %-13s wrapper net %-28s attached: %s" % (nm, outer.expanded_name()[:28], dict(cells)))
        print("     ", "; ".join(parts))
        print("      vias:", {k: v for k, v in vias.items() if v})
