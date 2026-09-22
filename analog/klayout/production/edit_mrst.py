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
R10 = {
# --- round 10 (on top of the applied m state): pixRst column off met3 -> met4, Rui 15:20 "pixRst toggles frequently, critical it has no coupling"
# pr4: pixRst met3 column (0.94-1.27 x 0.13-11.27) cut to three stubs (0.13-0.60 bottom edge, 1.66-1.99 around the existing via2 at 1.005-1.205 x 1.725-1.925,
#      10.90-11.27 top edge) so the 2x2 bridge cells still meet met3; met4 column 0.94-1.27 x 0.13-11.27 with via3 on each stub; VddA18 met4 plane slotted
#      0.64-1.57 (0.3 each side of the column); vd met4 ring west arm narrowed 1.855 -> 2.33 (its notch at y 2.3-3.4 already sits at 2.33); VddA18 met4 shield
#      strip 1.57-2.03 x 0.68-10.99 between column and ring, tied to the plane's bottom strip (1.285-3.0 x 0-0.68); slivers at 1.24-1.285 removed by the slot.
"pr4": [("met3", B(0.94, 0.60, 1.27, 1.66), "cut"), ("met3", B(0.94, 1.99, 1.27, 10.90), "cut"),
        ("met4", B(-1.57, -3.0, 1.57, 15.0), "cut"),                   # slot over the cell's full y extent (the cell overhangs its pitch by 2.5 um and the
                                                                        # mirrored neighbours draw the same overhang) and incl. the west overhang: the
                                                                        # VddA18 met4 strip along the pair boundary (|x| < 0.64) would be floating -> removed
        ("met4", B(1.855, 1.005, 2.33, 10.55), "cut"),                  # vd ring west arm 1.855-2.64 -> 2.33-2.64
        ("met4", B(0.94, 0.13, 1.27, 11.27), "add"),                    # pixRst met4 column
        ("met4", B(1.57, 0.68, 2.03, 10.99), "add"),                    # VddA18 shield strip (joins the plane's bottom band 1.57-3.0 x -0.42-0.68)
        ("via3", B(1.005, 0.28, 1.205, 0.48), "add"), ("via3", B(1.005, 1.725, 1.205, 1.925), "add"), ("via3", B(1.005, 11.00, 1.205, 11.20), "add")],
# gs: GndA met3 strip in the vacated lane (0.3 from the stubs, from readLine met3 at 0.64 and from the s3 strip at 1.57; 1.34 from capm at 2.61), via2 to the GndA met2 below
"gs": [("met3", B(0.94, 2.35, 1.27, 10.60), "add"), ("met3", B(1.27, 4.50, 1.57, 4.80), "add")],   # tied to the s3 GndA met3 strip (no GndA met2 under the lane)
# rl4: readLine met3 column (0.31-0.64) -> met4 the same way (stubs 0.13-0.60 / 1.66-1.99 around its via2 0.375-0.575 x 1.725-1.925 / 10.90-11.27)
"rl4": [("met3", B(0.31, 0.60, 0.64, 1.66), "cut"), ("met3", B(0.31, 1.99, 0.64, 10.90), "cut"),
        ("met4", B(0.31, 0.13, 0.64, 11.27), "add"),
        ("via3", B(0.375, 0.28, 0.575, 0.48), "add"), ("via3", B(0.375, 1.725, 0.575, 1.925), "add"), ("via3", B(0.375, 11.00, 0.575, 11.20), "add")],
# gs2: with both columns on met4 the whole met3 lane 0.31-1.27 becomes a GndA shield (0.3 from the mid stubs at 1.99 and the top stubs at 10.90), tied to s3
"gs2": [("met3", B(0.31, 2.29, 1.27, 10.60), "add"), ("met3", B(1.27, 4.50, 1.57, 4.80), "add")],
# --- round 11: the row lines (rowReadON met2 0.84-1.10, rowReadOFF 1.24-1.50) run under the C1a (capm 0.87-3.14) and C2 (0.87-1.87) plates:
# Quantus m: rowReadOFF->vsf 0.26 / ->vdiff 0.29, rowReadON->vsf 0.17 / ->vdiff 0.10.  Row lines move south (0.35-0.61 / 0.75-1.01), the GndD row
# line (was -0.44..0.70 across the pair mirror plane at y 0.13) moves under the plates (1.15-1.41, one via1 per nfet-source plate), C1a +0.35 and
# C2 +0.15 north (capm.11: C2 to the vd met3 pad 9.465x3.345 allows 1.38 um at +0.15 only).  The s3 GndA strip retreats to y 4.85 (1.36 from the moved C1a).
"rowmv": [("met2", B(-0.5, -0.5, 12.2, 0.70), "cut"), ("met2", B(0.16, 0.84, 12.16, 1.10), "cut"), ("met2", B(0.16, 1.24, 12.16, 1.50), "cut"),
          ("met2", B(0.16, 0.35, 12.16, 0.61), "add"), ("met2", B(0.16, 0.75, 12.16, 1.01), "add"), ("met2", B(0.0, 1.15, 12.16, 1.41), "add"),
          ("via1", B(2.185, 0.895, 2.335, 1.045), "cut"), ("via1", B(2.185, 0.41, 2.335, 0.56), "add"),
          ("via1", B(3.075, 1.295, 3.225, 1.445), "cut"), ("via1", B(3.075, 0.81, 3.225, 0.96), "add"),
          ("via1", B(1.44, 0.46, 2.24, 0.62), "cut"), ("via1", B(3.17, 0.46, 3.97, 0.62), "cut"), ("via1", B(-0.08, -0.27, 0.40, 0.53), "cut"),
          ("via1", B(1.445, 1.20, 1.595, 1.35), "add"), ("via1", B(3.815, 1.20, 3.965, 1.35), "add"),
          ("met1", B(2.10, 0.38, 2.42, 0.84), "add"), ("met1", B(2.99, 0.78, 3.31, 1.24), "add"),
          ("met1", B(1.65, 0.38, 2.32, 0.70), "cut"), ("met1", B(3.09, 0.38, 3.76, 0.70), "cut"), ("met1", B(-0.2, -0.4, 0.48, 0.61), "cut"),
          ("met1", B(1.36, 1.29, 1.65, 1.45), "add"), ("met1", B(3.76, 1.29, 4.05, 1.45), "add")],
"c1a35": [("capm", B(2.61, 0.87, 6.595, 1.22), "cut"), ("capm", B(2.61, 3.14, 6.595, 3.49), "add"),
          ("met3", B(2.47, 0.73, 6.735, 1.08), "cut"), ("met3", B(2.47, 3.28, 6.735, 3.63), "add")],
"c2p15": [("capm", B(8.08, 0.87, 9.08, 1.02), "cut"), ("capm", B(8.08, 1.87, 9.08, 2.02), "add"),
          ("met3", B(7.94, 0.73, 9.22, 0.88), "cut"), ("met3", B(7.94, 2.01, 9.22, 2.16), "add"),
          ("via3", B(8.28, 1.07, 8.88, 1.67), "cut"),
          ("via3", B(8.28, 1.22, 8.48, 1.42), "add"), ("via3", B(8.68, 1.22, 8.88, 1.42), "add"), ("via3", B(8.28, 1.62, 8.48, 1.82), "add"), ("via3", B(8.68, 1.62, 8.88, 1.82), "add")],
"s3up": [("met3", B(1.57, 4.50, 2.60, 4.85), "cut")],
"gs3": [("met3", B(0.31, 2.29, 1.27, 10.60), "add"), ("met3", B(1.27, 4.85, 1.57, 5.15), "add")],
# round 11b: C1a +0.80 instead of +0.35 (met3 rim 1.53 clears rowReadOFF 0.75-1.01 by 0.52 and GndD 1.15-1.41 by 0.12); its four via3 top-plate
# contacts (4.265-4.865 x 1.52-2.12) move with it and the vd met4 ring's south bar gets a tab up to y 3.0 to enclose them; s3 retreats to 5.28 (1.34 from capm 3.94)
"c1a80": [("capm", B(2.61, 0.87, 6.595, 1.67), "cut"), ("capm", B(2.61, 3.14, 6.595, 3.94), "add"),
          ("met3", B(2.47, 0.73, 6.735, 1.53), "cut"), ("met3", B(2.47, 3.28, 6.735, 4.08), "add"),
          ("via3", B(4.265, 1.52, 4.865, 2.12), "cut"),
          ("via3", B(4.265, 2.32, 4.465, 2.52), "add"), ("via3", B(4.665, 2.32, 4.865, 2.52), "add"), ("via3", B(4.265, 2.72, 4.465, 2.92), "add"), ("via3", B(4.665, 2.72, 4.865, 2.92), "add"),
          ("met4", B(4.20, 2.245, 4.93, 3.00), "add")],
"s3up80": [("met3", B(1.57, 4.50, 2.60, 5.28), "cut")],
"gs4": [("met3", B(0.31, 2.29, 1.27, 10.60), "add"), ("met3", B(1.27, 5.30, 1.57, 5.60), "add")],
# rowmv2: as rowmv but cuts before adds (rowmv cut the new rowReadON met1 back to a 0.10 sliver), Magic-safe via1 enclosures (0.055 met1/met2 all
# round -> lines 0.26 wide at 0.385-0.645 / 0.795-1.055 / 1.205-1.465, via1 0.44-0.59 / 0.85-1.00 / 1.26-1.41, GndD met1 plates to 1.47)
"rowmv2": [("met2", B(-0.5, -0.5, 12.2, 0.70), "cut"), ("met2", B(0.16, 0.84, 12.16, 1.10), "cut"), ("met2", B(0.16, 1.24, 12.16, 1.50), "cut"),
           ("via1", B(2.185, 0.895, 2.335, 1.045), "cut"), ("via1", B(3.075, 1.295, 3.225, 1.445), "cut"),
           ("via1", B(1.44, 0.46, 2.24, 0.62), "cut"), ("via1", B(3.17, 0.46, 3.97, 0.62), "cut"), ("via1", B(-0.08, -0.27, 0.40, 0.53), "cut"),
           ("met1", B(1.65, 0.38, 2.32, 0.70), "cut"), ("met1", B(3.09, 0.38, 3.76, 0.70), "cut"), ("met1", B(-0.2, -0.4, 0.48, 0.61), "cut"),
           ("met2", B(0.16, 0.385, 12.16, 0.645), "add"), ("met2", B(0.16, 0.795, 12.16, 1.055), "add"), ("met2", B(0.0, 1.205, 12.16, 1.465), "add"),
           ("via1", B(2.185, 0.44, 2.335, 0.59), "add"), ("via1", B(3.075, 0.85, 3.225, 1.00), "add"),
           ("via1", B(1.445, 1.26, 1.595, 1.41), "add"), ("via1", B(3.815, 1.26, 3.965, 1.41), "add"),
           ("met1", B(2.10, 0.385, 2.42, 0.84), "add"), ("met1", B(2.99, 0.795, 3.31, 1.24), "add"),
           ("met1", B(1.36, 1.29, 1.65, 1.47), "add"), ("met1", B(3.76, 1.29, 4.05, 1.47), "add")],
# rowmv3: GndD line 1.20-1.46 (0.145 from rowReadOFF and from the ON/nOFF met1 at 1.605 after the plate extensions to 1.46), via1 1.255-1.405
"rowmv3": [("met2", B(-0.5, -0.5, 12.2, 0.70), "cut"), ("met2", B(0.16, 0.84, 12.16, 1.10), "cut"), ("met2", B(0.16, 1.24, 12.16, 1.50), "cut"),
           ("via1", B(2.185, 0.895, 2.335, 1.045), "cut"), ("via1", B(3.075, 1.295, 3.225, 1.445), "cut"),
           ("via1", B(1.44, 0.46, 2.24, 0.62), "cut"), ("via1", B(3.17, 0.46, 3.97, 0.62), "cut"), ("via1", B(-0.08, -0.27, 0.40, 0.53), "cut"),
           ("met1", B(1.65, 0.38, 2.32, 0.70), "cut"), ("met1", B(3.09, 0.38, 3.76, 0.70), "cut"), ("met1", B(-0.2, -0.4, 0.48, 0.61), "cut"),
           ("met2", B(0.16, 0.385, 12.16, 0.645), "add"), ("met2", B(0.16, 0.795, 12.16, 1.055), "add"), ("met2", B(0.0, 1.20, 12.16, 1.46), "add"),
           ("via1", B(2.185, 0.44, 2.335, 0.59), "add"), ("via1", B(3.075, 0.85, 3.225, 1.00), "add"),
           ("via1", B(1.445, 1.255, 1.595, 1.405), "add"), ("via1", B(3.815, 1.255, 3.965, 1.405), "add"),
           ("met1", B(2.10, 0.385, 2.42, 0.84), "add"), ("met1", B(2.99, 0.795, 3.31, 1.24), "add"),
           ("met1", B(1.36, 1.29, 1.65, 1.46), "add"), ("met1", B(3.76, 1.29, 4.05, 1.46), "add")],
# pr4b: as pr4 with the VddA18 shield strip at 1.60-2.03 (Magic flags the 0.30 column-strip gap as met4.2)
"pr4b": [("met3", B(0.94, 0.60, 1.27, 1.66), "cut"), ("met3", B(0.94, 1.99, 1.27, 10.90), "cut"),
         ("met4", B(-1.57, -3.0, 1.57, 15.0), "cut"), ("met4", B(1.855, 1.005, 2.33, 10.55), "cut"),
         ("met4", B(0.94, 0.13, 1.27, 11.27), "add"), ("met4", B(1.60, 0.68, 2.03, 10.99), "add"), ("met4", B(1.57, 0.68, 1.60, 10.99), "cut"),
         ("via3", B(1.005, 0.28, 1.205, 0.48), "add"), ("via3", B(1.005, 1.725, 1.205, 1.925), "add"), ("via3", B(1.005, 11.00, 1.205, 11.20), "add")],
# round 11f: met3 stubs 0.73 tall for met3.6 min area (0.24 um2) and via3.5 (0.09 one-direction enclosure): 0.13-0.86 / 1.50-2.23 / 10.54-11.27;
# lane GndA strip 2.53-10.24; GndD nfet-source met1 plates 1.36-1.66 / 3.75-4.05 (via.5a 0.06 one-direction enclosure); vd ring notch sliver
# 5.14-5.87 x 2.245-2.255 removed (0.21 from the via3 tab).
"pr4c": [("met3", B(0.94, 0.86, 1.27, 1.50), "cut"), ("met3", B(0.94, 2.23, 1.27, 10.54), "cut"),
         ("met4", B(-1.57, -3.0, 1.57, 15.0), "cut"), ("met4", B(1.855, 1.005, 2.33, 10.55), "cut"),
         ("met4", B(0.94, 0.13, 1.27, 11.27), "add"), ("met4", B(1.57, 0.68, 2.03, 10.99), "add"),
         ("via3", B(1.005, 0.28, 1.205, 0.48), "add"), ("via3", B(1.005, 1.725, 1.205, 1.925), "add"), ("via3", B(1.005, 11.00, 1.205, 11.20), "add")],
"rl4b": [("met3", B(0.31, 0.86, 0.64, 1.50), "cut"), ("met3", B(0.31, 2.23, 0.64, 10.54), "cut"),
         ("met4", B(0.31, 0.13, 0.64, 11.27), "add"),
         ("via3", B(0.375, 0.28, 0.575, 0.48), "add"), ("via3", B(0.375, 1.725, 0.575, 1.925), "add"), ("via3", B(0.375, 11.00, 0.575, 11.20), "add")],
"gs5": [("met3", B(0.31, 2.53, 1.27, 10.24), "add"), ("met3", B(1.27, 5.30, 1.57, 5.60), "add")],
"rowmv4": [("met2", B(-0.5, -0.5, 12.2, 0.70), "cut"), ("met2", B(0.16, 0.84, 12.16, 1.10), "cut"), ("met2", B(0.16, 1.24, 12.16, 1.50), "cut"),
           ("via1", B(2.185, 0.895, 2.335, 1.045), "cut"), ("via1", B(3.075, 1.295, 3.225, 1.445), "cut"),
           ("via1", B(1.44, 0.46, 2.24, 0.62), "cut"), ("via1", B(3.17, 0.46, 3.97, 0.62), "cut"), ("via1", B(-0.08, -0.27, 0.40, 0.53), "cut"),
           ("met1", B(1.65, 0.38, 2.32, 0.70), "cut"), ("met1", B(3.09, 0.38, 3.76, 0.70), "cut"), ("met1", B(-0.2, -0.4, 0.48, 0.61), "cut"),
           ("met2", B(0.16, 0.385, 12.16, 0.645), "add"), ("met2", B(0.16, 0.795, 12.16, 1.055), "add"), ("met2", B(0.0, 1.20, 12.16, 1.46), "add"),
           ("via1", B(2.185, 0.44, 2.335, 0.59), "add"), ("via1", B(3.075, 0.85, 3.225, 1.00), "add"),
           ("via1", B(1.445, 1.255, 1.595, 1.405), "add"), ("via1", B(3.815, 1.255, 3.965, 1.405), "add"),
           ("met1", B(2.10, 0.385, 2.42, 0.84), "add"), ("met1", B(2.99, 0.795, 3.31, 1.24), "add"),
           ("met1", B(1.36, 1.29, 1.66, 1.46), "add"), ("met1", B(1.65, 0.70, 1.66, 1.29), "add"), ("met1", B(3.75, 1.29, 4.05, 1.46), "add"), ("met1", B(3.75, 0.70, 3.76, 1.29), "add")],
"ringfix": [("met4", B(5.14, 2.245, 5.87, 2.26), "cut")],
# round 11g: GndD plates 1.36-1.68 / 3.73-4.05 (via.5a 0.085 one-direction); VddA18 shield strip at 1.62-2.03 (test of the met4.2 flag on the 0.30 gap)
"rowmv5": [("met2", B(-0.5, -0.5, 12.2, 0.70), "cut"), ("met2", B(0.16, 0.84, 12.16, 1.10), "cut"), ("met2", B(0.16, 1.24, 12.16, 1.50), "cut"),
           ("via1", B(2.185, 0.895, 2.335, 1.045), "cut"), ("via1", B(3.075, 1.295, 3.225, 1.445), "cut"),
           ("via1", B(1.44, 0.46, 2.24, 0.62), "cut"), ("via1", B(3.17, 0.46, 3.97, 0.62), "cut"), ("via1", B(-0.08, -0.27, 0.40, 0.53), "cut"),
           ("met1", B(1.65, 0.38, 2.32, 0.70), "cut"), ("met1", B(3.09, 0.38, 3.76, 0.70), "cut"), ("met1", B(-0.2, -0.4, 0.48, 0.61), "cut"),
           ("met2", B(0.16, 0.385, 12.16, 0.645), "add"), ("met2", B(0.16, 0.795, 12.16, 1.055), "add"), ("met2", B(0.0, 1.20, 12.16, 1.46), "add"),
           ("via1", B(2.185, 0.44, 2.335, 0.59), "add"), ("via1", B(3.075, 0.85, 3.225, 1.00), "add"),
           ("via1", B(1.445, 1.255, 1.595, 1.405), "add"), ("via1", B(3.815, 1.255, 3.965, 1.405), "add"),
           ("met1", B(2.10, 0.385, 2.42, 0.84), "add"), ("met1", B(2.99, 0.795, 3.31, 1.24), "add"),
           ("met1", B(1.36, 0.70, 1.68, 1.46), "add"), ("met1", B(3.73, 0.70, 4.05, 1.46), "add")],
"pr4d": [("met3", B(0.94, 0.86, 1.27, 1.50), "cut"), ("met3", B(0.94, 2.23, 1.27, 10.54), "cut"),
         ("met4", B(-1.57, -3.0, 1.57, 15.0), "cut"), ("met4", B(1.855, 1.005, 2.33, 10.55), "cut"),
         ("met4", B(0.94, 0.13, 1.27, 11.27), "add"), ("met4", B(1.62, 0.68, 2.03, 10.99), "add"), ("met4", B(1.57, 0.68, 1.62, 10.99), "cut"),
         ("via3", B(1.005, 0.28, 1.205, 0.48), "add"), ("via3", B(1.005, 1.725, 1.205, 1.925), "add"), ("via3", B(1.005, 11.00, 1.205, 11.20), "add")],
# round 11h: VddA18 met4 west edge (shield strip and the plane's bottom band) at 1.67 = 0.40 from the pixRst column (Magic flags 0.30 next to the wide plane)
"pr4e": [("met3", B(0.94, 0.86, 1.27, 1.50), "cut"), ("met3", B(0.94, 2.23, 1.27, 10.54), "cut"),
         ("met4", B(-1.67, -3.0, 1.67, 15.0), "cut"), ("met4", B(1.855, 1.005, 2.33, 10.55), "cut"),
         ("met4", B(0.94, 0.13, 1.27, 11.27), "add"), ("met4", B(1.67, 0.68, 2.03, 10.99), "add"),
         ("via3", B(1.005, 0.28, 1.205, 0.48), "add"), ("via3", B(1.005, 1.725, 1.205, 1.925), "add"), ("via3", B(1.005, 11.00, 1.205, 11.20), "add")],
# round 11i: top via3 of both met4 columns at 10.85-11.05 (via3.5: 0.09 enclosure in one direction within the 10.54-11.27 stub)
"pr4f": [("met3", B(0.94, 0.86, 1.27, 1.50), "cut"), ("met3", B(0.94, 2.23, 1.27, 10.54), "cut"),
         ("met4", B(-1.67, -3.0, 1.67, 15.0), "cut"), ("met4", B(1.855, 1.005, 2.33, 10.55), "cut"),
         ("met4", B(0.94, 0.13, 1.27, 11.27), "add"), ("met4", B(1.67, 0.68, 2.03, 10.99), "add"),
         ("via3", B(1.005, 0.28, 1.205, 0.48), "add"), ("via3", B(1.005, 1.725, 1.205, 1.925), "add"), ("via3", B(1.005, 10.85, 1.205, 11.05), "add")],
"rl4c": [("met3", B(0.31, 0.86, 0.64, 1.50), "cut"), ("met3", B(0.31, 2.23, 0.64, 10.54), "cut"),
         ("met4", B(0.31, 0.13, 0.64, 11.27), "add"),
         ("via3", B(0.375, 0.28, 0.575, 0.48), "add"), ("via3", B(0.375, 1.725, 0.575, 1.925), "add"), ("via3", B(0.375, 10.85, 0.575, 11.05), "add")],
# round 12 (on top of the applied n state): C2 a further +0.19 north (total +0.34; the vd met3 pad 9.465-9.955 x 3.345-3.835 is trimmed to
# y >= 3.495 so capm.11 (1.34 um euclidean) still holds: sqrt(0.385^2 + (3.495-2.21)^2) = 1.34); rowReadOFF (0.795-1.055) then clears the C2 met3 rim (1.07)
"c2p18": [("capm", B(8.08, 1.02, 9.08, 1.20), "cut"), ("capm", B(8.08, 2.02, 9.08, 2.20), "add"),
          ("met3", B(7.94, 0.88, 9.22, 1.06), "cut"), ("met3", B(7.94, 2.16, 9.22, 2.34), "add"),
          ("via3", B(8.28, 1.22, 8.88, 1.82), "cut"),
          ("via3", B(8.28, 1.40, 8.48, 1.60), "add"), ("via3", B(8.68, 1.40, 8.88, 1.60), "add"), ("via3", B(8.28, 1.80, 8.48, 2.00), "add"), ("via3", B(8.68, 1.80, 8.88, 2.00), "add")],
"padtrim": [("met3", B(9.465, 3.345, 9.955, 3.495), "cut"), ("via3", B(9.665, 3.505, 9.865, 3.705), "cut"), ("via3", B(9.665, 3.56, 9.865, 3.76), "add"), ("met4", B(9.575, 3.795, 9.955, 3.835), "add")],
# padtrim2: the trimmed pad (0.49 x 0.34) is under met3.6 min area 0.24 um2 -> pad 9.465-10.12 x 3.495-3.895 (0.262 um2; 0.30 to the VddA18 met3 at 4.195 and to the $35 column at 10.42)
"padtrim2": [("met3", B(9.465, 3.345, 9.955, 3.495), "cut"), ("met3", B(9.955, 3.495, 10.12, 3.895), "add"), ("met3", B(9.465, 3.835, 9.955, 3.895), "add"),
             ("via3", B(9.665, 3.505, 9.865, 3.705), "cut"), ("via3", B(9.665, 3.56, 9.865, 3.76), "add"), ("met4", B(9.575, 3.795, 9.955, 3.835), "add")],
# round 13b: C1a +1.0 instead of +0.8 (Quantus p: rowReadOFF 1.24-1.50 still fringes 0.18 fF into vsf with the C1a met3 rim at 1.53); s3 -> 5.48, bridge 5.50-5.80
"c1a100": [("capm", B(2.61, 0.87, 6.595, 1.87), "cut"), ("capm", B(2.61, 3.14, 6.595, 4.14), "add"),
           ("met3", B(2.47, 0.73, 6.735, 1.73), "cut"), ("met3", B(2.47, 3.28, 6.735, 4.28), "add"),
           ("via3", B(4.265, 1.52, 4.865, 2.12), "cut"),
           ("via3", B(4.265, 2.52, 4.465, 2.72), "add"), ("via3", B(4.665, 2.52, 4.865, 2.72), "add"), ("via3", B(4.265, 2.92, 4.465, 3.12), "add"), ("via3", B(4.665, 2.92, 4.865, 3.12), "add"),
           ("met4", B(4.20, 2.245, 4.93, 3.20), "add")],
"s3up100": [("met3", B(1.57, 4.50, 2.60, 5.48), "cut")],
"gs6": [("met3", B(0.31, 2.53, 1.27, 10.24), "add"), ("met3", B(1.27, 5.50, 1.57, 5.80), "add")],
}
E.update(R10)
COMBOS.update({"r10": ["pr4", "gs"], "pr4": ["pr4"], "gs": ["gs"], "m_ref": [], "r10b": ["pr4", "rl4", "gs2"], "r11": ["pr4", "rl4", "s3up", "gs3", "rowmv", "c1a35", "c2p15"], "r11rows": ["rowmv"], "r11plates": ["c1a35", "c2p15", "s3up"], "r11b": ["pr4", "rl4", "s3up80", "gs4", "rowmv", "c1a80", "c2p15"], "r11c": ["pr4", "rl4", "s3up80", "gs4", "rowmv2", "c1a80", "c2p15"], "r11d": ["pr4b", "rl4", "s3up80", "gs4", "rowmv3", "c1a80", "c2p15"], "r11e": ["pr4", "rl4", "s3up80", "gs4", "rowmv3", "c1a80", "c2p15"], "r11f": ["pr4c", "rl4b", "s3up80", "gs5", "rowmv4", "c1a80", "c2p15", "ringfix"], "r11g": ["pr4d", "rl4b", "s3up80", "gs5", "rowmv5", "c1a80", "c2p15", "ringfix"], "r11h": ["pr4e", "rl4b", "s3up80", "gs5", "rowmv5", "c1a80", "c2p15", "ringfix"], "r11i": ["pr4f", "rl4c", "s3up80", "gs5", "rowmv5", "c1a80", "c2p15", "ringfix"], "r11j": ["pr4f", "rl4c", "s3up80", "gs5", "rowmv5", "c1a80", "c2p15", "ringfix"], "r12": ["c2p18", "padtrim"], "r12b": ["c2p18", "padtrim2"], "n_ref": [], "r13": ["pr4f", "rl4c", "s3up80", "gs5", "c1a80", "c2p15", "c2p18", "padtrim2", "ringfix"], "r13b": ["pr4f", "rl4c", "s3up100", "gs6", "c1a100", "c2p15", "c2p18", "padtrim2", "ringfix"]})

# --- 2x2-level pin overlays (openDVS_pixel2x2_top / _bot carry flattened copies of the pixel's edge structures as LVS pins:
# readLine/pixRst met3 columns, rowReadON/OFF/GndD met2 stubs + pin shapes (69/16) at x 0.16-0.42, the VddA18 met4 rail + pin (71/16)).
# Every set that moves those (r11d and later) needs this on each 2x2 cell.  Boxes are pixel-local and transformed by each pixel instance.
LNP = dict(LN, met2pin=(69, 16), met3pin=(70, 16), met4pin=(71, 16))
TOPFIX = [("met3", B(0.30, 0.13, 1.28, 11.27), "cut"),                       # overlay readLine/pixRst met3 columns inside the pixel span (pins stay in the bands)
          ("met4", B(-1.0, -13.5, 1.30, 13.5), "cut"),                        # the VddA18 met4 rail (would be an isolated piece; the pixels' planes reach the bands)
          ("met4pin", B(-1.0, -13.5, 1.30, 13.5), "cut"), ("met4pin", B(1.75, -0.1, 2.25, 0.35), "add")]   # its pin shape; new VddA18 pin on the plane band
def apply_topfix(ly, c):
    """c = a 2x2 cell (openDVS_pixel2x2_top or _bot).  Returns the number of labels moved."""
    insts = [i.trans for i in c.each_inst() if i.cell.name == "openDVS_pixel"]
    for ln, box, op in TOPFIX:
        lay = ly.find_layer(*LNP[ln])
        if lay is None: lay = ly.layer(*LNP[ln])
        r = pya.Region(c.shapes(lay))
        for t in insts:
            bb = box.transformed(t); r = (r - pya.Region(bb)) if op == "cut" else (r + pya.Region(bb))
        r = r.merged(); c.shapes(lay).clear(); c.shapes(lay).insert(r)
    # labels: the pixel instances sit at x = -18075 (west, r0/m0) and 6245 (east, r180/m90), rows at y -310 (row 0) / -50 (row 1, mirrored)
    xs = sorted({i.trans.disp.x for i in c.each_inst() if i.cell.name == "openDVS_pixel"})
    moved = 0   # round 13: only the VddA18 (met4) label moves, onto the plane's bottom band (pixel-local x 2.0, y 0.13); idempotent
    for lay in ly.layer_indexes():
        info = ly.get_info(lay)
        if info.datatype != 5 or info.layer != 71: continue
        for s in c.shapes(lay):
            if not s.is_text() or s.text.string != "VddA18" or abs(s.text.y) > 2500: continue
            tx = s.text; west = tx.x < (xs[0] + xs[-1]) / 2 if len(xs) > 1 else True
            x = (xs[0] + 2000) if west else (xs[-1] - 2000)
            if (x, -180) != (tx.x, tx.y): s.text = pya.Text("VddA18", pya.Trans(pya.Point(x, -180))); moved += 1
    return moved
NEEDS_TOPFIX = {"r11d", "r11e", "r11f", "r11g", "r11h", "r11i", "r11j", "r11k", "n", "r12", "r12b", "n_ref", "r13", "r13b"}

def apply_sets(ly, px, sets):
    for s in sets:
        for ln, box, op in E[s]:
            lay = ly.find_layer(*LN[ln]); r = pya.Region(px.shapes(lay))
            r = (r - pya.Region(box)) if op == "cut" else (r + pya.Region(box))
            r = r.merged(); px.shapes(lay).clear(); px.shapes(lay).insert(r)
# --- round 14 (2026-09-22 19:10): C1a back at the production position (the +0.8/+1.0 of n/p/q covered the photodiode, dnwell from y 3.28).
# The row lines leave the C1a plate (met3 rim 0.73) by going INTO the pair-mirror band: rowReadON 0.20-0.34, rowReadOFF 0.48-0.62 (0.14 wide,
# 0.26 tabs at their via1), GndD becomes one met2 line per row (1.20-1.46, under the plate: quiet) and is joined across the mirror axis inside
# the pixel by the two nfet-source met1 plates (extended down across y 0.13, merging with their mirror copies) -> the 2x2 keeps ONE GndD net,
# no 2x2-level connector.  The GndA met1 strap on the bottom edge (0.855-4.295 x 0.02-0.24, pure met1: no li/mcon under it) is replaced by a li
# strap (0.63-4.50 x 0.03-0.23) contacted at the GndA corner foot (mcon 0.655-0.825 x 0.30-0.47), so the met1 axis band is free for the plates.
R14 = {
"gs7": [("met3", B(0.31, 2.53, 1.27, 10.24), "add"), ("met3", B(1.27, 4.50, 1.57, 4.80), "add")],   # GndA lane (rl4c/pr4f stubs) bridged to the untouched s3 (bottom 4.50)
"rows14": [
    # cuts
    ("met2", B(-0.5, -0.5, 12.2, 0.70), "cut"), ("met2", B(0.16, 0.84, 12.16, 1.10), "cut"), ("met2", B(0.16, 1.24, 12.16, 1.50), "cut"),
    ("via1", B(2.185, 0.895, 2.335, 1.045), "cut"), ("via1", B(3.075, 1.295, 3.225, 1.445), "cut"),
    ("via1", B(1.44, 0.46, 2.24, 0.62), "cut"), ("via1", B(3.17, 0.46, 3.97, 0.62), "cut"), ("via1", B(-0.08, -0.27, 0.40, 0.53), "cut"),
    ("met1", B(-0.2, -0.4, 0.48, 0.61), "cut"),                                                   # GndD corner piece (only fed the axis line)
    ("met1", B(1.65, 0.38, 2.32, 0.70), "cut"), ("met1", B(3.09, 0.38, 3.76, 0.70), "cut"),        # wide feet of the GndD plates (made room for the met1 legs of the row lines)
    ("met1", B(0.855, 0.02, 4.295, 0.24), "cut"),                                                  # GndA met1 strap -> li
    # GndA li strap + contact at the corner foot (met1 0.62-0.855 x 0.02-0.94)
    ("li", B(0.63, 0.03, 4.50, 0.23), "add"), ("li", B(0.63, 0.03, 0.85, 0.60), "add"), ("mcon", B(0.655, 0.30, 0.825, 0.47), "add"),
    # GndD plates across the axis (merge with the mirror copies) + via1 to the per-row GndD line
    ("met1", B(1.36, 0.10, 1.68, 1.465), "add"), ("met1", B(3.73, 0.10, 4.05, 1.465), "add"),
    ("met2", B(0.0, 1.20, 12.16, 1.46), "add"),
    ("via1", B(1.445, 1.255, 1.595, 1.405), "add"), ("via1", B(3.815, 1.255, 3.965, 1.405), "add"),
    # rowReadON 0.20-0.34 with a via tab at x 2.13-2.39; met1 leg down from the handshake gate contact
    ("met2", B(0.16, 0.20, 12.16, 0.34), "add"), ("met2", B(2.10, 0.20, 2.42, 0.46), "add"),
    ("via1", B(2.185, 0.255, 2.335, 0.405), "add"), ("met1", B(2.10, 0.20, 2.42, 0.84), "add"),
    # rowReadOFF 0.48-0.62, raised to 0.60-0.74 around the rowReadON tab (x 1.95-2.57, 0.14 clear), via tab at x 3.02-3.28
    ("met2", B(0.16, 0.48, 12.16, 0.62), "add"), ("met2", B(1.95, 0.60, 2.57, 0.74), "add"), ("met2", B(1.81, 0.48, 1.95, 0.74), "add"), ("met2", B(2.57, 0.48, 2.71, 0.74), "add"),
    ("met2", B(1.95, 0.48, 2.57, 0.60), "cut"),                                                    # the lowered part must not pass over the rowReadON tab
    ("met2", B(2.99, 0.48, 3.31, 0.74), "add"),
    ("via1", B(3.075, 0.535, 3.225, 0.685), "add"), ("met1", B(2.99, 0.48, 3.31, 1.24), "add")],
}
E.update(R14)
COMBOS.update({"r14": ["pr4f", "rl4c", "gs7", "c2p15", "c2p18", "padtrim2", "rows14"], "r14rows": ["rows14"], "r14b": ["pr4f", "rl4c", "gs7", "c2p15", "c2p18", "padtrim2", "rows14"]})
# TOPFIX v4: column overlays as v3 + the three row nets' overlay stubs/pins at the new y (no GndD connector: GndD is joined inside the pixel)
TOPFIX = [("met3", B(0.30, 0.13, 1.28, 11.27), "cut"),
          ("met2", B(0.10, -0.5, 0.45, 1.55), "cut"),
          ("met4", B(-1.0, -13.5, 1.30, 13.5), "cut"),
          ("met2pin", B(0.10, -0.5, 0.45, 1.55), "cut"),
          ("met2pin", B(0.16, 0.20, 0.42, 0.34), "add"), ("met2pin", B(0.16, 0.48, 0.42, 0.62), "add"), ("met2pin", B(0.16, 1.20, 0.42, 1.46), "add"),
          ("met4pin", B(-1.0, -13.5, 1.30, 13.5), "cut"), ("met4pin", B(1.75, -0.1, 2.25, 0.35), "add")]
def apply_topfix(ly, c):
    """c = a 2x2 cell.  Row 1 (upper instance): 2x2 y = local y - 0.31; row 0: 2x2 y = -local y - 0.05; the axis is at -180.  Idempotent."""
    insts = [i.trans for i in c.each_inst() if i.cell.name == "openDVS_pixel"]
    for ln, box, op in TOPFIX:
        lay = ly.find_layer(*LNP[ln])
        if lay is None: lay = ly.layer(*LNP[ln])
        r = pya.Region(c.shapes(lay))
        for t in insts:
            bb = box.transformed(t); r = (r - pya.Region(bb)) if op == "cut" else (r + pya.Region(bb))
        r = r.merged(); c.shapes(lay).clear(); c.shapes(lay).insert(r)
    xs = sorted({i.trans.disp.x for i in c.each_inst() if i.cell.name == "openDVS_pixel"})
    Y = {"rowReadON": 270, "rowReadOFF": 550, "GndD": 1330}   # local line centres (nm)
    moved = 0
    for lay in ly.layer_indexes():
        info = ly.get_info(lay)
        if info.datatype != 5 or info.layer not in (69, 71): continue
        for s in c.shapes(lay):
            if not s.is_text(): continue
            tx = s.text; nm = tx.string; x, y = tx.x, tx.y
            west = x < (xs[0] + xs[-1]) / 2 if len(xs) > 1 else True
            base = nm.split("[")[0]
            if info.layer == 69 and base in Y:
                upper = y > -180 if base != "GndD" else False          # GndD's single label goes to row 0's line
                ny = (Y[base] - 310) if upper else (-Y[base] - 50)
            elif info.layer == 71 and nm == "VddA18" and abs(y) < 2500: ny = -180; x = (xs[0] + 2000) if west else (xs[-1] - 2000)
            else: continue
            if (x, ny) != (tx.x, tx.y): s.text = pya.Text(nm, pya.Trans(pya.Point(x, ny))); moved += 1
    return moved
NEEDS_TOPFIX = NEEDS_TOPFIX | {"r14", "r14b"}

# r14c: GndD line extended south to 0.76 as a lateral shield between the rowReadOFF top edge (0.62) and the C1a met3 rim (0.73); notch to 0.88 over the
# rowReadOFF raised part (1.81-2.71) and its via tab (3.02-3.28)
E["gndd76"] = [("met2", B(0.0, 0.76, 12.16, 1.20), "add"), ("met2", B(1.67, 0.76, 3.45, 0.88), "cut")]
COMBOS["r14c_delta"] = ["gndd76"]; COMBOS["r14d"] = ["pr4f", "rl4c", "gs7", "c2p15", "c2p18", "padtrim2", "rows14", "gndd76"]; NEEDS_TOPFIX = NEEDS_TOPFIX | {"r14c_delta", "r14d"}
# r15 (Rui 19:55: shield nRst from the MIM with VddA18/GndA instead of vdiff): the vdiff met2 band 3.31-7.235 x 2.83-3.28 under the C1a plate is
# narrowed to the 0.14 route 2.83-2.97 (kept full at 3.31-3.45 to meet the vdiff vertical 3.17-3.31 x 3.14-5.5); a VddA18 met2 strip 3.59-9.375 x
# 3.11-3.28 over the nRst met1 run (3.14-3.28), joined to the s1 VddA18 met2 L at 9.235-9.375 x 3.0-4.40.
E["nrs_vdd"] = [("met2", B(3.45, 2.97, 7.235, 3.28), "cut"), ("met2", B(3.59, 3.11, 9.375, 3.28), "add")]
COMBOS["sfvdd_delta"] = ["nrs_vdd"]; NEEDS_TOPFIX = NEEDS_TOPFIX | {"sfvdd_delta"}
# armsh: GndA met2 strip 2.33-3.03 x 3.40-8.10 under the vsf plate's left arm (met3 2.47-2.90), between the arm and the vdiff met2 vertical 3.17-3.31
# (joins the GndA met2 L at 2.72-3.03 x 3.35 / 2.335-2.72 x 3.4-3.955; 0.14 from nRst met2 top 3.26 and from the GndA met2 vertical 1.82-2.19)
E["armsh"] = [("met2", B(2.33, 3.40, 3.03, 7.95), "add")]
COMBOS["sfvdd2_delta"] = ["nrs_vdd", "armsh"]; NEEDS_TOPFIX = NEEDS_TOPFIX | {"sfvdd2_delta"}
# r15 (Rui 20:15: reduce the vd-vdiff wiring parasitic in the change-amp core; 0.29 of the 0.65 fF is the C2 MIM rim fringe, inherent):
# t3: drop the westmost gate contact of the input pfet (licon/mcon 10.635-10.805 x 2.225-2.395) and shorten the vd li row (to 10.915) and the
#     vd met1 bar (to 10.935) so they sit 0.44 instead of 0.1 um from the vdiff met1 vertical (10.245-10.48)
# t7: the vdiff met2 stub 9.96-10.385 x 2.005-2.99 only carries the via1 at 2.09-2.24: cut it above 2.30 (it ran beside the vd met4 stub and under the vd met3 pad)
# t5: VddA18 met2 shield 11.185-11.39 x 2.655-3.79 between the vd met2 bar (10.905-11.045) and the vdiff met2 vertical (11.53-11.67), foot 11.09-11.39 x 3.79-4.13
#     with via1 11.16-11.31 x 3.88-4.03 onto the VddA18 met1 plate
E["t3"] = [("licon", B(10.635, 2.225, 10.805, 2.395), "cut"), ("mcon", B(10.635, 2.225, 10.805, 2.395), "cut"), ("li", B(10.555, 2.225, 10.915, 2.395), "cut"), ("met1", B(10.575, 2.195, 10.935, 2.515), "cut")]
E["t7"] = [("met2", B(9.96, 2.30, 10.385, 2.99), "cut")]
E["t5"] = [("met2", B(11.185, 2.655, 11.39, 3.80), "add"), ("met2", B(11.09, 3.80, 11.39, 4.14), "add"), ("via1", B(11.16, 3.89, 11.31, 4.04), "add")]   # foot corner 0.147 from the vd met2 horizontal corner (11.045, 3.66)
COMBOS.update({"v_t3": ["t3"], "v_t7": ["t7"], "v_t5": ["t5"], "v_t357": ["t3", "t7", "t5"], "v_t357n": ["t3", "t7", "t5", "nrs_vdd"]})
# t8: the vdiff met2 band 9.465-11.67 x 1.865-2.005 (0.19 under the vd met1 bar / li gate row and the vd met2 bar) drops to 1.60-1.74 (0.14 above the GndD line),
#     with three legs up: the west connector 9.465-9.605, the via1 stub 9.96-10.385, the east vertical 11.53-11.67
E["t8"] = [("met2", B(9.605, 1.865, 9.96, 2.005), "cut"), ("met2", B(10.385, 1.865, 11.53, 2.005), "cut"),
           ("met2", B(9.465, 1.60, 11.67, 1.74), "add"), ("met2", B(9.465, 1.74, 9.605, 1.865), "add"), ("met2", B(9.96, 1.74, 10.385, 2.005), "add"), ("met2", B(11.53, 1.74, 11.67, 1.865), "add")]
COMBOS.update({"v_t8": ["t8"], "v_t3578": ["t3", "t7", "t5", "t8"], "r15a_delta": ["t3", "t7", "t5", "nrs_vdd"], "r15b_delta": ["t3", "t7", "t5", "t8", "nrs_vdd"]})
NEEDS_TOPFIX = NEEDS_TOPFIX | {"r15a_delta", "r15b_delta"}
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
    if globals().get("topfix", "") == "1":
        for cn in ("openDVS_pixel2x2_top", "openDVS_pixel2x2_bot"):
            c = ly.cell(cn); print("topfix", cn, "labels moved:", apply_topfix(ly, c) if c else "MISSING CELL")
    ly.write("pixel_4tile_work.gds"); print("applied", sets, "to pixel_4tile_work.gds (backup:", bak + ")")
