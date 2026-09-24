# klayout -b -r prune_orphans.py -rd gds=<merged wrapper>   : delete cells that lost their last parent in the merge (keep the one real top)
import pya
ly = pya.Layout(); ly.read(gds)
tops = [c.name for c in ly.top_cells()]; print("tops before:", tops)
for c in list(ly.top_cells()):
    if c.name != "user_project_wrapper":
        print("pruning orphan top", c.name, "children", [ly.cell(i.cell_index).name for i in c.each_inst()][:5])
        ly.prune_cell(c.cell_index(), -1)
print("tops after:", [c.name for c in ly.top_cells()], "cells", ly.cells())
ly.write(gds)
