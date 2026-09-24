"""Render the openDVS_pixel cell of the work file with the changes vs the pristine macro highlighted.
   klayout -b -r render_diff.py -rd out=x.png [-rd work=pixel_4tile_work.gds] [-rd ref=pixel_4tile_mag_9_1_pruned.gds]
                                 [-rd box=0,0,12.16,12.16] [-rd px=2000]
   Base = the work-file pixel, flattened, faint per-layer colours.  Added shapes (work - ref) in saturated
   per-layer colour with a black frame; removed shapes (ref - work) hatched red with a red frame."""
import pya
work = globals().get("work", "pixel_4tile_work.gds"); ref = globals().get("ref", "pixel_4tile_mag_9_1_pruned.gds"); mid = globals().get("mid", "")
out = globals().get("out", "pixel_diff.png"); PX = int(globals().get("px", "2000"))
A = pya.Layout(); A.read(ref); B = pya.Layout(); B.read(work)
ca, cb = A.cell("openDVS_pixel"), B.cell("openDVS_pixel")
# layer -> (name, base colour, added colour)
LAYS = {(65, 20): ("diff", "#b8dcb8", "#20a020"), (64, 20): ("nwell", "#e8e8e8", "#a0a0a0"),
        (66, 20): ("poly", "#e8dca0", "#d09000"), (66, 44): ("licon", "#d0c090", "#806000"),
        (95, 20): ("npc", "#f0d8d8", "#c06060"),
        (67, 20): ("li", "#c8d0f0", "#3050e0"), (67, 44): ("mcon", "#b0b8e0", "#102080"),
        (68, 20): ("met1", "#c8c8ec", "#4040d0"), (68, 44): ("via1", "#b0b0d8", "#202080"),
        (69, 20): ("met2", "#ecc8ec", "#c030c0"), (69, 44): ("via2", "#d8b0d8", "#701070"),
        (70, 20): ("met3", "#c8ecec", "#20b0b0"), (70, 44): ("via3", "#b0d8d8", "#106060"),
        (71, 20): ("met4", "#f0e0c0", "#e08000"), (71, 44): ("via4", "#e0d0b0", "#804000"),
        (89, 44): ("capm", "#f8e8c8", "#c0a000")}
def flat(ly, c):
    d = {}
    for li in ly.layer_indexes():
        info = ly.get_info(li); k = (info.layer, info.datatype)
        if k not in LAYS: continue
        r = pya.Region(c.begin_shapes_rec(li)); r.merge()
        if not r.is_empty(): d[k] = r
    return d
ra, rb = flat(A, ca), flat(B, cb)
rm = None
if mid:
    M = pya.Layout(); M.read(mid); rm = flat(M, M.cell("openDVS_pixel"))
# output layout: base (work) + added + removed, one flat cell
O = pya.Layout(); O.dbu = B.dbu; top = O.create_cell("diff")
order = sorted(set(ra) | set(rb), key=lambda k: (k[0], k[1]))
props = []
for k in order:
    name, cb_, ca_ = LAYS[k]; b = rb.get(k, pya.Region()); a = ra.get(k, pya.Region())
    if not b.is_empty():
        li = O.layer(pya.LayerInfo(k[0], k[1], name)); top.shapes(li).insert(b); props.append((li, name, cb_, "#909090" if name not in ("nwell",) else cb_, 0, 1, True))
    add, rem = b - a, a - b
    if rm is not None:
        m = rm.get(k, pya.Region()); add_early, rem_early = (m - a) & add, (a - m) & rem; add, rem = add - add_early, rem - rem_early
        if not add_early.is_empty():
            li = O.layer(pya.LayerInfo(700 + k[0], k[1], name + "_added_early")); top.shapes(li).insert(add_early); props.append((li, name + " ADDED earlier", ca_, "#ff8000", 0, 4, False))
        if not rem_early.is_empty():
            li = O.layer(pya.LayerInfo(800 + k[0], k[1], name + "_removed_early")); top.shapes(li).insert(rem_early); props.append((li, name + " REMOVED earlier", "#ff8000", "#ff8000", 6, 3, True))
    if not add.is_empty():
        li = O.layer(pya.LayerInfo(500 + k[0], k[1], name + "_added")); top.shapes(li).insert(add); props.append((li, name + " ADDED", ca_, "#000000", 0, 3, False))
        print("added   %-6s %7.3f um2  %s" % (name, add.area() / 1e6, add.bbox()))
    if not rem.is_empty():
        li = O.layer(pya.LayerInfo(600 + k[0], k[1], name + "_removed")); top.shapes(li).insert(rem); props.append((li, name + " REMOVED", "#ff0000", "#ff0000", 6, 3, True))
        print("removed %-6s %7.3f um2  %s" % (name, rem.area() / 1e6, rem.bbox()))
view = pya.LayoutView(); view.create_layout(True); cv = view.cellview(0); cv.layout().assign(O); cv.cell = cv.layout().cell("diff")
view.set_config("background-color", "#ffffff"); view.set_config("grid-visible", "false"); view.set_config("text-visible", "false")
view.clear_layers()
for li, name, fill, frame, dp, w, transp in props:
    info = O.get_info(li); lp = pya.LayerPropertiesNode(); lp.source = "%d/%d@1" % (info.layer, info.datatype)
    lp.fill_color = int(fill[1:], 16); lp.frame_color = int(frame[1:], 16); lp.dither_pattern = dp; lp.width = w; lp.transparent = transp; lp.name = name
    view.insert_layer(view.end_layers(), lp)
b = [float(v) for v in globals().get("box", "0,0,12.16,12.16").split(",")]
view.max_hier(); view.zoom_box(pya.DBox(b[0], b[1], b[2], b[3]))
view.save_image(out, PX, int(PX * (b[3] - b[1]) / (b[2] - b[0])))
print("wrote", out)
