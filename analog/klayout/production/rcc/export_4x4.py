import pya
ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); c = ly.cell("openDVS_pixel_4x4")
opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(c.cell_index()); ly.write("rcc/openDVS_pixel_4x4.r17b.gds", opt)
