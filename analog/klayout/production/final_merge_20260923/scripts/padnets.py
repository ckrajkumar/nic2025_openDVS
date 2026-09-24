import pya, sys, re
sys.path.insert(0, "/home/rpgraca/opendvs_final"); import opendvs_l2n
ly = pya.Layout(); ly.read(gds); c = ly.cell("openDVS_pixel")
L = {(ly.get_info(li).layer, ly.get_info(li).datatype): li for li in ly.layer_indexes()}
win = pya.Box(9300, 3300, 10300, 5200)
for ld, nm in [((70,20),"met3"),((89,44),"capm"),((70,44),"via3"),((69,44),"via2"),((71,20),"met4"),((71,44),"via4")]:
    r = pya.Region(c.begin_shapes_rec(L[ld])); r.merge()
    for p in r.each():
        if not (pya.Region(p) & pya.Region(win)).is_empty(): print("%-5s %s" % (nm, p.to_s()[:300]))
print("all capm:", [p.bbox().to_s() for p in pya.Region(c.begin_shapes_rec(L[(89,44)])).merged().each()])
l2n = opendvs_l2n.build_l2n(ly, c, threads=8)
def probe(lname, x, y):
    lay = l2n.layer_by_name(lname); net = l2n.probe_net(lay, pya.DPoint(x, y)); return net.expanded_name() if net else "-"
for lname, x, y, what in [("met3", 9.8, 3.7, "vd pad"), ("met3", 9.8, 4.3, "met3 block above the pad"), ("met3", 9.8, 6.0, "same block higher"), ("met4", 9.8, 3.0, "met4 arm under pad"), ("met4", 9.8, 4.5, "met4 at 4.5"), ("met3", 8.5, 1.7, "C1 plate"), ("met3", 9.0, 2.6, "C1 arm")]:
    print("  %-5s (%.2f,%.2f) %-28s -> %s" % (lname, x, y, what, probe(lname, x, y)))
t = open("/home/rpgraca/opendvs_final/drc/r18_tile_beol.xml").read()
for m in re.finditer(r"<item>(.*?)</item>", t, re.S):
    it = m.group(1); print("ITEM", re.search(r"<category>([^<]*)</category>", it).group(1), re.search(r"<cell>([^<]*)</cell>", it).group(1) if re.search(r"<cell>([^<]*)</cell>", it) else "", [v[:120] for v in re.findall(r"<value>([^<]*)</value>", it)][:1])
