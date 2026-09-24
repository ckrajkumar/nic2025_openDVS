import pya
A = pya.Layout(); A.read("/home/rpgraca/opendvs_final/r19/openDVS_pixel2x2_top.r19.gds"); B = pya.Layout(); B.read("/home/rpgraca/opendvs_final/r19/r19_2x2_ini.gds")
LA = {(A.get_info(li).layer, A.get_info(li).datatype): li for li in A.layer_indexes()}; LB = {(B.get_info(li).layer, B.get_info(li).datatype): li for li in B.layer_indexes()}
tot = 0; ta = tb = 0
for ld in sorted(set(LA) | set(LB)):
    a = pya.Region(A.top_cell().begin_shapes_rec(LA[ld])).merged() if ld in LA else pya.Region(); b = pya.Region(B.top_cell().begin_shapes_rec(LB[ld])).merged() if ld in LB else pya.Region(); tot += (a ^ b).area()
    if ld in LA: ta += sum(1 for s in A.top_cell().shapes(LA[ld]).each() if s.is_text())
    if ld in LB: tb += sum(1 for s in B.top_cell().shapes(LB[ld]).each() if s.is_text())
print("2x2 export vs the one extracted on ini: xor %.4f um2, texts %d vs %d" % (tot/1e6, ta, tb))
