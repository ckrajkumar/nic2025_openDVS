import pya
F = pya.Layout(); F.read("/home/rpgraca/opendvs_final/r19/pixel_4tile.merged.gds")
L = {(F.get_info(li).layer, F.get_info(li).datatype): li for li in F.layer_indexes()}
for cn in ("GS_openDVS_pixel2x2_top", "GS_openDVS_pixel2x2_bot"):
    c = F.cell(cn)
    for ld in ((68,20),(68,44),(67,20),(67,44)):
        sh = [s.bbox().to_s() for s in c.shapes(L[ld]).each() if not s.is_text() and s.bbox().left < -16000 and s.bbox().bottom < 1600 and s.bbox().top > -1700]
        if sh: print(cn, ld, sh[:12])
# pixel met1/via1/li at local x<0.6 for y -1.2..1.6
c = F.cell("GS_openDVS_pixel")
for ld in ((68,20),(68,44),(67,20),(67,44),(69,20),(69,44)):
    r = pya.Region(c.begin_shapes_rec(L[ld])).merged() & pya.Region(pya.Box(-300, -1300, 600, 1700))
    print("pixel", ld, [p.bbox().to_s() for p in r.each()][:10])
