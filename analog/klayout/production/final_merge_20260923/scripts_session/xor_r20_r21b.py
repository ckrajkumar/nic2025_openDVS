# klayout -b -r xor_r20_r21b.py -rd a=r20/user_project_wrapper.gds -rd b=r21b/user_project_wrapper.gds
# Full-layer XOR of two wrappers (Mitch's request, 2026-09-23 20:01): every layer/datatype present in either file, deep (hierarchical) mode.
# Prints, per layer with differences, the count and bounding boxes of the XOR polygons; also compares the cell/instance structure.
import pya
A = pya.Layout(); A.read(a); B = pya.Layout(); B.read(b)
ta, tb = A.top_cell(), B.top_cell()
print("top cells:", ta.name, tb.name, "| cells:", A.cells(), B.cells())
def infos(ly): return {(i.layer, i.datatype) for i in ly.layer_infos()}
L = sorted(infos(A) | infos(B))
dss = pya.DeepShapeStore(); dss.threads = 16
tot = 0
for (l, d) in L:
    la = A.find_layer(l, d); lb = B.find_layer(l, d)
    ra = pya.Region(ta.begin_shapes_rec(la), dss) if la is not None else pya.Region()
    rb = pya.Region(tb.begin_shapes_rec(lb), dss) if lb is not None else pya.Region()
    x = ra ^ rb
    n = x.count()
    if n:
        tot += n
        polys = [p.bbox() for p in x.each()][:6]
        print("layer %d/%d: %d xor polygons, area %.4f um2: %s" % (l, d, n, x.area() * A.dbu * A.dbu, [str(p.to_dtype(A.dbu)) for p in polys]))
# texts (labels) on every layer
for (l, d) in L:
    la = A.find_layer(l, d); lb = B.find_layer(l, d)
    tA = sorted((t.string, t.x, t.y) for t in pya.Texts(ta.begin_shapes_rec(la)).each()) if la is not None else []
    tB = sorted((t.string, t.x, t.y) for t in pya.Texts(tb.begin_shapes_rec(lb)).each()) if lb is not None else []
    if tA != tB: print("layer %d/%d: label difference %d vs %d" % (l, d, len(tA), len(tB)))
print("layers compared:", len(L), "| total xor polygons:", tot)
