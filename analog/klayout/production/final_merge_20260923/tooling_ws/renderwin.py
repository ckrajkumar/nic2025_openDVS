# QT_QPA_PLATFORM=offscreen klayout -z -r renderwin.py -rd gds=<file> -rd cell=<cell> -rd box=x1,y1,x2,y2 -rd out=<png> [-rd px=1600]
import pya
ly = pya.Layout(); ly.read(gds); c = ly.cell(cell)
LAYS = {(64,20):("nwell","#d0d0d0"),(65,20):("diff","#40c040"),(65,44):("tap","#207020"),(93,44):("nsdm","#ffb0b0"),(94,20):("psdm","#b0d0ff"),
        (66,20):("poly","#e0a000"),(66,44):("licon","#805000"),(95,20):("npc","#ff80c0"),(67,20):("li","#3060ff"),(67,44):("mcon","#102080"),
        (68,20):("met1","#8080ff"),(68,44):("via","#404090"),(69,20):("met2","#e040e0"),(69,44):("via2","#801080"),(70,20):("met3","#20c0c0"),(71,20):("met4","#f0b060")}
O = pya.Layout(); O.dbu = ly.dbu; top = O.create_cell("win")
x1,y1,x2,y2 = [float(v) for v in box.split(",")]
win = pya.Region(pya.Box(int(x1/ly.dbu), int(y1/ly.dbu), int(x2/ly.dbu), int(y2/ly.dbu)))
lps = []
for li in ly.layer_indexes():
    info = ly.get_info(li); k = (info.layer, info.datatype)
    if k not in LAYS: continue
    r = pya.Region(c.begin_shapes_rec(li)); r.merge(); r = r & win
    if r.is_empty(): continue
    ol = O.layer(pya.LayerInfo(k[0], k[1], LAYS[k][0])); top.shapes(ol).insert(r); lps.append((ol, LAYS[k]))
view = pya.LayoutView(); view.create_layout(True); cv = view.cellview(0); cv.layout().assign(O); cv.cell = cv.layout().cell("win")
view.clear_layers()
for ol, (name, col) in lps:
    lp = pya.LayerPropertiesNode(); lp.source = "%d/%d@1" % (O.get_info(ol).layer, O.get_info(ol).datatype); lp.name = name
    lp.fill_color = int(col[1:], 16); lp.frame_color = int(col[1:], 16); lp.dither_pattern = 1 if name in ("nwell","nsdm","psdm") else (5 if name in ("li","met1","met2","met3","met4","poly","diff","tap") else 0); lp.width = 1
    view.insert_layer(view.end_layers(), lp)
view.set_config("background-color", "#ffffff"); view.set_config("grid-visible", "false")
view.zoom_box(pya.DBox(x1, y1, x2, y2)); view.max_hier(); view.update_content()
PX = int(globals().get("px", "1600")); view.save_image(out, PX, int(PX*(y2-y1)/(x2-x1)))
print("wrote", out, "layers", [n for _, (n, _) in lps])
