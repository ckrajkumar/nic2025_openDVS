# klayout -b -r edge_stripes.py -rd gds=<wrapper> : vertical wrapper met4 stripes touching the tile's top/bottom edges, and met5 stripes at the side bars, by net
import pya, re
ly = pya.Layout(); ly.read(gds); top = ly.top_cell()
tc = ly.cell("pixel_4tile"); inst = [i for i in top.each_inst() if i.cell.name == "pixel_4tile"][0]; T = inst.cplx_trans; tb = tc.bbox().transformed(T)
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
plane = pya.Box(1206885, 715715, 2748265, 2274055)
for n in c.each_net():
    nm = n.expanded_name()
    if not re.search(r"^(vdda1|vssa1|vssa2|vccd1|vssd1)$", nm): continue
    m4 = l2n.shapes_of_net(n, reg["met4"], False); m5 = l2n.shapes_of_net(n, reg["met5"], False)
    vert = [p for p in m4.each() if p.bbox().height() > 30000 and p.bbox().width() < 5000]
    at_top = [p for p in vert if abs(p.bbox().bottom - tb.top) < 20000 and tb.left < p.bbox().left < tb.right]
    at_bot = [p for p in vert if abs(p.bbox().top - tb.bottom) < 20000 and tb.left < p.bbox().left < tb.right]
    horiz5 = [p for p in m5.each() if p.bbox().width() > 30000 and p.bbox().height() < 5000 and plane.bottom < p.bbox().bottom < plane.top]
    west = [p for p in horiz5 if p.bbox().right < plane.left + 1000 and p.bbox().right > tb.left]
    east = [p for p in horiz5 if p.bbox().left > plane.right - 1000 and p.bbox().left < tb.right]
    print("%-6s vertical met4 stripes reaching the tile top edge: %2d (x %s), bottom edge: %2d | met5 stripes ending at the west side within the plane's y-range: %d, east: %d" % (
        nm, len(at_top), [round(p.bbox().left/1000,1) for p in at_top][:8], len(at_bot), len(west), len(east)))
    if at_top: print("       top-edge stripe ends y: %s (tile top %.1f)" % (sorted(set(round(p.bbox().bottom/1000,1) for p in at_top))[:4], tb.top/1000))
    if west: print("       west met5 stripe right ends x: %s (plane left edge %.3f)" % (sorted(set(round(p.bbox().right/1000,3) for p in west))[:4], plane.left/1000))
