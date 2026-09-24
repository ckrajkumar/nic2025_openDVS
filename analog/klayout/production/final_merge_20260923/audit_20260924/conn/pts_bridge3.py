# flatten pixel_test_structure, extract; get met3 of the vdiff,vsf net; remove each met3 polygon in turn to find the bridge
import pya
ly = pya.Layout(); ly.read(gds)
src = ly.cell("pixel_test_structure")
L = {"li":(67,20),"mcon":(67,44),"met1":(68,20),"via1":(68,44),"met2":(69,20),"via2":(69,44),"met3":(70,20),"via3":(70,44),"met4":(71,20),"via4":(71,44),"met5":(72,20)}
T = {"li":(67,5),"met1":(68,5),"met2":(69,5),"met3":(70,5),"met4":(71,5),"met5":(72,5)}
base = {k: pya.Region(src.begin_shapes_rec(ly.find_layer(a,b))) for k,(a,b) in L.items()}
texts = {k: pya.Texts(src.begin_shapes_rec(ly.find_layer(a,b))) for k,(a,b) in T.items()}
def extract(regs):
    fl = pya.Layout(); fl.dbu = ly.dbu; c = fl.create_cell("F")
    li = {}
    for k,(a,b) in L.items(): li[k] = fl.layer(a,b); c.shapes(li[k]).insert(regs[k])
    for k,(a,b) in T.items(): x = fl.layer(a,b); c.shapes(x).insert(texts[k]); li[k+"t"] = x
    l2n = pya.LayoutToNetlist(pya.RecursiveShapeIterator(fl, c, []))
    r = {k: l2n.make_layer(li[k], k) for k in L}
    for k in ["li","met1","met2","met3","met4","met5"]: l2n.connect(r[k])
    for k in T: t = l2n.make_text_layer(li[k+"t"], k+"t"); l2n.connect(r[k], t)
    for a,v,b in [("li","mcon","met1"),("met1","via1","met2"),("met2","via2","met3"),("met3","via3","met4"),("met4","via4","met5")]:
        l2n.connect(r[a],r[v]); l2n.connect(r[v],r[b])
    l2n.extract_netlist()
    return l2n, r, fl
l2n, r, fl = extract(base)
t = l2n.netlist().circuit_by_name("F")
tr = pya.CplxTrans(0.001)
for n in t.each_net():
    if "vsf" in n.expanded_name().split(","):
        print("net", n.expanded_name())
        for k in ["met1","met2","met3","met4","met5"]:
            s = l2n.shapes_of_net(n, r[k], True); print("  ", k, s.count(), tr*s.bbox())
        m3 = l2n.shapes_of_net(n, r["met3"], True).merged()
        for i,p in enumerate(m3.each()):
            reg = dict(base); reg["met3"] = base["met3"] - pya.Region(p)
            l2, _, _ = extract(reg)
            t2 = l2.netlist().circuit_by_name("F")
            nm = [x.expanded_name() for x in t2.each_net() if set(x.expanded_name().split(",")) & {"vsf","vdiff"}]
            print("   remove met3 poly", i, tr*p.bbox(), "->", nm)
