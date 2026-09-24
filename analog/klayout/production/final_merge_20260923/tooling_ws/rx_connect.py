# klayout -b -r rx_connect.py -rd gds=<wrapper.gds>
# Probe the net of the analog_io[17] met2 wire end and of the BiasBranchnMasterx11 rx met3 pin; same net? which labels does it carry?
import pya, time
ly = pya.Layout(); ly.read(gds); top = ly.top_cell()
L = {"li":(67,20),"mcon":(67,44),"met1":(68,20),"via1":(68,44),"met2":(69,20),"via2":(69,44),"met3":(70,20),"via3":(70,44),"met4":(71,20),"via4":(71,44),"met5":(72,20)}
T = {"met1":(68,5),"met2":(69,5),"met3":(70,5),"met4":(71,5),"met5":(72,5)}
PIN = {"met2":(69,16),"met3":(70,16),"met4":(71,16),"met5":(72,16)}
l2n = pya.LayoutToNetlist(pya.RecursiveShapeIterator(ly, top, [])); l2n.include_floating_subcircuits = True
reg = {}
for k,(a,b) in L.items():
    li = ly.find_layer(a,b); reg[k] = l2n.make_layer(li, k) if li is not None else l2n.make_layer(k)
for k,(a,b) in PIN.items():
    li = ly.find_layer(a,b)
    if li is not None: reg[k+"p"] = l2n.make_layer(li, k+"p"); l2n.connect(reg[k], reg[k+"p"]); l2n.connect(reg[k+"p"])
for k,(a,b) in T.items():
    li = ly.find_layer(a,b)
    if li is not None: tl = l2n.make_text_layer(li, k+"_lbl"); l2n.connect(reg[k], tl)
for k in ["li","met1","met2","met3","met4","met5"]: l2n.connect(reg[k])
for a,v,b in [("li","mcon","met1"),("met1","via1","met2"),("met2","via2","met3"),("met3","via3","met4"),("met4","via4","met5")]:
    l2n.connect(reg[a],reg[v]); l2n.connect(reg[v],reg[b])
l2n.extract_netlist()
wire = l2n.probe_net(reg["met2"], pya.DPoint(403.0, 2622.42))
pin = l2n.probe_net(reg["met3"], pya.DPoint(410.0, 2622.8))
def desc(n):
    if n is None: return None
    return "%s in circuit %s" % (n.expanded_name(), n.circuit().name)
print("met2 wire end net:", desc(wire)); print("met3 rx pin net:", desc(pin))
print("same net:", wire is not None and pin is not None and wire.cluster_id == pin.cluster_id and wire.circuit().name == pin.circuit().name)
# does the analog_io[17] top-level net exist, and how many shapes / where does it end?
ctop = l2n.netlist().circuit_by_name(top.name)
for n in ctop.each_net():
    if n.expanded_name() == "analog_io[17]":
        print("analog_io[17]: subcircuit pins", n.subcircuit_pin_count(), [ (sp.subcircuit().circuit_ref().name, sp.pin().name()) for sp in n.each_subcircuit_pin()][:10])
