# klayout -b -r column_feed.py -rd gds=<tile gds> : how the VddA18 columns and the GndA plane are fed from the rings: the vdda1/vssa1 net shapes
# in the bottom periphery band (tile y -75..50 um), per layer, widths; and the via counts there
import pya, collections
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
l2n.extract_netlist(); c = l2n.netlist().circuit_by_name(top.name)
band = pya.Region(pya.Box(-80000, -75000, 1620000, 50000))      # bottom periphery incl. the rings
colwin = pya.Region(pya.Box(40000, -75000, 90000, 60000))       # one 2x2 column at the bottom
for n in c.each_net():
    nm = n.expanded_name()
    if nm not in ("vdda1","vssa1","vssc1"): continue
    print("== net", nm)
    for k in ["li","met1","met2","met3","met4","met5"]:
        r = l2n.shapes_of_net(n, reg[k], True) & band
        if not r.count(): continue
        ws = sorted(set(round(min(p.bbox().width(), p.bbox().height())/1e3, 2) for p in r.each()))
        print("   %-5s %6d shapes area %8.1f um2 in the bottom band; min-side widths %s" % (k, r.count(), r.area()/1e6, ws[:6]))
    for k in ["mcon","via1","via2","via3","via4"]:
        r = l2n.shapes_of_net(n, reg[k], True) & band
        if r.count(): print("   %-5s %6d in the bottom band" % (k, r.count()))
    print("   -- inside one column window x 40-90 um, y -75..60 um:")
    for k in ["li","met1","met2","met3","met4","met5","via1","via2","via3","via4"]:
        r = l2n.shapes_of_net(n, reg[k], True) & colwin
        if r.count(): print("      %-5s %4d shapes area %7.1f um2  bboxes %s" % (k, r.count(), r.area()/1e6, [p.bbox().to_s() for p in list(r.each())[:3]]))
