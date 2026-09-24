# klayout -b -r celldiff.py -rd a=<gdsA> -rd b=<gdsB> -rd pairs="cellA:cellB,cellA2:cellB2" [-rd c=<gdsC> -rd cpairs=...]
# per-layer XOR of hierarchically-collected shapes of cell pairs; prints area and bbox of differences.
import pya
def load(p):
    ly = pya.Layout(); ly.read(p); return ly
A = load(a); B = load(b)
def region(ly, cellname, li):
    c = ly.cell(cellname)
    return pya.Region(c.begin_shapes_rec(li))
def layers(ly):
    return {(ly.get_info(li).layer, ly.get_info(li).datatype): li for li in ly.layer_indexes()}
LA, LB = layers(A), layers(B)
for pair in pairs.split(","):
    ca, cb = pair.split(":")
    if A.cell(ca) is None or B.cell(cb) is None:
        print("MISSING", ca, A.cell(ca) is not None, cb, B.cell(cb) is not None); continue
    print("== %s (A) vs %s (B)  bboxA %s bboxB %s" % (ca, cb, A.cell(ca).bbox().to_s(), B.cell(cb).bbox().to_s()))
    tot = 0
    for ld in sorted(set(LA) | set(LB)):
        ra = region(A, ca, LA[ld]) if ld in LA else pya.Region()
        rb = region(B, cb, LB[ld]) if ld in LB else pya.Region()
        ra.merge(); rb.merge()
        onlyA = ra - rb; onlyB = rb - ra
        if onlyA.is_empty() and onlyB.is_empty(): continue
        tot += 1
        print("  layer %s/%s: A-only area %.3f um2 (%d polys, bbox %s) | B-only area %.3f um2 (%d polys, bbox %s)" % (
            ld[0], ld[1], onlyA.area()/1e6, onlyA.count(), onlyA.bbox().to_s(), onlyB.area()/1e6, onlyB.count(), onlyB.bbox().to_s()))
    if tot == 0: print("  IDENTICAL on all layers")
