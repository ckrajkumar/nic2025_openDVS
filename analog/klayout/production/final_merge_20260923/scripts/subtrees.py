# klayout -b -r subtrees.py -rd fin=<merged wrapper> -rd prod=<prod tile> -rd r18=<r18 tile> -rd outdir=<dir>
# 1. make the r18 tile's contact$26$1$1 identical to the production/final one (drop the edited via cell) and rewrite it
# 2. write pixel_4tile and pixel_test_structure subtrees of the merged wrapper as standalone GDS files
import pya
def load(p):
    ly = pya.Layout(); ly.read(p); return ly
F, P, R = load(fin), load(prod), load(r18)
def lmap(ly): return {(ly.get_info(li).layer, ly.get_info(li).datatype): li for li in ly.layer_indexes()}
LP, LR = lmap(P), lmap(R)
c = R.cell("contact$26$1$1")
for li in R.layer_indexes(): c.shapes(li).clear()
pc = P.cell("contact$26$1$1")
for ld, li in LP.items():
    tgt = R.find_layer(ld[0], ld[1]); tgt = tgt if tgt is not None else R.layer(ld[0], ld[1])
    for s in pc.shapes(li).each(): c.shapes(tgt).insert(s)
R.write(r18)
print("rewrote contact$26$1$1 in", r18)
# verify the 2x2 cells now equal the wrapper's
LF = lmap(F); LR = lmap(R)
def rec(ly, cell, L, ld):
    if ld not in L: return pya.Region()
    r = pya.Region(ly.cell(cell).begin_shapes_rec(L[ld])); r.merge(); return r
tot = 0
for cw, cr in (("GS_openDVS_pixel2x2_top", "openDVS_pixel2x2_top"), ("GS_openDVS_pixel2x2_bot", "openDVS_pixel2x2_bot")):
    for ld in sorted(set(LF) | set(LR)):
        tot += (rec(F, cw, LF, ld) ^ rec(R, cr, LR, ld)).area()
print("2x2 wrapper vs r18 tile flat xor total um2:", tot/1e6)
for top, name in (("pixel_4tile", "pixel_4tile.merged.gds"), ("pixel_test_structure", "pixel_test_structure.merged.gds")):
    O = pya.Layout(); O.dbu = F.dbu; t = O.create_cell(top); t.copy_tree(F.cell(top)); O.write(outdir + "/" + name)
    print("wrote", name, "cells", O.cells(), "bbox", t.bbox().to_s())
