# klayout -b -r rx_probe.py -rd gds=<wrapper.gds>
# ChipFoundry (Mitch, 2026-09-23): analog_io[17] (GPIO 24) should reach BiasBranchnMasterx11/rx, but a via2 met2-met3 is missing.
# Metal-only connectivity of the wrapper; report the net on the rx pin of BiasBranchnMasterx11 (outside the macro) and the net named
# analog_io[17]; list their met2/met3 shapes and every place where one net's met2 overlaps the other's met3 (candidate via2 sites).
import pya, time
t0 = time.time()
ly = pya.Layout(); ly.read(gds); top = ly.top_cell()
L = {"li":(67,20),"mcon":(67,44),"met1":(68,20),"via1":(68,44),"met2":(69,20),"via2":(69,44),"met3":(70,20),"via3":(70,44),"met4":(71,20),"via4":(71,44),"met5":(72,20)}
T = {"li":(67,5),"met1":(68,5),"met2":(69,5),"met3":(70,5),"met4":(71,5),"met5":(72,5)}
PIN = {"met2":(69,16),"met3":(70,16),"met4":(71,16)}
l2n = pya.LayoutToNetlist(pya.RecursiveShapeIterator(ly, top, []))
reg = {}
for k,(a,b) in L.items():
    li = ly.find_layer(a,b); reg[k] = l2n.make_layer(li, k) if li is not None else l2n.make_layer(k)
for k,(a,b) in PIN.items():   # pin shapes belong to the metal
    li = ly.find_layer(a,b)
    if li is not None:
        reg[k+"p"] = l2n.make_layer(li, k+"p"); l2n.connect(reg[k], reg[k+"p"]); l2n.connect(reg[k+"p"])
for k,(a,b) in T.items():
    li = ly.find_layer(a,b)
    if li is not None:
        tl = l2n.make_text_layer(li, k+"_lbl"); l2n.connect(reg[k], tl)
for k in ["li","met1","met2","met3","met4","met5"]: l2n.connect(reg[k])
for a,v,b in [("li","mcon","met1"),("met1","via1","met2"),("met2","via2","met3"),("met3","via3","met4"),("met4","via4","met5")]:
    l2n.connect(reg[a],reg[v]); l2n.connect(reg[v],reg[b])
l2n.extract_netlist()
nl = l2n.netlist(); ctop = nl.circuit_by_name(top.name)
print("extracted in %.0f s" % (time.time()-t0))
cb = nl.circuit_by_name("BiasBranchnMasterx11"); assert cb, "no BiasBranchnMasterx11 circuit"
pn = [(p.id(), cb.net_for_pin(p.id()).expanded_name() if cb.net_for_pin(p.id()) else None) for p in cb.each_pin()]
import re
print("BiasBranchnMasterx11 pins:", len(pn), "named-other:", [x[1] for x in pn if x[1] and not re.match(r"(n?FineCode|CoarseOneHot|BIT0|NBiasEn|PBiasEn|BiasDisabled|PowerDown|Bias|PadBias|CoarseOneHotLowBiasEn|n?LowBiasInterfaceEn)\\[", x[1])], "unnamed:", sum(1 for x in pn if not x[1] or x[1].startswith("$")))
rxpin = [p for p in cb.each_pin() if cb.net_for_pin(p.id()) and cb.net_for_pin(p.id()).expanded_name().lower() in ("rx", "ir")]
print("rx pins on BiasBranchnMasterx11:", [p.id() for p in rxpin])
outer = None
for sc in ctop.each_subcircuit():
    if sc.circuit_ref().name == "BiasBranchnMasterx11":
        for p in rxpin: outer = sc.net_for_pin(p.id()); print("instance", sc.expanded_name(), "rx -> wrapper net", outer.expanded_name() if outer else None, "trans", sc.trans)
import sys
if not rxpin: sys.exit(0)
inner = cb.net_for_pin(rxpin[0].id())
for k in ["met2","met3","met4"]:
    r = l2n.shapes_of_net(inner, reg[k], False)
    if r.count(): print("  macro rx %s: %d shapes, bbox %s (macro coords)" % (k, r.count(), r.bbox()))
aio = [n for n in ctop.each_net() if n.expanded_name() == "analog_io[17]"]
print("nets named analog_io[17]:", len(aio))
def shapes(net, k): return l2n.shapes_of_net(net, reg[k], True)
if outer:
    for k in ["met1","met2","met3","met4"]:
        r = shapes(outer, k)
        if r.count(): print("  rx outer net %s: %d shapes, bbox %s" % (k, r.count(), r.bbox()))
for a in aio:
    print("  analog_io[17] subcircuit pins:", a.subcircuit_pin_count())
    for k in ["met1","met2","met3","met4"]:
        r = shapes(a, k)
        if r.count(): print("  analog_io[17] %s: %d shapes, bbox %s" % (k, r.count(), r.bbox()))
    if outer:
        for (x, y) in [("met2", "met3"), ("met3", "met2")]:
            ov = shapes(outer, x) & shapes(a, y)
            print("  overlap rx-net %s x analog_io[17] %s: %d" % (x, y, ov.count()))
            for p in ov.merged().each(): print("     ", p.bbox(), "%.3f x %.3f um" % (p.bbox().width()/1000, p.bbox().height()/1000))
        # nearest approach on the same layer
        for k in ["met2", "met3"]:
            A = shapes(outer, k); B = shapes(a, k)
            if A.count() and B.count():
                e = A.separation_check(B, 5000)
                ds = sorted([(ep.distance(), ep) for ep in e.each()], key=lambda t: t[0])[:3]
                for d, ep in ds: print("  same-layer gap %s: %.3f um at %s" % (k, d/1000, ep.first.bbox()))
