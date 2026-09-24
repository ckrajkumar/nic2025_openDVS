import pya
ly = pya.Layout(); ly.read("rcc/work_bot4x4.r17b.gds"); c = ly.cell("openDVS_pixel_4x4_bot")
opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(c.cell_index()); ly.write("rcc/openDVS_pixel_4x4_bot.r17b.gds", opt)
