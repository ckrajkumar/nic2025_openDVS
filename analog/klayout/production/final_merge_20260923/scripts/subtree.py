# klayout -b -r subtree.py -rd src=in.gds -rd dst=out.gds -rd top=pixel_4tile : write only the subtree of one cell
import pya
ly = pya.Layout(); ly.read(src)
c = ly.cell(top); assert c is not None
o = pya.SaveLayoutOptions(); o.clear_cells(); o.add_cell(c.cell_index())
ly.write(dst, o)
l2 = pya.Layout(); l2.read(dst); print(dst, "tops", [t.name for t in l2.top_cells()], "cells", l2.cells())
