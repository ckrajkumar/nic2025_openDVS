import pya, sys
sys.path.insert(0, "/home/rpgraca/opendvs_final"); import opendvs_l2n
ly = pya.Layout(); ly.read(gds); top = ly.top_cell()
box = pya.Box(int(float(x1)), int(float(y1)), int(float(x2)), int(float(y2)))
O = pya.Layout(); O.dbu = ly.dbu; c = O.create_cell("win")
for li in ly.layer_indexes():
    info = ly.get_info(li); ol = O.layer(info); it = pya.RecursiveShapeIterator(ly, top, li, box)
    while not it.at_end():
        s = it.shape(); t = it.trans()
        if s.is_text():
            p = t * pya.Point(s.text_trans.disp.x, s.text_trans.disp.y); c.shapes(ol).insert(pya.Text(s.text_string, pya.Trans(pya.Vector(int(p.x), int(p.y)))))
        elif s.is_polygon() or s.is_box() or s.is_path(): c.shapes(ol).insert(t * s.polygon)
        it.next()
l2n = opendvs_l2n.build_l2n(O, c, threads=8); circ = l2n.netlist().top_circuit()
net = [n for n in circ.each_net() if "GndD" in n.expanded_name() and "VddA18" in n.expanded_name()][0]
print("merged net:", net.expanded_name()[:80])
near = pya.Region(pya.Box(-6000, 60500, 4000, 66500))
for lname in ("met1", "via1", "met2", "via2", "met3", "li", "mcon"):
    lay = l2n.layer_by_name(lname)
    if lay is None: continue
    r = l2n.shapes_of_net(net, lay, True) & near
    print("  %-5s %d polys: %s" % (lname, r.count(), "; ".join(p.bbox().to_s() for p in r.each())[:700]))
# labels of the layout in the window by layer near the feed
for ld in ((68,5),(69,5),(67,5),(70,5)):
    li = O.find_layer(ld[0], ld[1])
    if li is None: continue
    print("  labels %d/%d:" % ld, [(s.text_string, s.text_trans.disp.to_s()) for s in c.shapes(li).each() if s.is_text() and near.bbox().contains(s.text_trans.disp)][:12])
