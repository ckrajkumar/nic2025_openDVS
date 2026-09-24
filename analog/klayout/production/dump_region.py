"""List every net's polygons (as bboxes) per layer inside a window.  -rd box=x1,y1,x2,y2 [-rd layers=li,met1,met2]"""
import pya, sys
sys.path.insert(0, "."); import opendvs_l2n
ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); px = ly.cell("openDVS_pixel")
l2n = opendvs_l2n.build_l2n(ly, px); top = l2n.netlist().top_circuit()
b = [float(v) for v in box.split(",")]; win = pya.Region(pya.Box(int(b[0]*1000), int(b[1]*1000), int(b[2]*1000), int(b[3]*1000)))
LAY = globals().get("layers", "poly,licon,li,mcon,met1,via1,met2,via2,met3").split(",")
def um(bx): return "(%.3f,%.3f;%.3f,%.3f)" % (bx.left/1e3, bx.bottom/1e3, bx.right/1e3, bx.top/1e3)
for ln in LAY:
    print("== %s" % ln)
    for net in top.each_net():
        r = l2n.shapes_of_net(net, l2n.layer_by_name(ln), True) & win
        if r.is_empty(): continue
        for p in r.merged().each():
            print("   %-12s %s  %s" % (net.expanded_name(), um(p.bbox()), "" if p.is_box() else "poly %d pts" % p.num_points()))
