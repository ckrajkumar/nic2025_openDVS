import pya
F = pya.Layout(); F.read("/home/rpgraca/opendvs_final/merged/user_project_wrapper.gds")
for cn in ("GS_pixel_4tile_left_vdd_gnd_connectors", "GS_pixel_layout_biasgen_connector_v3"):
    c = F.cell(cn); print("==", cn)
    for li in F.layer_indexes():
        n = c.shapes(li).size()
        if n: print("  %d/%d n=%d %s" % (F.get_info(li).layer, F.get_info(li).datatype, n, [(s.text_string + "@" + s.text_trans.disp.to_s()) if s.is_text() else s.bbox().to_s() for s in c.shapes(li).each()][:8]))
