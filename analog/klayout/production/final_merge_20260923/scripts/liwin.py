# klayout -b -r liwin.py -rd fin=... -rd prod=... -rd r17=...   : polygons in the NE window of the pixel for the overlap analysis
import pya
def load(p):
    ly = pya.Layout(); ly.read(p); return ly
F, P, R = load(fin), load(prod), load(r17)
def lmap(ly): return {(ly.get_info(li).layer, ly.get_info(li).datatype): li for li in ly.layer_indexes()}
LF, LP, LR = lmap(F), lmap(P), lmap(R)
def reg(ly, cell, L, ld):
    if ld not in L: return pya.Region()
    r = pya.Region(ly.cell(cell).begin_shapes_rec(L[ld])); r.merge(); return r
win = pya.Region(pya.Box(8000, 7800, 11200, 12600))
names = {(64,20):"nwell",(65,20):"diff",(65,44):"tap",(66,20):"poly",(66,44):"licon",(67,20):"li",(67,44):"mcon",(68,20):"met1",(68,44):"via",(69,20):"met2",(93,44):"nsdm",(94,20):"psdm",(95,20):"npc"}
for ld, nm in names.items():
    f = reg(F,"GS_openDVS_pixel",LF,ld) & win; p = reg(P,"openDVS_pixel",LP,ld) & win; r = reg(R,"openDVS_pixel",LR,ld) & win
    print("== %s (%s/%s) in window: final %d polys, prod %d, r17b %d" % (nm, ld[0], ld[1], f.count(), p.count(), r.count()))
    for tag, rr in (("final-only(vs prod)", f-p), ("prod-only(vs final)", p-f), ("r17b-only(vs prod)", r-p), ("prod-only(vs r17b)", p-r)):
        for poly in rr.each():
            print("   %-22s %s  area %.3f" % (tag, poly.bbox().to_s(), poly.area()/1e6))
# exact overlap polygons on li
f = reg(F,"GS_openDVS_pixel",LF,(67,20)); p = reg(P,"openDVS_pixel",LP,(67,20)); r = reg(R,"openDVS_pixel",LR,(67,20))
ov = (f-p) & (r-p)
print("LI OVERLAP polys:"); 
for poly in ov.each(): print("   ", poly.to_s())
# what does the r17b li piece connect to: r17b mcon over it and met1 over the mcon; licon under it and diff/tap/poly under the licon
r17li = (r-p) & pya.Region(pya.Box(9800, 7900, 10800, 11500))
print("r17b li polys in 9.8-10.8 x 7.9-11.5:")
for poly in r17li.each(): print("   ", poly.to_s())
mc = reg(R,"openDVS_pixel",LR,(67,44)) & r17li.sized(10)
print("  r17b mcon on it:", [q.bbox().to_s() for q in mc.each()])
lc = reg(R,"openDVS_pixel",LR,(66,44)) & r17li.sized(10)
print("  r17b licon under it:", [q.bbox().to_s() for q in lc.each()])
m1 = reg(R,"openDVS_pixel",LR,(68,20)) & mc.sized(10)
print("  r17b met1 over those mcon:", [q.bbox().to_s() for q in m1.each()])
# the full r17b li polygon(s) that the piece belongs to
full = reg(R,"openDVS_pixel",LR,(67,20))
for poly in full.each():
    if not (pya.Region(poly) & r17li).is_empty(): print("  r17b full li polygon containing the piece:", poly.bbox().to_s(), "area %.3f" % (poly.area()/1e6))
# and the prod li polygons in the same place
for poly in p.each():
    if not (pya.Region(poly) & r17li.sized(200)).is_empty(): print("  prod li polygon near:", poly.bbox().to_s(), "area %.3f" % (poly.area()/1e6))
# S7 pixel vs prod pixel (test structure) — rotated? compare bbox-normalised via XOR after trying the 4 rotations
s7 = F.cell("S7_openDVS_pixel"); print("S7 pixel bbox", s7.bbox().to_s(), "children", [F.cell(i.cell_index).name for i in s7.each_inst()][:5])
for ld in [(65,20),(65,44),(66,44),(67,20),(68,20),(69,20),(70,20),(71,20),(93,44),(94,20)]:
    a = reg(F,"S7_openDVS_pixel",LF,ld); b = reg(P,"openDVS_pixel",LP,ld)
    best = None
    for t in [pya.Trans(0,False), pya.Trans(1,False), pya.Trans(2,False), pya.Trans(3,False), pya.Trans(0,True), pya.Trans(1,True), pya.Trans(2,True), pya.Trans(3,True)]:
        bt = b.transformed(t); d = pya.Point(a.bbox().left - bt.bbox().left, a.bbox().bottom - bt.bbox().bottom); bt = bt.moved(d)
        x = (a ^ bt).area()
        if best is None or x < best[0]: best = (x, t.to_s(), d.to_s())
    print("S7 %s/%s best xor area %.3f um2 with trans %s shift %s" % (ld[0], ld[1], best[0]/1e6, best[1], best[2]))
