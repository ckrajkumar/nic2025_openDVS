import pya
ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); c = ly.cell("openDVS_pixel2x2_top")
opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(c.cell_index()); ly.write("rcc/openDVS_pixel2x2_top.r17b.gds", opt)
