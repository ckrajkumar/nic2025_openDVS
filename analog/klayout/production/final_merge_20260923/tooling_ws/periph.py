import pya
F = pya.Layout(); F.read("/home/rpgraca/opendvs_final/merged/user_project_wrapper.gds")
L = {(F.get_info(li).layer, F.get_info(li).datatype): li for li in F.layer_indexes()}
def dump(cn, box=None, layers=((69,20),(69,16),(68,20),(70,20),(69,44),(70,44),(68,44))):
    c = F.cell(cn); print("== %s bbox %s insts %s" % (cn, c.bbox().to_s(), sorted(set(F.cell(i.cell_index).name for i in c.each_inst()))))
    for inst in c.each_inst(): print("   inst", F.cell(inst.cell_index).name, inst.trans.to_s(), "array" if inst.is_regular_array() else "")
    for ld in layers:
        if ld not in L: continue
        for s in c.shapes(L[ld]).each():
            if s.is_text(): print("   %d/%d text %r at %s" % (ld[0], ld[1], s.text_string, s.text_trans.disp.to_s())); continue
            p = s.polygon if s.is_polygon() else (s.box if s.is_box() else s.path.polygon()); bb = p.bbox()
            if box is None or not (pya.Region(p) & pya.Region(box)).is_empty(): print("   %d/%d %s" % (ld[0], ld[1], p.to_s()[:200]))
dump("GS_pixel_layout_biasgen_connector_v3")
dump("GS_pixel_4tile_left_vdd_gnd_connectors")
# tile-cell own shapes at the west edge (x < 3200) for the first two pair rows, and near the seam
dump("GS_pixel_layout_tile", pya.Box(0, -2000, 3200, 4000), layers=((69,20),(69,16),(68,20),(68,16),(70,20)))
print("== GS_pixel_layout_tile own met2 shapes total:", sum(1 for s in F.cell("GS_pixel_layout_tile").shapes(L[(69,20)]).each()), "met2 pins:", sum(1 for s in F.cell("GS_pixel_layout_tile").shapes(L[(69,16)]).each()) if (69,16) in L else 0)
xs = sorted(set(s.bbox().left for s in F.cell("GS_pixel_layout_tile").shapes(L[(69,20)]).each())); print("   met2 x-lefts:", xs[:12], "...", xs[-6:])
# instances of the connectors in pixel_4tile: y of the first few
pt = F.cell("pixel_4tile")
for nm in ("GS_pixel_layout_biasgen_connector_v3", "GS_pixel_4tile_left_vdd_gnd_connectors", "GS_pixel_layout_tile", "GS_pixel_layout_tile_bot"):
    ts = sorted((i.trans.disp.x, i.trans.disp.y, i.trans.rot, i.trans.is_mirror()) for i in pt.each_inst() if F.cell(i.cell_index).name == nm)
    print("   %s: %d insts, first %s last %s" % (nm, len(ts), ts[:3], ts[-2:]))
