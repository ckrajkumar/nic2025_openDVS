# klayout -b -r short_probe.py -rd gds=<pixel_4tile.merged.gds> -rd x1=.. -rd y1=.. -rd x2=.. -rd y2=..  : flatten a window, extract connectivity, report nets carrying both GndD and VddA18 (or GndA) labels
import pya, sys
sys.path.insert(0, "/home/rpgraca/opendvs_final"); import opendvs_l2n
ly = pya.Layout(); ly.read(gds); top = ly.top_cell()
box = pya.Box(int(float(x1)), int(float(y1)), int(float(x2)), int(float(y2)))
O = pya.Layout(); O.dbu = ly.dbu; c = O.create_cell("win")
for li in ly.layer_indexes():
    info = ly.get_info(li); ol = O.layer(info)
    it = pya.RecursiveShapeIterator(ly, top, li, box)
    while not it.at_end():
        s = it.shape(); t = it.trans()
        if s.is_text():
            p = t * pya.Point(s.text_trans.disp.x, s.text_trans.disp.y); c.shapes(ol).insert(pya.Text(s.text_string, pya.Trans(pya.Vector(int(p.x), int(p.y)))))
        elif s.is_polygon() or s.is_box() or s.is_path(): c.shapes(ol).insert(t * s.polygon)
        it.next()
print("window shapes:", sum(c.shapes(li).size() for li in O.layer_indexes()))
l2n = opendvs_l2n.build_l2n(O, c, threads=8)
nl = l2n.netlist(); circ = nl.top_circuit()
names = {}
for n in circ.each_net():
    nm = n.expanded_name(); names.setdefault(nm, 0); names[nm] += 1
sus = [nm for nm in names if ("GndD" in nm and ("VddA18" in nm or "GndA" in nm)) or nm.count(",") >= 1]
print("nets with merged labels:", sus[:10])
# where do GndD and VddA18 meet: probe met1/met2 shapes along the west feed at pair 0 (A=63220)
A = 63220
for lname, pts in (("met1", [(2.85, A/1000.0 + 0.0), (0.0, A/1000.0), (2.85, A/1000.0 + 1.1), (2.85, A/1000.0 - 1.1)]), ("met2", [(2.8, A/1000.0 + 0.98), (2.8, A/1000.0 - 0.98), (0.3, A/1000.0), (2.8, A/1000.0 + 0.14), (2.8, A/1000.0 + 0.42), (2.28, A/1000.0 + 0.9), (1.88, A/1000.0 + 0.5)]), ("li", [(2.7, A/1000.0 + 0.5)])):
    lay = l2n.layer_by_name(lname)
    for x, y in pts:
        net = l2n.probe_net(lay, pya.DPoint(x, y)); print("  %-5s (%.2f,%.2f) -> %s" % (lname, x, y, net.expanded_name() if net else "-"))
