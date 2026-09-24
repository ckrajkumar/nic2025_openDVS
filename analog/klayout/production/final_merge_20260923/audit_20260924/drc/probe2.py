import pya
for tag, f in (("A", a), ("B", b)):
    L = pya.Layout(); L.read(f)
    for cn, x, y in (("GS_openDVS_pixel", 10.22, 6.13), ("S7_openDVS_pixel", 6.13, -10.22), ("GS_pixel_layout_tile_bot", 2.82, 15.67), ("GS_pixel_layout_tile_bot", 2.82, 14.69)):
        c = L.cell(cn); pt = pya.DBox(x-0.001, y-0.001, x+0.001, y+0.001)
        on = []
        for li in L.layer_indexes():
            inf = L.get_info(li)
            r = pya.Region(c.begin_shapes_rec(li)); r.merge()
            hit = r.interacting(pya.Region(pt.to_itype(L.dbu)))
            if not hit.is_empty(): on.append("%d/%d %s" % (inf.layer, inf.datatype, hit.bbox().to_dtype(L.dbu)))
        print(tag, cn, (x, y), "layers under point:", on)
    # labels touching the met2 polygon under GND label in tile_bot (recursive)
    c = L.cell("GS_pixel_layout_tile_bot")
    for (x, y) in ((2.82, 15.67), (2.82, 14.69)):
        m2 = pya.Region(c.begin_shapes_rec(L.find_layer(69, 20))); m2.merge()
        hit = m2.interacting(pya.Region(pya.DBox(x-0.001, y-0.001, x+0.001, y+0.001).to_itype(L.dbu)))
        if hit.is_empty(): print(tag, "no met2 at", x, y); continue
        it = c.begin_shapes_rec(L.find_layer(69, 5)); labs = set()
        while not it.at_end():
            s = it.shape()
            if s.is_text():
                t = s.text.transformed(it.trans())
                if not hit.interacting(pya.Region(pya.Box(t.x-1, t.y-1, t.x+1, t.y+1))).is_empty(): labs.add(s.text_string)
            it.next()
        print(tag, "met2 poly under", (x, y), hit.bbox().to_dtype(L.dbu), "carries labels", sorted(labs))
