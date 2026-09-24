# klayout -b -r power_trace.py -rd gds=tile.gds -rd top=pixel_4tile
# Metal-only connectivity extraction of the tile; the power nets are found by probing at the top-level power labels.
import pya, re, time
t0=time.time()
ly = pya.Layout(); ly.read(gds); top = ly.cell(top)
L = {"li":(67,20),"mcon":(67,44),"met1":(68,20),"via1":(68,44),"met2":(69,20),"via2":(69,44),"met3":(70,20),"via3":(70,44),"met4":(71,20),"via4":(71,44),"met5":(72,20)}
T = {"li":(67,5),"met1":(68,5),"met2":(69,5),"met3":(70,5),"met4":(71,5),"met5":(72,5)}
pw = re.compile(r"vdd|vss|gnd", re.I)
labels = []
for k,(a,b) in T.items():
    li = ly.find_layer(a,b)
    if li is None: continue
    for s in top.shapes(li).each():
        if s.is_text() and pw.search(s.text_string): labels.append((s.text_string, k, s.text_trans.disp))
print("power labels on the top cell:", len(labels))
l2n = pya.LayoutToNetlist(pya.RecursiveShapeIterator(ly, top, []))
reg = {}
for k,(a,b) in L.items():
    li = ly.find_layer(a,b)
    reg[k] = l2n.make_layer(li, k) if li is not None else l2n.make_layer(k)
for k in ["li","met1","met2","met3","met4","met5"]: l2n.connect(reg[k])
for a,v,b in [("li","mcon","met1"),("met1","via1","met2"),("met2","via2","met3"),("met3","via3","met4"),("met4","via4","met5")]:
    l2n.connect(reg[a],reg[v]); l2n.connect(reg[v],reg[b])
l2n.extract_netlist()
nl = l2n.netlist(); c = nl.circuit_by_name(top.name)
print("extracted in %.0f s: nets in top circuit %d" % (time.time()-t0, sum(1 for _ in c.each_net())))
bynet = {}
for name, k, p in labels:
    n = l2n.probe_net(reg[k], pya.DPoint(p.x*ly.dbu, p.y*ly.dbu))
    key = (n.cluster_id if n else None)
    bynet.setdefault(key, {"names": set(), "net": n, "labels": 0})
    bynet[key]["names"].add(name); bynet[key]["labels"] += 1
for key, d in bynet.items():
    n = d["net"]
    print("== cluster", key, "labels", d["labels"], "names", sorted(d["names"]), "net", n.expanded_name() if n else None, "subcircuit pins", n.subcircuit_pin_count() if n else None)
    if not n: continue
    for k in ["li","met1","met2","met3","met4","met5"]:
        r = l2n.shapes_of_net(n, reg[k], True)
        if r.count(): print("   %-5s %7d shapes  area %10.1f um2  bbox %s" % (k, r.count(), r.area()/1e6, r.bbox().to_s()))
    # top-level-only shapes of the net (what the tile itself draws, not the pixels)
    for k in ["met2","met3","met4","met5"]:
        r = l2n.shapes_of_net(n, reg[k], False)
        if r.count(): print("   top-level %-5s %5d shapes  area %9.1f um2  bbox %s" % (k, r.count(), r.area()/1e6, r.bbox().to_s()))
