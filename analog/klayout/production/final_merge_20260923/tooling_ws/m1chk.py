import pya
T = pya.Layout(); T.read("/home/rpgraca/opendvs_final/r19/pixel_4tile.r19.gds"); R = pya.Layout(); R.read("/home/rpgraca/tile_r15a/pixel_4tile.r15a.gds")
def reg(ly, ld, box):
    L = {(ly.get_info(li).layer, ly.get_info(li).datatype): li for li in ly.layer_indexes()}
    return pya.Region(ly.cell("openDVS_pixel").begin_shapes_rec(L[ld])).merged() & pya.Region(box)
box = pya.Box(-300, -450, 1500, 1600)
a = reg(T, (68,20), box); b = reg(R, (68,20), box)
print("r19 met1 in band:", [p.bbox().to_s() for p in a.each()]); print("r15a met1 in band:", [p.bbox().to_s() for p in b.each()])
print("r19-only:", [p.bbox().to_s() for p in (a-b).each()]); print("r15a-only:", [p.bbox().to_s() for p in (b-a).each()])
for ld, nm in [((68,44),"via1"),((69,20),"met2"),((67,20),"li"),((67,44),"mcon")]:
    a = reg(T, ld, box); b = reg(R, ld, box); print(nm, "r19-only:", [p.bbox().to_s() for p in (a-b).each()], "r15a-only:", [p.bbox().to_s() for p in (b-a).each()])
