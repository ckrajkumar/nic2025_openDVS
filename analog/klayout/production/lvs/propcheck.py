import pya
A = pya.Layout(); A.read("pixel_4tile_mag_9_1_pruned.gds"); B = pya.Layout(); B.read("pixel_4tile_work.gds")
ca, cb = {c.name for c in A.each_cell()}, {c.name for c in B.each_cell()}
print("   cells %d -> %d; new: %s; removed: %s" % (len(ca), len(cb), sorted(cb - ca), sorted(ca - cb)))
def own(ly, c): return {(ly.get_info(l).layer, ly.get_info(l).datatype): pya.Region(c.shapes(l)) for l in ly.layer_indexes() if c.shapes(l).size()}
def insts(c): return sorted((i.cell.name, str(i.trans)) for i in c.each_inst())
for name in sorted(ca & cb):
    a, b = A.cell(name), B.cell(name); oa, ob = own(A, a), own(B, b); d = []
    for k in sorted(set(oa) | set(ob)):
        x = oa.get(k, pya.Region()) ^ ob.get(k, pya.Region())
        if not x.is_empty(): d.append("%d/%d %d->%d shapes, xor %.3f um2 at %s" % (k[0], k[1], oa.get(k, pya.Region()).count(), ob.get(k, pya.Region()).count(), x.area() / 1e6, x.bbox()))
    if d or insts(a) != insts(b):
        print("   CHANGED", name); [print("      " + s) for s in d]
        if insts(a) != insts(b): print("      instances changed")
for n in ("openDVS_pixel_4x4", "pixel_layout_tile", "pixel_layout_tile_bot"):
    c = B.cell(n); print("   %s -> %s" % (n, sorted({i.cell.name for i in c.each_inst() if "pixel2x2" in i.cell.name})))
