# klayout -b -r l2n_macro_conn.py -rd gds=<wrapper.gds> -rd out=<out.json>
# Metal-only hierarchical LayoutToNetlist (li..met5 + mcon..via4, pin layers xx/16 joined to their metal, labels xx/5),
# macros and std cells kept as subcircuits. For every label inside each analog macro: inner net, whether that net is a
# pin of the macro circuit (i.e. touched from outside), the wrapper net it lands on, and every terminal on that wrapper net.
import pya, time, json, re
t0 = time.time()
ly = pya.Layout(); ly.read(gds); top = ly.top_cell()
MACROS = ["BiasBranchnMasterx11", "pixel_4tile", "pixel_test_structure", "photodiode_test_structure"]
L = {"li":(67,20),"mcon":(67,44),"met1":(68,20),"via1":(68,44),"met2":(69,20),"via2":(69,44),"met3":(70,20),"via3":(70,44),"met4":(71,20),"via4":(71,44),"met5":(72,20)}
T = {"li":(67,5),"met1":(68,5),"met2":(69,5),"met3":(70,5),"met4":(71,5),"met5":(72,5)}
PIN = {"li":(67,16),"met1":(68,16),"met2":(69,16),"met3":(70,16),"met4":(71,16),"met5":(72,16)}
l2n = pya.LayoutToNetlist(pya.RecursiveShapeIterator(ly, top, []))
l2n.threads = 16
l2n.include_floating_subcircuits = True
reg = {}; tls = {}
for k,(a,b) in L.items():
    li = ly.find_layer(a,b); reg[k] = l2n.make_layer(li, k) if li is not None else l2n.make_layer(k)
for k in ["li","met1","met2","met3","met4","met5"]: l2n.connect(reg[k])
for k,(a,b) in PIN.items():
    li = ly.find_layer(a,b)
    if li is not None:
        reg[k+"p"] = l2n.make_layer(li, k+"p"); l2n.connect(reg[k], reg[k+"p"]); l2n.connect(reg[k+"p"])
for k,(a,b) in T.items():
    li = ly.find_layer(a,b)
    if li is not None:
        tls[k] = l2n.make_text_layer(li, k+"_lbl"); l2n.connect(reg[k], tls[k])
for a,v,b in [("li","mcon","met1"),("met1","via1","met2"),("met2","via2","met3"),("met3","via3","met4"),("met4","via4","met5")]:
    l2n.connect(reg[a],reg[v]); l2n.connect(reg[v],reg[b])
l2n.extract_netlist()
print("extracted in %.0f s" % (time.time()-t0), flush=True)
nl = l2n.netlist(); ctop = nl.circuit_by_name(top.name)
dbu = ly.dbu

def labels_of(net):
    out = []
    for k, tl in tls.items():
        sh = pya.Shapes(); l2n.shapes_of_net(net, tl, False, sh)
        for s in sh.each():
            if s.is_text(): out.append((s.text_string, k, s.text.x*dbu, s.text.y*dbu))
    return out

pinname_cache = {}
def refpin_name(circ, pin):
    key = (circ.name, pin.id())
    if key not in pinname_cache:
        n = circ.net_for_pin(pin.id()); pinname_cache[key] = n.expanded_name() if n else "?"
    return pinname_cache[key]

def net_terminals(net):
    terms = []
    for sp in net.each_subcircuit_pin():
        sc = sp.subcircuit(); ref = sc.circuit_ref()
        terms.append((ref.name, sc.expanded_name(), refpin_name(ref, sp.pin())))
    return terms

inst = {}
for sc in ctop.each_subcircuit():
    if sc.circuit_ref().name in MACROS: inst[sc.circuit_ref().name] = sc
res = {"gds": gds, "macros": {}, "outer": {}}
outer_seen = {}
for mn in MACROS:
    c = nl.circuit_by_name(mn); sc = inst[mn]
    tr = sc.trans  # DCplxTrans in um
    pin_of_net = {}
    for p in c.each_pin():
        n = c.net_for_pin(p.id())
        if n: pin_of_net[n.cluster_id] = p.id()
    recs = []
    for n in c.each_net():
        labs = labels_of(n)
        if not labs: continue
        rec = {"inner": n.expanded_name(), "labels": sorted(set(l[0] for l in labs)),
               "label_pos_top": [(l[0], l[1], round(tr.trans(pya.DPoint(l[2], l[3])).x,3), round(tr.trans(pya.DPoint(l[2], l[3])).y,3)) for l in labs][:6],
               "is_pin": n.cluster_id in pin_of_net}
        if rec["is_pin"]:
            on = sc.net_for_pin(pin_of_net[n.cluster_id])
            if on is None:
                rec["outer"] = None
            else:
                key = on.cluster_id; rec["outer"] = key
                if key not in outer_seen:
                    outer_seen[key] = on
                    bb = {}
                    for k in ["met1","met2","met3","met4","met5"]:
                        r = l2n.shapes_of_net(on, reg[k], False)
                        if r.count() and r.count() < 200000:
                            b = r.bbox(); bb[k] = [b.left*dbu, b.bottom*dbu, b.right*dbu, b.top*dbu, r.count()]
                    res["outer"][str(key)] = {"name": on.expanded_name(), "top_labels": sorted(set(l[0] for l in labels_of(on))),
                                              "terms": net_terminals(on), "bbox": bb}
        recs.append(rec)
    res["macros"][mn] = {"trans": str(tr), "nets": recs, "npins": c.pin_count()}
    print(mn, "labelled nets", len(recs), "pins", c.pin_count(), "%.0f s" % (time.time()-t0), flush=True)

# top-level nets: every labelled top net (name derived from top labels)
tops = []
for n in ctop.each_net():
    nm = n.expanded_name()
    if nm.startswith("$"): continue
    tops.append({"name": nm, "cid": n.cluster_id, "nsc": n.subcircuit_pin_count()})
res["top_named_nets"] = tops
# std-cell power pin islands: top nets with std-cell VPWR/VGND/VPB/VNB pins but no label
PW = {"VPWR","VGND","VPB","VNB"}
islands = []
for n in ctop.each_net():
    if not n.expanded_name().startswith("$"): continue
    k = 0; ex = None
    for sp in n.each_subcircuit_pin():
        ref = sp.subcircuit().circuit_ref()
        if refpin_name(ref, sp.pin()) in PW: k += 1; ex = ex or (ref.name, sp.subcircuit().trans.disp.x, sp.subcircuit().trans.disp.y)
    if k: islands.append({"net": n.expanded_name(), "npw": k, "nsc": n.subcircuit_pin_count(), "example": ex})
res["unlabelled_power_nets"] = islands
json.dump(res, open(out, "w"), indent=0)
print("done %.0f s" % (time.time()-t0), "unlabelled power nets", len(islands), flush=True)
