"""r19: GndD as a continuous met2 line per row through the array; row/GndD feeds adapted at the array edge inside pixel_4tile.
klayout -b -r r19_build.py -rd fin=<r18b wrapper> -rd r15a=<r15a tile export> -rd r18tile=<r18b tile, prod names> -rd outdir=<dir>
Pixel (GS_openDVS_pixel and, in the prod-name tile, openDVS_pixel): the west-edge band goes back to r15a on met2 (straight rowReadON/OFF
lines, GndD line from x 0); the iface17 GndD met1 corner+bar and its via1 are removed; the GndA li vertical (r17) and the foundry fixes,
fill and micro-fixes stay.  2x2 overlay pins/labels in the west strip: r15a's (band heights).  The test structure keeps r18b.
Periphery (pixel_4tile coords, pair axis A_k = 63220 + 24000 k; connector_v3 origin (2690, 61850 + 24000 k) so A = cell y 1370):
  connector_v3: the four 0.26 met2 stubs at A±(0.71..0.97)/(1.11..1.37) become jogged 0.14 routes into the band A±(0.07..0.21)/(0.35..0.49).
  left_vdd_gnd_connectors: met2 GndD bar cut at x 0.60; GndD continues on met1 to x 2.95, a met1 vertical A±1.21 at x 2.69-2.95 and
  two via1 per row land on the pixel's GndD met2 line (A±0.63..1.33).
  pixel_layout_tile/_bot: the 128 0.26 met2 pin squares (and the pair-0 GndD square) become 0.14 rectangles at the band heights."""
import pya
B = pya.Box
rep = []
def log(*a):
    s = " ".join(str(x) for x in a); print(s); rep.append(s)
def load(p):
    ly = pya.Layout(); ly.read(p); return ly
def lmap(ly): return {(ly.get_info(li).layer, ly.get_info(li).datatype): li for li in ly.layer_indexes()}
def layer_of(ly, ld):
    li = ly.find_layer(ld[0], ld[1]); return li if li is not None else ly.layer(ld[0], ld[1])
def own_region(ly, c, ld):
    L = lmap(ly); r = pya.Region()
    if ld in L: r.insert(c.shapes(L[ld]))
    r.merge(); return r
def set_own_region(ly, c, ld, reg):
    li = layer_of(ly, ld); txt = [s.text for s in c.shapes(li).each() if s.is_text()]
    c.shapes(li).clear(); c.shapes(li).insert(reg)
    for t in txt: c.shapes(li).insert(t)

# ---------- pixel + 2x2 edits (applied to a layout with given cell names) ----------
BAND = B(-300, -450, 1500, 1600)
CORNER = [B(-160, -350, 620, 1200), B(160, 900, 1360, 1200)]      # iface17 GndD met1 corner + bar (r18b-only met1 in the band)
PADVIA = B(85, 55, 235, 205)
def fix_pixel(ly, pixname, R, tag):
    c = ly.cell(pixname); assert c.child_instances() == 0
    rp = R.cell("openDVS_pixel")
    m2 = own_region(ly, c, (69, 20)); r15 = pya.Region(rp.begin_shapes_rec(lmap(R)[(69, 20)])).merged()
    new_m2 = (m2 - pya.Region(BAND)) + (r15 & pya.Region(BAND)); new_m2.merge()
    set_own_region(ly, c, (69, 20), new_m2)
    m1 = own_region(ly, c, (68, 20))
    for b in CORNER: assert not (m1 & pya.Region(b)).is_empty(), ("corner box misses", tag, b)
    new_m1 = m1;
    for b in CORNER: new_m1 = new_m1 - pya.Region(b)
    set_own_region(ly, c, (68, 20), new_m1.merged())
    v1 = own_region(ly, c, (68, 44)); assert not (v1 & pya.Region(PADVIA)).is_empty(); set_own_region(ly, c, (68, 44), (v1 - pya.Region(PADVIA)).merged())
    # verification: band met2 == r15a; band met1 == r15a minus the GndA met1 pieces r17 replaced by li
    d = ((own_region(ly, c, (69, 20)) & pya.Region(BAND)) ^ (r15 & pya.Region(BAND))).area()
    r15m1 = pya.Region(rp.begin_shapes_rec(lmap(R)[(68, 20)])).merged() & pya.Region(BAND)
    dm1 = (own_region(ly, c, (68, 20)) & pya.Region(BAND)) ^ r15m1
    log("   %s %s: band met2 vs r15a xor %.4f um2; band met1 vs r15a: %s" % (tag, pixname, d / 1e6, [p.bbox().to_s() for p in dm1.each()]))
WSTRIP = B(-18300, -1600, -16500, 1300); ESTRIP = B(4000, -1600, 9000, 1300)
STRIPS = pya.Region([WSTRIP, ESTRIP])
def fix_2x2(ly, cellname, R, rname, tag):
    c = ly.cell(cellname); rc = R.cell(rname); LR = lmap(R)
    for ld in ((69, 16),):
        reg = own_region(ly, c, ld) - STRIPS
        reg += pya.Region(rc.shapes(LR[ld])) & STRIPS
        set_own_region(ly, c, ld, reg.merged())
    li = layer_of(ly, (69, 5)); P = lambda s: pya.Point(s.text_trans.disp.x, s.text_trans.disp.y)
    keep = [s.text for s in c.shapes(li).each() if s.is_text() and not (WSTRIP.contains(P(s)) or ESTRIP.contains(P(s)))]
    add = [s.text for s in rc.shapes(LR[(69, 5)]).each() if s.is_text() and (WSTRIP.contains(P(s)) or ESTRIP.contains(P(s)))]
    c.shapes(li).clear()
    for t in keep + add: c.shapes(li).insert(t)
    log("   %s %s: strip met2 pins %d; labels kept %d added %d: %s" % (tag, cellname, (own_region(ly, c, (69, 16)) & STRIPS).count(), len(keep), len(add), sorted(t.string for t in add)))

# ---------- periphery edits (wrapper only) ----------
def fix_connector_v3(ly):
    c = ly.cell("GS_pixel_layout_biasgen_connector_v3"); li = layer_of(ly, (69, 20))
    old = [s for s in c.shapes(li).each() if s.bbox().right == 0 and s.bbox().height() == 260]
    assert len(old) == 4, [s.bbox().to_s() for s in old]
    for s in old: c.shapes(li).erase(s)
    new = [  # stub from the via cell, vertical, horizontal into the band (extended to x 260 = tile 2.95 to overlap the pins)
        B(-1925, 0, -340, 260), B(-480, 0, -340, 1020), B(-480, 880, 260, 1020),            # rowReadOFF row-  (A-1.37..-1.11 -> A-0.49..-0.35); vertical at tile 2.21-2.35, 0.18 from the GndD line ends (x 2.53)
        B(-1925, 400, -740, 660), B(-880, 400, -740, 1300), B(-880, 1160, 260, 1300),      # rowReadON  row-  (A-0.97..-0.71 -> A-0.21..-0.07); vertical at tile 1.81-1.95
        B(-1925, 2080, -740, 2340), B(-880, 1440, -740, 2340), B(-880, 1440, 260, 1580),   # rowReadON  row+  (A+0.71..0.97 -> A+0.07..0.21)
        B(-1925, 2480, -340, 2740), B(-480, 1720, -340, 2740), B(-480, 1720, 260, 1860)]   # rowReadOFF row+  (A+1.11..1.37 -> A+0.35..0.49)
    reg = own_region(ly, c, (69, 20)); reg += pya.Region(new); reg.merge()
    set_own_region(ly, c, (69, 20), reg)
    sp = reg.space_check(140, False, pya.Region.Euclidian)
    log("   connector_v3: met2 polygons %d, met2 space<0.14 violations %d" % (reg.count(), sp.count()))
def fix_gnd_connector(ly):
    c = ly.cell("GS_pixel_4tile_left_vdd_gnd_connectors")
    for ld in ((69, 20), (69, 16)):
        reg = own_region(ly, c, ld); bar = pya.Region(B(-2255, 62910, 2950, 63530))
        hit = reg & bar
        if hit.is_empty(): continue
        reg = (reg - pya.Region(B(600, 62910, 2950, 63530))).merged(); set_own_region(ly, c, ld, reg)
        log("   gnd connector %d/%d: GndD met2 bar cut at x 0.60 (was to 2.95)" % ld)
    m1 = own_region(ly, c, (68, 20)); assert not (m1 & pya.Region(B(-1400, 62910, -1345, 63530))).is_empty()
    m1 += pya.Region([B(100, 62910, 3010, 63530), B(2690, 62010, 3010, 64430)]); set_own_region(ly, c, (68, 20), m1.merged())   # met1 only east of x 0.10: a VddA18 met1 tie rail runs at x -0.665..-0.045 (production crosses it on met2)   # 0.32 post: via.5a needs 0.085 met1 enclosure on two opposite sides
    v1 = own_region(ly, c, (68, 44)); v1 += pya.Region([B(2775, 63905, 2925, 64055), B(2775, 64225, 2925, 64375), B(2775, 62385, 2925, 62535), B(2775, 62065, 2925, 62215), B(200, 62965, 350, 63115), B(200, 63325, 350, 63475)])   # + met2->met1 drop on the GndD bar: two vias stacked in y at x 0.20-0.35   # centred in the 2.69-3.01 post: 0.085 met1 enclosure both sides
    set_own_region(ly, c, (68, 44), v1.merged())
    log("   gnd connector: GndD met2 bar to x 0.60, via1 pair to met1 at x 0.15-0.47, met1 0.10 -> 3.01 + vertical A+-1.21 at x 2.69-2.95, 4 via1 per pair onto the GndD lines")
def fix_connector_v2(ly):
    """east-side GndD feed (63 instances, cell y of the pair axis = 13760): the 1.14-tall met2 block at A+-0.57 (26690..31270) becomes
    two tongues onto the GndD line ends (A+-0.63..1.33, the lines end at tile x 1538.85 = cell 26850) plus a plate from cell x 27000
    to the vias_gen$8 stack; the band lines (A+-0.07..0.49) end at cell 26690 and stay >= 0.14 away."""
    c = ly.cell("GS_pixel_layout_biasgen_connector_v2"); li = layer_of(ly, (69, 20))
    old = [s for s in c.shapes(li).each() if s.bbox() == B(26690, 13190, 31270, 14330)]
    assert len(old) == 1, [s.bbox().to_s() for s in c.shapes(li).each()]
    c.shapes(li).erase(old[0])
    reg = own_region(ly, c, (69, 20)); reg += pya.Region([B(26600, 12430, 31270, 13130), B(26600, 14390, 31270, 15090), B(27000, 12430, 31270, 15090)]); reg.merge()
    set_own_region(ly, c, (69, 20), reg)
    log("   connector_v2 (east GndD feed): block A+-0.57 -> tongues at A+-(0.63..1.33) + plate x>=27000 to the via stack; met2 polygons %d" % reg.count())
def fix_tile(ly, cellname):
    c = ly.cell(cellname); n_removed = 0
    ys0 = sorted(set(i.trans.disp.y for i in c.each_inst() if ly.cell(i.cell_index).name.startswith("GS_openDVS_pixel2x2")))
    assert len(ys0) == 32, len(ys0)
    for ld in ((69, 20), (69, 16)):
        li = layer_of(ly, ld); old = [s for s in c.shapes(li).each() if not s.is_text() and s.bbox().left == 2690 and s.bbox().right == 2950 and s.bbox().height() in (260, 1140)]
        for s in old: c.shapes(li).erase(s); n_removed += 1
        new = []
        for y0 in ys0:
            A = y0 - 180
            new += [B(2690, A - 490, 2950, A - 350), B(2690, A - 210, 2950, A - 70), B(2690, A + 70, 2950, A + 210), B(2690, A + 350, 2950, A + 490)]
        c.shapes(li).insert(pya.Region(new))
    # the tile's own port labels at the west edge (x 2.82): rowRead at A+-0.84/+-1.24 -> A+-0.14/+-0.42, 'GND' at A -> the GndD line (A+0.98)
    li = layer_of(ly, (69, 5)); moved = 0; A_all = [y - 180 for y in ys0]
    txt = [s.text for s in c.shapes(li).each() if s.is_text()]; c.shapes(li).clear()
    for t in txt:
        x, y = t.trans.disp.x, t.trans.disp.y
        if x == 2820:
            k = min(range(len(A_all)), key=lambda i: abs(A_all[i] - y)); dy = y - A_all[k]
            ndy = {840: 140, -840: -140, 1240: 420, -1240: -420}.get(dy)
            if ndy is None and t.string == "GND" and dy == 0: ndy = 980
            if ndy is not None: t = pya.Text(t.string, pya.Trans(pya.Vector(x, A_all[k] + ndy))); moved += 1
        c.shapes(li).insert(t)
    log("   %s: removed %d edge pin squares, added %d band rectangles (x2 layers); %d edge labels moved to the band heights" % (cellname, n_removed, 4 * len(ys0), moved))

F = load(fin); R = load(r15a)
log("== r19 pixel/2x2 edits in the wrapper")
fix_pixel(F, "GS_openDVS_pixel", R, "wrapper")
fix_2x2(F, "GS_openDVS_pixel2x2_top", R, "openDVS_pixel2x2_top", "wrapper"); fix_2x2(F, "GS_openDVS_pixel2x2_bot", R, "openDVS_pixel2x2_bot", "wrapper")
log("== r19 periphery edits")
fix_connector_v3(F); fix_connector_v2(F); fix_gnd_connector(F); fix_tile(F, "GS_pixel_layout_tile"); fix_tile(F, "GS_pixel_layout_tile_bot")
F.write(outdir + "/user_project_wrapper.gds"); log("   wrote", outdir + "/user_project_wrapper.gds")
for top, name in (("pixel_4tile", "pixel_4tile.merged.gds"), ("pixel_test_structure", "pixel_test_structure.merged.gds")):
    O = pya.Layout(); O.dbu = F.dbu; t = O.create_cell(top); t.copy_tree(F.cell(top)); O.write(outdir + "/" + name); log("   wrote", name)
T = load(r18tile)
log("== r19 pixel/2x2 edits in the prod-name tile")
fix_pixel(T, "openDVS_pixel", R, "tile")
fix_2x2(T, "openDVS_pixel2x2_top", R, "openDVS_pixel2x2_top", "tile"); fix_2x2(T, "openDVS_pixel2x2_bot", R, "openDVS_pixel2x2_bot", "tile")
T.write(outdir + "/pixel_4tile.r19.gds")
c = T.cell("openDVS_pixel2x2_top"); opt = pya.SaveLayoutOptions(); opt.clear_cells(); opt.add_cell(c.cell_index()); T.write(outdir + "/openDVS_pixel2x2_top.r19.gds", opt)
log("   wrote pixel_4tile.r19.gds, openDVS_pixel2x2_top.r19.gds")
# cross-check: wrapper 2x2 cells == tile 2x2 cells (flat)
LF, LT = lmap(F), lmap(T); tot = 0
for cw, ct in (("GS_openDVS_pixel2x2_top", "openDVS_pixel2x2_top"), ("GS_openDVS_pixel2x2_bot", "openDVS_pixel2x2_bot")):
    for ld in sorted(set(LF) | set(LT)):
        a = pya.Region(F.cell(cw).begin_shapes_rec(LF[ld])).merged() if ld in LF else pya.Region(); b = pya.Region(T.cell(ct).begin_shapes_rec(LT[ld])).merged() if ld in LT else pya.Region()
        tot += (a ^ b).area()
log("   wrapper 2x2 vs r19 tile 2x2 flat xor: %.4f um2" % (tot / 1e6))
open(outdir + "/r19_report.txt", "w").write("\n".join(rep) + "\n")
