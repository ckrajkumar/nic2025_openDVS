"""Pixel-only GDS variants of the current (rotated-cap) layout for Magic attribution of C(nRst,vd)."""
import pya, os
os.makedirs("rcc/attrib_e", exist_ok=True)
def B(x1, y1, x2, y2): return pya.Box(int(x1*1000), int(y1*1000), int(x2*1000), int(y2*1000))
VAR = {
  "base": [],
  "no_cap_gate": [("poly", B(9.80, 3.25, 12.05, 4.85))],                     # rotated cap gate poly
  "no_cap_gate_li": [("li", B(9.80, 3.80, 10.30, 4.80)), ("licon", B(9.80, 3.80, 10.30, 4.80))],
  "no_nRst_li_top": [("li", B(10.545, 8.72, 10.715, 11.115)), ("li", B(10.715, 10.945, 11.60, 11.115))],
  "no_nRst_li_low": [("li", B(10.11, 7.565, 10.30, 8.72)), ("li", B(10.110, 8.55, 10.545, 8.72))],
  "no_nRst_met1_mid": [("met1", B(9.60, 6.8, 10.10, 7.20))],                 # nRst met1 under vd met3 (9.71-10.00, 7.01-7.14)
  "no_vd_met2_cross": [("met2", B(9.50, 3.50, 11.10, 3.85))],                # vd met2 horizontal bar (9.515-11.045, 3.52-3.66)
  "no_shield": [("li", B(10.205, 8.890, 10.375, 11.300)), ("li", B(9.550, 8.890, 10.200, 9.060))],
}
LN = {"poly": (66,20), "licon": (66,44), "li": (67,20), "met1": (68,20), "met2": (69,20), "met3": (70,20), "via2": (69,44)}
for name, cuts in VAR.items():
    ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); px = ly.cell("openDVS_pixel")
    for ln, box in cuts:
        li = ly.find_layer(*LN[ln]); r = pya.Region(px.shapes(li)) - pya.Region(box)
        px.shapes(li).clear(); px.shapes(li).insert(r)
    opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(px.cell_index())
    ly.write("rcc/attrib_e/%s.gds" % name, opt); print("wrote", name)
