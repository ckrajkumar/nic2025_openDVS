"""Reduce nRst<->vd coupling in openDVS_pixel (pixel_4tile_work.gds), li layer only:
 1. GndA li shield strip under the vd met1 vertical, in the li-level gap between vd met1 (x<=10.30)
    and the nRst li run (x>=10.545): strip (10.205,8.890;10.375,11.300), tied to the GndA li block
    with (9.550,8.890;10.375,9.060).
 2. Move the lower nRst li vertical leg from x 9.94-10.11 to x 10.11-10.28 (y 7.565-8.72), away from
    the vd met1 leg at x 9.655-9.795.
Writes a backup first.  klayout -b -r edit_shield.py"""
import pya, shutil
GDS = "pixel_4tile_work.gds"; shutil.copy(GDS, "pixel_4tile_work.before-shield.gds")
ly = pya.Layout(); ly.read(GDS); px = ly.cell("openDVS_pixel"); li = ly.find_layer(67, 20)
def B(x1, y1, x2, y2): return pya.Box(int(x1*1000), int(y1*1000), int(x2*1000), int(y2*1000))
region = pya.Region(px.shapes(li))
n0 = region.count()
# 2. nRst leg move: cut the old vertical (keep the bottom joint), add the new vertical + joint extension
region -= pya.Region(B(9.940, 7.735, 10.110, 8.720))
region += pya.Region(B(9.940, 7.565, 10.280, 7.735))      # bottom joint extended to the new leg
region += pya.Region(B(10.110, 7.565, 10.280, 8.720))     # new vertical leg
# 1. shield + tie
region += pya.Region(B(10.205, 8.890, 10.375, 11.300))
region += pya.Region(B(9.550, 8.890, 10.375, 9.060))
region = region.merged()
px.shapes(li).clear(); px.shapes(li).insert(region)
ly.write(GDS)
print("li shapes %d -> %d (merged); wrote %s, backup pixel_4tile_work.before-shield.gds" % (n0, region.count(), GDS))
