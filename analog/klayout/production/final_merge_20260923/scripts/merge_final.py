"""Merge the r17b pixel into the final user_project_wrapper GDS, carrying the foundry-side fixes of the final pixel.
klayout -b -r merge_final.py -rd fin=<final wrapper gds> -rd prod=<prod tile gds> -rd r17=<r17b tile gds> -rd outdir=<dir>
Writes: <outdir>/user_project_wrapper.gds (merged wrapper), <outdir>/pixel_4tile.r18.gds (merged tile, production cell names),
        <outdir>/merge_report.txt
Rule: new = r17b + (final - prod) - (prod - final), with explicit exclusions where the foundry additions collide with r17b."""
import pya, sys
rep = []
def log(*a):
    s = " ".join(str(x) for x in a); print(s); rep.append(s)
def load(p):
    ly = pya.Layout(); ly.read(p); return ly
F, P, R = load(fin), load(prod), load(r17)
G = load(fin)   # pristine copy for the final verification
def lmap(ly): return {(ly.get_info(li).layer, ly.get_info(li).datatype): li for li in ly.layer_indexes()}
LF, LP, LR = lmap(F), lmap(P), lmap(R)
def rec(ly, cell, L, ld):
    if ld not in L: return pya.Region()
    r = pya.Region(ly.cell(cell).begin_shapes_rec(L[ld])); r.merge(); return r
def own(ly, cell, L, ld, plus_children=()):
    """cell's own shapes plus the (flattened) shapes of the listed child cell names."""
    r = pya.Region()
    if ld in L:
        r.insert(ly.cell(cell).shapes(L[ld]))
        for inst in ly.cell(cell).each_inst():
            child = ly.cell(inst.cell_index)
            if child.name in plus_children:
                r += pya.Region(pya.RecursiveShapeIterator(ly, child, L[ld])).transformed(inst.trans)
    r.merge(); return r
def texts(ly, cell, L):
    out = []
    for ld, li in L.items():
        for s in ly.cell(cell).shapes(li).each():
            if s.is_text(): out.append((ld, s.text_string, s.text_trans.disp.x, s.text_trans.disp.y, s.text))
    return out
ALL = sorted(set(LF) | set(LP) | set(LR))
NAMES = {(65,20):"diff",(65,44):"tap",(66,20):"poly",(66,44):"licon",(67,20):"li",(67,44):"mcon",(68,20):"met1",(68,44):"via",(69,20):"met2",(69,44):"via2",(70,20):"met3",(70,44):"via3",(71,20):"met4",(71,44):"via4",(72,20):"met5",(93,44):"nsdm",(94,20):"psdm",(95,20):"npc",(64,20):"nwell"}
SPACING = {(67,20):170,(68,20):140,(69,20):140,(70,20):300,(71,20):300,(66,20):210,(65,20):270,(65,44):270,(66,44):170,(67,44):190,(68,44):170,(69,44):200}
def nm(ld): return NAMES.get(ld, "%d/%d" % ld)

# ---------------- pixel-level merge ----------------
STRIP_TAP  = pya.Region(pya.Box(10085, 8210, 10495, 11045))          # vertical part of the foundry VddA18 tie (collides with r17b GndA li + nRst li)
STRIP_LI   = pya.Region(pya.Box(10035, 8210, 10545, 11470))   # everything east of 10035 (= GndA li 10205 - 0.17) below 11470 (= GndA li top 11300 + 0.17)
STRIP_LICON= pya.Region(pya.Box(10205, 8210, 10375, 11470))
STRIP_NSDM = pya.Region(pya.Box(9960, 8085, 10620, 10920))
pixel_new = {}   # ld -> Region
pixel_fixadd_kept = {}; pixel_fixdel = {}
log("== PIXEL merge (openDVS_pixel): r17b + (final GS_openDVS_pixel - prod) - (prod - final)")
for ld in ALL:
    r = rec(R, "openDVS_pixel", LR, ld); p = rec(P, "openDVS_pixel", LP, ld); f = rec(F, "GS_openDVS_pixel", LF, ld)
    fa, fd = f - p, p - f
    if not fa.is_empty() or not fd.is_empty():
        excl = pya.Region()
        if ld == (65,44): excl = STRIP_TAP
        if ld == (67,20): excl = STRIP_LI
        if ld == (66,44): excl = STRIP_LICON
        if ld == (93,44): excl = STRIP_NSDM
        if ld == (66,44):
            dropped = fa.interacting(excl); fa = fa - dropped        # contacts: drop whole cuts, never slice them
        else:
            dropped = fa & excl; fa = fa - excl
        if ld in ((68,20),(69,20)):
            # density tiles: drop any tile closer than the metal spacing to r17b metal
            sp = SPACING[ld]; keep = pya.Region(); drop = pya.Region()
            for t in fa.each():
                if (pya.Region(t).sized(sp - 1) & r).is_empty(): keep.insert(t)
                else: drop.insert(t)
            if not drop.is_empty(): log("   %s: dropped %d density tiles within %.2f um of r17b metal: %s" % (nm(ld), drop.count(), sp/1000, [t.bbox().to_s() for t in drop.each()]))
            fa = keep
        if not dropped.is_empty(): log("   %s: dropped foundry additions colliding with r17b (area %.3f um2): %s" % (nm(ld), dropped.area()/1e6, [t.bbox().to_s() for t in dropped.each()][:6]))
        # safety: remaining additions vs r17b-changed shapes on the same layer
        rch = (r - p) + (p - r)
        ov = fa & r
        if not ov.is_empty(): log("   !! %s: kept foundry addition OVERLAPS r17b shapes area %.4f um2 %s" % (nm(ld), ov.area()/1e6, ov.bbox().to_s()))
        if ld in SPACING:
            near = fa.sized(SPACING[ld]-1) & rch
            if not near.is_empty(): log("   !! %s: kept foundry addition within %.2f um of r17b-changed shapes: %d polys %s" % (nm(ld), SPACING[ld]/1000, near.count(), near.bbox().to_s()))
        # fixDel must not remove anything r17b introduced, and must exist in r17b
        if not (fd & (r - p)).is_empty(): log("   !! %s: foundry deletion hits r17b-added shapes area %.4f" % (nm(ld), (fd & (r-p)).area()/1e6))
        missing = fd - r
        if not missing.is_empty(): log("   note %s: foundry deletion of %.4f um2 that r17b no longer has (r17b already removed it)" % (nm(ld), missing.area()/1e6))
        log("   %-6s fixAdd kept %.3f um2 (%d)  fixDel %.3f um2 (%d)" % (nm(ld), fa.area()/1e6, fa.count(), fd.area()/1e6, fd.count()))
        pixel_fixadd_kept[ld] = fa; pixel_fixdel[ld] = fd
    new = (r - pixel_fixdel.get(ld, pya.Region())) + pixel_fixadd_kept.get(ld, pya.Region())
    new.merge()
    if not new.is_empty(): pixel_new[ld] = new
# texts: r17b pixel texts + final-only texts (not in prod) outside the excluded strip
pix_texts = texts(R, "openDVS_pixel", LR)
pt = set((t[0], t[1], t[2], t[3]) for t in texts(P, "openDVS_pixel", LP))
extra = [t for t in texts(F, "GS_openDVS_pixel", LF) if (t[0], t[1], t[2], t[3]) not in pt]
for t in extra:
    inside = not (pya.Region(pya.Box(t[2]-1, t[3]-1, t[2]+1, t[3]+1)) & (STRIP_LI)).is_empty()
    log("   final-only pixel text %r at (%d,%d) on %s -> %s" % (t[1], t[2], t[3], nm(t[0]), "DROPPED (on excluded strip)" if inside else "kept"))
    if not inside: pix_texts.append(t)

# ---------------- 2x2-level merge (own shapes + contact/via children flattened) ----------------
def merge_2x2(rcell, pcell, fcell, tag):
    log("== 2x2-level merge %s: r17b %s own + (final %s own+vias - prod own) - (prod - final)" % (tag, rcell, fcell))
    out = {}
    rflat = {ld: rec(R, rcell, LR, ld) for ld in ALL}   # full flat r17b 2x2 for conflict checks
    for ld in ALL:
        r = own(R, rcell, LR, ld); p = own(P, pcell, LP, ld); f = own(F, fcell, LF, ld, plus_children=("vias_gen$4",))
        fa, fd = f - p, p - f
        if not fa.is_empty() or not fd.is_empty():
            ov = fa & rflat[ld]
            if not ov.is_empty(): log("   !! %s: 2x2-level foundry addition OVERLAPS r17b flat shapes area %.4f um2 %s" % (nm(ld), ov.area()/1e6, ov.bbox().to_s()))
            if ld in SPACING:
                rch = (rflat[ld] - rec(P, pcell, LP, ld)) + (rec(P, pcell, LP, ld) - rflat[ld])
                near = fa.sized(SPACING[ld]-1) & rch
                if not near.is_empty(): log("   !! %s: 2x2-level foundry addition within %.2f um of r17b-changed shapes: %d polys %s" % (nm(ld), SPACING[ld]/1000, near.count(), near.bbox().to_s()))
            if not (fd & (r - p)).is_empty(): log("   !! %s: 2x2-level foundry deletion hits r17b-added shapes" % nm(ld))
            log("   %-6s fixAdd %.3f um2 (%d) %s  fixDel %.3f um2 (%d)" % (nm(ld), fa.area()/1e6, fa.count(), fa.bbox().to_s(), fd.area()/1e6, fd.count()))
        new = (r - fd) + fa; new.merge()
        if not new.is_empty(): out[ld] = new
    return out, texts(R, rcell, LR)
top_new, top_texts = merge_2x2("openDVS_pixel2x2_top", "openDVS_pixel2x2_top", "GS_openDVS_pixel2x2_top", "top")
bot_new, bot_texts = merge_2x2("openDVS_pixel2x2_bot", "openDVS_pixel2x2_bot", "GS_openDVS_pixel2x2_bot", "bot")

# ---------------- checks on the untouched hierarchy pieces ----------------
log("== hierarchy checks")
for cn in ("contact$1", "contact$25$1$1", "contact$26$1$1", "contact$30$1$1"):
    for pref in ("GS_", "S7_"):
        d = sum((rec(F, pref+cn, LF, ld) ^ (rec(P, cn, LP, ld) if pref == "GS_" else rec(P, cn, LP, ld).transformed(pya.Trans(3, False)))).area() for ld in ALL)
        d2 = sum((rec(R, cn, LR, ld) ^ rec(P, cn, LP, ld)).area() for ld in ALL)
        log("   %s%s vs prod %s: xor %.4f um2 ; r17b vs prod: %.4f" % (pref, cn, cn, d/1e6, d2/1e6))
R270 = pya.Trans(3, False)
d = sum((rec(F, "S7_openDVS_pixel", LF, ld) ^ rec(P, "openDVS_pixel", LP, ld).transformed(R270)).area() for ld in ALL)
log("   S7_openDVS_pixel vs r270(prod pixel): xor %.4f um2" % (d/1e6))
d = sum((own(F, "S7_openDVS_pixel2x2_bot", LF, ld) ^ own(P, "openDVS_pixel2x2_bot", LP, ld).transformed(R270)).area() for ld in ALL)
log("   S7_openDVS_pixel2x2_bot own vs r270(prod 2x2_bot own): xor %.4f um2" % (d/1e6))
def insts(ly, cell, pix):
    return sorted(i.trans.to_s() for i in ly.cell(cell).each_inst() if ly.cell(i.cell_index).name == pix)
log("   pixel instance transforms final top/bot == r17b:", insts(F,"GS_openDVS_pixel2x2_top","GS_openDVS_pixel") == insts(R,"openDVS_pixel2x2_top","openDVS_pixel"), insts(F,"GS_openDVS_pixel2x2_bot","GS_openDVS_pixel") == insts(R,"openDVS_pixel2x2_bot","openDVS_pixel"))
s7i = [i.trans for i in F.cell("S7_openDVS_pixel2x2_bot").each_inst() if F.cell(i.cell_index).name == "S7_openDVS_pixel"]
r17i = [i.trans for i in R.cell("openDVS_pixel2x2_bot").each_inst() if R.cell(i.cell_index).name == "openDVS_pixel"]
log("   S7 pixel transforms == r270*r17b transforms*r90?:", sorted((R270 * t * R270.inverted()).to_s() for t in r17i) == sorted(t.to_s() for t in s7i))

# ---------------- write into the wrapper ----------------
def layer_of(ly, ld):
    li = ly.find_layer(ld[0], ld[1]); return li if li is not None else ly.layer(ld[0], ld[1])
def rewrite_cell(ly, cellname, shapes, txts, trans, keep_child_names):
    c = ly.cell(cellname)
    for li in ly.layer_indexes(): c.shapes(li).clear()
    for inst in list(c.each_inst()):
        if ly.cell(inst.cell_index).name not in keep_child_names: c.erase(inst)
    for ld, reg in shapes.items():
        c.shapes(layer_of(ly, ld)).insert(reg.transformed(trans))
    for ld, s, x, y, t in txts:
        tt = pya.Text(s, trans * pya.Trans(pya.Point(x, y)))
        c.shapes(layer_of(ly, ld)).insert(tt)
    log("   rewrote %s: %d layers, %d texts, kept children %s" % (cellname, len(shapes), len(txts), sorted(set(ly.cell(i.cell_index).name for i in c.each_inst()))))
I = pya.Trans()
GS_keep = {"GS_openDVS_pixel", "GS_contact$1", "GS_contact$25$1$1", "GS_contact$26$1$1", "GS_contact$30$1$1"}
S7_keep = {"S7_openDVS_pixel", "S7_contact$1", "S7_contact$25$1$1", "S7_contact$26$1$1", "S7_contact$30$1$1"}
log("== writing the merged wrapper")
rewrite_cell(F, "GS_openDVS_pixel", pixel_new, pix_texts, I, set())
rewrite_cell(F, "GS_openDVS_pixel2x2_top", top_new, top_texts, I, GS_keep)
rewrite_cell(F, "GS_openDVS_pixel2x2_bot", bot_new, bot_texts, I, GS_keep)
rewrite_cell(F, "S7_openDVS_pixel", pixel_new, pix_texts, R270, set())
rewrite_cell(F, "S7_openDVS_pixel2x2_bot", bot_new, bot_texts, R270, S7_keep)
# prune cells that lost their last parent (density tile, via cells of the pixel/2x2)
pruned = []
for cn in ("m1_m2_density_tile", "vias_gen$3", "vias_gen$4"):
    c = F.cell(cn)
    if c is not None and c.parent_cells() == 0 and not c.is_top():
        pruned.append(cn); F.delete_cell_rec(c.cell_index()) if False else F.prune_cell(c.cell_index(), -1)
log("   pruned orphan cells:", pruned)
F.write(outdir + "/user_project_wrapper.gds")
log("   wrote", outdir + "/user_project_wrapper.gds", "cells", F.cells())

# ---------------- the merged tile with production cell names (for our own flows) ----------------
rewrite_cell(R, "openDVS_pixel", pixel_new, pix_texts, I, set())
rewrite_cell(R, "openDVS_pixel2x2_top", top_new, top_texts, I, {"openDVS_pixel", "contact$1", "contact$25$1$1", "contact$26$1$1", "contact$30$1$1"})
rewrite_cell(R, "openDVS_pixel2x2_bot", bot_new, bot_texts, I, {"openDVS_pixel", "contact$1", "contact$25$1$1", "contact$26$1$1", "contact$30$1$1"})
R.write(outdir + "/pixel_4tile.r18.gds")
log("   wrote", outdir + "/pixel_4tile.r18.gds")

# ---------------- verification ----------------
log("== verification")
LG = lmap(G); LFn = lmap(F)
# (1) merged pixel vs r17b pixel = foundry delta kept; merged vs final pixel = r17b delta (+ exclusions)
for ld in ALL:
    a = rec(F, "GS_openDVS_pixel", LFn, ld); r = rec(R, "openDVS_pixel", LR, ld) if False else None
for ld in sorted(set(LFn)):
    a = rec(F, "GS_openDVS_pixel", LFn, ld); g = rec(G, "GS_openDVS_pixel", LG, ld)
    d = a ^ g
    if not d.is_empty(): log("   pixel merged^final %-6s %.3f um2 (%d polys)" % (nm(ld), d.area()/1e6, d.count()))
# (2) tile with production names == wrapper's pixel_4tile (flat, all layers)
tot = 0; LRn = lmap(R)
for cw, cr in (("GS_openDVS_pixel2x2_top", "openDVS_pixel2x2_top"), ("GS_openDVS_pixel2x2_bot", "openDVS_pixel2x2_bot")):
    for ld in sorted(set(LFn) | set(LRn)):
        a = rec(F, cw, LFn, ld) if ld in LFn else pya.Region(); b = rec(R, cr, LRn, ld) if ld in LRn else pya.Region()
        d = (a ^ b).area(); tot += d
        if d: log("   !! %s (wrapper) vs %s (r18 tile) differ on %s: %.3f um2" % (cw, cr, nm(ld), d/1e6))
log("   2x2 cells: wrapper GS_ vs pixel_4tile.r18 flat xor total: %.4f um2 (tile-level periphery fixes of the final are NOT in the r18 tile by design)" % (tot/1e6))
# (3) every other cell of the wrapper untouched: compare own shape counts + bbox with the pristine copy
changed = {"GS_openDVS_pixel", "GS_openDVS_pixel2x2_top", "GS_openDVS_pixel2x2_bot", "S7_openDVS_pixel", "S7_openDVS_pixel2x2_bot"}
bad = []
for c in G.each_cell():
    if c.name in changed: continue
    c2 = F.cell(c.name)
    if c2 is None: bad.append(c.name + ":missing"); continue
    n1 = sum(c.shapes(li).size() for li in G.layer_indexes()); n2 = sum(c2.shapes(li).size() for li in F.layer_indexes())
    if n1 != n2 or c.child_instances() != c2.child_instances(): bad.append("%s:%d/%d" % (c.name, n1, n2))
log("   untouched cells with changed shape/instance counts:", bad if bad else "none")
# (4) the S7 pixel equals r270(GS pixel)
d = sum((rec(F, "S7_openDVS_pixel", LFn, ld) ^ rec(F, "GS_openDVS_pixel", LFn, ld).transformed(R270)).area() for ld in LFn)
log("   S7_openDVS_pixel == r270(GS_openDVS_pixel): xor %.4f um2" % (d/1e6))
open(outdir + "/merge_report.txt", "w").write("\n".join(rep) + "\n")
