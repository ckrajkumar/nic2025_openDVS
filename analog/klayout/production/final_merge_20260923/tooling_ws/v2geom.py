import pya
F = pya.Layout(); F.read("/home/rpgraca/opendvs_final/r19/user_project_wrapper.gds")
L = {(F.get_info(li).layer, F.get_info(li).datatype): li for li in F.layer_indexes()}
pt = F.cell("pixel_4tile")
for i in pt.each_inst():
    if F.cell(i.cell_index).name == "GS_pixel_layout_biasgen_connector_v2":
        print("v2 inst", i.trans.to_s(), "array", i.is_regular_array(), i.a.to_s() if i.is_regular_array() else "", i.na, i.nb)
c = F.cell("GS_pixel_layout_biasgen_connector_v2"); print("v2 bbox", c.bbox().to_s())
for inst in c.each_inst(): print("   inst", F.cell(inst.cell_index).name, inst.trans.to_s(), F.cell(inst.cell_index).bbox().to_s(), "array" if inst.is_regular_array() else "")
for ld in ((69,20),(69,16),(68,20),(68,44),(69,44),(70,20),(70,44),(71,20)):
    if ld not in L: continue
    sh = [s for s in c.shapes(L[ld]).each()]
    print("  %d/%d n=%d: %s" % (ld[0], ld[1], len(sh), "; ".join((s.text_string + "@" + s.text_trans.disp.to_s()) if s.is_text() else s.bbox().to_s() for s in sh)[:900]))
# what the last pixel column sees: shapes of any cell east of x 1538690 in pixel_4tile for one pair (A = 63220 + 24000*62 = 1551220)
A = 1551220
for ld in ((69,20),(68,20),(70,20)):
    it = pya.RecursiveShapeIterator(F, pt, L[ld], pya.Box(1538600, A - 1800, 1546000, A + 1800)); n = 0
    print("== %d/%d east of the array at pair 62 (A=%d):" % (ld[0], ld[1], A))
    while not it.at_end() and n < 20:
        s = it.shape(); print("   %-40s %s" % (F.cell(it.cell_index()).name, (it.trans() * s.bbox()).to_s())); it.next(); n += 1
