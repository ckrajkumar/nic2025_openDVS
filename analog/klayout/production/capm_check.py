"""capm/met3 spacing audit + vd-vdiff parasitic geometry.  klayout -b -r capm_check.py [-rd gds=...]"""
import pya, sys
sys.path.insert(0, "."); import opendvs_l2n
ly = pya.Layout(); ly.read(globals().get("gds", "pixel_4tile_work.gds")); px = ly.cell("openDVS_pixel")
l2n = opendvs_l2n.build_l2n(ly, px); top = l2n.netlist().top_circuit()
def R(l, d):
    li = ly.find_layer(l, d); return pya.Region() if li is None else pya.Region(px.begin_shapes_rec(li)).merged()
capm = R(89, 44); met3 = R(70, 20); met4 = R(71, 20)
plates = {n: pya.Region(b) for n, b in (("C1a", pya.Box(2610, 870, 6595, 3140)), ("C1b", pya.Box(2610, 9120, 9080, 10625)), ("C2", pya.Box(8080, 870, 9080, 1870)))}
def netshapes(ln, net):
    for n in top.each_net():
        if n.name == net: return l2n.shapes_of_net(n, l2n.layer_by_name(ln), True)
    return pya.Region()
vsf3 = netshapes("met3", "vsf"); vdiff3 = netshapes("met3", "vdiff"); vd4 = netshapes("met4", "vd")
print("== capm plates: distance to nearest met3 NOT part of their own bottom plate net")
for name, p in plates.items():
    own = vsf3 if name != "C2" else vdiff3
    others = met3 - own
    for grow in (500, 840, 1200, 1340, 1500):
        hit = (p.sized(grow) & others)
        if not hit.is_empty():
            print("  %s: unrelated met3 within %.2f um: %s" % (name, grow / 1e3, [q.bbox().to_s() for q in hit.each()][:3])); break
    else: print("  %s: no unrelated met3 within 1.5 um" % name)
    # exact edge distance via successive sizing
    d = 0
    while d < 2000 and (p.sized(d) & others).is_empty(): d += 5
    print("     min distance capm -> unrelated met3 = %.3f um" % (d / 1e3))
# bottom plates (met3 interacting with capm) to unrelated met3 (capm.2b 1.2)
bp = met3.interacting(capm)
print("== met3 polygons touching capm (bottom plates):", [q.bbox().to_s() for q in bp.each()])
for q in bp.each():
    others = met3 - pya.Region(q); d = 0
    while d < 2000 and (pya.Region(q).sized(d) & others).is_empty(): d += 5
    hit = pya.Region(q).sized(d) & others
    print("  bottom plate %s: nearest other met3 at %.3f um: %s" % (q.bbox().to_s(), d / 1e3, [h.bbox().to_s() for h in hit.each()][:3]))
print("== vd met4 over vdiff met3 (outside capm):", "%.3f um2" % (((vd4 & vdiff3) - capm).area() / 1e6), [q.bbox().to_s() for q in ((vd4 & vdiff3) - capm).each()])
print("== vd met4 over vdiff met3 (over capm C2, the device contact region):", "%.3f um2" % (((vd4 & vdiff3) & capm).area() / 1e6))
vdiff2 = netshapes("met2", "vdiff"); print("== vd met4 over vdiff met2:", "%.3f um2" % ((vd4 & vdiff2).area() / 1e6), [q.bbox().to_s() for q in (vd4 & vdiff2).each()][:4])
for ln in ("li", "met1", "met2", "met3"):
    a = netshapes(ln, "vd"); b = netshapes(ln, "vdiff")
    near = a.sized(150) & b
    if not near.is_empty(): print("== vd/vdiff same-layer proximity <0.15 um on %s: %s" % (ln, [q.bbox().to_s() for q in near.each()][:5]))
