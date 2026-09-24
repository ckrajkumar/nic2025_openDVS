"""Night edits to cut nRst coupling (pixel coordinates, um).  Two modes:
   klayout -b -r edit_night.py -rd mode=variants          -> rcc/attrib_night/<set>.gds (pixel-only, for Magic attribution)
   klayout -b -r edit_night.py -rd mode=apply -rd sets=e1,e3b,...   -> edits openDVS_pixel in pixel_4tile_work.gds (backup first)
Edit sets:
  e1  VddA18 met1 plate extended west under the vd met2 overhang (shields the cap gate contact / nRst met1 leg)
  e3a nRst li leg moved from x 10.11-10.28 to 10.03-10.20 (away from vsf met1 at 10.295)      e3b: to 9.98-10.15
  e5  nRst li column run moved from x 10.54-10.71 to 10.80-10.97 (0.48 from the vd met1 vertical instead of 0.24)
  e5s e5 + GndA li shield widened to x 10.63 between vd met1 and the new run (y 9.30-10.78)
  e4  vd met1 top plate at Mrst raised 11.295-11.60 -> 11.50-11.76 (0.38 from the nRst gate-contact row instead of 0.175)
  e7  vd met4 ring overhang trimmed where nRst met2/met1 sit under it (x 1.85-2.46, y 2.30-3.40)  [check via3/capm first]
"""
import pya, os, shutil
def B(x1, y1, x2, y2): return pya.Box(int(round(x1*1000)), int(round(y1*1000)), int(round(x2*1000)), int(round(y2*1000)))
LN = {"poly": (66,20), "licon": (66,44), "li": (67,20), "mcon": (67,44), "met1": (68,20), "via1": (68,44), "met2": (69,20), "via2": (69,44), "met3": (70,20), "via3": (70,44), "met4": (71,20), "capm": (89,44), "npc": (95,20), "psdm": (94,20)}
E = {
  "e1":  [("met1", B(9.45, 3.35, 10.245, 3.85), "add")],
  "e3a": [("li", B(10.10, 7.56, 10.29, 8.55), "cut"), ("li", B(10.03, 7.50, 10.20, 8.72), "add"), ("li", B(10.03, 8.55, 10.54, 8.72), "add")],
  "e3b": [("li", B(10.10, 7.56, 10.29, 8.55), "cut"), ("li", B(9.98, 7.50, 10.15, 8.72), "add"), ("li", B(9.98, 8.55, 10.54, 8.72), "add")],
  "e5":  [("li", B(10.53, 8.72, 10.72, 10.95), "cut"), ("li", B(10.28, 8.55, 10.805, 8.72), "add"), ("li", B(10.635, 8.55, 10.805, 9.13), "add"),
          ("li", B(10.635, 8.96, 10.97, 9.13), "add"), ("li", B(10.80, 8.96, 10.97, 11.12), "add")],
  "e5s": [("li", B(10.375, 9.30, 10.63, 10.78), "add")],          # only meaningful together with e5
  "e4":  [("met1", B(10.59, 11.29, 11.01, 11.61), "cut"), ("met1", B(10.16, 11.44, 10.30, 11.50), "add"), ("met1", B(10.16, 11.50, 11.00, 11.76), "add"),
          ("mcon", B(10.77, 11.36, 10.96, 11.55), "cut"), ("mcon", B(10.78, 11.53, 10.95, 11.70), "add")],
  "e7":  [("met4", B(1.85, 2.30, 2.33, 3.40), "cut")],   # keep a 0.31 um strip: the met4 ring is C-shaped, its left arm is the only path between the two vd halves
  # e2: GndA met2 shield over the nRst met1 run/stub where the vsf met3 plate edge is above and vdiff met2 is not (x 2.47-3.17),
  #     tied through a new via1 on a locally widened GndA met1 (2.30-2.63, 3.65-3.95)
  "e2":  [("met2", B(2.555, 3.07, 3.03, 3.35), "add"), ("met2", B(2.555, 3.35, 2.72, 3.40), "add"), ("met2", B(2.335, 3.40, 2.72, 3.955), "add"),
          ("met1", B(2.30, 3.65, 2.63, 3.95), "add"), ("via1", B(2.39, 3.72, 2.54, 3.87), "add")],
  # e8: Mrst gate contact moved 0.15 down a longer poly endcap: row li 10.95-11.12 -> 10.80-10.97 (0.355 from the drain li instead of 0.205)
  "e8":  [("poly", B(11.235, 10.74, 11.655, 10.87), "add"), ("licon", B(11.34, 10.94, 11.53, 11.12), "cut"), ("licon", B(11.36, 10.82, 11.53, 10.99), "add"),
          ("npc", B(11.24, 10.84, 11.63, 11.22), "cut"), ("npc", B(11.26, 10.72, 11.63, 11.09), "add"),
          ("li", B(10.53, 10.79, 11.62, 11.13), "cut"), ("li", B(10.545, 10.78, 11.61, 10.99), "add")],    # row overlaps the run end (10.79); x from 10.545 = 0.17 from the GndA li shield
  # e14: nRst li stub at the crossing moved right (x 9.77-9.94 -> 9.87-10.04) out from under the vd met2 (9.525-9.805, 7.41-8.24)
  "e14": [("li", B(9.76, 6.82, 9.95, 7.75), "cut"), ("li", B(9.87, 6.83, 10.04, 7.74), "add"),
          ("mcon", B(9.76, 6.90, 9.95, 7.10), "cut"), ("mcon", B(9.87, 6.915, 10.04, 7.085), "add"), ("met1", B(9.71, 6.855, 10.07, 7.145), "add")],
  # e9: drain li trimmed to the contact (no overhang above the gate row); mcon stacked on the licon; met1 plate encloses it (tab removed)
  "e9":  [("li", B(10.70, 11.30, 10.92, 11.80), "cut"), ("mcon", B(10.77, 11.36, 10.96, 11.55), "cut"), ("mcon", B(10.98, 11.40, 11.15, 11.57), "add"),
          ("met1", B(10.70, 11.29, 11.01, 11.46), "cut"), ("met1", B(10.90, 11.34, 11.21, 11.63), "add")]   # plate top 11.63: 2x2-level met1 starts at y 11.77,
}
COMBOS = {"base": [], "e1": ["e1"], "e3a": ["e3a"], "e3b": ["e3b"], "e5": ["e5"], "e5s": ["e5", "e5s"], "e4": ["e4"], "e7": ["e7"],
          "all_a": ["e1", "e3a", "e5", "e5s", "e4", "e7"], "all_b": ["e1", "e3b", "e5", "e5s", "e4", "e7"],
          "e2": ["e2"], "e8": ["e8"], "e9": ["e9"], "e89": ["e8", "e9"], "final": ["e1", "e2", "e7", "e8", "e9"], "e14": ["e14"], "final2": ["e1", "e2", "e7", "e8", "e9", "e14"]}
def apply_sets(ly, px, sets):
    for s in sets:
        for ln, box, op in E[s]:
            lay = ly.find_layer(*LN[ln]); r = pya.Region(px.shapes(lay))
            r = (r - pya.Region(box)) if op == "cut" else (r + pya.Region(box))
            r = r.merged(); px.shapes(lay).clear(); px.shapes(lay).insert(r)
MODE = globals().get("mode", "variants")
if MODE == "variants":
    os.makedirs("rcc/attrib_night", exist_ok=True)
    ly0 = pya.Layout(); ly0.read("pixel_4tile_work.gds"); px0 = ly0.cell("openDVS_pixel")
    for ln in ("via3", "capm", "met4"):     # e7 safety: what lies in the trimmed box
        r = pya.Region(px0.shapes(ly0.find_layer(*LN[ln]))) & pya.Region(B(1.85, 2.30, 2.46, 3.40))
        print("   e7 box has %s: %s" % (ln, [str(p.bbox()) for p in r.each()]))
    for name, sets in COMBOS.items():
        ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); px = ly.cell("openDVS_pixel"); apply_sets(ly, px, sets)
        opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(px.cell_index()); ly.write("rcc/attrib_night/%s.gds" % name, opt); print("wrote", name, sets)
else:
    sets = globals()["sets"].split(","); bak = "pixel_4tile_work.before-night.gds"
    if not os.path.exists(bak): shutil.copy("pixel_4tile_work.gds", bak)
    ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); px = ly.cell("openDVS_pixel"); apply_sets(ly, px, sets)
    ly.write("pixel_4tile_work.gds"); print("applied", sets, "to pixel_4tile_work.gds (backup:", bak + ")")
