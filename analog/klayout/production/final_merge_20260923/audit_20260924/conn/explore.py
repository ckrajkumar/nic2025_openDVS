import pya, collections
ly = pya.Layout(); ly.read(gds); top = ly.top_cell()
print("top", top.name, "dbu", ly.dbu)
cnt = collections.Counter()
for inst in top.each_inst():
    cnt[inst.cell.name] += 1
print("top children (non-stdcell):", [(k,v) for k,v in cnt.items() if not k.startswith("sky130_fd_sc")][:50])
print("n stdcell types", sum(1 for k in cnt if k.startswith("sky130_fd_sc")), "n stdcell insts", sum(v for k,v in cnt.items() if k.startswith("sky130_fd_sc")))
for inst in top.each_inst():
    if inst.cell.name in ("BiasBranchnMasterx11","pixel_4tile","pixel_test_structure","photodiode_test_structure"):
        print(inst.cell.name, inst.dcplx_trans, inst.dbbox())
for mn in ("BiasBranchnMasterx11","pixel_4tile","pixel_test_structure","photodiode_test_structure"):
    c = ly.cell(mn)
    tl = collections.Counter(); names=collections.defaultdict(set)
    for li in ly.layer_indexes():
        info = ly.get_info(li)
        for s in c.shapes(li).each():
            if s.is_text(): tl[(info.layer,info.datatype)] += 1; names[(info.layer,info.datatype)].add(s.text_string)
    print(mn, "texts by layer", dict(tl))
    for k,v in names.items(): print("   ", k, sorted(v)[:400])
# top-level texts
tl = collections.Counter()
for li in ly.layer_indexes():
    info = ly.get_info(li)
    for s in top.shapes(li).each():
        if s.is_text(): tl[(info.layer,info.datatype)] += 1
print("top texts", dict(tl))
