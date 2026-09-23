# klayout -b -r via_geom.py -rd wrapper=... : via4 sizes on the wrapper grid crossings of the tile's west vdda1 bar, met5 stripe width there, via3 array sizes on the top vdda1 ring
import pya
ly = pya.Layout(); ly.read(wrapper); top = ly.top_cell()
tc = ly.cell("pixel_4tile"); inst = [i for i in top.each_inst() if i.cell.name == "pixel_4tile"][0]; T = inst.cplx_trans
m4 = ly.layer(71,20); v4 = ly.layer(71,44); m3 = ly.layer(70,20); v3 = ly.layer(70,44); m5 = ly.layer(72,20)
bar = pya.Region(pya.Box(1156885,600000,1166885,2389450))   # west middle bar (vdda1)
via4 = pya.Region(top.shapes(v4)) & bar
print("via4 on the west vdda1 bar:", via4.count(), "sizes", sorted(set("%.2fx%.2f" % (p.bbox().width()/1e3, p.bbox().height()/1e3) for p in via4.each())))
m5b = pya.Region(top.shapes(m5)) & bar
print("met5 stripe widths over the bar:", sorted(set("%.2f" % (p.bbox().height()/1e3) for p in m5b.each()))[:6], "count", m5b.count())
topring = pya.Region(pya.Box(1131000,2354105,2823265,2364105))  # top middle ring (vdda1), wrapper coords
via3 = pya.Region(top.begin_shapes_rec(v3)) & topring; via3.merge()
arrays = via3.sized(300).merged()
sizes = sorted(set("%.2fx%.2f" % (a.bbox().width()/1e3-0.6, a.bbox().height()/1e3-0.6) for a in arrays.each()))
print("via3 on the top vdda1 ring:", via3.count(), "in", arrays.count(), "arrays; array extents", sizes[:6], "via size", sorted(set("%.2f" % (p.bbox().width()/1e3) for p in via3.each())))
# per array via count
cnts = sorted(set(sum(1 for _ in (via3 & pya.Region(a)).each()) for a in list(arrays.each())[:20]))
print("vias per array (first 20):", cnts)
# west inner bar (vssa1): via3 arrays sizes
wbar = pya.Region(pya.Box(1176885,600000,1186885,2389450)); v3w = pya.Region(top.begin_shapes_rec(v3)) & wbar; v3w.merge(); aw = v3w.sized(300).merged()
print("via3 on the west vssa1 bar:", v3w.count(), "in", aw.count(), "arrays; vias per array", sorted(set(sum(1 for _ in (v3w & pya.Region(a)).each()) for a in list(aw.each())[:20])))
