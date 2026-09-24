import pya
F = pya.Layout(); F.read("/home/rpgraca/opendvs_final/merged/user_project_wrapper.gds"); R = pya.Layout(); R.read("/home/rpgraca/tile_r15a/pixel_4tile.r15a.gds")
W = pya.Region(pya.Box(-18300, -1600, -16500, 1300))
LF = {(F.get_info(li).layer, F.get_info(li).datatype): li for li in F.layer_indexes()}; LR = {(R.get_info(li).layer, R.get_info(li).datatype): li for li in R.layer_indexes()}
for ld in sorted(set(LF) | set(LR)):
    a = (pya.Region(F.cell("GS_openDVS_pixel2x2_top").shapes(LF[ld])) if ld in LF else pya.Region()) & W
    b = (pya.Region(R.cell("openDVS_pixel2x2_top").shapes(LR[ld])) if ld in LR else pya.Region()) & W
    if (a ^ b).area(): print("%d/%d r18b-own: %s | r15a-own: %s" % (ld[0], ld[1], [p.bbox().to_s() for p in (a-b).each()], [p.bbox().to_s() for p in (b-a).each()]))
