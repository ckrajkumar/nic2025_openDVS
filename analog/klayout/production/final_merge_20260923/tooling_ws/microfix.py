"""r18 -> r18b: three micro-fixes for the precheck's manufacturing-rule deck (sky130A_mr.drc), applied to the flat pixel cells.
klayout -b -r microfix.py -rd gds=<file> -rd cells="GS_openDVS_pixel:r0,S7_openDVS_pixel:r270"
  A  MR_licon.SP.6  psdm >= 0.11 from poly licon: the r17b psdm piece top edge 5.225 -> 5.210 (diff enclosure stays 0.130 >= 0.125)
  B  MR_capm.SP.2   met3 >= 1.2 from the MIM footprint+0.14: vd via pad west edge 9.465 -> 9.555 (corner distance 1.181 -> 1.203 um);
                    via2 9.600-9.800 -> 9.620-9.820 with its met2 landing extended east 9.885 -> 9.905; via3 9.665-9.865 -> 9.690-9.890
  C  m2.5           two adjacent met2 enclosures < 0.085 on the second GndD via1: via 1.445-1.595 x 0.820-0.970 -> y 0.850-1.000
"""
import pya
B = pya.Box
OPS = {  # (layer, datatype): (remove boxes, add boxes)  in pixel coordinates (nm)
    (94, 20): ([B(9725, 5210, 12435, 5225)], []),
    (70, 20): ([B(9465, 3495, 9555, 3895)], []),
    (69, 44): ([B(9600, 3560, 9800, 3760)], [B(9620, 3560, 9820, 3760)]),
    (69, 20): ([], [B(9885, 3660, 9905, 3800)]),
    (70, 44): ([B(9665, 3560, 9865, 3760)], [B(9690, 3560, 9890, 3760)]),
    (68, 44): ([B(1445, 820, 1595, 970)], [B(1445, 850, 1595, 1000)]),
}
ly = pya.Layout(); ly.read(gds)
for spec in cells.split(","):
    cn, rot = spec.split(":"); c = ly.cell(cn); t = {"r0": pya.Trans(), "r270": pya.Trans(3, False), "r90": pya.Trans(1, False)}[rot]
    assert c.child_instances() == 0, cn + " is not flat"
    for (l, d), (rem, add) in OPS.items():
        li = ly.find_layer(l, d); assert li is not None, (cn, l, d)
        txt = [s.text for s in c.shapes(li).each() if s.is_text()]
        reg = pya.Region(c.shapes(li)); reg.merge()
        before = reg.area()
        for b in rem:
            bb = pya.Region(b).transformed(t)
            assert not (reg & bb).is_empty(), ("remove box misses geometry", cn, l, d, b)
            reg -= bb
        for b in add: reg += pya.Region(b).transformed(t)
        reg.merge()
        c.shapes(li).clear(); c.shapes(li).insert(reg)
        for x in txt: c.shapes(li).insert(x)
        print("  %s %d/%d: area %.4f -> %.4f um2 (%d texts kept)" % (cn, l, d, before/1e6, reg.area()/1e6, len(txt)))
ly.write(gds); print("wrote", gds)
