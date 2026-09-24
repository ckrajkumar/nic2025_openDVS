# klayout -b -r bias_nbrs2.py -rd gds=<wrapper> : per bias net, every neighbouring top-level wire within 0.35 um (same layer): net, layer, parallel length,
# min spacing, the neighbour's driving/attached cell pins; plus pin locations (tile dac_config pins, BiasBranchnMasterx11 Bias pins) and met5 usage
import pya, re, collections
ly = pya.Layout(); ly.read(gds); top = ly.top_cell()
L = {"li":(67,20),"mcon":(67,44),"met1":(68,20),"via1":(68,44),"met2":(69,20),"via2":(69,44),"met3":(70,20),"via3":(70,44),"met4":(71,20),"via4":(71,44),"met5":(72,20)}
Tx = {"li":(67,5),"met1":(68,5),"met2":(69,5),"met3":(70,5),"met4":(71,5),"met5":(72,5)}
l2n = pya.LayoutToNetlist(pya.RecursiveShapeIterator(ly, top, [])); reg = {}
for k,(a,b) in L.items():
    li = ly.find_layer(a,b); reg[k] = l2n.make_layer(li, k) if li is not None else l2n.make_layer(k)
for k,(a,b) in Tx.items():
    li = ly.find_layer(a,b)
    if li is not None: l2n.connect(reg[k], l2n.make_text_layer(li, k+"_lbl"))
for k in ["li","met1","met2","met3","met4","met5"]: l2n.connect(reg[k])
for a,v,b in [("li","mcon","met1"),("met1","via1","met2"),("met2","via2","met3"),("met3","via3","met4"),("met4","via4","met5")]:
    l2n.connect(reg[a],reg[v]); l2n.connect(reg[v],reg[b])
l2n.extract_netlist(); nl = l2n.netlist(); c = nl.circuit_by_name(top.name); tile = nl.circuit_by_name("pixel_4tile")
topl = {k: pya.Region(top.shapes(ly.layer(*L[k]))) for k in ["met1","met2","met3","met4","met5"]}
def pins(net, n=5):
    out = []
    for sp in net.each_subcircuit_pin():
        cr = sp.subcircuit().circuit_ref(); pn = cr.net_for_pin(sp.pin().id())
        out.append(cr.name.replace("sky130_fd_sc_hd__","") + ":" + (pn.expanded_name() if pn else "?"))
    cnt = collections.Counter(out)
    drv = [p for p in cnt if re.search(r":(X|Y|Q|Q_N|LO|HI)$", p)]
    return len(out), drv[:n], [p for p in cnt if p not in drv][:n]
def cls(net):
    if net is None: return "?"
    nm = net.expanded_name(); n, drv, oth = pins(net); s = " ".join(drv + oth) + " " + nm
    if re.search(r"vssd|vccd|vdda|vssa|VGND|VPWR|VPB|VNB", s): return "supply"
    if re.search(r"clkbuf|clkinv|clk|CLK", s): return "clock"
    if re.search(r"dac_config|Bias\[", s): return "bias"
    if re.search(r"pixel_4tile:|BiasBranch|photodiode|pixel_test", s): return "analog-macro-pin"
    if n == 0: return "no-cell-pin"
    if re.search(r"conb", s): return "tie"
    return "digital"
def inside_pt(p):
    for e in p.each_edge():
        m = pya.Point((e.p1.x+e.p2.x)//2, (e.p1.y+e.p2.y)//2); d = e.d(); L = max(1.0, d.length())
        for s in (1, -1):
            q = pya.Point(int(m.x - s*d.y*60/L), int(m.y + s*d.x*60/L))
            if p.inside(q): return q
    return p.bbox().center()
def netlen(n):
    return sum(max(p.bbox().width(), p.bbox().height()) for k in ["met1","met2","met3","met4"] for p in l2n.shapes_of_net(n, reg[k], False).each())/1e3
# tile pin label positions
tc = ly.cell("pixel_4tile"); inst = [i for i in top.each_inst() if i.cell.name == "pixel_4tile"][0]; T = inst.cplx_trans
for lay in [(68,5),(69,5),(70,5),(71,5),(67,5)]:
    li = ly.find_layer(*lay)
    if li is None: continue
    for s in tc.shapes(li).each():
        if s.is_text() and s.text.string.startswith("dac_config"):
            pt = T * s.text.trans.disp
            print("TILEPIN %s layer %s at wrapper (%.1f, %.1f) um" % (s.text.string, lay, pt.x/1e3, pt.y/1e3))
bg = ly.cell("BiasBranchnMasterx11"); binst = [i for i in top.each_inst() if i.cell.name == "BiasBranchnMasterx11"]
if binst:
    print("BIASGEN bbox in wrapper:", bg.bbox().transformed(binst[0].cplx_trans).to_s())
    for lay in [(68,5),(69,5),(70,5),(71,5),(67,5)]:
        li = ly.find_layer(*lay)
        if li is None: continue
        for s in bg.shapes(li).each():
            if s.is_text() and s.text.string.startswith("Bias["):
                pt = binst[0].cplx_trans * s.text.trans.disp
                print("BIASPIN %s layer %s at wrapper (%.1f, %.1f) um" % (s.text.string, lay, pt.x/1e3, pt.y/1e3))
# pin locations
for sc in c.each_subcircuit():
    cr = sc.circuit_ref()
    if cr.name not in ("pixel_4tile", "BiasBranchnMasterx11"): continue
    for pin in cr.each_pin():
        inner = cr.net_for_pin(pin.id()); nm = inner.expanded_name() if inner else ""
        if not (nm.startswith("dac_config") or nm.startswith("Bias")): continue
        outer = sc.net_for_pin(pin.id())
        if outer is None: print("PIN", cr.name, nm, "unconnected"); continue
        # the wrapper-net shapes touching the macro's bbox edge on each layer

        loc = []
        for k in ["met1","met2","met3","met4"]:
            r = l2n.shapes_of_net(outer, reg[k], False)
            if r.count(): loc.append("%s bbox %s" % (k, r.bbox().to_s()))
        print("PIN %s %s -> wrapper %s ; %s" % (cr.name, nm, outer.expanded_name(), "; ".join(loc)))
# met5 usage at top level
m5 = topl["met5"]; widths = collections.Counter(round(min(p.bbox().width(), p.bbox().height())/1e3, 2) for p in m5.each())
print("top-level met5 shapes by min dimension (um):", dict(widths.most_common(8)))
# met4 usage: shapes not on the PDN nets
pdn = set(["vccd1","vssd1","vdda1","vssa1","vssa2","vccd2","vssd2","vdda2"])
m4cnt = collections.Counter()
for n in c.each_net():
    r = l2n.shapes_of_net(n, reg["met4"], False)
    if r.count(): m4cnt["pdn" if n.expanded_name() in pdn else "other"] += r.count()
print("top-level met4 shapes on PDN nets vs other nets:", dict(m4cnt))
for sc in c.each_subcircuit():
    if sc.circuit_ref().name != "pixel_4tile": continue
    for pin in tile.each_pin():
        inner = tile.net_for_pin(pin.id()); nm = inner.expanded_name() if inner else ""
        if not nm.startswith("dac_config"): continue
        outer = sc.net_for_pin(pin.id())
        rows = collections.defaultdict(lambda: [0, 9999, None])
        for k in ["met1","met2","met3","met4"]:
            own = l2n.shapes_of_net(outer, reg[k], False)
            if not own.count(): continue
            nbr = (topl[k] & own.sized(350)) - own
            for p in nbr.each():
                b = p.bbox(); q = inside_pt(p); n = l2n.probe_net(reg[k], pya.DPoint(q.x*ly.dbu, q.y*ly.dbu))
                key = (n.expanded_name() if n else "?", k)
                rows[key][0] += max(b.width(), b.height())/1e3
                # spacing: grow own until it touches this piece
                for sp in (140, 200, 260, 350):
                    if not ((own.sized(sp) & pya.Region(p)).is_empty()): rows[key][1] = min(rows[key][1], sp); break
                rows[key][2] = n
        print("== %s (wrapper %s): %d neighbour nets" % (nm, outer.expanded_name(), len(rows)))
        for (nn, k), (length, sp, n) in sorted(rows.items(), key=lambda kv: -kv[1][0])[:16]:
            npins, drv, oth = pins(n) if n else (0, [], [])
            print("    %-6s %7.0f um  sp<=%.2f  %-14s %-12s len %6.0f um drivers %s pins %d e.g. %s" % (k, length, sp/1e3, cls(n), nn[:12], netlen(n) if n else -1, drv[:3], npins, oth[:4]))
