import pya
F = pya.Layout(); F.read("/home/rpgraca/opendvs_final/r19/pixel_4tile.merged.gds")
L = {(F.get_info(li).layer, F.get_info(li).datatype): li for li in F.layer_indexes()}
c = F.cell("GS_pixel_4tile_left_vdd_gnd_connectors")
for ld in ((68,20),(68,44),(69,20)):
    print(ld, [s.bbox().to_s() for s in c.shapes(L[ld]).each() if s.bbox().right > 2000])
# what met1 exists under the vias in the full hierarchy (pair 0)
top = F.cell("pixel_4tile"); it = pya.RecursiveShapeIterator(F, top, L[(68,20)], pya.Box(2600, 61900, 3100, 64500)); n = 0
while not it.at_end() and n < 10:
    print("  met1 near the vias:", F.cell(it.cell_index()).name, (it.trans() * it.shape().bbox()).to_s()); it.next(); n += 1
