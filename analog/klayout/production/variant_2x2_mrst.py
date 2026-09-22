"""Export a 2x2 with an edit_mrst.py combo applied to openDVS_pixel (and the 2x2-level pin overlays fixed for combos in NEEDS_TOPFIX):
   klayout -b -r variant_2x2_mrst.py -rd name=<combo>"""
import pya
src = open("edit_mrst.py").read(); ns = {"pya": pya, "os": __import__("os"), "shutil": __import__("shutil")}
exec(src.split("MODE = globals()")[0], ns)
ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); px = ly.cell("openDVS_pixel"); ns["apply_sets"](ly, px, ns["COMBOS"][name])
c = ly.cell("openDVS_pixel2x2_top")
if name in ns["NEEDS_TOPFIX"]: print("TOPFIX applied to openDVS_pixel2x2_top; labels moved:", ns["apply_topfix"](ly, c))
opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(c.cell_index())
ly.write("rcc/openDVS_pixel2x2_top.mrst_%s.gds" % name, opt); print("wrote mrst_%s" % name, ns["COMBOS"][name])
