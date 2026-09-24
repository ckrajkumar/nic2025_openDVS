# pixel_test_structure alone: do vdiff and vsf merge with/without pin layers (xx/16)? which layer causes it?
import pya
ly = pya.Layout(); ly.read(gds)
c = ly.cell("pixel_test_structure")
L = {"li":(67,20),"mcon":(67,44),"met1":(68,20),"via1":(68,44),"met2":(69,20),"via2":(69,44),"met3":(70,20),"via3":(70,44),"met4":(71,20),"via4":(71,44),"met5":(72,20)}
T = {"li":(67,5),"met1":(68,5),"met2":(69,5),"met3":(70,5),"met4":(71,5),"met5":(72,5)}
PIN = {"li":(67,16),"met1":(68,16),"met2":(69,16),"met3":(70,16),"met4":(71,16),"met5":(72,16)}
def run(use_pins, skip=None):
    l2n = pya.LayoutToNetlist(pya.RecursiveShapeIterator(ly, c, []))
    reg = {}
    for k,(a,b) in L.items():
        li = ly.find_layer(a,b); reg[k] = l2n.make_layer(li, k) if (li is not None and k != skip) else l2n.make_layer(k)
    for k in ["li","met1","met2","met3","met4","met5"]: l2n.connect(reg[k])
    if use_pins:
        for k,(a,b) in PIN.items():
            li = ly.find_layer(a,b)
            if li is not None: reg[k+"p"] = l2n.make_layer(li, k+"p"); l2n.connect(reg[k], reg[k+"p"]); l2n.connect(reg[k+"p"])
    for k,(a,b) in T.items():
        li = ly.find_layer(a,b)
        if li is not None: tl = l2n.make_text_layer(li, k+"_lbl"); l2n.connect(reg[k], tl)
    for a,v,b in [("li","mcon","met1"),("met1","via1","met2"),("met2","via2","met3"),("met3","via3","met4"),("met4","via4","met5")]:
        l2n.connect(reg[a],reg[v]); l2n.connect(reg[v],reg[b])
    l2n.extract_netlist()
    cc = l2n.netlist().circuit_by_name("pixel_test_structure")
    names = [n.expanded_name() for n in cc.each_net() if "vsf" in n.expanded_name().split(",") or "vdiff" in n.expanded_name().split(",")]
    print("pins=%s skip=%s -> %s" % (use_pins, skip, names))
run(True); run(False)
for s in ["li","mcon","via1","via2","met1","met2","met3"]: run(False, s)
