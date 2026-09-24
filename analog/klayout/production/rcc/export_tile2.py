import pya, sys
for src, tag in (("pixel_4tile_mag_9_1_pruned.gds", "prod"), ("pixel_4tile_work.edit20260922m.gds", "m")):
    ly = pya.Layout(); ly.read(src); c = ly.cell("pixel_4tile")
    opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(c.cell_index()); ly.write("rcc/pixel_4tile.%s.gds" % tag, opt); print("wrote", tag)
