import pya
ly = pya.Layout(); ly.read(globals().get("gds", "pixel_4tile_work.gds")); c = ly.cell("openDVS_pixel")
b = [float(v) for v in box.split(",")]; win = pya.Box(int(b[0]*1000), int(b[1]*1000), int(b[2]*1000), int(b[3]*1000))
for (l, d, n) in [(64,20,"nwell"),(65,20,"diff"),(65,44,"tap"),(94,20,"psdm"),(93,44,"nsdm"),(78,44,"hvtp"),(66,20,"poly"),(66,44,"licon"),(67,20,"li"),(67,44,"mcon"),(68,20,"met1")]:
    li = ly.find_layer(l, d)
    if li is None: continue
    r = pya.Region(c.begin_shapes_rec_touching(li, win)); r.merge()
    for p in r.each():
        bx = p.bbox()
        extra = "" if p.is_box() else "poly %d pts: %s" % (p.num_points(), " ".join("(%.3f,%.3f)" % (q.x/1e3, q.y/1e3) for q in p.each_point_hull()))
        print("%-6s (%.3f,%.3f;%.3f,%.3f) %s" % (n, bx.left/1e3, bx.bottom/1e3, bx.right/1e3, bx.top/1e3, extra))
