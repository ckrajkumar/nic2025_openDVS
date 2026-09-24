# klayout -b -r stripe_ends.py -rd wrapper=... : where the wrapper's vertical vdda1/vssa1 met4 stripes end below/above the tile, and what met4 the tile has in the ring band
import pya
ly = pya.Layout(); ly.read(wrapper); top = ly.top_cell()
tc = ly.cell("pixel_4tile"); inst = [i for i in top.each_inst() if i.cell.name == "pixel_4tile"][0]; T = inst.cplx_trans
m4 = ly.layer(71,20); v3 = ly.layer(70,44)
tb = tc.bbox().transformed(T)
wm4 = pya.Region(top.shapes(m4))
vert = pya.Region([p for p in wm4.each() if p.bbox().height() > 50000 and p.bbox().width() < 5000])
below = pya.Region([p for p in vert.each() if p.bbox().top <= tb.bottom + 1 and p.bbox().top > tb.bottom - 30000 and tb.left < p.bbox().left < tb.right])
above = pya.Region([p for p in vert.each() if p.bbox().bottom >= tb.top - 1 and p.bbox().bottom < tb.top + 30000 and tb.left < p.bbox().left < tb.right])
print("tile bbox", tb.to_s())
print("vertical wrapper met4 stripes ending at the tile bottom edge: %d, top ends y=%s, x pitch sample %s" % (below.count(), sorted(set(p.bbox().top for p in below.each()))[:3], [round(p.bbox().left/1000,1) for p in sorted(below.each(), key=lambda p:p.bbox().left)[:6]]))
print("vertical wrapper met4 stripes starting at the tile top edge: %d" % above.count())
# tile met4 (hierarchical) in the bottom band between the tile edge and the array bottom (y 600..715.7 k), excluding the six bars
band = pya.Box(tb.left+80000, tb.bottom, tb.right-80000, 675665+40050)
tm4 = pya.Region(tc.begin_shapes_rec_overlapping(m4, band.transformed(T.inverted()))).transformed(T) & pya.Region(band)
print("tile met4 in the bottom periphery band (x inside the bars): %d shapes, area %.0f um2; sample %s" % (tm4.count(), tm4.area()/1e6, [p.bbox().to_s() for p in list(tm4.each())[:4]]))
# VddA18 column bottoms: via3 arrays on the vdda1 bottom ring -> x positions
ring = pya.Region(pya.Box(1131000,625665,2823265,635665))
v3r = pya.Region(top.begin_shapes_rec(v3)) & ring; v3r.merge(); arrays = v3r.sized(300).merged()
xs = sorted(round((a.bbox().left+a.bbox().right)/2000,1) for a in arrays.each())
print("via3 arrays on the vdda1 bottom ring: %d, x centres (um) first 8: %s, pitch %.2f" % (arrays.count(), xs[:8], (xs[-2]-xs[1])/(len(xs)-3)))
