"""Pixel-only GDS variants for Magic attribution of C(nRst,vd) by REGION: clip every drawing layer to a window
(labels inside the window kept, extra labels added where the clipped net would otherwise be unnamed), plus
in-window edits.   klayout -b -r make_variants_win.py   -> rcc/attrib_win/<name>.gds (top cell openDVS_pixel)"""
import pya, os
os.makedirs("rcc/attrib_win", exist_ok=True)
def B(x1, y1, x2, y2): return pya.Box(int(x1*1000), int(y1*1000), int(x2*1000), int(y2*1000))
LN = {"poly": (66,20), "licon": (66,44), "li": (67,20), "mcon": (67,44), "met1": (68,20), "via1": (68,44), "met2": (69,20), "via2": (69,44), "met3": (70,20)}
ALL = B(-3, -3, 15.5, 15.5); LOW = B(-3, -3, 15.5, 6.5); UP = B(-3, 6.5, 15.5, 15.5)
VDM2 = B(9.50, 2.19, 11.23, 3.81)                 # vd met2: bar (9.515-11.045, 3.52-3.66) + vertical (10.905-11.225, 2.195-3.66) + (9.515-9.885, 3.66-3.8)
PLATE = B(10.245, 2.795, 12.275, 4.33)            # VddA18 met1 plate over the cap slot
PLATE_EXT = B(9.45, 3.35, 10.245, 3.85)           # candidate shield: extend the plate west, under the vd met2 bar, over the gate-contact endcap
GATE_LI = B(9.85, 3.86, 10.25, 4.76)              # my gate li (9.86-10.24, 3.87-4.75) + its licons/mcon region
UP_LABELS = [((68, 5), "vd", 10.23, 10.0), ((67, 5), "nRst", 10.63, 9.5)]   # vd met1 vertical (10.16-10.30, 9.16-11.46); nRst li (10.545-10.715, 8.72-11.115)
VAR = {
  "full":            (ALL, [], []),
  "low":             (LOW, [], []),
  "up":              (UP,  [], UP_LABELS),
  "low_no_vdm2":     (LOW, [("met2", VDM2, "cut"), ("via2", VDM2, "cut"), ("via1", VDM2, "cut")], []),
  "low_no_plate":    (LOW, [("met1", PLATE, "cut")], []),
  "low_plate_ext":   (LOW, [("met1", PLATE_EXT, "add")], []),
  "full_plate_ext":  (ALL, [("met1", PLATE_EXT, "add")], []),
  "low_no_gateli":   (LOW, [("li", GATE_LI, "cut"), ("licon", GATE_LI, "cut"), ("mcon", GATE_LI, "cut")], []),   # cap gate floats: nRst minus the cap
  "low_vdm2_westcut":(LOW, [("met2", B(9.50, 2.19, 10.245, 3.81), "cut"), ("via2", B(9.50, 2.19, 10.245, 3.81), "cut")], []),   # vd met2 only where the plate is under it
  "up_lo":           (B(-3, 6.5, 15.5, 9.0), [], [((68, 5), "vd", 9.66, 8.5), ((67, 5), "nRst", 10.2, 8.0)]),   # crossings: nRst met1 under vd met3, nRst li leg vs vd met1/met2
  "up_hi":           (B(-3, 9.0, 15.5, 15.5), [], UP_LABELS),                                                     # parallel run: vd met1 vertical vs nRst li, GndA li shield between
  "up_hi_no_shield": (B(-3, 9.0, 15.5, 15.5), [("li", B(10.205, 8.890, 10.375, 11.300), "cut"), ("li", B(9.550, 8.890, 10.200, 9.060), "cut")], UP_LABELS),
}
for name, (win, edits, labels) in VAR.items():
    ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); px = ly.cell("openDVS_pixel")
    for li in ly.layer_indexes():
        info = ly.get_info(li)
        if info.datatype == 5:      # labels: keep those inside the window
            keep = [(s.text_string, s.text_pos) for s in px.shapes(li).each() if s.is_text() and win.contains(s.text_pos)]
            px.shapes(li).clear()
            for t, p in keep: px.shapes(li).insert(pya.Text(t, pya.Trans(p)))
            continue
        r = pya.Region(px.shapes(li)) & pya.Region(win)
        px.shapes(li).clear(); px.shapes(li).insert(r)
    for ln, box, op in edits:
        li = ly.find_layer(*LN[ln]); r = pya.Region(px.shapes(li))
        r = (r - pya.Region(box)) if op == "cut" else (r + pya.Region(box)).merged()
        px.shapes(li).clear(); px.shapes(li).insert(r)
    for (l, d), t, x, y in labels:
        px.shapes(ly.layer(l, d)).insert(pya.Text(t, pya.Trans(pya.Point(int(x*1000), int(y*1000)))))
    opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(px.cell_index())
    ly.write("rcc/attrib_win/%s.gds" % name, opt); print("wrote", name)
