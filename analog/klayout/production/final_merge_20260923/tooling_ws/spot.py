import pya
F = pya.Layout(); F.read("/home/rpgraca/opendvs_final/r19/user_project_wrapper.gds"); R = pya.Layout(); R.read("/home/rpgraca/tile_r15a/pixel_4tile.r15a.gds")
LF = {(F.get_info(li).layer, F.get_info(li).datatype): li for li in F.layer_indexes()}; LR = {(R.get_info(li).layer, R.get_info(li).datatype): li for li in R.layer_indexes()}
top = F.cell("pixel_4tile")
for ld in ((69,20),(69,16)):
    it = pya.RecursiveShapeIterator(F, top, LF[ld], pya.Box(1538400, 1575600, 1539100, 1576000))
    print("== shapes on %d/%d near (1538.7, 1575.8):" % ld)
    seen = 0
    while not it.at_end() and seen < 12:
        s = it.shape()
        print("   cell %s  bbox(top) %s" % (F.cell(it.cell_index()).name, (it.trans() * s.bbox()).to_s())); it.next(); seen += 1
W = pya.Region(pya.Box(4000, -1600, 9000, 1300))
print("== 2x2 own shapes EAST strip (x > 4000), r18b/r19 wrapper vs r15a")
for ld in sorted(set(LF) | set(LR)):
    a = (pya.Region(F.cell("GS_openDVS_pixel2x2_top").shapes(LF[ld])) if ld in LF else pya.Region()) & W
    b = (pya.Region(R.cell("openDVS_pixel2x2_top").shapes(LR[ld])) if ld in LR else pya.Region()) & W
    if (a ^ b).area(): print("%d/%d wrapper-own: %s | r15a-own: %s" % (ld[0], ld[1], [p.bbox().to_s() for p in (a-b).each()], [p.bbox().to_s() for p in (b-a).each()]))
for tag, ly, cn, L in (("wrapper", F, "GS_openDVS_pixel2x2_top", LF), ("r15a", R, "openDVS_pixel2x2_top", LR)):
    if (69,5) in L: print(tag, "east texts:", [(s.text_string, s.text_trans.disp.to_s()) for s in ly.cell(cn).shapes(L[(69,5)]).each() if s.is_text() and s.text_trans.disp.x > 4000])
