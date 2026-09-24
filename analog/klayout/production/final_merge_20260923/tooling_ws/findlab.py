import pya
F = pya.Layout(); F.read("/home/rpgraca/opendvs_final/r19/pixel_4tile.merged.gds")
L = {(F.get_info(li).layer, F.get_info(li).datatype): li for li in F.layer_indexes()}
for c in F.each_cell():
    for ld in ((69,5),(69,16),(68,5),(70,5)):
        if ld not in L: continue
        hits = [(s.text_string, s.text_trans.disp.to_s()) for s in c.shapes(L[ld]).each() if s.is_text() and (s.text_string in ("GND", "rowReadON[1]", "rowReadOFF[1]", "GndD", "rowReadON", "rowReadOFF"))]
        if hits: print(c.name, ld, hits[:14])
