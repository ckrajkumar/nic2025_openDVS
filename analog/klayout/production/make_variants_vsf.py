"""Pixel-only variants for Magic attribution of C(nRst,vsf) (series cuts isolate the labelled right-hand part of nRst).
   klayout -b -r make_variants_vsf.py -> rcc/attrib_vsf/<name>.gds"""
import pya, os
os.makedirs("rcc/attrib_vsf", exist_ok=True)
def B(x1, y1, x2, y2): return pya.Box(int(x1*1000), int(y1*1000), int(x2*1000), int(y2*1000))
LN = {"li": (67,20), "met1": (68,20), "met2": (69,20)}
VAR = {
  "base": [],
  "no_leftrun":  [("met1", B(2.5, 3.0, 8.9, 3.35))],     # nRst met1 run under vdiff met2 / vsf met3 (left part becomes unnamed)
  "no_met2left": [("met2", B(0.5, 2.4, 2.45, 3.3))],     # nRst met2 at the reset-gen (pull-down side unnamed)
  "no_leg":      [("li", B(10.10, 7.56, 10.29, 8.55))],  # nRst li leg beside vsf met1 (upper part / Mrst gate unnamed)
  "no_top":      [("li", B(10.53, 8.72, 10.72, 11.13))], # nRst li top run (Mrst gate unnamed)
}
for name, cuts in VAR.items():
    ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); px = ly.cell("openDVS_pixel")
    for ln, box in cuts:
        li = ly.find_layer(*LN[ln]); r = pya.Region(px.shapes(li)) - pya.Region(box)
        px.shapes(li).clear(); px.shapes(li).insert(r)
    opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(px.cell_index())
    ly.write("rcc/attrib_vsf/%s.gds" % name, opt); print("wrote", name)
