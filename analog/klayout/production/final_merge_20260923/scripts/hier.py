# klayout -b -r hier.py -rd gds=<file> -rd focus=<cellname substring>
import pya, sys
ly = pya.Layout(); ly.read(gds)
tops = [c.name for c in ly.top_cells()]
print("dbu", ly.dbu, "cells", ly.cells(), "tops", tops)
for t in ly.top_cells():
    print("top", t.name, "bbox um", t.bbox().to_s(), "layers", len([l for l in ly.layer_indexes()]))
# cells whose name contains focus, with their children and instance counts
for c in ly.each_cell():
    if focus in c.name:
        kids = {}
        for inst in c.each_inst():
            n = ly.cell(inst.cell_index).name
            kids[n] = kids.get(n,0) + (inst.cell_inst.na*inst.cell_inst.nb if inst.is_regular_array() else 1)
        parents = [ly.cell(p).name for p in c.each_parent_cell()]
        print("CELL", c.name, "bbox", c.bbox().to_s(), "parents", parents[:5], "children", sorted(kids.items()))
