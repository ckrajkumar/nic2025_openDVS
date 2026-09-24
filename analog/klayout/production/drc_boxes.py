#!/usr/bin/env python3
"""Parse a magic_drc.sh drc_why.txt (alternating why / box-list lines, Magic units 0.005 um, 2x2 coords) into pixel-local
coordinates of the r0 instance (x+18.075, y+0.31); boxes of the other three instances are folded back by the mirrors."""
import sys, re
lines = [l.rstrip("\n") for l in open(sys.argv[1])]
i = 0
while i < len(lines):
    why = lines[i]; boxes = lines[i+1] if i + 1 < len(lines) else ""; i += 2
    bl = [tuple(int(v) * 0.005 for v in b.split()) for b in re.findall(r"\{([^}]*)\}", boxes)]
    seen = set()
    for x1, y1, x2, y2 in bl:
        # 2x2 -> pixel-local of r0; fold mirrors: x about 12.16 (pair), y about 0.13 / 12.29
        px1, px2, py1, py2 = x1 + 18.075, x2 + 18.075, y1 + 0.31, y2 + 0.31
        if px1 > 12.16: px1, px2 = 24.32 - px2, 24.32 - px1
        if py1 < 0.13 - 2.6 or py2 > 12.29 + 0.5:
            pass
        if py2 < 0.13: py1, py2 = 0.26 - py2, 0.26 - py1
        if py1 > 12.29: py1, py2 = 24.58 - py2, 24.58 - py1
        key = (round(px1, 2), round(py1, 2), round(px2, 2), round(py2, 2))
        if key in seen: continue
        seen.add(key)
    print("== %s  (%d boxes, %d distinct after folding)" % (why, len(bl), len(seen)))
    for k in sorted(seen)[:12]: print("   (%.3f,%.3f ; %.3f,%.3f)" % k)
