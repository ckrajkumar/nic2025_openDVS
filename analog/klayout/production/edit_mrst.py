"""Mrst re-contact edits (option 1 of the 2026-09-22 handoff), pixel coordinates in um.  Two modes:
   klayout -b -r edit_mrst.py -rd mode=variants                 -> rcc/attrib_mrst/<combo>.gds (pixel-only, Magic attribution)
   klayout -b -r edit_mrst.py -rd mode=apply -rd sets=m1,...     -> edits openDVS_pixel in pixel_4tile_work.gds (backup pixel_4tile_work.before-mrst.gds)
Starting point = edit20260922f (gate licon 11.36-11.53 x 10.82-10.99 on the finger 11.235-11.655 x 10.74-12.015; nRst li row 10.545-11.61 x 10.78-10.99).
Edit sets:
  m1  L-finger: the wide finger ends at y 11.20 (endcap 0.20 above the diff at 11.40); a 0.17 stem runs down to y 10.25 and a poly arm
      (10.465-11.53 x 10.25-10.58) runs west to the nRst li column, which contacts it with a licon (10.545-10.715 x 10.33-10.50).
      The li row and the column above y 10.60 are removed.  Gate contact -> vd li: 0.83 um (was 0.34); -> vd met1 bar: 0.96 (was 0.47).
  m2  straight finger: stem/pad 11.28-11.61 down to y 10.29, licon 11.36-11.53 x 10.37-10.54 (0.245 above the Mpr diff), li row at y 10.33-10.58.
  p1  vd met1 drain plate east edge 11.21 -> 11.18 (mcon enclosure 0.03)
  d1  drain contact moved 0.20 west: diff extended to x 10.735 (psdm follows), licon 10.80-10.97 x 11.52-11.69, li 10.72-11.05 x 11.32-11.77,
      mcon 10.80-10.97 x 11.40-11.57, met1 plate 10.74-11.03 x 11.34-11.63 (top stays 11.63: 2x2-level VddA18 met1 starts at 11.77).
      Gate poly -> vd stack: licon 0.265, li 0.185, met1 0.205 (was 0.065 / 0.025).  Changes AD/PD of Mrst (not W/L).
"""
import pya, os, shutil
def B(x1, y1, x2, y2): return pya.Box(int(round(x1*1000)), int(round(y1*1000)), int(round(x2*1000)), int(round(y2*1000)))
LN = {"nwell": (64,20), "diff": (65,20), "poly": (66,20), "licon": (66,44), "li": (67,20), "mcon": (67,44), "met1": (68,20), "via1": (68,44),
      "met2": (69,20), "via2": (69,44), "met3": (70,20), "via3": (70,44), "met4": (71,20), "capm": (89,44), "npc": (95,20), "psdm": (94,20), "hvtp": (78,44)}
E = {
  "m1": [("poly", B(11.235, 10.74, 11.655, 11.20), "cut"), ("poly", B(11.36, 10.25, 11.53, 11.20), "add"), ("poly", B(10.465, 10.25, 11.53, 10.58), "add"),
         ("licon", B(11.36, 10.82, 11.53, 10.99), "cut"), ("licon", B(10.545, 10.33, 10.715, 10.50), "add"),
         ("npc", B(11.26, 10.72, 11.63, 11.09), "cut"), ("npc", B(10.445, 10.23, 10.815, 10.60), "add"),
         ("li", B(10.53, 10.60, 11.62, 11.00), "cut")],
  "m2": [("poly", B(11.235, 10.74, 11.655, 11.20), "cut"), ("poly", B(11.28, 10.29, 11.61, 11.20), "add"),
         ("licon", B(11.36, 10.82, 11.53, 10.99), "cut"), ("licon", B(11.36, 10.37, 11.53, 10.54), "add"),
         ("npc", B(11.26, 10.72, 11.63, 11.09), "cut"), ("npc", B(11.26, 10.27, 11.63, 10.64), "add"),
         ("li", B(10.53, 10.60, 11.62, 11.00), "cut"), ("li", B(10.545, 10.33, 11.61, 10.58), "add")],
  "p1": [("met1", B(11.18, 11.34, 11.21, 11.63), "cut")],
  "d1": [("diff", B(10.735, 11.40, 10.935, 11.82), "add"), ("psdm", B(10.61, 11.275, 10.81, 11.945), "add"),
         ("licon", B(11.00, 11.52, 11.17, 11.69), "cut"), ("licon", B(10.80, 11.52, 10.97, 11.69), "add"),
         ("li", B(10.92, 11.325, 11.17, 11.77), "cut"), ("li", B(10.72, 11.32, 11.05, 11.77), "add"),
         ("mcon", B(10.98, 11.40, 11.15, 11.57), "cut"), ("mcon", B(10.80, 11.40, 10.97, 11.57), "add"),
         ("met1", B(10.90, 11.34, 11.21, 11.63), "cut"), ("met1", B(10.74, 11.34, 11.03, 11.63), "add")],
  # --- round 2 (on top of m1) ---
  # m1b/m1c: shorter poly arm (its west end was 0.165 from the vd met1 vertical): contact further east via a short li stub from the column
  "m1b": [("poly", B(11.235, 10.74, 11.655, 11.20), "cut"), ("poly", B(11.36, 10.25, 11.53, 11.20), "add"), ("poly", B(10.67, 10.25, 11.53, 10.58), "add"),
          ("licon", B(11.36, 10.82, 11.53, 10.99), "cut"), ("licon", B(10.75, 10.33, 10.92, 10.50), "add"),
          ("npc", B(11.26, 10.72, 11.63, 11.09), "cut"), ("npc", B(10.65, 10.23, 11.02, 10.60), "add"),
          ("li", B(10.53, 10.60, 11.62, 11.00), "cut"), ("li", B(10.545, 10.30, 11.00, 10.53), "add")],
  "m1c": [("poly", B(11.235, 10.74, 11.655, 11.20), "cut"), ("poly", B(11.36, 10.25, 11.53, 11.20), "add"), ("poly", B(10.87, 10.25, 11.53, 10.58), "add"),
          ("licon", B(11.36, 10.82, 11.53, 10.99), "cut"), ("licon", B(10.95, 10.33, 11.12, 10.50), "add"),
          ("npc", B(11.26, 10.72, 11.63, 11.09), "cut"), ("npc", B(10.85, 10.23, 11.22, 10.60), "add"),
          ("li", B(10.53, 10.60, 11.62, 11.00), "cut"), ("li", B(10.545, 10.30, 11.20, 10.53), "add")],
  "ls":  [("li", B(10.375, 10.78, 10.75, 11.30), "add")],                       # GndA li shield widened east above the (now shorter) nRst column
  # lower window: VddA18 met2 shield west of / above the vd met2 bar, between it and the nRst met1 vertical (9.01-9.15) and bar (y 4.28)
  "s1":  [("met2", B(9.235, 3.00, 9.375, 4.40), "add"), ("met2", B(9.375, 3.94, 10.12, 4.40), "add")],   # one L: no 0.09 notch (met2.2 flagged the first version)
  "s1fix": [("met2", B(9.375, 3.94, 9.465, 4.195), "add")],   # what turns the first s1 into the L above (applied to the work file 01:58)
  "s2":  [("met4", B(9.465, 4.10, 10.60, 4.195), "add"), ("met3", B(9.465, 4.14, 10.12, 4.195), "add")],   # VddA18 met3/met4 brought down to 0.30 from the vd stack
  # crossing: GndA met1 plate between the vd met2 vertical (9.525-9.805 x 7.41-8.24) and the nRst li stub (9.77-9.94 x 6.82-7.75), tied by an mcon on the GndA li column
  "s4":  [("met1", B(9.40, 7.29, 9.95, 7.76), "add"), ("mcon", B(9.43, 7.44, 9.60, 7.61), "add")],   # mcon exactly on the 0.17 GndA li column; met1 encl 0.03 W / 0.15 N-S
  # --- round 3: nRst-vsf at the right crossing (vsf met1 vertical 10.295-10.435 x 7.31-7.995 sits 0.015 east of the nRst li leg 10.11-10.28)
  "v1":  [("li", B(10.10, 7.56, 10.29, 8.55), "cut"), ("li", B(9.98, 7.50, 10.15, 8.72), "add"), ("li", B(9.98, 8.55, 10.54, 8.72), "add")],   # = e3b: leg to x 9.98-10.15
  "v2":  [("met1", B(9.935, 7.45, 10.155, 8.40), "add")],    # GndA met1 strip over the moved leg, merged with the s4 plate; y from 7.45 = 0.14 above the vsf met1 block (7.31)
  # --- round 4 (defined on the g+v1+v2 = h state; v1 is NOT idempotent, so variants are generated before v1/v2 are applied)
  # v3: GndA met1 lateral shield between the nRst li column (10.545-10.715) and the vd met1 vertical (10.16-10.30), fed from the v2 strip
  "v3":  [("met1", B(9.935, 8.40, 10.30, 8.60), "add"), ("met1", B(10.16, 8.60, 10.30, 8.88), "add"), ("met1", B(10.16, 8.74, 10.58, 8.88), "add"), ("met1", B(10.44, 8.88, 10.58, 10.60), "add")],
  # w2: vdiff met2 band over the nRst met1 run widened downward (3.14 -> 2.97) so the run can sit 0.17 inside the shield and the vsf plate edge (3.28)
  "w2":  [("met2", B(3.31, 2.97, 7.095, 3.14), "add")],
  # w3: nRst met1 run moved down from y 3.14-3.28 to 2.97-3.11 (0.14 above the GndA met1 at 2.83); the vertical at 9.01-9.15 is extended down to meet it
  "w3":  [("met1", B(2.445, 3.14, 9.01, 3.28), "cut"), ("met1", B(2.445, 2.97, 9.15, 3.11), "add"), ("met1", B(9.01, 2.97, 9.15, 3.14), "add")],
  # e2x: the e2 GndA met2 shield brought down to 2.93 over the moved run (x 2.555-3.03)
  "e2x": [("met2", B(2.555, 2.93, 3.03, 3.07), "add")],
  # v1fix: the v1 leg started at y 7.50, leaving a 0.04 notch to the nRst li stub (x <= 9.94) below the horizontal (y < 7.565) -> li.3 on the 4x4; leg now starts at 7.565
  "v1fix": [("li", B(9.945, 7.40, 10.16, 7.565), "cut")],
  # --- round 5 (on the applied i state)
  # v4: v3 strip continued up to y 11.20 and a GndA met1 plate (10.44-11.50 x 10.92-11.20) over the poly stem, between it and the vd met1 bar/plate above (0.14 from vd plate 11.34, vpr pad 10.775, vdiff met1 11.66)
  "v4":  [("met1", B(10.44, 10.60, 10.58, 11.20), "add"), ("met1", B(10.44, 10.92, 11.50, 11.20), "add")],
  # p2: nRst met1 pad at the crossing mcon shrunk (mcon 9.77-9.94 lowered to 6.87-7.04, pad top 7.145 -> 7.07) to shorten the face toward the vsf met1 block (10.215-10.57 x 7.02-7.31)
  "p2":  [("mcon", B(9.77, 6.915, 9.94, 7.085), "cut"), ("mcon", B(9.77, 6.87, 9.94, 7.04), "add"), ("met1", B(9.71, 7.07, 10.0, 7.145), "cut")],   # attribution only: breaks li.5 / met1.4
  # p2b: DRC-legal version: mcon 9.77-9.94 x 6.885-7.055 (met1 encl 0.03 below on the 6.855 horizontal, 0.06 E/W), li stub extended to 6.80 (li.5 0.08), pad top 7.145 -> 7.09
  "p2b": [("mcon", B(9.77, 6.915, 9.94, 7.085), "cut"), ("mcon", B(9.77, 6.885, 9.94, 7.055), "add"), ("li", B(9.77, 6.80, 9.94, 6.835), "add"), ("met1", B(9.71, 7.09, 10.0, 7.145), "cut")],
  # met4 decomposition pieces (attribution only)
  "m4a": [("met4", B(9.5, 1.4, 10.0, 3.9), "cut")], "m4b": [("met4", B(2.3, 2.25, 2.7, 3.45), "cut")], "m4c": [("met4", B(1.8, 0.9, 9.2, 2.3), "cut")],
  # w2x: vdiff met2 band under the vsf MIM plate widened to 2.83-3.28 (was 3.14-3.28) so the moved run (w3, 2.97-3.11) has >= 0.14 shield margin on both sides
  "w2x": [("met2", B(3.31, 2.83, 7.095, 3.14), "add")],
  # x1: nRst via1 at the reset-gen stub moved 0.055 west and the nRst met2 east edge pulled back 2.415 -> 2.36 (0.11 from the vsf met3 plate edge at 2.47 instead of 0.055)
  "x1":  [("via1", B(2.21, 3.025, 2.36, 3.175), "cut"), ("via1", B(2.155, 3.025, 2.305, 3.175), "add"), ("met2", B(2.36, 2.70, 2.42, 3.30), "cut")],   # rejected: -0.001, via enclosure errors
  # s7: VddA18 met1 plate (e1) extended up to 4.14 over the cap-gate li (9.86-10.24 x 3.87-4.75), 0.14 below the nRst met1 bar at 4.28
  "s7":  [("met1", B(9.45, 3.85, 10.245, 4.14), "add")],   # rejected: Quantus -0.002
  # w1: vd via stack (via2/via3/met3 pad) moved 0.19 east inside the VddA18 met4 cutout (x < 11.035; $36 met3 at 10.42 caps the pad at 10.12),
  #     met4 stub trimmed on the west (9.575 -> 9.755) and the vd met2 bar's west end pulled back 9.515 -> 9.735: all vd metal >= 0.58 from the nRst met1 vertical (9.01-9.15)
  "w1":  [("via2", B(9.60, 3.56, 9.80, 3.76), "cut"), ("via2", B(9.79, 3.56, 9.99, 3.76), "add"),
          ("via3", B(9.665, 3.505, 9.865, 3.705), "cut"), ("via3", B(9.855, 3.505, 10.055, 3.705), "add"),
          ("met3", B(9.465, 3.345, 9.955, 3.835), "cut"), ("met3", B(9.725, 3.345, 10.12, 3.835), "add"),
          ("met4", B(9.955, 2.245, 10.12, 3.795), "add"), ("met4", B(9.575, 2.245, 9.755, 3.795), "cut"),
          ("met2", B(9.515, 3.52, 9.735, 3.80), "cut"), ("met2", B(9.735, 3.52, 10.045, 3.80), "add")],
  # y1: close the met2-shield hole over the nRst run under the vsf MIM plate: vdiff met2 band extended west 3.31 -> 3.17 for y 2.83-3.14
  #     (the vdiff met2 vertical already occupies 3.17-3.31 for y >= 3.14; GndA met2 e2 ends at 3.03 -> 0.14 spacing)
  "y1":  [("met2", B(3.17, 2.83, 3.31, 3.14), "add")],
  # y6: GndA met1 fill 10.30-10.58 x 8.40-8.74 over the exposed part of the nRst li east piece (9.98-10.545 x 8.55-8.72) under the vsf met2 riser
  #     (merges with the v2 strip 9.935-10.30 x 8.40-8.60 and the v3 feed 10.16-10.58 x 8.74-8.88; 0.145 above the vsf met1 top piece, 0.14 west of the vpr met1)
  "y6":  [("met1", B(10.30, 8.40, 10.58, 8.74), "add")],
  # z1: GndA met3 shield strip in the empty met3 gap between the pixRst met3 column (x 0.94-1.27) and the vsf MIM plate / arm (x >= 2.47):
  #     strip 1.57-1.87 x 0.73-10.79 (0.30 to pixRst, 0.60 to vsf), via2 tab 1.585-1.955 x 10.25-10.65 with via2 1.67-1.87 x 10.35-10.55
  #     down to the GndA met2 bar (0.64-3.93 x 10.15-10.79).  Targets C(pixRst,vsf) 0.20 fF (Quantus) / 0.47 (Magic) = the slow vsf recovery slide.
  "z1":  [("met3", B(1.57, 0.73, 1.87, 10.79), "add"), ("met3", B(1.585, 10.25, 1.955, 10.65), "add"), ("via2", B(1.67, 10.35, 1.87, 10.55), "add")],
  # z2: DRC-clean variant of z1 - strip only along the vsf met3 arm (y >= 4.50, i.e. >= 1.34 from the capm top edge 3.14): 1.57-1.87 x 4.50-10.79 + the same via2 tab
  "z2":  [("met3", B(1.57, 4.50, 1.87, 10.79), "add"), ("met3", B(1.585, 10.25, 1.955, 10.65), "add"), ("via2", B(1.67, 10.35, 1.87, 10.55), "add")],
  # ---- round 9 (2026-09-22 14:30): legal replacement of z1 (capm.11: unrelated met3 >= 1.34 um from any capm) ----
  # z1rm: remove the z1 strip + its via2 tab (back to the k geometry on met3/via2)
  "z1rm": [("met3", B(1.57, 0.73, 1.955, 10.79), "cut"), ("via2", B(1.67, 10.35, 1.87, 10.55), "cut")],
  # a1: narrow the vsf met3 arm from 2.47-3.31 to 2.90-3.31 between the two plates (y 3.58-8.68 keeps 0.3 to the plate junctions)
  "a1":  [("met3", B(2.47, 3.58, 2.90, 8.68), "cut")],
  # g2: GndA met2 strip under the met3 gap, east of the ON met2 vertical (1.54-1.68) and tied to the e2 GndA met2 piece by a bridge
  "g2":  [("met2", B(1.82, 3.45, 2.19, 7.48), "add"), ("met2", B(2.19, 3.45, 2.335, 3.955), "add")],
  # s3: legal GndA met3 strip 1.57-2.60 x 4.50-7.76 (>= 1.34 from both capm plates, 0.3 from pixRst met3 and from the narrowed arm), via2 down to g2
  "s3":  [("met3", B(1.57, 4.50, 2.60, 7.76), "add"), ("via2", B(1.90, 6.00, 2.10, 6.20), "add")],
  # s3n: same strip without the arm narrowing (east edge 2.17 = 0.3 from the arm at 2.47)
  "s3n": [("met3", B(1.57, 4.50, 2.17, 7.76), "add"), ("via2", B(1.90, 6.00, 2.10, 6.20), "add")],
}
COMBOS = {"base": [], "m1": ["m1"], "m2": ["m2"], "m3": ["m1", "p1"], "m4": ["m1", "d1"], "m5": ["d1"],
          "m1b": ["m1b"], "m1c": ["m1c"], "m1s": ["m1", "ls"], "m1_s1": ["m1", "s1"], "m1_s2": ["m1", "s2"], "m1_s4": ["m1", "s4"],
          "m1_all": ["m1", "ls", "s1", "s2", "s4"], "m1b_all": ["m1b", "ls", "s1", "s2", "s4"],
          "g": ["m1", "s1", "s4"], "g_d1": ["m1", "s1", "s4", "d1"], "v1": ["v1"], "v2": ["v1", "v2"],
          "v3": ["v1", "v2", "v3"], "w2": ["v1", "v2", "w2"], "w": ["v1", "v2", "w2", "w3", "e2x"], "hw": ["v1", "v2", "v3", "w2", "w3", "e2x"],
          "i": ["v1fix", "v3"],   # i = on top of the applied h state
          "v4": ["v4"], "p2": ["p2"], "v4p2": ["v4", "p2"], "m4a": ["m4a"], "m4b": ["m4b"], "m4c": ["m4c"],   # round 5: on top of the applied i state
          "wx": ["w2x", "w3", "e2x", "x1"], "x1": ["x1"], "j": ["v4", "p2b"],
          "k": ["w2x", "w3", "e2x"], "s7": ["s7"],   # k, s7: on top of the applied j state
          "w1": ["w1"],   # on top of the applied k state
          "kb": [], "y1": ["y1"], "y6": ["y6"], "y": ["y1", "y6"], "z1": ["z1"], "z2": ["z2"], "yz": ["y1", "y6", "z1"],
          "keq": ["z1rm"], "z3": ["z1rm", "a1", "g2", "s3"], "z3b": ["z1rm", "g2", "s3n"], "z3a": ["z1rm", "a1"]}   # round 9 on top of the applied l state   # round 8 on top of the applied k state
def apply_sets(ly, px, sets):
    for s in sets:
        for ln, box, op in E[s]:
            lay = ly.find_layer(*LN[ln]); r = pya.Region(px.shapes(lay))
            r = (r - pya.Region(box)) if op == "cut" else (r + pya.Region(box))
            r = r.merged(); px.shapes(lay).clear(); px.shapes(lay).insert(r)
MODE = globals().get("mode", "variants")
if MODE == "variants":
    os.makedirs("rcc/attrib_mrst", exist_ok=True)
    ONLY = globals().get("only", "").split(",") if globals().get("only", "") else None
    for name, sets in COMBOS.items():
        if ONLY and name not in ONLY: continue
        ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); px = ly.cell("openDVS_pixel"); apply_sets(ly, px, sets)
        opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(px.cell_index()); ly.write("rcc/attrib_mrst/%s.gds" % name, opt); print("wrote", name, sets)
else:
    sets = globals()["sets"].split(","); bak = "pixel_4tile_work.before-mrst.gds"
    if not os.path.exists(bak): shutil.copy("pixel_4tile_work.gds", bak)
    ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); px = ly.cell("openDVS_pixel"); apply_sets(ly, px, sets)
    ly.write("pixel_4tile_work.gds"); print("applied", sets, "to pixel_4tile_work.gds (backup:", bak + ")")
