import pya
ly = pya.Layout(); ly.read(gds); c = ly.cell("openDVS_pixel")
L = {(ly.get_info(li).layer, ly.get_info(li).datatype): li for li in ly.layer_indexes()}
win = pya.Box(7500, 1000, 11000, 5000)
for ld, nm in [((70,20),"met3"),((89,44),"capm"),((70,44),"via3"),((69,44),"via2")]:
    r = pya.Region(c.begin_shapes_rec(L[ld])); r.merge()
    for p in r.each():
        if not (pya.Region(p) & pya.Region(win)).is_empty(): print("%-5s %s" % (nm, p.to_s()[:600]))
# distances between met3 polygons that overlap capm (bottom plates) and every other met3
m3 = pya.Region(c.begin_shapes_rec(L[(70,20)])); m3.merge(); cm = pya.Region(c.begin_shapes_rec(L[(89,44)])); cm.merge()
bot = m3.interacting(cm); other = m3 - bot
print("bottom plates:", [p.bbox().to_s() for p in bot.each()])
print("other met3 near plates (<1.2):", [p.bbox().to_s() for p in (other & bot.sized(1200)).each()][:10])
ep = bot.separation_check(other, 1200, False, pya.Region.Euclidian)
for e in ep.each(): print("  sep<1.2:", e.to_s(), "dist %.3f" % (e.distance()/1000.0))
ep2 = bot.space_check(1200, False, pya.Region.Euclidian)
for e in ep2.each(): print("  plate-plate<1.2:", e.to_s(), "dist %.3f" % (e.distance()/1000.0))
