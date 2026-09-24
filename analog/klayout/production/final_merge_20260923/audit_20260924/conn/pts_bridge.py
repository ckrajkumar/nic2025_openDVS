# find the met3 polygon(s) that join vdiff and vsf inside pixel_test_structure and list other layers on them
import pya
ly = pya.Layout(); ly.read(gds)
c = ly.cell("pixel_test_structure")
L = {"li":(67,20),"mcon":(67,44),"met1":(68,20),"via1":(68,44),"met2":(69,20),"via2":(69,44)}
T = {"li":(67,5),"met1":(68,5),"met2":(69,5)}
l2n = pya.LayoutToNetlist(pya.RecursiveShapeIterator(ly, c, []))
reg = {k: l2n.make_layer(ly.find_layer(a,b), k) for k,(a,b) in L.items()}
for k in ["li","met1","met2"]: l2n.connect(reg[k])
for k,(a,b) in T.items(): tl = l2n.make_text_layer(ly.find_layer(a,b), k+"_lbl"); l2n.connect(reg[k], tl)
l2n.connect(reg["via2"])
for a,v,b in [("li","mcon","met1"),("met1","via1","met2")]: l2n.connect(reg[a],reg[v]); l2n.connect(reg[v],reg[b])
l2n.connect(reg["met2"], reg["via2"])
l2n.extract_netlist()
cc = l2n.netlist().circuit_by_name("pixel_test_structure")
v2 = {}
for n in cc.each_net():
    for nm in n.expanded_name().split(","):
        if nm in ("vdiff","vsf"): v2.setdefault(nm, pya.Region()); v2[nm] += l2n.shapes_of_net(n, reg["via2"], True)
print({k: v.count() for k,v in v2.items()})
m3 = pya.Region(c.begin_shapes_rec(ly.find_layer(70,20))).merged()
a = m3.interacting(v2["vdiff"]); b = m3.interacting(v2["vsf"])
br = a & b
tr = pya.CplxTrans(ly.dbu)
for p in a.interacting(b).each():
    bb = p.bbox()
    print("met3 bridge polygon bbox (cell um):", tr*bb, "area um2 %.2f" % (p.area()*ly.dbu**2))
    for li in ly.layer_indexes():
        info = ly.get_info(li)
        r = pya.Region(c.begin_shapes_rec_overlapping(li, bb)) & pya.Region(p)
        if r.count() and info.layer not in (70,): print("   overlapped by", info, r.count(), "area %.2f" % (r.area()*ly.dbu**2))
    print("   cells there:", sorted(set(it.cell().name for it in [c.begin_shapes_rec_overlapping(ly.find_layer(70,20), bb)] for _ in [0])))
    it = c.begin_shapes_rec_overlapping(ly.find_layer(70,20), bb); names=set()
    while not it.at_end(): names.add(it.cell().name); it.next()
    print("   met3 contributed by cells:", names)
