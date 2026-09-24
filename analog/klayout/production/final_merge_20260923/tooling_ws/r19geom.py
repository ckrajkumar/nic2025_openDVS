import pya
F = pya.Layout(); F.read("/home/rpgraca/opendvs_final/merged/user_project_wrapper.gds")
R = pya.Layout(); R.read("/home/rpgraca/tile_r15a/pixel_4tile.r15a.gds")
LF = {(F.get_info(li).layer, F.get_info(li).datatype): li for li in F.layer_indexes()}; LR = {(R.get_info(li).layer, R.get_info(li).datatype): li for li in R.layer_indexes()}
pt = F.cell("pixel_4tile")
for i in pt.each_inst():
    n = F.cell(i.cell_index).name
    if n in ("GS_pixel_layout_biasgen_connector_v3", "GS_pixel_4tile_left_vdd_gnd_connectors"):
        print(n, "trans", i.trans.to_s(), "array", i.is_regular_array(), "a", i.a.to_s() if i.is_regular_array() else "-", "b", i.b.to_s() if i.is_regular_array() else "-", "na", i.na, "nb", i.nb)
c = F.cell("GS_M2M3_MAG_7849107791415"); print("M2M3 via cell bbox", c.bbox().to_s(), "layers:", sorted(set((F.get_info(li).layer, F.get_info(li).datatype) for li in F.layer_indexes() if c.shapes(li).size())))
c = F.cell("GS_vias_gen$3"); print("vias_gen$3 bbox", c.bbox().to_s(), sorted(set((F.get_info(li).layer, F.get_info(li).datatype) for li in F.layer_indexes() if c.shapes(li).size())))
box = pya.Box(-300, -450, 1500, 1600)
print("== pixel west-edge band, r15a vs r18b (GS_openDVS_pixel), per layer")
for ld, nm in [((67,20),"li"),((67,44),"mcon"),((68,20),"met1"),((68,44),"via1"),((69,20),"met2"),((69,44),"via2"),((70,20),"met3")]:
    a = pya.Region(R.cell("openDVS_pixel").begin_shapes_rec(LR[ld])).merged() & pya.Region(box) if ld in LR else pya.Region()
    b = pya.Region(F.cell("GS_openDVS_pixel").begin_shapes_rec(LF[ld])).merged() & pya.Region(box) if ld in LF else pya.Region()
    print("  %-5s r15a-only: %s" % (nm, "; ".join(p.bbox().to_s() for p in (a - b).each())[:400]))
    print("  %-5s r18b-only: %s" % (nm, "; ".join(p.bbox().to_s() for p in (b - a).each())[:400]))
print("== 2x2 own shapes west strip (x < -16500), r15a vs r18b: pins + texts")
for ld in ((69,16),(68,16),(71,16),(70,16),(69,5),(68,5),(70,5),(71,5)):
    for tag, ly, cn, L in (("r15a", R, "openDVS_pixel2x2_top", LR), ("r18b", F, "GS_openDVS_pixel2x2_top", LF)):
        if ld not in L: continue
        items = []
        for s in ly.cell(cn).shapes(L[ld]).each():
            if s.is_text():
                if s.text_trans.disp.x < -16500: items.append("%r@%s" % (s.text_string, s.text_trans.disp.to_s()))
            elif s.bbox().left < -16500: items.append(s.bbox().to_s())
        if items: print("  %d/%d %s: %s" % (ld[0], ld[1], tag, "; ".join(items)[:500]))
