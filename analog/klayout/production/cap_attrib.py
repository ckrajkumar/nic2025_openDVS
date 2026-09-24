"""Estimate, piece by piece, where the coupling capacitance between two pixel nets comes from, using the
Magic ngspice(si) coefficients (overlap aF/um2, sideoverlap aF/um, sidewall aF*um/(d+off)).
  klayout -b -r cap_attrib.py -rd a=nRst -rd b=vd [-rd halo=0.3]
Approximations: no shielding by intervening planes, fringe counted where the partner lies within `halo`
of an edge. Use it for ranking / rough magnitudes, calibrated against Magic's total."""
import pya, sys
sys.path.insert(0, "."); import opendvs_l2n
A, B = a, b; H = int(float(globals().get("halo", "0.3")) * 1000)
OVL = {("li","poly"):(94.16,51.85,25.14), ("met1","poly"):(44.81,46.72,16.69), ("met1","li"):(114.20,59.50,34.70),
       ("met2","poly"):(24.50,41.22,11.17), ("met2","li"):(37.56,46.28,21.74), ("met2","met1"):(133.86,67.05,48.19),
       ("met3","poly"):(16.06,43.53,9.18), ("met3","li"):(20.79,46.71,15.08), ("met3","met1"):(34.54,54.81,26.68), ("met3","met2"):(86.19,69.85,44.43)}
SW = {"poly":(16.0,0.0), "li":(25.5,0.14), "met1":(44.0,0.25), "met2":(50.0,0.30), "met3":(74.0,0.40)}
LAY = ["poly","li","met1","met2","met3"]
ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); px = ly.cell("openDVS_pixel")
l2n = opendvs_l2n.build_l2n(ly, px); top = l2n.netlist().top_circuit()
def shapes(name):
    n = [n for n in top.each_net() if n.name == name][0]
    return {ln: l2n.shapes_of_net(n, l2n.layer_by_name(ln), True).merged() for ln in LAY}
RA, RB = shapes(A), shapes(B)
def um(box): return "(%.2f,%.2f;%.2f,%.2f)" % (box.left/1e3, box.bottom/1e3, box.right/1e3, box.top/1e3)
items = []
# vertical: overlap + fringe (both orderings of which net is on the upper plane)
for (U, L), (c_ov, c_ul, c_lu) in OVL.items():
    for (X, xn), (Y, yn) in (((RA, A), (RB, B)), ((RB, B), (RA, A))):   # X on upper plane U, Y on lower plane L
        if X[U].is_empty() or Y[L].is_empty(): continue
        ov = X[U] & Y[L]
        for p in ov.each():
            items.append((p.area()/1e6*c_ov, "%s %s over %s %s  overlap %.3f um2" % (xn, U, yn, L, p.area()/1e6), p.bbox()))
        # fringe: edges of the upper shape with the lower net nearby (outside or under), and edges of the lower with the upper nearby
        e1 = X[U].edges() & Y[L].sized(H); e2 = Y[L].edges() & X[U].sized(H)
        for e, c, lab in ((e1, c_ul, "%s %s edge -> %s %s" % (xn, U, yn, L)), (e2, c_lu, "%s %s edge -> %s %s" % (yn, L, xn, U))):
            for m in e.merged().each():   # group by rough location: one item per merged edge
                items.append((m.length()/1e3*c, "%s  fringe %.2f um" % (lab, m.length()/1e3), m.bbox()))
# lateral, same plane
for ln, (c, off) in SW.items():
    if RA[ln].is_empty() or RB[ln].is_empty(): continue
    for ep in RA[ln].separation_check(RB[ln], H + 1).each():
        d = ep.distance()/1e3; L = min(ep.first.length(), ep.second.length())/1e3
        if L <= 0: continue
        items.append((L * c/(d+off), "%s %s || %s %s  sidewall run %.2f um at %.3f um" % (A, ln, B, ln, L, d), ep.bbox()))
items.sort(key=lambda t: -t[0]); tot = sum(t[0] for t in items)
print("== %s <-> %s : estimated total %.1f aF (%d pieces)" % (A, B, tot, len(items)))
for v, lab, bb in items:
    if v >= 3: print("   %6.1f aF  %4.0f%%  %-58s @ %s" % (v, 100*v/tot, lab, um(bb)))
print("   (pieces < 3 aF omitted: %.1f aF)" % sum(v for v, _, _ in items if v < 3))
