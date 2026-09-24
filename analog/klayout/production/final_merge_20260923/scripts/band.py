import pya
def load(p):
    ly = pya.Layout(); ly.read(p); return ly
F, P, R = load(fin), load(prod), load(r17)
def lmap(ly): return {(ly.get_info(li).layer, ly.get_info(li).datatype): li for li in ly.layer_indexes()}
LF, LP, LR = lmap(F), lmap(P), lmap(R)
def rec(ly, cell, L, ld):
    if ld not in L: return pya.Region()
    r = pya.Region(ly.cell(cell).begin_shapes_rec(L[ld])); r.merge(); return r
def own(ly, cell, L, ld, plus=()):
    r = pya.Region()
    if ld in L:
        r.insert(ly.cell(cell).shapes(L[ld]))
        for inst in ly.cell(cell).each_inst():
            ch = ly.cell(inst.cell_index)
            if ch.name in plus: r += pya.Region(pya.RecursiveShapeIterator(ly, ch, L[ld])).transformed(inst.trans)
    r.merge(); return r
band = pya.Region(pya.Box(-21000, -800, 9000, 450))
print("== 2x2-level foundry additions (GS_openDVS_pixel2x2_top own+vias_gen$4 minus prod own) exact polygons")
for ld, nm in [((65,44),"tap"),((67,20),"li"),((66,44),"licon"),((94,20),"psdm"),((93,44),"nsdm"),((65,20),"diff")]:
    fa = own(F,"GS_openDVS_pixel2x2_top",LF,ld,("vias_gen$4",)) - own(P,"openDVS_pixel2x2_top",LP,ld)
    for poly in fa.each():
        s = poly.to_s(); print("  %s fixAdd %s" % (nm, s if len(s) < 300 else poly.bbox().to_s() + " (%d pts)" % poly.num_points()))
    if nm == "licon": print("  licon xs:", sorted(set(q.bbox().left for q in fa.each()))[:40], "ys:", sorted(set((q.bbox().bottom, q.bbox().top) for q in fa.each())))
print("== r17b flat 2x2 shapes in the band y -800..450 (per layer, polygons clipped to band)")
for ld, nm in [((65,20),"diff"),((65,44),"tap"),((93,44),"nsdm"),((94,20),"psdm"),((67,20),"li"),((66,44),"licon"),((66,20),"poly"),((68,20),"met1"),((67,44),"mcon"),((64,20),"nwell")]:
    r = rec(R,"openDVS_pixel2x2_top",LR,ld) & band; p = rec(P,"openDVS_pixel2x2_top",LP,ld) & band
    print("  %-5s r17b %d polys: %s" % (nm, r.count(), "; ".join(q.bbox().to_s() for q in r.each())[:900]))
    d = (r - p); 
    if not d.is_empty(): print("        r17b-only: %s" % "; ".join(q.bbox().to_s() for q in d.each())[:600])
    d = (p - r)
    if not d.is_empty(): print("        prod-only: %s" % "; ".join(q.bbox().to_s() for q in d.each())[:600])
print("== contact$26$1$1: r17b vs prod per layer")
for ld in sorted(set(LR)|set(LP)):
    d = rec(R,"contact$26$1$1",LR,ld) ^ rec(P,"contact$26$1$1",LP,ld)
    if not d.is_empty(): print("  %s/%s xor %.4f um2: r17b-only %s prod-only %s" % (ld[0], ld[1], d.area()/1e6, [q.bbox().to_s() for q in (rec(R,"contact$26$1$1",LR,ld)-rec(P,"contact$26$1$1",LP,ld)).each()], [q.bbox().to_s() for q in (rec(P,"contact$26$1$1",LP,ld)-rec(R,"contact$26$1$1",LR,ld)).each()]))
print("contact$26 instances in r17b 2x2_top:", [i.trans.to_s() for i in R.cell("openDVS_pixel2x2_top").each_inst() if R.cell(i.cell_index).name == "contact$26$1$1"])
