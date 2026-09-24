import pya
ly = pya.Layout(); ly.read(gds)
want = set(names.split(","))
for mn in ("BiasBranchnMasterx11","pixel_4tile","pixel_test_structure","photodiode_test_structure"):
    c = ly.cell(mn)
    for li in ly.layer_indexes():
        it = c.begin_shapes_rec(li)
        while not it.at_end():
            s = it.shape()
            if s.is_text() and (s.text_string in want or s.text_string.lower() in want):
                print(mn, ly.get_info(li), s.text_string, it.cell().name, (it.trans()*s.text_pos) if False else it.trans().trans(s.text.trans.disp))
            it.next()
