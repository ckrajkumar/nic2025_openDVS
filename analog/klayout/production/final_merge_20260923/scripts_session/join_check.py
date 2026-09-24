# klayout -b -r join_check.py -rd gds=<Rui's wrapper> : exact geometry between the met4 join at x 1263 and the tile's met4 around its end; net of both
import pya
ly = pya.Layout(); ly.read(gds); top = ly.top_cell()
m4 = ly.layer(71,20)
join = pya.Box(1263040,2263715,1264640,2379410)
win = pya.Box(1258000, 2258000, 1270000, 2270000)
it = top.begin_shapes_rec_overlapping(m4, win); pieces = []
while not it.at_end():
    b = it.shape().bbox().transformed(it.trans()); pieces.append((it.cell().name, b)); it.next()
for cn, b in pieces:
    ov = b & join
    print("%-28s %s  overlap with join: %s" % (cn, b.to_s(), ov.to_s() if not ov.empty() else ("touching" if b.touches(join) else "no")))
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
l2n.extract_netlist(); c = l2n.netlist().circuit_by_name(top.name)
for nm, x, y in [("join end", 1263840, 2263800), ("join middle", 1263840, 2320000), ("GndA pad", 1261000, 2262900), ("join bottom 5nm", 1263200, 2263720)]:
    n = l2n.probe_net(reg["met4"], pya.DPoint(x*ly.dbu, y*ly.dbu))
    print(nm, "->", n.expanded_name() if n else None, sorted(set(sp.subcircuit().circuit_ref().name + ":" + (sp.subcircuit().circuit_ref().net_for_pin(sp.pin().id()).expanded_name() if sp.subcircuit().circuit_ref().net_for_pin(sp.pin().id()) else "?") for sp in n.each_subcircuit_pin()))[:4] if n else "")
names = sorted(n.expanded_name() for n in c.each_net() if "vdda1" in n.expanded_name() or "vssa1" in n.expanded_name())
print("nets containing vdda1/vssa1 in their name:", names)
