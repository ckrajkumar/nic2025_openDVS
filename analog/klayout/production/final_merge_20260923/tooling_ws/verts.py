import pya
def load(p):
    ly = pya.Layout(); ly.read(p); return ly
F, P, R = load(fin), load(prod), load(r17)
def lmap(ly): return {(ly.get_info(li).layer, ly.get_info(li).datatype): li for li in ly.layer_indexes()}
LF, LP, LR = lmap(F), lmap(P), lmap(R)
def reg(ly, cell, L, ld):
    if ld not in L: return pya.Region()
    r = pya.Region(ly.cell(cell).begin_shapes_rec(L[ld])); r.merge(); return r
win = pya.Region(pya.Box(8000, 7500, 11500, 12600))
for ld, nm in [((65,44),"tap"),((67,20),"li"),((66,44),"licon"),((93,44),"nsdm"),((94,20),"psdm"),((64,20),"nwell"),((65,20),"diff")]:
    f = reg(F,"GS_openDVS_pixel",LF,ld); p = reg(P,"openDVS_pixel",LP,ld); r = reg(R,"openDVS_pixel",LR,ld)
    print("== %s fixAdd polygons (full):" % nm)
    for poly in (f-p).each():
        if not (pya.Region(poly) & win).is_empty(): print("   ", poly.to_s())
    print("== %s prod polygons touching window:" % nm)
    for poly in p.each():
        if not (pya.Region(poly) & win).is_empty() and nm in ("li","tap","nwell","nsdm","psdm","diff"): print("   ", poly.to_s()[:400])
    print("== %s r17b-only polygons touching window:" % nm)
    for poly in (r-p).each():
        if not (pya.Region(poly) & win).is_empty(): print("   ", poly.to_s()[:400])
