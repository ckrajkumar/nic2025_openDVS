# klayout -b -r rx_locate.py -rd gds=<wrapper.gds>
# Find the 'rx' label(s) inside BiasBranchnMasterx11, transform to wrapper coordinates, and list the top-level (wrapper) metal and via
# shapes within 3 um of each, per layer, so the missing via2 of analog_io[17] -> rx can be located.
import pya
ly = pya.Layout(); ly.read(gds); top = ly.top_cell()
cb = ly.cell("BiasBranchnMasterx11")
inst = [i for i in top.each_inst() if i.cell.name == "BiasBranchnMasterx11"]
print("instances:", [str(i.cplx_trans) for i in inst])
LAY = {(68,20):"met1",(68,44):"via1",(69,20):"met2",(69,44):"via2",(70,20):"met3",(70,44):"via3",(71,20):"met4",(69,16):"met2pin",(70,16):"met3pin",(71,16):"met4pin"}
for li_info in ly.layer_infos():
    pass
hits = []
for li in ly.layer_indexes():
    info = ly.get_info(li)
    for s in cb.shapes(li).each(pya.Shapes.STexts):
        if s.text.string in ("rx", "IR", "rx[0]"):
            hits.append((s.text.string, info, s.text.trans.disp))
print("rx labels in BiasBranchnMasterx11:", [(h[0], "%d/%d" % (h[1].layer, h[1].datatype), str(h[2])) for h in hits])
# pin shapes of the macro carrying the rx label position
for name, info, p in hits:
    for i in inst:
        tp = i.cplx_trans * pya.DPoint(p.x * ly.dbu, p.y * ly.dbu) if False else i.cplx_trans.to_itrans(ly.dbu) if False else None
        dq = i.dcplx_trans * pya.DPoint(p.x * ly.dbu, p.y * ly.dbu)
        print("== label %s on %d/%d at wrapper (%.3f, %.3f)" % (name, info.layer, info.datatype, dq.x, dq.y))
        q = pya.Point(int(round(dq.x / ly.dbu)), int(round(dq.y / ly.dbu)))
        box = pya.Box(q.x - 3000, q.y - 3000, q.x + 3000, q.y + 3000)
        for (a, b), nm in LAY.items():
            li = ly.find_layer(a, b)
            if li is None: continue
            # top-level shapes only (the wrapper routing) and macro shapes (flattened) separately
            tops = [s.bbox() for s in top.shapes(li).each_overlapping(box)]
            it = pya.RecursiveShapeIterator(ly, top, li, box); it.overlapping = True
            allsh = []
            while not it.at_end():
                allsh.append((it.shape().bbox().transformed(it.trans()), it.cell().name)); it.next()
            if tops or allsh:
                print("   %-8s top-level: %s" % (nm, [str(b2) for b2 in tops][:6]))
                print("   %-8s all cells: %s" % (nm, [(str(b2), c) for b2, c in allsh][:8]))
