"""Where do two pixel nets run close to each other?  klayout -b -r proximity.py -rd a=nRst -rd b=vd [-rd d=0.3]
Reports, per layer pair, the pieces of net B within distance d (um) of net A (same layer, lateral) and the
vertical overlaps / near-overlaps between adjacent metal layers, with bboxes in pixel coordinates (um)."""
import pya, sys
sys.path.insert(0, "."); import opendvs_l2n
A, B = a, b; D = int(float(globals().get("d", "0.3")) * 1000)
ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); px = ly.cell("openDVS_pixel")
l2n = opendvs_l2n.build_l2n(ly, px); top = l2n.netlist().top_circuit()
LAY = ["poly", "li", "met1", "met2", "met3", "met4"]
def shapes(name):
    n = [n for n in top.each_net() if n.name == name][0]
    return {ln: l2n.shapes_of_net(n, l2n.layer_by_name(ln), True) for ln in LAY}
ra, rb = shapes(A), shapes(B)
def um(box): return "(%.2f,%.2f;%.2f,%.2f)" % (box.left / 1e3, box.bottom / 1e3, box.right / 1e3, box.top / 1e3)
print("== %s vs %s, lateral within %.2f um (same layer)" % (A, B, D / 1e3))
for ln in LAY:
    if ra[ln].is_empty() or rb[ln].is_empty(): continue
    near = rb[ln].sized(D) & ra[ln].sized(0)          # part of A within D of B
    for p in near.merged().each():
        # parallel run length estimate = bbox long side
        bb = p.bbox(); print("   %-5s A-piece near B  bbox %s  run ~%.2f um" % (ln, um(bb), max(bb.width(), bb.height()) / 1e3))
print("== vertical overlap / near-overlap between adjacent layers (A over/under B), lateral margin %.2f um" % (D / 1e3))
pairs = [("poly", "li"), ("li", "met1"), ("met1", "met2"), ("met2", "met3"), ("met3", "met4"), ("poly", "met1"), ("li", "met2"), ("met1", "met3")]
for lo, hi in pairs:
    for (x, xl), (y, yl) in (((ra, A), (rb, B)), ((rb, B), (ra, A))):
        if x[lo].is_empty() or y[hi].is_empty(): continue
        ov = x[lo] & y[hi]
        for p in ov.merged().each(): print("   %s on %-5s under %s on %-5s : overlap bbox %s area %.3f um2" % (xl, lo, yl, hi, um(p.bbox()), p.area() / 1e6))
        nr = (x[lo].sized(D) & y[hi]) - ov
        for p in nr.merged().each(): print("   %s on %-5s beside %s on %-5s (within %.2f): bbox %s" % (xl, lo, yl, hi, D / 1e3, um(p.bbox())))
