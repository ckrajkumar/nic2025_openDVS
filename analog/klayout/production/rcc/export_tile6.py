import pya
ly = pya.Layout(); ly.read("pixel_4tile_work.edit20260922r17b.gds"); c = ly.cell("pixel_4tile")
opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(c.cell_index()); ly.write("rcc/pixel_4tile.r17b.gds", opt); print("wrote r17b")
