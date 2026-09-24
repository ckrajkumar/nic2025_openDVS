import pya
def B(x1,y1,x2,y2): return pya.Box(int(x1*1000),int(y1*1000),int(x2*1000),int(y2*1000))
V = {"trim_polyB_2p755": [((66,20), B(10.50,2.60,12.02,2.755))],          # nRst MOS-cap poly bottom raised to 0.13 endcap
     "trim_polyB_2p80":  [((66,20), B(10.50,2.60,12.02,2.80))]}           # 0.085 endcap (DRC-illegal, sensitivity only)
for name, cuts in V.items():
    ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); px = ly.cell("openDVS_pixel")
    for (l,d), box in cuts:
        li = ly.find_layer(l,d); r = pya.Region(px.shapes(li)) - pya.Region(box); px.shapes(li).clear(); px.shapes(li).insert(r)
    opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(px.cell_index()); ly.write("rcc/attrib/%s.gds" % name, opt); print("wrote", name)
