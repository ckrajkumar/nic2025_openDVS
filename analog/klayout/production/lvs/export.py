import pya
ly = pya.Layout(); ly.read("/home/rpgraca/research/projects/telluride/2025/nic_eventcam/nic2025_openDVS/analog/klayout/production/pixel_4tile_work.gds")
c = ly.cell("openDVS_pixel2x2_top"); c.name = "openDVS_pixel2x2"
opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(c.cell_index())
ly.write("/home/rpgraca/research/projects/telluride/2025/nic_eventcam/nic2025_openDVS/analog/klayout/production/lvs/openDVS_pixel2x2_top.work.deep.gds", opt)
print("wrote /home/rpgraca/research/projects/telluride/2025/nic_eventcam/nic2025_openDVS/analog/klayout/production/lvs/openDVS_pixel2x2_top.gds  child cells:", sorted(ly.cell(i).name for i in c.each_child_cell()))
