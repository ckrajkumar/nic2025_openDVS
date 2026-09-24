import pya
F = pya.Layout(); F.read("/home/rpgraca/opendvs_final/r19/pixel_4tile.merged.gds")
L = {(F.get_info(li).layer, F.get_info(li).datatype): li for li in F.layer_indexes()}
for cn in ("GS_pixel_layout_tile", "GS_pixel_layout_tile_bot"):
    c = F.cell(cn); ys0 = sorted(set(i.trans.disp.y for i in c.each_inst() if F.cell(i.cell_index).name.startswith("GS_openDVS_pixel2x2")))
    A = [y - 180 for y in ys0]
    for ld, li in sorted(L.items()):
        tx = [(s.text_string, s.text_trans.disp.x, s.text_trans.disp.y) for s in c.shapes(li).each() if s.is_text()]
        if not tx: continue
        west = [t for t in tx if t[1] < 4000]
        print(cn, ld, "texts", len(tx), "at x<4: %d" % len(west))
        for t in west[:40]:
            k = min(range(len(A)), key=lambda i: abs(A[i] - t[2])); print("    %-16s x %d y %d  pair %d  dy %+d" % (t[0], t[1], t[2], k, t[2] - A[k]))
