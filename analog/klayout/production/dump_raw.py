"""Raw layer polygons of openDVS_pixel inside a window.  -rd box=... -rd layers=65/20,64/20,94/20,93/44,78/44"""
import pya
ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); px = ly.cell("openDVS_pixel")
b = [float(v) for v in box.split(",")]; win = pya.Region(pya.Box(int(b[0]*1000), int(b[1]*1000), int(b[2]*1000), int(b[3]*1000)))
for spec in layers.split(","):
    l, d = map(int, spec.split("/")); li = ly.find_layer(l, d)
    if li is None: print("%s: (absent)" % spec); continue
    r = pya.Region(px.begin_shapes_rec(li)) & win
    for p in r.merged().each():
        print("%s: %s" % (spec, " ".join("(%.3f,%.3f)" % (pt.x/1e3, pt.y/1e3) for pt in p.each_point_hull())))
