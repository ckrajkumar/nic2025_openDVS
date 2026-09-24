# klayout -b -r celldiff_audit.py -rd a=ORIG.gds -rd b=NEW.gds
# Per-cell structural diff: cell lists, local shapes per layer (XOR of local regions), local texts, instance lists.
import pya, collections
A = pya.Layout(); A.read(a); B = pya.Layout(); B.read(b)
ta, tb = A.top_cell(), B.top_cell()
print("top:", ta.name, tb.name, "dbu", A.dbu, B.dbu, "cells", A.cells(), B.cells())
na = {c.name for c in A.each_cell()}; nb = {c.name for c in B.each_cell()}
print("cells only in A (%d):" % len(na-nb), sorted(na-nb))
print("cells only in B (%d):" % len(nb-na), sorted(nb-na))
LI = sorted({(i.layer,i.datatype) for i in A.layer_infos()} | {(i.layer,i.datatype) for i in B.layer_infos()})
print("layers only in A:", sorted({(i.layer,i.datatype) for i in A.layer_infos()} - {(i.layer,i.datatype) for i in B.layer_infos()}))
print("layers only in B:", sorted({(i.layer,i.datatype) for i in B.layer_infos()} - {(i.layer,i.datatype) for i in A.layer_infos()}))
def subtree(ly, name):
    c = ly.cell(name)
    if c is None: return set()
    s = {ly.cell(i).name for i in c.called_cells()}; s.add(name); return s
for root in ("pixel_4tile", "pixel_test_structure"):
    print("subtree %s: A %d cells, B %d cells" % (root, len(subtree(A,root)), len(subtree(B,root))))
subP = subtree(B,"pixel_4tile") | subtree(A,"pixel_4tile"); subT = subtree(B,"pixel_test_structure") | subtree(A,"pixel_test_structure")
def insts(ly, c):
    out = collections.Counter()
    for i in c.each_inst():
        ci = i.cell_inst
        out[(ly.cell(ci.cell_index).name, str(ci.trans) if not ci.is_complex() else str(ci.cplx_trans), ci.na, ci.nb, str(ci.a), str(ci.b))] += 1
    return out
def region(ly, c, l, d):
    li = ly.find_layer(l, d)
    return pya.Region(c.shapes(li)) if li is not None else pya.Region()
def texts(ly, c, l, d):
    li = ly.find_layer(l, d)
    if li is None: return []
    return sorted((s.text_string, s.text.x, s.text.y) for s in c.shapes(li).each() if s.is_text())
ndiff = 0
for name in sorted(na & nb):
    ca, cb = A.cell(name), B.cell(name)
    where = ("pixel_4tile-subtree" if name in subP else "") + ("pixel_test_structure-subtree" if name in subT else "")
    msgs = []
    for (l, d) in LI:
        x = region(A, ca, l, d) ^ region(B, cb, l, d)
        if not x.is_empty():
            bb = x.bbox().to_dtype(A.dbu)
            msgs.append("  L%d/%d: %d xor polys area %.5f um2 bbox %s" % (l, d, x.count(), x.area()*A.dbu**2, bb))
            if name == tb.name or where == "":
                for p in list(x.each())[:40]: msgs.append("      poly %s" % p.bbox().to_dtype(A.dbu))
        tA, tB = texts(A, ca, l, d), texts(B, cb, l, d)
        if tA != tB:
            sa, sb = set(tA), set(tB)
            msgs.append("  L%d/%d texts: -%d +%d  removed %s added %s" % (l, d, len(sa-sb), len(sb-sa), [(s,x*A.dbu,y*A.dbu) for s,x,y in sorted(sa-sb)][:10], [(s,x*B.dbu,y*B.dbu) for s,x,y in sorted(sb-sa)][:10]))
    ia, ib = insts(A, ca), insts(B, cb)
    if ia != ib:
        rem = ia - ib; add = ib - ia
        msgs.append("  instances: A %d B %d; removed %d added %d" % (sum(ia.values()), sum(ib.values()), sum(rem.values()), sum(add.values())))
        for k in list(rem)[:15]: msgs.append("    - %s x%d" % (k, rem[k]))
        for k in list(add)[:15]: msgs.append("    + %s x%d" % (k, add[k]))
    if msgs:
        ndiff += 1
        print("CELL %s [%s] bboxA %s bboxB %s" % (name, where or "OTHER", ca.dbbox(), cb.dbbox())); print("\n".join(msgs))
print("common cells with differences:", ndiff)
# cells only in B: where are they used
for name in sorted(nb-na):
    c = B.cell(name); parents = {B.cell(p).name for p in c.each_parent_cell()}
    print("NEWCELL %s parents %s in4tile %s inTS %s bbox %s" % (name, sorted(parents)[:5], name in subP, name in subT, c.dbbox()))
for name in sorted(na-nb):
    c = A.cell(name); parents = {A.cell(p).name for p in c.each_parent_cell()}
    print("GONECELL %s parents %s in4tile %s inTS %s" % (name, sorted(parents)[:5], name in subP, name in subT))
# top-level instances
print("top instances: A %d B %d" % (ta.child_instances(), tb.child_instances()))
for nm, ly, t in (("A", A, ta), ("B", B, tb)):
    for i in t.each_inst():
        if ly.cell(i.cell_index).name in ("pixel_4tile", "pixel_test_structure"): print(nm, "placement", ly.cell(i.cell_index).name, i.dcplx_trans, i.dbbox())
# zero-width / degenerate shapes in B, per cell
for c in B.each_cell():
    for li in B.layer_indexes():
        for s in c.shapes(li).each():
            if s.is_box() and (s.box.width() == 0 or s.box.height() == 0): print("ZERO box", c.name, B.get_info(li), s.dbox)
            elif s.is_path() and s.path.width <= 0: print("ZERO path", c.name, B.get_info(li), s.dbbox())
            elif s.is_polygon() and s.polygon.area() == 0: print("ZERO poly", c.name, B.get_info(li), s.dbbox())
print("done")
