# klayout -b -r overlap.py -rd fin=<final gds> -rd prod=<prod tile gds> -rd r17=<r17b tile gds>
# Exact overlap test between the foundry fix delta (final vs prod) and the r17b delta (r17b vs prod) in the pixel cell.
import pya
def load(p):
    ly = pya.Layout(); ly.read(p); return ly
F, P, R = load(fin), load(prod), load(r17)
def lmap(ly): return {(ly.get_info(li).layer, ly.get_info(li).datatype): li for li in ly.layer_indexes()}
LF, LP, LR = lmap(F), lmap(P), lmap(R)
def reg(ly, cell, L, ld):
    if ld not in L: return pya.Region()
    r = pya.Region(ly.cell(cell).begin_shapes_rec(L[ld])); r.merge(); return r
lds = sorted(set(LF) | set(LP) | set(LR))
print("layer | fixAdd fixDel | r17Add r17Del | overlaps: fixAdd&r17Add fixAdd&r17Del fixDel&r17Add fixDel&r17Del | fixAdd touching r17 delta (0.14um)")
tot = 0
for ld in lds:
    f = reg(F, "GS_openDVS_pixel", LF, ld); p = reg(P, "openDVS_pixel", LP, ld); r = reg(R, "openDVS_pixel", LR, ld)
    fa, fd = f - p, p - f
    ra, rd = r - p, p - r
    if (fa.is_empty() and fd.is_empty()) or (ra.is_empty() and rd.is_empty()):
        continue
    o = [(fa & ra).area(), (fa & rd).area(), (fd & ra).area(), (fd & rd).area()]
    near = (fa + fd).sized(140) & (ra + rd)
    print("%s/%s | %.3f %.3f | %.3f %.3f | %s | near-area %.3f (%d polys) %s" % (ld[0], ld[1], fa.area()/1e6, fd.area()/1e6, ra.area()/1e6, rd.area()/1e6, ["%.3f"%(x/1e6) for x in o], near.area()/1e6, near.count(), near.bbox().to_s()))
    tot += sum(o)
print("TOTAL exact overlap area um2:", tot/1e6)
# print the fix polygons explicitly for the small layers (tap, licon, li, psdm, nsdm, diff)
for ld in [(65,20),(65,44),(66,44),(67,20),(93,44),(94,20),(33,24)]:
    f = reg(F, "GS_openDVS_pixel", LF, ld); p = reg(P, "openDVS_pixel", LP, ld)
    for name, rr in (("fixAdd", f-p), ("fixDel", p-f)):
        for poly in rr.each():
            print("  %s %s/%s %s" % (name, ld[0], ld[1], poly.bbox().to_s()))
# met4 in the 2x2: prod vs r17b
for ld in [(71,20),(71,16),(69,16)]:
    p = reg(P, "openDVS_pixel2x2_top", LP, ld); r = reg(R, "openDVS_pixel2x2_top", LR, ld)
    print("2x2 layer %s/%s prod polys:" % ld)
    for poly in (p - r).each(): print("   prod-only", poly.bbox().to_s(), "area %.2f" % (poly.area()/1e6))
    for poly in (r - p).each(): print("   r17b-only", poly.bbox().to_s(), "area %.2f" % (poly.area()/1e6))
