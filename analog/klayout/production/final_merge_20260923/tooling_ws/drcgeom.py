import pya
ly = pya.Layout(); ly.read(gds); c = ly.cell("openDVS_pixel")
L = {(ly.get_info(li).layer, ly.get_info(li).datatype): li for li in ly.layer_indexes()}
def reg(ld, box):
    if ld not in L: return pya.Region()
    r = pya.Region(c.begin_shapes_rec(L[ld])); r.merge(); return r & pya.Region(box)
def show(title, box, layers):
    print("==", title, box.to_s())
    for ld, nm in layers:
        r = reg(ld, box)
        for p in r.each(): print("   %-6s %s" % (nm, p.to_s()[:200]))
show("A: psdm vs poly licons", pya.Box(10300, 4300, 12500, 5700), [((94,20),"psdm"),((66,44),"licon"),((66,20),"poly"),((65,20),"diff"),((95,20),"npc"),((67,20),"li")])
show("B: met3 bottom plates near the vd pad", pya.Box(8900, 2000, 10200, 3800), [((70,20),"met3"),((89,44),"capm"),((70,44),"via3"),((71,20),"met4"),((69,44),"via2")])
show("C: GndD via1 + met2", pya.Box(1200, 500, 1900, 1600), [((69,20),"met2"),((68,44),"via1"),((68,20),"met1"),((69,44),"via2")])
