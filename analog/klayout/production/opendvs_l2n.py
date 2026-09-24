"""sky130 connectivity-only net extraction for openDVS layouts (KLayout LayoutToNetlist).

GUI:   the ~/.klayout/pymacros/opendvs_nets.lym menu item (Tools -> openDVS: extract nets)
       calls extract_view() on the *current* cell of the active layout tab, in memory,
       so unsaved edits are included. It then opens the Netlist Browser bound to that
       tab: clicking a net highlights it.
Batch: klayout -b -r opendvs_l2n.py -rd gds=<file.gds> -rd top=<cell> [-rd out=<file.l2n>]

No devices are extracted: nets stop at transistor terminals (S/D diff is cut by poly),
which is what net highlighting needs. Substrate/well connectivity is not modelled.
"""
import os
import time

import pya

# (name, gds layer, datatype) -- sky130A drawing layers
CONDUCTORS = [
    ("diff", 65, 20),
    ("poly", 66, 20), ("licon", 66, 44),
    ("li", 67, 20), ("mcon", 67, 44),
    ("met1", 68, 20), ("via1", 68, 44),
    ("met2", 69, 20), ("via2", 69, 44),
    ("met3", 70, 20), ("via3", 70, 44),
    ("met4", 71, 20), ("via4", 71, 44),
    ("met5", 72, 20),
    ("capm", 89, 44), ("cap2m", 97, 44),
]
# text labels that name nets: conductor -> (layer, datatype)
LABELS = {
    "diff": (65, 6), "poly": (66, 5), "li": (67, 5),
    "met1": (68, 5), "met2": (69, 5), "met3": (70, 5), "met4": (71, 5), "met5": (72, 5),
}
CONNECT = [
    ("sd", "licon"), ("poly", "licon"), ("licon", "li"),
    ("li", "mcon"), ("mcon", "met1"),
    ("met1", "via1"), ("via1", "met2"),
    ("met2", "via2"), ("via2", "met3"),
    ("met3", "via3"), ("via3", "met4"),
    ("met4", "via4"), ("via4", "met5"),
]


def build_l2n(layout, cell, threads=4):
    l2n = pya.LayoutToNetlist(pya.RecursiveShapeIterator(layout, cell, []))
    l2n.threads = threads
    R = {}
    for name, l, d in CONDUCTORS:
        li = layout.find_layer(l, d)
        R[name] = l2n.make_layer(li, name) if li is not None else l2n.make_layer(name)
    # source/drain regions: diff minus the gate poly, otherwise S and D short through the channel
    R["sd"] = R["diff"] - R["poly"]
    l2n.register(R["sd"], "sd")
    # MiM cap plates sit on via3/via4 layers and are not vias
    R["via3"] = R["via3"] - R["capm"]
    R["via4"] = R["via4"] - R["cap2m"]
    l2n.register(R["via3"], "via3_")
    l2n.register(R["via4"], "via4_")
    for name in ("sd", "poly", "licon", "li", "mcon", "met1", "via1", "met2", "via2",
                 "met3", "via3", "met4", "via4", "met5"):
        l2n.connect(R[name])            # intra-layer: without this, edge-abutting shapes stay separate nets
    for a, b in CONNECT:
        l2n.connect(R[a], R[b])
    for name, (l, d) in LABELS.items():
        li = layout.find_layer(l, d)
        if li is None:
            continue
        target = R["sd"] if name == "diff" else R[name]
        l2n.connect(target, l2n.make_text_layer(li, name + "_lbl"))
    l2n.extract_netlist()
    name_nets_from_pins(l2n.netlist())
    return l2n


def name_nets_from_pins(netlist):
    """Labels only name nets on their own hierarchy level, so a 4x4 or tile-level net that just
    joins subcell pins comes out as $N. Name it after the subcell pin(s) it connects, bottom-up."""
    for circuit in netlist.each_circuit_bottom_up():
        for net in circuit.each_net():
            if net.name:
                continue
            names = sorted({ref.pin().name() for ref in net.each_subcircuit_pin() if ref.pin().name()})
            if names:
                net.name = names[0] if len(names) == 1 else "|".join(names[:2]) + ("|..." if len(names) > 2 else "")


def summary(l2n):
    nl = l2n.netlist()
    top = nl.top_circuit()
    nets = list(top.each_net())
    named = [n.name for n in nets if n.name and not n.name.startswith("$")]
    return "circuit %s: %d nets, %d named (%s)" % (
        top.name, len(nets), len(named), ", ".join(sorted(set(named))[:24]))


def extract_view(write_file=True):
    mw = pya.Application.instance().main_window()
    view = mw.current_view()
    if view is None:
        raise RuntimeError("no layout open")
    cvi = view.active_cellview_index
    cv = view.cellview(cvi)
    layout, cell = cv.layout(), cv.cell
    t0 = time.time()
    l2n = build_l2n(layout, cell)
    msg = "%s  (%.1f s)" % (summary(l2n), time.time() - t0)
    if write_file and cv.filename():
        out = os.path.splitext(cv.filename())[0] + "." + cell.name + ".l2n"
        l2n.write(out)
        msg += "  -> " + out
    while view.num_l2ndbs() > 0:      # replace any previous extraction of this tab
        view.remove_l2ndb(0)
    idx = view.add_l2ndb(l2n)
    view.show_l2ndb(idx, cvi)
    mw.message(msg, 20000)
    print(msg)
    return l2n


if "gds" in globals():                # batch: klayout -b -r opendvs_l2n.py -rd gds=.. -rd top=..
    _ly = pya.Layout()
    _ly.read(gds)
    _cell = _ly.cell(top) if "top" in globals() else _ly.top_cell()
    _t0 = time.time()
    _l2n = build_l2n(_ly, _cell)
    print("%s  (%.1f s)" % (summary(_l2n), time.time() - _t0))
    _out = globals().get("out") or (os.path.splitext(gds)[0] + "." + _cell.name + ".l2n")
    _l2n.write(_out)
    print("wrote", _out)
