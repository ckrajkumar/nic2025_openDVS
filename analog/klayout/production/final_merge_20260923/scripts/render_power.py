# QT_QPA_PLATFORM=offscreen klayout -z -r render_power.py -rd gds=<file> -rd box=x1,y1,x2,y2 (um) -rd out=<png> [-rd px=1800]
# Metal-only render (met1..met5 + vias + power labels) of a window of the wrapper, hierarchy flattened into the window.
import pya
ly = pya.Layout(); ly.read(gds); c = ly.top_cell()
LAYS = {(68,20):("met1","#9090ff",4),(68,44):("via1","#404090",0),(69,20):("met2","#e040e0",4),(69,44):("via2","#801080",0),
        (70,20):("met3","#20c0c0",5),(70,44):("via3","#106060",0),(71,20):("met4","#f0b060",2),(71,44):("via4","#a05000",0),(72,20):("met5","#ff4040",6)}
O = pya.Layout(); O.dbu = ly.dbu; top = O.create_cell("win")
x1,y1,x2,y2 = [float(v) for v in box.split(",")]
ibox = pya.Box(int(x1/ly.dbu), int(y1/ly.dbu), int(x2/ly.dbu), int(y2/ly.dbu)); win = pya.Region(ibox)
lps = []
for li in ly.layer_indexes():
    info = ly.get_info(li); k = (info.layer, info.datatype)
    if k not in LAYS: continue
    r = pya.Region(c.begin_shapes_rec_overlapping(li, ibox)); r.merge(); r = r & win
    if r.is_empty(): continue
    ol = O.layer(pya.LayerInfo(k[0], k[1], LAYS[k][0])); top.shapes(ol).insert(r); lps.append((ol, LAYS[k]))
# labels (power names) on met2..met5, from the hierarchy, as texts
tl = O.layer(pya.LayerInfo(200, 0, "labels")); nlab = 0
for (a,b) in [(69,5),(70,5),(71,5),(72,5)]:
    li = ly.find_layer(a,b)
    if li is None: continue
    it = c.begin_shapes_rec_overlapping(li, ibox)
    while not it.at_end():
        s = it.shape()
        if s.is_text():
            t = s.text.transformed(it.trans())
            if ibox.contains(t.trans.disp.to_p()) and any(w in t.string.lower() for w in ("vdd","vss","gnd")):
                top.shapes(tl).insert(pya.Text(t.string + "@" + ["","","","met2","met3","met4","met5"][a-66], t.trans)); nlab += 1
        it.next()
view = pya.LayoutView(); view.create_layout(True); cv = view.cellview(0); cv.layout().assign(O); cv.cell = cv.layout().cell("win")
view.clear_layers()
for ol, (name, col, dp) in lps:
    lp = pya.LayerPropertiesNode(); lp.source = "%d/%d@1" % (O.get_info(ol).layer, O.get_info(ol).datatype); lp.name = name
    lp.fill_color = int(col[1:], 16); lp.frame_color = int(col[1:], 16); lp.dither_pattern = dp; lp.width = 1
    view.insert_layer(view.end_layers(), lp)
lp = pya.LayerPropertiesNode(); lp.source = "200/0@1"; lp.name = "labels"; lp.fill_color = 0; lp.frame_color = 0; lp.width = 2
view.insert_layer(view.end_layers(), lp)
view.set_config("background-color", "#ffffff"); view.set_config("grid-visible", "false"); view.set_config("text-visible", "true"); view.set_config("default-text-size", "0.6")
view.zoom_box(pya.DBox(x1, y1, x2, y2)); view.max_hier(); view.update_content()
PX = int(globals().get("px", "1800")); view.save_image(out, PX, int(PX*(y2-y1)/(x2-x1)))
print("wrote", out, "layers", [n for _, (n, _, _) in lps], "labels", nlab)
