import pya
ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); c = ly.cell("pixel_4tile")
print("pixel_4tile bbox", c.bbox(), "instances of 2x2 cells:", sum(1 for i in c.each_inst()), "pixels (flat):", c.child_instances() if hasattr(c, "child_instances") else "?")
opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(c.cell_index()); ly.write("rcc/pixel_4tile.r15a.gds", opt)
