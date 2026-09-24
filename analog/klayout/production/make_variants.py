"""Pixel-only GDS variants for Magic attribution of C(nRst,vd): delete one geometry piece per variant.
   klayout -b -r make_variants.py   -> rcc/attrib/<name>.gds (top cell openDVS_pixel)"""
import pya, os
os.makedirs("rcc/attrib", exist_ok=True)
def B(x1, y1, x2, y2): return pya.Box(int(x1*1000), int(y1*1000), int(x2*1000), int(y2*1000))
VAR = {
  "base": [],
  "no_shield": [("li", B(10.205, 8.890, 10.375, 11.300)), ("li", B(9.550, 8.890, 10.200, 9.060))],
  "no_nRst_polyB": [("poly", B(10.50, 2.40, 12.05, 3.80))],                 # region B gate on nRst (MOS cap 1.5/1.5)
  "no_Mrst_gate": [("poly", B(11.235, 10.865, 11.655, 12.015))],
  "no_nRst_li_top": [("li", B(10.545, 8.72, 10.715, 11.115)), ("li", B(10.715, 10.945, 11.60, 11.115))],
  "no_nRst_li_low": [("li", B(9.940, 7.565, 10.280, 8.720)), ("li", B(10.110, 8.55, 10.545, 8.72))],
  "no_vd_m2m3": [("met2", B(9.525, 7.410, 9.805, 8.240)), ("met3", B(9.500, 7.015, 10.120, 7.780)), ("via2", B(9.565, 7.495, 9.765, 7.695))],
  "no_vd_met1_low": [("met1", B(9.535, 7.905, 9.795, 9.020))],
  "no_vd_met1_vert": [("met1", B(10.160, 9.160, 10.300, 11.460))],
}
LN = {"poly": (66,20), "li": (67,20), "met1": (68,20), "met2": (69,20), "met3": (70,20), "via2": (69,44)}
for name, cuts in VAR.items():
    ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); px = ly.cell("openDVS_pixel")
    for ln, box in cuts:
        li = ly.find_layer(*LN[ln]); r = pya.Region(px.shapes(li)) - pya.Region(box)
        px.shapes(li).clear(); px.shapes(li).insert(r)
    opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(px.cell_index())
    ly.write("rcc/attrib/%s.gds" % name, opt); print("wrote", name)
