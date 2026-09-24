# klayout -b -r feed_geom.py -rd gds=<r20 wrapper> : for each vdda1 met4 stripe joined to the array (top/bottom) the nearest via4 crossings
# above/below the tile edge (feed length, via4 count), and for each vssa1 met5 stub the nearest via4 on its stripe; plus the met5 PDN stripe y's near the tile
import pya, re
ly = pya.Layout(); ly.read(gds); top = ly.top_cell()
tc = ly.cell("pixel_4tile"); inst = [i for i in top.each_inst() if i.cell.name == "pixel_4tile"][0]; T = inst.cplx_trans; tb = tc.bbox().transformed(T)
plane = pya.Box(1206885, 715715, 2748265, 2274055)
L = {"met3":(70,20),"via3":(70,44),"met4":(71,20),"via4":(71,44),"met5":(72,20)}
Tx = {"met3":(70,5),"met4":(71,5),"met5":(72,5)}
l2n = pya.LayoutToNetlist(pya.RecursiveShapeIterator(ly, top, [])); reg = {}
for k,(a,b) in L.items(): reg[k] = l2n.make_layer(ly.find_layer(a,b), k)
for k,(a,b) in Tx.items():
    li = ly.find_layer(a,b)
    if li is not None: l2n.connect(reg[k], l2n.make_text_layer(li, k+"_lbl"))
for k in ["met3","met4","met5"]: l2n.connect(reg[k])
for a,v,b in [("met3","via3","met4"),("met4","via4","met5")]: l2n.connect(reg[a],reg[v]); l2n.connect(reg[v],reg[b])
l2n.extract_netlist(); c = l2n.netlist().circuit_by_name(top.name)
nets = {n.expanded_name(): n for n in c.each_net() if n.expanded_name() in ("vdda1","vssa1")}
v4all = pya.Region(top.shapes(ly.layer(71,44)))
print("tile bbox", tb.to_s(), "plane", plane.to_s())
for nm in ("vdda1","vssa1"):
    m4 = l2n.shapes_of_net(nets[nm], reg["met4"], False); m4.merge()
    m5 = l2n.shapes_of_net(nets[nm], reg["met5"], False)
    # merged vertical met4 pieces that cross the tile top or bottom edge (the r20 joins are merged into the stripes)
    for p in m4.each():
        b = p.bbox()
        if b.width() > 5000 or b.height() < 30000 or not (tb.left < b.left < tb.right): continue
        if b.bottom < tb.top < b.top: side, edge = "top", tb.top
        elif b.bottom < tb.bottom < b.top: side, edge = "bot", tb.bottom
        else: continue
        v = v4all & pya.Region(b)
        ys = sorted(set(q.bbox().center().y for q in v.each()))
        if side == "top":
            near = [y for y in ys if y > edge]; y0 = min(near) if near else None; inner = b.bottom
        else:
            near = [y for y in ys if y < edge]; y0 = max(near) if near else None; inner = b.top
        cnt = sum(1 for q in v.each() if y0 is not None and abs(q.bbox().center().y - y0) < 2000)
        print("%s met4 %s x %.1f: stripe %s, join end y %.1f, nearest via4 crossing y %s (%d via4), feed length via4->join end %.1f um, via4 crossings on stripe %d" % (
            nm, side, b.left/1e3, b.to_s(), inner/1e3, ("%.1f" % (y0/1e3)) if y0 else "none", cnt, (abs(y0 - inner)/1e3) if y0 else -1, len(ys)))
    if nm == "vssa1":
        for p in m5.each():
            b = p.bbox()
            if b.width() < 30000 or b.height() > 5000 or not (plane.bottom < b.bottom < plane.top): continue
            if not (b.right >= plane.left - 100 and b.left < plane.left) and not (b.left <= plane.right + 100 and b.right > plane.right): continue
            v = v4all & pya.Region(b); xs = sorted(set(q.bbox().center().x for q in v.each()))
            if b.left < plane.left: end = plane.left; near = [x for x in xs if x < end]; x0 = max(near) if near else None
            else: end = plane.right; near = [x for x in xs if x > end]; x0 = min(near) if near else None
            cnt = sum(1 for q in v.each() if x0 is not None and abs(q.bbox().center().x - x0) < 12000)
            print("vssa1 met5 stub y %.1f: stripe x %.1f..%.1f, nearest via4 group to the plane edge at x %s (%d via4 within 12 um), distance %.1f um" % (
                b.bottom/1e3, b.left/1e3, b.right/1e3, ("%.1f" % (x0/1e3)) if x0 else "none", cnt, (abs(x0-end)/1e3) if x0 else -1))
    # met5 horizontal stripes of this net near the tile top/bottom
    ys = sorted(set(round(p.bbox().bottom/1e3,1) for p in m5.each() if p.bbox().width() > 30000 and p.bbox().height() < 5000))
    print(nm, "met5 stripe y's within 400 um of the tile edges:", [y for y in ys if abs(y*1e3 - tb.top) < 400000 or abs(y*1e3 - tb.bottom) < 400000], "tile top %.1f bottom %.1f" % (tb.top/1e3, tb.bottom/1e3))
