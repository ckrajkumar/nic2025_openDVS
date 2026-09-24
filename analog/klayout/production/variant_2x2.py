"""Export a 2x2 (openDVS_pixel2x2_top) with a pixel-level edit applied in memory, for Quantus/Magic what-if runs.
   klayout -b -r variant_2x2.py -rd name=<tag>   (edits table below)   -> rcc/openDVS_pixel2x2_top.<tag>.gds"""
import pya
def B(x1, y1, x2, y2): return pya.Box(int(x1*1000), int(y1*1000), int(x2*1000), int(y2*1000))
LN = {"li": (67,20), "met1": (68,20)}
VAR = {
  "plate_ext":  [("met1", B(9.45, 3.35, 10.245, 3.85), "add")],                                              # VddA18 met1 plate extended west under the vd met2 overhang
  "no_shield":  [("li", B(10.205, 8.890, 10.375, 11.300), "cut"), ("li", B(9.550, 8.890, 10.200, 9.060), "cut")],   # GndA li shield in the column removed
}
ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); px = ly.cell("openDVS_pixel")
for ln, box, op in VAR[name]:
    li = ly.find_layer(*LN[ln]); r = pya.Region(px.shapes(li))
    r = (r - pya.Region(box)) if op == "cut" else (r + pya.Region(box)).merged()
    px.shapes(li).clear(); px.shapes(li).insert(r)
c = ly.cell("openDVS_pixel2x2_top"); opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(c.cell_index())
ly.write("rcc/openDVS_pixel2x2_top.%s.gds" % name, opt); print("wrote", name)
