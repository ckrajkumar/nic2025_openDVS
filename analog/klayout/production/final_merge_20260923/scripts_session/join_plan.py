# klayout -b -r join_plan.py -rd gds=<r19 wrapper> : for every vdda1 met4 PDN stripe at the tile's top/bottom edge, the deepest entry into the array
# that overlaps VddA18 met4 by >= 0.3 um while staying >= 0.3 um from any other-net met4 (also through the periphery band)
import pya
ly = pya.Layout(); ly.read(gds); top = ly.top_cell()
tc = ly.cell("pixel_4tile"); inst = [i for i in top.each_inst() if i.cell.name == "pixel_4tile"][0]; T = inst.cplx_trans; tb = tc.bbox().transformed(T)
plane = pya.Box(1206885, 715715, 2748265, 2274055)
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
vdda1 = [n for n in c.each_net() if n.expanded_name() == "vdda1"][0]
own = l2n.shapes_of_net(vdda1, reg["met4"], True); allm4 = pya.Region(top.begin_shapes_rec(ly.layer(71,20))); other = allm4 - own
SP = 300; MAXD = 40000
m4top = l2n.shapes_of_net(vdda1, reg["met4"], False)
for p in m4top.each():
    b = p.bbox()
    if b.height() < 30000 or b.width() > 5000 or not (tb.left < b.left < tb.right): continue
    if abs(b.bottom - tb.top) < 20000: edge, dirn, start = plane.top, -1, b.bottom
    elif abs(b.top - tb.bottom) < 20000: edge, dirn, start = plane.bottom, +1, b.top
    else: continue
    best = None; first_obst = None
    for d in range(0, MAXD + 1, 50):
        yend = edge + dirn * d
        box = pya.Box(b.left, min(start, yend), b.right, max(start, yend))
        hit = pya.Region(box).sized(SP) & other
        if not hit.is_empty():
            first_obst = (d, list(hit.each())[0].bbox().to_s()); break
        ov = pya.Region(box) & own
        if not ov.is_empty() and ov.bbox().height() >= 300: best = d
    print("stripe x %.1f %s: deepest clean entry %s um; first obstacle at %s" % (b.left/1e3, "top" if dirn < 0 else "bottom", (best/1e3) if best is not None else None, first_obst))
