import pya
def load(p):
    ly = pya.Layout(); ly.read(p); return ly
F, P, R = load(fin), load(prod), load(r17)
def lmap(ly): return {(ly.get_info(li).layer, ly.get_info(li).datatype): li for li in ly.layer_indexes()}
LF, LP, LR = lmap(F), lmap(P), lmap(R)
def reg(ly, cell, L, ld):
    if ld not in L: return pya.Region()
    r = pya.Region(ly.cell(cell).begin_shapes_rec(L[ld])); r.merge(); return r
# 1. density tiles vs r17b met1/met2 spacing (0.14)
for ld, nm in [((68,20),"met1"),((69,20),"met2")]:
    f = reg(F,"GS_openDVS_pixel",LF,ld); p = reg(P,"openDVS_pixel",LP,ld); r = reg(R,"openDVS_pixel",LR,ld)
    tiles = f - p
    bad = tiles.sized(139) & r
    print("%s: %d tiles; tiles within 0.14 of r17b %s: %d polys area %.4f; within 0.14 of prod %s: %d" % (nm, tiles.count(), nm, bad.count(), bad.area()/1e6, nm, (tiles.sized(139) & p).count()))
    for t in tiles.each():
        if not (pya.Region(t).sized(139) & r).is_empty(): print("   tile", t.bbox().to_s(), "near r17b", [q.bbox().to_s() for q in (pya.Region(t).sized(139) & r).each()][:3])
    print("   tile sample", [t.bbox().to_s() for t in list(tiles.each())[:3]])
# 2. 2x2 own shapes (excluding the pixel instances) final vs prod vs r17b
def own_plus_nonpixel(ly, cellname, L, ld, pixname):
    c = ly.cell(cellname); r = pya.Region()
    if ld in L:
        r.insert(c.shapes(L[ld]))
        for inst in c.each_inst():
            child = ly.cell(inst.cell_index)
            if child.name == pixname: continue
            for s in child.begin_shapes_rec(L[ld]):
                pass
            rr = pya.Region(child.begin_shapes_rec(L[ld])); rr.transform(inst.cplx_trans) if False else None
            # collect child shapes transformed by the instance
            ri = pya.RecursiveShapeIterator(ly, child, L[ld]); rc = pya.Region(ri); rc = rc.transformed(inst.trans)
            r += rc
    r.merge(); return r
lds = sorted(set(LF) | set(LP) | set(LR))
print("== 2x2 own+contacts (no pixel instances): final vs prod, r17b vs prod")
for ld in lds:
    f = own_plus_nonpixel(F, "GS_openDVS_pixel2x2_top", LF, ld, "GS_openDVS_pixel")
    p = own_plus_nonpixel(P, "openDVS_pixel2x2_top", LP, ld, "openDVS_pixel")
    r = own_plus_nonpixel(R, "openDVS_pixel2x2_top", LR, ld, "openDVS_pixel")
    d1 = (f ^ p).area(); d2 = (r ^ p).area()
    if d1 or d2: print("  %s/%s: final^prod %.3f (f %d p %d)   r17b^prod %.3f (r %d)" % (ld[0], ld[1], d1/1e6, f.count(), p.count(), d2/1e6, r.count()))
# 3. texts in the r17b 2x2 and pixel
for ly, cn, tag in ((R,"openDVS_pixel2x2_top","r17b 2x2"),(R,"openDVS_pixel","r17b pixel"),(F,"GS_openDVS_pixel2x2_top","final 2x2"),(F,"GS_openDVS_pixel","final pixel")):
    c = ly.cell(cn); n = 0; layers = {}
    for li in ly.layer_indexes():
        for s in c.shapes(li).each():
            if s.is_text(): n += 1; k = (ly.get_info(li).layer, ly.get_info(li).datatype); layers[k] = layers.get(k, 0) + 1
    print(tag, "texts:", n, layers)
# 4. instance transforms of the pixel in the 2x2 (final vs r17b)
for ly, cn, pn, tag in ((F,"GS_openDVS_pixel2x2_top","GS_openDVS_pixel","final"),(R,"openDVS_pixel2x2_top","openDVS_pixel","r17b"),(F,"S7_openDVS_pixel2x2_bot","S7_openDVS_pixel","S7")):
    c = ly.cell(cn); print(tag, "pixel insts:", [i.trans.to_s() for i in c.each_inst() if ly.cell(i.cell_index).name == pn], "other insts:", sorted(set(ly.cell(i.cell_index).name for i in c.each_inst() if ly.cell(i.cell_index).name != pn)))
