# For the cells that changed (and the top), check every label: is it on drawing of its layer (and on pin if pin exists),
# and does any merged local drawing polygon (cell + all its descendants, flattened into the cell) carry labels of >1 distinct net?
import pya
L = pya.Layout(); L.read(b)
cells = ["GS_openDVS_pixel","S7_openDVS_pixel","GS_openDVS_pixel2x2_bot","GS_openDVS_pixel2x2_top","S7_openDVS_pixel2x2_bot",
         "GS_pixel_layout_tile","GS_pixel_layout_tile_bot","GS_pixel_4tile_left_vdd_gnd_connectors","GS_pixel_layout_biasgen_connector_v2","GS_pixel_layout_biasgen_connector_v3"]
pairs = {5: (20, 16)}
for cn in cells:
    c = L.cell(cn)
    for lay in (67, 68, 69, 70, 71, 72):
        lt = L.find_layer(lay, 5); ld = L.find_layer(lay, 20); lp = L.find_layer(lay, 16)
        if lt is None or ld is None: continue
        texts = [(s.text_string, s.text.x, s.text.y) for s in c.shapes(lt).each() if s.is_text()]
        if not texts: continue
        dr = pya.Region(c.begin_shapes_rec(ld)); dr.merge()
        pr = pya.Region(c.begin_shapes_rec(lp)) if lp is not None else pya.Region()
        off = [t for t in texts if dr.interacting(pya.Region(pya.Box(t[1]-1, t[2]-1, t[1]+1, t[2]+1))).is_empty()]
        offpin = [t for t in texts if not pr.is_empty() and pr.interacting(pya.Region(pya.Box(t[1]-1, t[2]-1, t[1]+1, t[2]+1))).is_empty()]
        # label->polygon mapping
        by = {}
        for s, x, y in texts:
            for p in dr.interacting(pya.Region(pya.Box(x-1, y-1, x+1, y+1))).each():
                by.setdefault(str(p.bbox()), set()).add(s)
        multi = {k: v for k, v in by.items() if len(v) > 1}
        print("%s L%d: %d labels, off-drawing %d, off-pin %d, polys with >1 net %d" % (cn, lay, len(texts), len(off), len(offpin), len(multi)))
        for t in off[:8]: print("    OFF", t[0], t[1]*L.dbu, t[2]*L.dbu)
        for t in offpin[:8]: print("    OFFPIN", t[0], t[1]*L.dbu, t[2]*L.dbu)
        for k, v in list(multi.items())[:8]: print("    MULTI", k, sorted(v))
