import pya, sys
sys.path.insert(0, "/home/rpgraca/opendvs_final"); import opendvs_l2n
for tag, path in (("r15a", "/home/rpgraca/tile_r15a/pixel_4tile.r15a.gds"), ("r18b", "/home/rpgraca/opendvs_final/merged/pixel_4tile.r18.gds")):
    ly = pya.Layout(); ly.read(path); c = ly.cell("openDVS_pixel")
    L = {(ly.get_info(li).layer, ly.get_info(li).datatype): li for li in ly.layer_indexes()}
    l2n = opendvs_l2n.build_l2n(ly, c, threads=8)
    print("==", tag)
    for ld, nm in [((69,20),"met2"),((68,20),"met1"),((68,44),"via1"),((69,44),"via2"),((67,20),"li")]:
        r = pya.Region(c.begin_shapes_rec(L[ld])); r.merge()
        lay = l2n.layer_by_name({"met2":"met2","met1":"met1","via1":"via1","via2":"via2","li":"li"}[nm])
        for p in r.each():
            bb = p.bbox()
            if bb.right < -300 or bb.left > 2000 or bb.top < -600 or bb.bottom > 1700: continue
            pt = pya.DPoint((bb.left + bb.right) / 2000.0, (bb.bottom + bb.top) / 2000.0)
            net = l2n.probe_net(lay, pt); nn = net.expanded_name() if net else "-"
            if nn in ("GndD", "rowReadON", "rowReadOFF", "-") or "GndD" in nn: print("   %-5s %-11s %s" % (nm, nn, bb.to_s()))
    # full extent of the GndD met2 line
    lay = l2n.layer_by_name("met2")
    r = pya.Region(c.begin_shapes_rec(L[(69,20)])); r.merge()
    for p in r.each():
        bb = p.bbox()
        net = l2n.probe_net(lay, pya.DPoint((bb.left + bb.right) / 2000.0, (bb.bottom + bb.top) / 2000.0))
        if net and net.expanded_name() == "GndD" and bb.width() > 3000: print("   GndD met2 long piece:", bb.to_s(), "width(y) %d" % bb.height())
