import pya
from collections import Counter
F = pya.Layout(); F.read("/home/rpgraca/opendvs_final/merged/user_project_wrapper.gds")
L = {(F.get_info(li).layer, F.get_info(li).datatype): li for li in F.layer_indexes()}
pt = F.cell("pixel_4tile")
for nm in ("GS_pixel_layout_biasgen_connector_v3", "GS_pixel_4tile_left_vdd_gnd_connectors", "GS_pixel_layout_tile", "GS_pixel_layout_tile_bot", "GS_M1M2_MAG_784910779144", "GS_M2M3_MAG_784910779142", "GS_M2M3_MAG_784910779140"):
    ts = sorted((i.trans.disp.x, i.trans.disp.y, i.trans.to_s().split()[0]) for i in pt.each_inst() if F.cell(i.cell_index).name == nm)
    ys = sorted(set(t[1] for t in ts)); xs = sorted(set(t[0] for t in ts))
    print("%s: %d insts; x %s; y first %s last %s; pitch %s" % (nm, len(ts), xs[:4], ys[:3], ys[-2:], (ys[1]-ys[0]) if len(ys) > 1 else "-"))
for cn in ("GS_pixel_layout_tile", "GS_pixel_layout_tile_bot"):
    c = F.cell(cn)
    ys2 = sorted(set(i.trans.disp.y for i in c.each_inst() if F.cell(i.cell_index).name.startswith("GS_openDVS_pixel2x2")))
    xs2 = sorted(set(i.trans.disp.x for i in c.each_inst() if F.cell(i.cell_index).name.startswith("GS_openDVS_pixel2x2")))
    print("== %s: 2x2 y0 %s ... %s (n=%d), x0 %s ... %s (n=%d)" % (cn, ys2[:2], ys2[-1:], len(ys2), xs2[:2], xs2[-1:], len(xs2)))
    for ld in ((69,20),(69,16),(68,20),(68,16),(70,20),(70,16)):
        if ld not in L: continue
        shapes = [s for s in c.shapes(L[ld]).each() if not s.is_text()]
        texts = [s for s in c.shapes(L[ld]).each() if s.is_text()]
        cnt = Counter(); ex = {}
        for s in shapes:
            bb = s.bbox(); key = (bb.left, bb.width(), bb.height()); cnt[key] += 1; ex.setdefault(key, bb)
        print("   %d/%d: %d shapes, %d texts; groups (x-left,w,h)->count, first bbox:" % (ld[0], ld[1], len(shapes), len(texts)))
        for key, n in sorted(cnt.items())[:14]: print("      %s x%d  e.g. %s" % (key, n, ex[key].to_s()))
        tc = Counter(t.text_string.split("[")[0].split("<")[0] for t in texts); print("      texts:", dict(tc))
        if texts:
            tt = sorted((t.text_trans.disp.y, t.text_string, t.text_trans.disp.x) for t in texts)[:6]; print("      first texts:", tt)
# the pixel band / GndD in the r15a export and r18b for reference (pixel local y)
print("pair axis (pixel local) = 0.13; r15a rows: ON 0.20-0.34?, OFF 0.48-0.62?, GndD 0.76-1.46; production: ON A+-0.71..0.97, OFF A+-1.11..1.37, GndD A+-0.31")
