# klayout -b -r ts_gap.py -rd gds=<ts gds> : merged met1/met2 shapes of pixel_test_structure near the Magic met1.2 item (37.83..37.905 x -45.755..-45.615)
import pya
ly = pya.Layout(); ly.read(gds); c = ly.cell("pixel_test_structure")
win = pya.Box(37000, -46500, 39500, -45000)
for (a,b,name) in [(68,20,"met1"),(69,20,"met2")]:
    li = ly.find_layer(a,b); r = pya.Region(c.begin_shapes_rec_overlapping(li, win)); r.merge()
    r = r & pya.Region(win)
    print(name, "merged polygons in window:", r.count())
    for p in r.each(): print("   ", p.bbox().to_s(), "area", p.area()/1e6)
    sp = r.space_check(140, False, pya.Region.Projection)  # 0.14 um spacing violations
    print(name, "0.14 um space violations in window:", sp.count(), [e.to_s() for e in list(sp.each())[:4]])
