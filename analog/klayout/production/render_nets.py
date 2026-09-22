"""Render a pixel window with net overlays.  klayout -b -r render_nets.py -rd out=x.png [-rd box=8,1,12.5,12.5] [-rd nets=nRst,vd,vsf,GndA,VddA18]"""
import pya, sys
sys.path.insert(0, "."); import opendvs_l2n
ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); px = ly.cell("openDVS_pixel")
l2n = opendvs_l2n.build_l2n(ly, px); top = l2n.netlist().top_circuit()
LAY = ["poly","licon","li","mcon","met1","via1","met2","via2","met3"]
NETS = globals().get("nets", "nRst,vd,vsf").split(",")
COL = {"nRst": 0xff2020, "vd": 0x20c0ff, "vsf": 0x40ff40, "GndA": 0x808080, "VddA18": 0xffa000, "vdiff": 0xff40ff, "vpr": 0xffff40}
# copy net shapes into fresh layers so they can be coloured per net
tmp = {}
for net in top.each_net():
    if net.name not in NETS: continue
    for ln in LAY:
        r = l2n.shapes_of_net(net, l2n.layer_by_name(ln), True)
        if r.is_empty(): continue
        li = ly.layer(pya.LayerInfo(900 + NETS.index(net.name), LAY.index(ln), "%s_%s" % (net.name, ln)))
        px.shapes(li).insert(r); tmp[(net.name, ln)] = li
view = pya.LayoutView(); cv = view.create_layout(True); cv_ly = view.cellview(0).layout()
cv_ly.assign(ly); view.cellview(0).cell = cv_ly.cell("openDVS_pixel")
view.set_config("background-color", "#ffffff"); view.set_config("grid-visible", "false")
view.clear_layers()
# base layers, faint
base = {(66,20):("#c0a000","poly"),(66,44):("#806000","licon"),(67,20):("#4060ff","li"),(67,44):("#203080","mcon"),(68,20):("#4040c0","met1"),(68,44):("#202060","via1"),(69,20):("#c040c0","met2"),(69,44):("#602060","via2"),(70,20):("#40c0c0","met3"),(65,20):("#40a040","diff"),(78,44):("#e0e0a0","hvtp")}
for (l, d), (col, name) in base.items():
    lp = pya.LayerPropertiesNode(); lp.source = "%d/%d@1" % (l, d); lp.fill_color = int(col[1:], 16); lp.frame_color = int(col[1:], 16)
    lp.dither_pattern = 4 if name in ("li", "met1", "met2", "met3", "poly") else 0; lp.transparent = True; lp.width = 1; lp.name = name
    view.insert_layer(view.end_layers(), lp)
for (net, ln), li in tmp.items():
    lp = pya.LayerPropertiesNode(); info = ly.get_info(li); lp.source = "%d/%d@1" % (info.layer, info.datatype)
    lp.fill_color = COL.get(net, 0x000000); lp.frame_color = COL.get(net, 0x000000); lp.width = 2
    lp.dither_pattern = {"poly": 7, "li": 1, "met1": 0, "met2": 5, "met3": 9}.get(ln, 2); lp.transparent = False; lp.name = "%s %s" % (net, ln)
    view.insert_layer(view.end_layers(), lp)
b = [float(v) for v in globals().get("box", "8,1,12.5,12.5").split(",")]
view.max_hier(); view.zoom_box(pya.DBox(b[0], b[1], b[2], b[3]))
view.save_image(out, 1400, int(1400 * (b[3]-b[1]) / (b[2]-b[0])))
print("wrote", out)
