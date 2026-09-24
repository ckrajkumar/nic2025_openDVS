# klayout -b -r ts_insts.py -rd gds=<wrapper> : instances inside pixel_test_structure (cell, transformation, bbox) + the S7 pixel bbox
import pya
ly = pya.Layout(); ly.read(gds); c = ly.cell("pixel_test_structure")
print("pixel_test_structure bbox", c.bbox().to_s())
for i in c.each_inst():
    print("  inst", i.cell.name, str(i.cplx_trans), "bbox", i.bbox().to_s())
    if "pixel2x2" in i.cell.name:
        for j in i.cell.each_inst(): print("      sub", j.cell.name, str(j.cplx_trans), "bbox", j.bbox().to_s())
