import pya
ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); c = ly.cell("openDVS_pixel")
def R(l, d):
    li = ly.find_layer(l, d); return pya.Region() if li is None else pya.Region(c.begin_shapes_rec(li)).merged()
hole = pya.Region(pya.Box(3310, 3280, 9010, 8980)); um2 = lambda r: r.area() / 1e6
print("aperture (met5 hole) %.2f um2 = %.1f %% of the 147.9 um2 pixel" % (um2(hole), 100 * um2(hole) / 147.9))
for n, (l, d) in {"diff": (65, 20), "poly": (66, 20), "li": (67, 20), "met1": (68, 20), "met2": (69, 20), "met3": (70, 20), "capm": (89, 44), "met4": (71, 20), "nwell": (64, 20)}.items():
    r = R(l, d) & hole; print("  %-5s inside aperture: %.2f um2  %s" % (n, um2(r), [q.bbox().to_s() for q in r.each()][:4]))
nw = R(64, 20)
print("nwell polygons:", [(q.bbox().to_s(), round(q.area() / 1e6, 2)) for q in nw.each()])
