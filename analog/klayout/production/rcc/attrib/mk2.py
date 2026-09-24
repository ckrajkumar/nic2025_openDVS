import pya
def B(x1,y1,x2,y2): return pya.Box(int(x1*1000),int(y1*1000),int(x2*1000),int(y2*1000))
for name, cuts in {"no_vd_met2_cross": [((69,20), B(10.905,2.60,11.045,3.66))], "no_vd_li_m1_contacts": [((67,20), B(10.555,2.225,11.965,2.395)), ((68,20), B(10.575,2.195,11.225,2.515))]}.items():
    ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); px = ly.cell("openDVS_pixel")
    for (l,d), box in cuts:
        li = ly.find_layer(l,d); r = pya.Region(px.shapes(li)) - pya.Region(box); px.shapes(li).clear(); px.shapes(li).insert(r)
    opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(px.cell_index()); ly.write("rcc/attrib/%s.gds" % name, opt); print("wrote", name)
