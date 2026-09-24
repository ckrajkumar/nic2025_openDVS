import pya
for tag, f in (("A", a), ("B", b)):
    L = pya.Layout(); L.read(f)
    for cn in ("S7_openDVS_pixel","S7_openDVS_pixel2x2_bot","pixel_test_structure","GS_openDVS_pixel","pixel_4tile"):
        c = L.cell(cn); loc = []; rec = []
        for li in L.layer_indexes():
            inf = L.get_info(li)
            if inf.datatype in (24, 52, 4, 98) and inf.layer != 235:
                if c.shapes(li).size(): loc.append("%d/%d:%d" % (inf.layer, inf.datatype, c.shapes(li).size()))
                r = pya.Region(c.begin_shapes_rec(li)); a_ = r.area()*L.dbu**2
                if a_: rec.append("%d/%d:%.2f" % (inf.layer, inf.datatype, a_))
        print(tag, cn, "local", loc, "| recursive area um2", rec)
