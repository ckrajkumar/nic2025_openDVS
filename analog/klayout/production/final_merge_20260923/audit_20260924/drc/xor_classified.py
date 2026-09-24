# klayout -b -r xor_classified.py -rd a=ORIG -rd b=NEW : deep full-layer XOR; residue split into inside pixel_4tile bbox,
# inside pixel_test_structure bbox, and elsewhere (elsewhere listed polygon by polygon, flattened).
import pya
A = pya.Layout(); A.read(a); B = pya.Layout(); B.read(b)
ta, tb = A.top_cell(), B.top_cell()
boxes = {}
for i in tb.each_inst():
    n = B.cell(i.cell_index).name
    if n in ("pixel_4tile", "pixel_test_structure"): boxes[n] = i.bbox()
for i in ta.each_inst():
    n = A.cell(i.cell_index).name
    if n in ("pixel_4tile", "pixel_test_structure"): print("A placement", n, i.dbbox(), " B:", boxes[n].to_dtype(B.dbu))
L = sorted({(i.layer,i.datatype) for i in A.layer_infos()} | {(i.layer,i.datatype) for i in B.layer_infos()})
dss = pya.DeepShapeStore(); dss.threads = 16
mP = pya.Region(boxes["pixel_4tile"]); mT = pya.Region(boxes["pixel_test_structure"])
tot_else = 0
for (l, d) in L:
    la = A.find_layer(l, d); lb = B.find_layer(l, d)
    ra = pya.Region(ta.begin_shapes_rec(la), dss) if la is not None else pya.Region()
    rb = pya.Region(tb.begin_shapes_rec(lb), dss) if lb is not None else pya.Region()
    x = ra ^ rb
    if x.is_empty(): continue

    inP = x & mP; inT = x & mT; rest = x - mP - mT
    rest.flatten(); rest.merge()
    print("L%d/%d: xor area inP %.3f inTS %.3f elsewhere %.5f um2 (elsewhere polys %d)" % (l, d, inP.area()*A.dbu**2, inT.area()*A.dbu**2, rest.area()*A.dbu**2, rest.count()))
    for p in rest.each():
        tot_else += 1
        inA = not (ra & pya.Region(p)).is_empty(); inB = not (rb & pya.Region(p)).is_empty()
        print("   ELSE L%d/%d %s area %.5f  %s" % (l, d, p.bbox().to_dtype(A.dbu), p.area()*A.dbu**2, "added" if inB and not inA else ("removed" if inA and not inB else "changed")))
print("elsewhere polygons total", tot_else)
# labels: flatten texts outside pixel_4tile/TS boxes, compare
for (l, d) in L:
    la = A.find_layer(l, d); lb = B.find_layer(l, d)
    def T(ly, t, li):
        if li is None: return set()
        out = set()
        it = t.begin_shapes_rec(li); it.shape_flags = pya.Shapes.STexts
        while not it.at_end():
            s = it.shape(); tt = s.text.transformed(it.trans())
            out.add((s.text_string, tt.x, tt.y)); it.next()
        return out
    sa, sb = T(A, ta, la), T(B, tb, lb)
    if sa != sb:
        def where(x, y):
            p = pya.Point(x, y)
            return "P4" if boxes["pixel_4tile"].contains(p) else ("TS" if boxes["pixel_test_structure"].contains(p) else "ELSE")
        rem = sa - sb; add = sb - sa
        print("L%d/%d labels: A %d B %d, removed %d added %d" % (l, d, len(sa), len(sb), len(rem), len(add)))
        for tag, S in (("-", rem), ("+", add)):
            cnt = {}
            for s, x, y in S: cnt[where(x, y)] = cnt.get(where(x, y), 0) + 1
            print("   %s by region %s" % (tag, cnt))
            for s, x, y in sorted(S):
                if where(x, y) == "ELSE": print("   %s ELSE '%s' at %.3f,%.3f" % (tag, s, x*A.dbu, y*A.dbu))
print("done")
