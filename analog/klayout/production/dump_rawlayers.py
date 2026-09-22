"""Raw GDS shapes of openDVS_pixel per layer/datatype inside a window (no netlist).  -rd box=x1,y1,x2,y2 -rd lds=68/44,70/44,89/44,71/20"""
import pya
ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); px = ly.cell("openDVS_pixel")
b = [float(v) for v in box.split(",")]; win = pya.Box(int(b[0]*1000), int(b[1]*1000), int(b[2]*1000), int(b[3]*1000))
for ld in lds.split(","):
    l, d = [int(v) for v in ld.split("/")]; li = ly.find_layer(l, d)
    print("== %d/%d" % (l, d))
    if li is None: print("   (no such layer)"); continue
    for s in px.shapes(li).each_overlapping(win):
        p = s.polygon
        if p is None: continue
        bb = p.bbox()
        print("   (%.3f,%.3f;%.3f,%.3f) %s" % (bb.left/1e3, bb.bottom/1e3, bb.right/1e3, bb.top/1e3, "" if p.is_box() else " ".join("(%.3f,%.3f)" % (pt.x/1e3, pt.y/1e3) for pt in p.each_point_hull())))
