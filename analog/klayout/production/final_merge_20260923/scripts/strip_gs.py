# klayout -b -r strip_gs.py -rd src=... -rd dst=...
# Production-named pixel_4tile from the wrapper subtree: rename GS_<name> -> <name>.
# A GS_ cell whose stripped name already exists is merged into that cell when geometrically identical.
import pya as db
ly = db.Layout(); ly.read(src)
names = {ly.cell(i).name: ly.cell(i) for i in range(ly.cells())}
print("non-GS cells:", [n for n in names if not n.startswith("GS_")])
def sig(c):
    return sorted((ly.get_info(l).to_s(), s.to_s()) for l in ly.layer_indexes() for s in c.shapes(l).each())
ren = 0; merged = []
for i in range(ly.cells()):
    c = ly.cell(i)
    if not c.name.startswith("GS_"): continue
    n = c.name[3:]
    if n in names:
        t = names[n]
        if sig(c) == sig(t) and c.child_cells() == 0 and t.child_cells() == 0:
            for p in c.each_parent_inst():
                pi = p.inst()
                ca = pi.cell_inst; ca.cell_index = t.cell_index(); pi.cell_inst = ca
            c.delete(); merged.append(n); continue
        # different cell of the wrapper level sharing the base name (a via cell, no devices): keep it under a _wrap suffix
        t.name = n + "_wrap"; merged.append(n + " -> " + t.name)
    c.name = n; ren += 1
print("renamed", ren, "merged into existing", merged, "cells", ly.cells(), "tops", [c.name for c in ly.top_cells()])
ly.write(dst)
