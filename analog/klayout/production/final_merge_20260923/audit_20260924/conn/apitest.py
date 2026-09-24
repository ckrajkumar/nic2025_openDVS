import pya
ly = pya.Layout(); ly.dbu=0.001
top = ly.create_cell("TOP"); ch = ly.create_cell("CH")
m1 = ly.layer(68,20); t1 = ly.layer(68,5)
ch.shapes(m1).insert(pya.Box(0,0,1000,100)); ch.shapes(t1).insert(pya.Text("A", 10,10)); ch.shapes(t1).insert(pya.Text("B", 900,10))
ch.shapes(m1).insert(pya.Box(0,500,1000,600)); ch.shapes(t1).insert(pya.Text("C", 10,510))
top.insert(pya.CellInstArray(ch.cell_index(), pya.Trans(0,0)))
top.shapes(m1).insert(pya.Box(900,0,2000,100)); top.shapes(t1).insert(pya.Text("TOPX", 1900,50)); top.shapes(t1).insert(pya.Text("TOPY", 1800,50))
l2n = pya.LayoutToNetlist(pya.RecursiveShapeIterator(ly, top, []))
r = l2n.make_layer(m1, "m1"); tl = l2n.make_text_layer(t1, "t1")
l2n.connect(r); l2n.connect(r, tl)
l2n.extract_netlist()
nl = l2n.netlist()
for c in nl.each_circuit():
    print("circuit", c.name, [ (p.id(), c.net_for_pin(p.id()).expanded_name()) for p in c.each_pin()])
    for n in c.each_net():
        sh = pya.Shapes()
        l2n.shapes_of_net(n, tl, False, sh)
        print("  net", n.expanded_name(), [s.text_string for s in sh.each() if s.is_text()], "pins", n.pin_count(), "scpins", n.subcircuit_pin_count())
    for sc in c.each_subcircuit(): print("  sc", sc.expanded_name(), sc.trans, [ (sp.pin().id(), sp.net().expanded_name()) for sp in [] ])
print(l2n.probe_net(r, pya.DPoint(0.01, 0.51)))
