"""Print vertex lists of selected net polygons.  -rd want=nRst:li,vd:met1,... -rd box=..."""
import pya, sys
sys.path.insert(0, "."); import opendvs_l2n
ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); px = ly.cell("openDVS_pixel")
l2n = opendvs_l2n.build_l2n(ly, px); top = l2n.netlist().top_circuit()
b = [float(v) for v in box.split(",")]; win = pya.Region(pya.Box(int(b[0]*1000), int(b[1]*1000), int(b[2]*1000), int(b[3]*1000)))
for item in want.split(","):
    name, ln = item.split(":")
    for net in top.each_net():
        if net.expanded_name() != name: continue
        r = l2n.shapes_of_net(net, l2n.layer_by_name(ln), True) & win
        for p in r.merged().each():
            print("%s %s: %s" % (name, ln, " ".join("(%.3f,%.3f)" % (pt.x/1e3, pt.y/1e3) for pt in p.each_point_hull())))
