# klayout -b -r r21_build.py -rd src=r20/user_project_wrapper.gds -rd out=r21/user_project_wrapper.gds
# r21 = r20 + the missing via2 of analog_io[17] -> BiasBranchnMasterx11/rx (reported by ChipFoundry, Mitch, 2026-09-23 18:38 CEST).
# The router's met2 wire of analog_io[17] ends at x 403.650 um under the macro's met3 pin rx (x 403.420-417.630, y 2620.285-2625.285)
# without a via2. Added at the top level of user_project_wrapper, all on that net:
#   via2 0.200 x 0.200 at x 403.485-403.685 (r21b; r21 had 403.435, m3.4 enclosure 0.015), y 2622.320-2622.520 (inside the met3 pin: >= 0.065 met3 enclosure)
#   met2 pad x 403.400-403.770, y 2622.280-2622.560 (via2 enclosure 0.085 in x, 0.040 in y; area 0.104 um2; overlaps the existing met2 wire)
import pya
ly = pya.Layout(); ly.read(src); top = ly.top_cell()
dbu = ly.dbu
def B(x1, y1, x2, y2): return pya.Box(int(round(x1/dbu)), int(round(y1/dbu)), int(round(x2/dbu)), int(round(y2/dbu)))
m2 = ly.layer(69, 20); v2 = ly.layer(69, 44); m3p = ly.find_layer(70, 16)
via = B(403.485, 2622.320, 403.685, 2622.520); pad = B(403.400, 2622.280, 403.770, 2622.560)   # r21b: via2 >= 0.065 inside the met3 pin edge x 403.420 (m3.4)
# sanity: the via lies inside the rx met3 pin of the macro, and the pad touches the existing top-level met2 wire
inst = [i for i in top.each_inst() if i.cell.name == "BiasBranchnMasterx11"][0]
pin = B(403.420, 2620.285, 417.630, 2625.285)
assert pin.contains(via.p1) and pin.contains(via.p2)
assert any(s.bbox().overlaps(pad) for s in top.shapes(m2).each_overlapping(pad)), "pad does not touch the existing met2 wire"
others = [s.bbox() for s in top.shapes(v2).each_overlapping(B(402.9, 2621.8, 404.2, 2623.0))]
assert not others, "a via2 is already there: %s" % others
top.shapes(m2).insert(pad); top.shapes(v2).insert(via)
ly.write(out)
print("r21 written:", out, "via2", via, "met2 pad", pad)
