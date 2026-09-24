# klayout -b -r r20_build.py -rd src=<r19 wrapper> -rd dst=<r20 wrapper>
# r20 = r19 + wrapper-level same-net joins:
#  (a) every vdda1 vertical met4 PDN stripe ending at the tile's top/bottom edge is extended through the periphery into the array until it
#      overlaps VddA18 met4 by >= 0.3 um; where other-net met4 sits in the way the last stretch is narrowed (>= 0.3 um wide) to keep 0.3 um
#      clearance, as in Rui's hand edit at x 1263;
#  (b) every vssa1 met5 PDN stripe ending at a side bar inside the GndA plane's y-range is extended onto the plane.
# Nets come from a full-layer extraction with labels; after the edit every join is re-probed and the power-net pin sets must be unchanged.
import pya, re
ly = pya.Layout(); ly.read(src); top = ly.top_cell()
tc = ly.cell("pixel_4tile"); inst = [i for i in top.each_inst() if i.cell.name == "pixel_4tile"][0]; T = inst.cplx_trans; tb = tc.bbox().transformed(T)
plane = pya.Box(1206885, 715715, 2748265, 2274055)
L = {"li":(67,20),"mcon":(67,44),"met1":(68,20),"via1":(68,44),"met2":(69,20),"via2":(69,44),"met3":(70,20),"via3":(70,44),"met4":(71,20),"via4":(71,44),"met5":(72,20)}
Tx = {"li":(67,5),"met1":(68,5),"met2":(69,5),"met3":(70,5),"met4":(71,5),"met5":(72,5)}
def extract():
    l2n = pya.LayoutToNetlist(pya.RecursiveShapeIterator(ly, top, [])); reg = {}
    for k,(a,b) in L.items():
        li = ly.find_layer(a,b); reg[k] = l2n.make_layer(li, k) if li is not None else l2n.make_layer(k)
    for k,(a,b) in Tx.items():
        li = ly.find_layer(a,b)
        if li is not None: l2n.connect(reg[k], l2n.make_text_layer(li, k+"_lbl"))
    for k in ["li","met1","met2","met3","met4","met5"]: l2n.connect(reg[k])
    for a,v,b in [("li","mcon","met1"),("met1","via1","met2"),("met2","via2","met3"),("met3","via3","met4"),("met4","via4","met5")]: l2n.connect(reg[a],reg[v]); l2n.connect(reg[v],reg[b])
    l2n.extract_netlist(); return l2n, reg, l2n.netlist().circuit_by_name(top.name)
def pinset(net):
    return set(sp.subcircuit().circuit_ref().name + ":" + (sp.subcircuit().circuit_ref().net_for_pin(sp.pin().id()).expanded_name() if sp.subcircuit().circuit_ref().net_for_pin(sp.pin().id()) else "?") for sp in net.each_subcircuit_pin())
l2n, reg, c = extract()
nets = {n.expanded_name(): n for n in c.each_net() if n.expanded_name() in ("vdda1","vssa1")}
before = {k: pinset(v) for k, v in nets.items()}
SP = 300; MAXD = 40000
own4 = l2n.shapes_of_net(nets["vdda1"], reg["met4"], True); all4 = pya.Region(top.begin_shapes_rec(ly.layer(*L["met4"]))); other4 = all4 - own4
own5 = l2n.shapes_of_net(nets["vssa1"], reg["met5"], True); all5 = pya.Region(top.begin_shapes_rec(ly.layer(*L["met5"]))); other5 = all5 - own5
def clear(box, other): return (pya.Region(box).sized(SP) & other).is_empty()
def reaches(box, own): return not (pya.Region(box).sized(1) & own).is_empty()
adds = []; notes = []
m4top = l2n.shapes_of_net(nets["vdda1"], reg["met4"], False)
for p in m4top.each():
    b = p.bbox()
    if b.height() < 30000 or b.width() > 5000 or not (tb.left < b.left < tb.right): continue
    if abs(b.bottom - tb.top) < 20000: edge, dirn, start = plane.top, -1, b.bottom
    elif abs(b.top - tb.bottom) < 20000: edge, dirn, start = plane.bottom, +1, b.top
    else: continue
    def mk(x1, x2, ya, yb): return pya.Box(x1, min(ya, yb), x2, max(ya, yb))
    # 1. full-width box as deep as it stays clear
    dfull = 0
    for d in range(0, MAXD + 1, 50):
        if clear(mk(b.left, b.right, start, edge + dirn*d), other4): dfull = d
        else: break
    full = mk(b.left, b.right, start, edge + dirn*dfull)
    if reaches(full, own4) and (pya.Region(full) & own4).bbox().height() >= SP:
        adds.append(("met4", full, "vdda1")); notes.append("x %.1f %s: full width to %.2f um" % (b.left/1e3, "top" if dirn<0 else "bot", dfull/1e3)); continue
    # 2. narrowed continuation: try widths and x offsets, deepen until it overlaps own met4 by >= 0.3 um
    found = None
    for w in (1200, 960, 800, 600, 400, 300):
        for xa in range(b.left, b.right - w + 1, 40):
            xb = xa + w; yf = edge + dirn*dfull
            for d in range(dfull, MAXD + 1, 50):
                nb = mk(xa, xb, yf, edge + dirn*d)
                if not clear(nb, other4): break
                ov = pya.Region(nb) & own4
                if not ov.is_empty() and ov.bbox().height() >= SP: found = (nb, d); break
            if found: break
        if found: break
    if found:
        nb, d = found
        if dfull > 0: adds.append(("met4", full, "vdda1"))
        else:  # still need the stretch from the stripe end to the array edge at full width
            adds.append(("met4", mk(b.left, b.right, start, edge), "vdda1"))
        adds.append(("met4", nb, "vdda1")); notes.append("x %.1f %s: full to %.2f um, then %.2f um wide to %.2f um" % (b.left/1e3, "top" if dirn<0 else "bot", dfull/1e3, nb.width()/1e3, d/1e3))
    else: notes.append("x %.1f %s: NO clean path found" % (b.left/1e3, "top" if dirn<0 else "bot"))
m5top = l2n.shapes_of_net(nets["vssa1"], reg["met5"], False)
for p in m5top.each():
    b = p.bbox()
    if b.width() < 30000 or b.height() > 5000 or not (plane.bottom < b.bottom < plane.top): continue
    if tb.left < b.right < plane.left: box = pya.Box(b.right, b.bottom, plane.left, b.top)
    elif plane.right < b.left < tb.right: box = pya.Box(plane.right, b.bottom, b.left, b.top)
    else: continue
    if clear(box, other5) and reaches(box, own5): adds.append(("met5", box, "vssa1"))
    else: notes.append("met5 stub at y %.1f skipped" % (b.bottom/1e3))
for n_ in notes: print("  ", n_)
print("joins to add:", {k: sum(1 for a in adds if a[0]==k) for k in ("met4","met5")})
for lay, box, net in adds: top.shapes(ly.layer(*L[lay])).insert(box)
l2n, reg, c = extract()
nets = {n.expanded_name(): n for n in c.each_net() if n.expanded_name() in ("vdda1","vssa1")}
after = {k: pinset(v) for k, v in nets.items()}; ok = True
for lay, box, net in adds:
    n = l2n.probe_net(reg[lay], pya.DPoint(box.center().x*ly.dbu, box.center().y*ly.dbu)); nm = n.expanded_name() if n else None
    if nm != net: ok = False; print("   BAD join", lay, box.to_s(), "-> net", nm)
for k in after:
    if after[k] != before[k]: ok = False; print("   pin set changed on", k, sorted(after[k] ^ before[k]))
pw = sorted(n.expanded_name() for n in c.each_net() if re.search(r"^(vdda1|vdda2|vssa1|vssa2|vssd1|vssd2|vccd1|vccd2)$", n.expanded_name()))
print("power nets present:", pw, "verification", "OK" if ok else "FAILED")
if ok and len(pw) == 8:
    ly.write(dst); print("wrote", dst, "with", len(adds), "shapes")
    for lay, box, net in adds: print("   %s %s %s  %.2f x %.2f um" % (net, lay, box.to_s(), box.width()/1e3, box.height()/1e3))
