import pya
ly = pya.Layout(); ly.read("/home/rpgraca/opendvs_final/merged/pixel_4tile.r18.gds"); c = ly.cell("openDVS_pixel2x2_top")
opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(c.cell_index()); ly.write("/home/rpgraca/opendvs_final/merged/openDVS_pixel2x2_top.r18.gds", opt)
o = pya.Layout(); o.read("/home/rpgraca/opendvs_final/merged/openDVS_pixel2x2_top.r18.gds"); print("exported cells:", [x.name for x in o.each_cell()], "top", o.top_cell().name, "bbox", o.top_cell().bbox().to_s())
