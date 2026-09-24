"""Rotate the nRst MOS cap (pfet_01v8 1.5/1.5, S=D=VddA18, gate=nRst) by 90 deg and shift it up in its slot
between the vd input pfet (below) and the RefrBp pfet (above), so that a VddA18 source/drain strip - not the
nRst gate poly - faces the vd gate, and the gate contact sits on the west endcap, away from vd.

Before: diff (10.210,2.885;12.310,4.385), gate poly (10.510,2.755;12.010,4.915), S/D contacts on the west
        (x 10.275-10.445) and east/mirror (x 12.075-12.245) li columns, gate contacts on the top endcap
        (li row y 4.665-4.835) -> gate poly bottom edge 0.28 um from the vd gate poly (top 2.475).
After:  diff (10.360,3.000;11.860,5.080) [W=1.5 in x], gate poly (9.860,3.300;12.000,4.800) [L=1.5 in y],
        S/D strips at y 3.00-3.30 and 4.80-5.08 contacted by li rows tied to the mirror-shared VddA18 li column,
        gate contacts at x 9.94-10.11 (2 licons) with li up to an mcon into the nRst met1 leg, which is widened
        to 9.935-10.22 after trimming the now-contactless corner of the VddA18 met1 plate (x<10.38, y 4.0-4.34).
        Gate poly bottom edge 0.825 um from the vd gate poly with a VddA18 diff+li strip in between.
Wiring/device-position only: same device, same W/L, same nets.  Backup: pixel_4tile_work.before-rotate.gds
"""
import pya, shutil, os
SRC = "pixel_4tile_work.gds"; BAK = "pixel_4tile_work.before-rotate.gds"
if os.path.exists(BAK): shutil.copy(BAK, SRC); print("restored", SRC, "from", BAK)   # idempotent re-run
else: shutil.copy(SRC, BAK)
ly = pya.Layout(); ly.read(SRC); px = ly.cell("openDVS_pixel")
def B(x1, y1, x2, y2): return pya.Box(int(round(x1 * 1000)), int(round(y1 * 1000)), int(round(x2 * 1000)), int(round(y2 * 1000)))
LN = {"diff": (65, 20), "poly": (66, 20), "licon": (66, 44), "li": (67, 20), "mcon": (67, 44), "met1": (68, 20), "psdm": (94, 20), "npc": (95, 20)}
def region(name): return pya.Region(px.shapes(ly.find_layer(*LN[name])))
def put(name, r):
    r = r.merged(); lay = ly.find_layer(*LN[name]); n0 = px.shapes(lay).size(); px.shapes(lay).clear(); px.shapes(lay).insert(r)
    print("   %-5s shapes %d -> %d" % (name, n0, r.count()))

REMOVE = {
    "diff":  [B(10.20, 2.80, 12.40, 4.45)],                       # old cap diffusion (mirror-shared strip)
    "poly":  [B(10.50, 2.70, 12.05, 4.95)],                       # old gate
    "licon": [B(10.20, 2.90, 10.50, 4.40), B(12.00, 2.90, 12.40, 4.40), B(10.50, 4.60, 12.00, 4.90)],
    "li":    [B(10.20, 2.90, 10.50, 4.40), B(10.50, 4.60, 12.00, 4.90)],   # west S/D column, old gate row
    "mcon":  [B(10.20, 3.20, 10.50, 4.30), B(10.50, 4.60, 12.00, 4.90)],   # west column mcons, gate-row mcons
    "met1":  [B(10.575, 4.60, 11.30, 4.90),                       # nRst met1 bar over the old gate row
              B(10.245, 4.00, 10.38, 4.34)],                      # VddA18 plate corner (its west-column mcons are gone)
    "npc":   [B(10.50, 4.50, 12.00, 5.00)],
}
LICON_X = [10.50, 10.86, 11.22, 11.58]
ADD = {
    "diff":  [B(10.36, 3.00, 11.86, 5.08)],                       # top edge 0.245 from the RefrBp poly contacts (licon.9)
    "poly":  [B(9.86, 3.30, 12.00, 4.80)],
    "licon": [B(x, 3.06, x + 0.17, 3.23) for x in LICON_X] + [B(x, 4.87, x + 0.17, 5.04) for x in LICON_X]
             + [B(9.94, 3.95, 10.11, 4.12), B(9.94, 4.31, 10.11, 4.48)],   # gate: 0.25 from diff (licon.9 0.235)
    "li":    [B(10.42, 3.06, 12.245, 3.23), B(10.42, 4.87, 12.245, 5.04),   # S/D rows -> mirror VddA18 column
              B(12.075, 2.93, 12.245, 5.04),                                # VddA18 column extended up
              B(9.86, 3.87, 10.24, 4.75)],                                  # gate li up to the nRst met1 leg
    "mcon":  [B(9.99, 4.50, 10.16, 4.67)],
    "met1":  [B(9.935, 4.42, 10.22, 4.865)],                     # widen the nRst met1 leg for that mcon
    "psdm":  [B(9.725, 2.76, 12.435, 5.225)],
    "npc":   [B(9.84, 3.85, 10.21, 4.58)],
}
for name in LN:
    r = region(name)
    for b in REMOVE.get(name, []): r -= pya.Region(b)
    for b in ADD.get(name, []): r += pya.Region(b)
    put(name, r)
ly.write(SRC); print("wrote", SRC)
