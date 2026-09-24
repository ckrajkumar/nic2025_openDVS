"""Optical aperture / fill-factor and MIM-ratio survey of openDVS_pixel (work file).  klayout -b -r fillfactor.py"""
import pya
ly = pya.Layout(); ly.read(globals().get("gds", "pixel_4tile_work.gds")); c = ly.cell("openDVS_pixel")
def R(l, d):
    li = ly.find_layer(l, d)
    return pya.Region() if li is None else pya.Region(c.begin_shapes_rec(li)).merged()
um2 = lambda r: r.area() / 1e6
pix = pya.Region(pya.Box(0, 0, 12160, 12160)); print("pixel area %.1f um2" % um2(pix))
diff = R(65, 20); poly = R(66, 20); nwell = R(64, 20)
# photodiode = biggest diff polygon
pd = max(diff.each(), key=lambda p: p.area()); pd = pya.Region(pd); print("photodiode diff bbox %s area %.1f um2 (%.1f %% of pixel)" % (pd.bbox().to_s(), um2(pd), 100 * um2(pd) / um2(pix)))
layers = {"li": (67, 20), "met1": (68, 20), "met2": (69, 20), "met3": (70, 20), "capm": (89, 44), "met4": (71, 20), "met5": (72, 20), "poly": (66, 20)}
cov = {}
for n, (l, d) in layers.items():
    r = R(l, d); cov[n] = r; ov = r & pd
    print("  %-5s covers %6.1f um2 of the diode (%4.1f %%); layer area in pixel %.1f" % (n, um2(ov), 100 * um2(ov) / um2(pd), um2(r & pix)))
allmetal = pya.Region()
for n in ("li", "met1", "met2", "met3", "capm", "met4", "met5"): allmetal += cov[n]
allmetal = allmetal.merged(); openpd = pd - allmetal
print("diode free of ANY metal: %.1f um2 = %.1f %% of diode, %.1f %% of pixel" % (um2(openpd), 100 * um2(openpd) / um2(pd), 100 * um2(openpd) / um2(pix)))
nom5 = pd - (allmetal - cov["met5"]); print("diode free of metal except met5: %.1f um2 (%.1f %% of pixel)" % (um2(nom5), 100 * um2(nom5) / um2(pix)))
# met5 holes
m5 = cov["met5"]
for p in m5.each():
    print("met5 polygon holes: %d" % p.holes(), [pya.Polygon(h).bbox().to_s() for h in [list(p.each_point_hole(i)) for i in range(p.holes())]] if p.holes() else "")
for i, p in enumerate(m5.each()):
    for h in range(p.holes()):
        pts = list(p.each_point_hole(h)); print("  hole %d: %s" % (h, pya.Polygon(pts).bbox().to_s()))
# met5 labels / texts in pixel (72/5) and in the 2x2
for cellname in ("openDVS_pixel", "openDVS_pixel2x2_top"):
    cc = ly.cell(cellname); li = ly.find_layer(72, 5)
    if li is not None:
        for s in cc.shapes(li).each():
            if s.is_text(): print("  %s met5 label: %s at %s" % (cellname, s.text_string, s.text_trans.to_s()))
# capm plates and their overlap with the diode and with the met4-ring opening
capm = cov["capm"]
for p in capm.each():
    b = p.bbox(); rr = pya.Region(p)
    print("capm %s area %.2f um2; over diode %.2f um2" % (b.to_s(), um2(rr), um2(rr & pd)))
# free space for extending C1a / C1b: obstacles on met3, met4, capm within 1.5 um around each plate
for name, box in (("C1a", pya.Box(2610, 870, 6595, 3140)), ("C1b", pya.Box(2610, 9120, 9080, 10625)), ("C2", pya.Box(8080, 870, 9080, 1870))):
    grow = pya.Region(box.enlarged(1500, 1500)) - pya.Region(box)
    for n in ("met3", "capm", "met4", "via3"):
        r = R(70, 44) if n == "via3" else cov[n]
        near = (r & grow)
        for q in near.each(): print("  near %s on %-5s: %s" % (name, n, q.bbox().to_s()))
