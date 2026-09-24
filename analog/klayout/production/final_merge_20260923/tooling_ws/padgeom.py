import pya
ly = pya.Layout(); ly.read(gds); c = ly.cell("openDVS_pixel")
L = {(ly.get_info(li).layer, ly.get_info(li).datatype): li for li in ly.layer_indexes()}
win = pya.Box(9300, 3300, 10300, 4300)
for ld, nm in [((69,20),"met2"),((69,44),"via2"),((70,20),"met3"),((70,44),"via3"),((71,20),"met4"),((71,44),"via4")]:
    r = pya.Region(c.begin_shapes_rec(L[ld])); r.merge()
    for p in r.each():
        if not (pya.Region(p) & pya.Region(win)).is_empty(): print("%-5s %s" % (nm, p.to_s()[:400]))
