import pya as db
for f in files.split(","):
    ly = db.Layout(); ly.read(f)
    tops = [c.name for c in ly.top_cells()]
    names = [ly.cell(i).name for i in range(ly.cells())]
    gs = sum(1 for n in names if n.startswith("GS_"))
    print(f, "cells", len(names), "GS_", gs, "tops", tops)
    m2 = ly.layer(69,20); m1 = ly.layer(68,20); v1 = ly.layer(68,44)
    for cn in ["pixel_layout_biasgen_connector_v3","pixel_4tile_left_vdd_gnd_connectors","pixel_layout_biasgen_connector_v2","pixel_layout_tile","openDVS_pixel","GS_pixel_layout_biasgen_connector_v3","GS_pixel_4tile_left_vdd_gnd_connectors","GS_openDVS_pixel"]:
        c = ly.cell(cn)
        if c is None: continue
        print("  ", cn, "met2", c.shapes(m2).size(), "met1", c.shapes(m1).size(), "via1", c.shapes(v1).size())
