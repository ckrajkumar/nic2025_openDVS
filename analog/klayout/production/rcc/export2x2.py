import pya
for tag, src in (("pristine", "pixel_4tile_mag_9_1_pruned.gds"), ("edit20260921", "pixel_4tile_work.gds")):
    ly = pya.Layout(); ly.read(src); c = ly.cell("openDVS_pixel2x2_top")
    opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(c.cell_index())
    out = "rcc/openDVS_pixel2x2_top.%s.gds" % tag; ly.write(out, opt); print("wrote", out)
