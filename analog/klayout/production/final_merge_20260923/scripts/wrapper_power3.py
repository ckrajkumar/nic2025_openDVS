# klayout -b -r wrapper_power2.py -rd gds=user_project_wrapper.gds
# Metal-only connectivity of the wrapper with the two analog macros reduced to their own top-level shapes (rings + pin stubs).
# Net names come from the labels (hierarchically), so each macro pin net can be paired with the wrapper net it sits on.
import pya, re, time
t0=time.time()
ly = pya.Layout(); ly.read(gds); top = ly.top_cell()
macros = ["pixel_4tile", "pixel_test_structure"]
for cn in macros:
    c = ly.cell(cn); assert c is not None, cn
    insts = [i for i in top.each_inst() if i.cell.name == cn]
    print(cn, "instances", len(insts), "trans", [str(i.cplx_trans) for i in insts], "children", c.child_cells())
L = {"li":(67,20),"mcon":(67,44),"met1":(68,20),"via1":(68,44),"met2":(69,20),"via2":(69,44),"met3":(70,20),"via3":(70,44),"met4":(71,20),"via4":(71,44),"met5":(72,20)}
T = {"li":(67,5),"met1":(68,5),"met2":(69,5),"met3":(70,5),"met4":(71,5),"met5":(72,5)}
l2n = pya.LayoutToNetlist(pya.RecursiveShapeIterator(ly, top, []))
reg = {}
for k,(a,b) in L.items():
    li = ly.find_layer(a,b)
    reg[k] = l2n.make_layer(li, k) if li is not None else l2n.make_layer(k)
for k,(a,b) in T.items():
    li = ly.find_layer(a,b)
    if li is not None:
        tl = l2n.make_text_layer(li, k+"_lbl"); l2n.connect(reg[k], tl)
for k in ["li","met1","met2","met3","met4","met5"]: l2n.connect(reg[k])
for a,v,b in [("li","mcon","met1"),("met1","via1","met2"),("met2","via2","met3"),("met3","via3","met4"),("met4","via4","met5")]:
    l2n.connect(reg[a],reg[v]); l2n.connect(reg[v],reg[b])
l2n.extract_netlist()
nl = l2n.netlist(); ctop = nl.circuit_by_name(top.name)
print("extracted in %.0f s; top nets %d" % (time.time()-t0, sum(1 for _ in ctop.each_net())))
pw = re.compile(r"vdd|vss|gnd", re.I)
for cn in macros:
    cm = nl.circuit_by_name(cn)
    if cm is None: print("no circuit for", cn); continue
    print("==", cn, "circuit nets", sum(1 for _ in cm.each_net()), "pins", sum(1 for _ in cm.each_pin()))
    for sc in ctop.each_subcircuit():
        if sc.circuit_ref().name != cn: continue
        for pin in cm.each_pin():
            inner = cm.net_for_pin(pin.id()); outer = sc.net_for_pin(pin.id())
            iname = inner.expanded_name() if inner else "-"
            if not pw.search(iname) and not pw.search(outer.expanded_name() if outer else ""): continue
            oname = outer.expanded_name() if outer else "<unconnected>"
            print("   macro net %-10s -> wrapper net %-8s" % (iname, oname))
            for k in ["met3","met4","met5"]:
                r = l2n.shapes_of_net(inner, reg[k], False)
                if r.count(): print("        macro top-level %-5s %5d shapes area %9.1f um2 bbox %s" % (k, r.count(), r.area()/1e6, r.bbox().to_s()))
            if outer:
                for k in ["met4","met5"]:
                    r = l2n.shapes_of_net(outer, reg[k], False)
                    if r.count(): print("        wrapper top-level %-5s %5d shapes area %9.1f um2 bbox %s" % (k, r.count(), r.area()/1e6, r.bbox().to_s()))
print("== wrapper power nets and the macro pins on them (macro-internal nets named by their labels)")
for n in ctop.each_net():
    nm = n.expanded_name()
    if not pw.search(nm) or n.subcircuit_pin_count() > 1000: continue
    pins = []
    for sp in n.each_subcircuit_pin():
        sc = sp.subcircuit(); cr = sc.circuit_ref(); pin = sp.pin(); inner = cr.net_for_pin(pin.id())
        pins.append("%s:%s" % (cr.name, inner.expanded_name() if inner else "?"))
    print("   %-10s subcircuit pins %d: %s" % (nm, n.subcircuit_pin_count(), sorted(set(pins))[:12]))
cm = nl.circuit_by_name("pixel_4tile")
names = [n.expanded_name() for n in cm.each_net()]
print("== pixel_4tile circuit: nets with power names", [x for x in names if pw.search(x)][:20])
print("   sample net names", names[:15])
