"""Window decomposition of C(nRst,vd) for a pixel-only GDS (default rcc/attrib_mrst/m1.gds):
   klayout -b -r make_variants_win_mrst.py [-rd src=<pixel gds>] [-rd out=rcc/attrib_win_m1]   -> <out>/<name>.gds"""
import pya, os
SRC = globals().get("src", "rcc/attrib_mrst/m1.gds"); OUT = globals().get("out", "rcc/attrib_win_m1"); os.makedirs(OUT, exist_ok=True)
def B(x1, y1, x2, y2): return pya.Box(int(x1*1000), int(y1*1000), int(x2*1000), int(y2*1000))
LN = {"poly": (66,20), "licon": (66,44), "li": (67,20), "mcon": (67,44), "met1": (68,20), "via1": (68,44), "met2": (69,20), "via2": (69,44), "met3": (70,20), "met4": (71,20)}
ALL = B(-3, -3, 15.5, 15.5); LOW = B(-3, -3, 15.5, 6.5); UP = B(-3, 6.5, 15.5, 15.5); UPLO = B(-3, 6.5, 15.5, 9.0); UPHI = B(-3, 9.0, 15.5, 15.5)
UP_LABELS = [((68, 5), "vd", 10.23, 10.0), ((67, 5), "nRst", 10.63, 9.5)]
UPLO_LABELS = [((68, 5), "vd", 9.66, 8.5), ((67, 5), "nRst", 10.2, 8.0)]
VDM2W = B(9.50, 2.19, 10.245, 3.81)      # vd met2 bar west of the VddA18 plate edge (the part over the nRst leg / cap gate contact)
GATE_LI = B(9.85, 3.86, 10.25, 4.76)     # cap gate li + licons/mcon (floats the cap gate)
VAR = {
  "full":   (ALL, [], []),  "low": (LOW, [], []),  "up": (UP, [], UP_LABELS),  "up_lo": (UPLO, [], UPLO_LABELS),  "up_hi": (UPHI, [], UP_LABELS),
  "low_no_vdm2w":  (LOW, [("met2", VDM2W, "cut"), ("via2", VDM2W, "cut"), ("via1", VDM2W, "cut")], []),
  "low_no_gateli": (LOW, [("li", GATE_LI, "cut"), ("licon", GATE_LI, "cut"), ("mcon", GATE_LI, "cut")], []),
  "low_no_vdmet4": (LOW, [("met4", ALL, "cut")], []),
  "up_lo_no_vdmet3": (UPLO, [("met3", B(9.0, 6.5, 10.5, 9.0), "cut")], UPLO_LABELS),
  "up_lo_no_vdmet2": (UPLO, [("met2", B(9.4, 7.3, 9.9, 8.3), "cut"), ("via1", B(9.4, 7.3, 9.9, 8.3), "cut"), ("via2", B(9.4, 7.3, 9.9, 8.3), "cut")], UPLO_LABELS),
  "up_hi_no_shield": (UPHI, [("li", B(10.205, 8.890, 10.375, 11.300), "cut"), ("li", B(9.550, 8.890, 10.200, 9.060), "cut")], UP_LABELS),
  "up_hi_no_polyarm": (UPHI, [("poly", B(10.4, 10.2, 11.7, 11.25), "cut"), ("licon", B(10.4, 10.2, 11.7, 11.25), "cut")], UP_LABELS),
  # vsf windows: left (x<9, nRst met1 run under the vsf met3 plate + reset-gen met2) and right (x>=9, li leg/column beside vsf met1/met2)
  "left":      (B(-3, -3, 9.0, 15.5), [], [((68, 5), "nRst", 5.0, 3.21), ((70, 5), "vsf", 5.0, 2.0)]),
  "left_low":  (B(-3, -3, 9.0, 3.6),  [], [((68, 5), "nRst", 5.0, 3.21), ((70, 5), "vsf", 5.0, 2.0)]),
  "left_high": (B(-3, 3.6, 9.0, 15.5), [], [((68, 5), "nRst", 2.6, 4.0), ((70, 5), "vsf", 2.9, 5.0)]),
  "right":     (B(9.0, -3, 15.5, 15.5), [], [((67, 5), "nRst", 10.63, 9.5), ((68, 5), "vsf", 10.5, 7.5)]),
  "right_no_vsfmet1": (B(9.0, -3, 15.5, 15.5), [("met1", B(10.2, 7.0, 10.81, 8.26), "cut"), ("via1", B(10.2, 7.0, 10.81, 8.26), "cut"), ("mcon", B(10.2, 7.0, 10.81, 8.26), "cut")], [((67, 5), "nRst", 10.63, 9.5), ((69, 5), "vsf", 10.2, 8.5)]),
  # proper vsf pieces at the right crossing (the vsf label is on met1 at (11.645, 8.49), east of the cut boxes): name the detached pieces separately
  "r_base":     (B(9.0, -3, 15.5, 15.5), [], [((67, 5), "nRst", 10.63, 9.5)]),
  "r_no_vert":  (B(9.0, -3, 15.5, 15.5), [("met1", B(10.29, 7.40, 10.44, 7.90), "cut")], [((67, 5), "nRst", 10.63, 9.5), ((67, 5), "vsfli", 10.36, 7.16)]),   # vertical cut: li+lower block -> vsfli; top+via1+met2/3 stay vsf
  "r_no_lower": (B(9.0, -3, 15.5, 15.5), [("met1", B(10.20, 6.90, 10.60, 7.35), "cut"), ("mcon", B(10.20, 6.90, 10.60, 7.35), "cut")], [((67, 5), "nRst", 10.63, 9.5), ((67, 5), "vsfli", 10.36, 7.16)]),   # li piece floats as vsfli, met1 vertical stays vsf
  "r_no_top":   (B(9.0, -3, 15.5, 15.5), [("met1", B(10.29, 7.99, 11.05, 8.26), "cut"), ("via1", B(10.29, 7.99, 11.05, 8.26), "cut")], [((67, 5), "nRst", 10.63, 9.5), ((69, 5), "vsfm2", 10.0, 9.0), ((67, 5), "vsfli", 10.36, 7.16)]),   # top+via1 cut: met2/met3 -> vsfm2, vertical+block+li -> vsfli, label piece east keeps vsf
}
for name, (win, edits, labels) in VAR.items():
    ly = pya.Layout(); ly.read(SRC); px = ly.cell("openDVS_pixel")
    for li in ly.layer_indexes():
        info = ly.get_info(li)
        if info.datatype == 5:
            keep = [(s.text_string, s.text_pos) for s in px.shapes(li).each() if s.is_text() and win.contains(s.text_pos)]
            px.shapes(li).clear()
            for t, p in keep: px.shapes(li).insert(pya.Text(t, pya.Trans(p)))
            continue
        r = pya.Region(px.shapes(li)) & pya.Region(win); px.shapes(li).clear(); px.shapes(li).insert(r)
    for ln, box, op in edits:
        li = ly.find_layer(*LN[ln])
        if li is None: continue
        r = pya.Region(px.shapes(li)); r = (r - pya.Region(box)) if op == "cut" else (r + pya.Region(box)).merged()
        px.shapes(li).clear(); px.shapes(li).insert(r)
    for (l, d), t, x, y in labels:
        px.shapes(ly.layer(l, d)).insert(pya.Text(t, pya.Trans(pya.Point(int(x*1000), int(y*1000)))))
    opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(px.cell_index()); ly.write("%s/%s.gds" % (OUT, name), opt); print("wrote", name)
