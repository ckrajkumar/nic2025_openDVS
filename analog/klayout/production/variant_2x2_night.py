"""Export a 2x2 with a night edit-set combo applied to openDVS_pixel:  klayout -b -r variant_2x2_night.py -rd name=<combo>"""
import pya, re
src = open("edit_night.py").read()
ns = {"pya": pya, "os": __import__("os"), "shutil": __import__("shutil")}
exec(src.split("MODE = globals()")[0], ns)          # defines B, LN, E, COMBOS, apply_sets
ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); px = ly.cell("openDVS_pixel"); ns["apply_sets"](ly, px, ns["COMBOS"][name])
c = ly.cell("openDVS_pixel2x2_top"); opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(c.cell_index())
ly.write("rcc/openDVS_pixel2x2_top.night_%s.gds" % name, opt); print("wrote night_%s" % name, ns["COMBOS"][name])
