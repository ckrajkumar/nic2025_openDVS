import pya
F = pya.Layout(); F.read("/home/rpgraca/opendvs_final/drive/lvs_final_submission_run/user_project_wrapper.gds")
for top, name in (("pixel_4tile", "pixel_4tile.final.gds"), ("pixel_test_structure", "pixel_test_structure.final.gds")):
    O = pya.Layout(); O.dbu = F.dbu; t = O.create_cell(top); t.copy_tree(F.cell(top)); O.write("/home/rpgraca/opendvs_final/drc/" + name); print("wrote", name)
