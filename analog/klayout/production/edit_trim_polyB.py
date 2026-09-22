"""Raise the bottom edge of the nRst MOS-cap gate poly (region B) from y=2.685 to 2.755 um (endcap over
its diffusion stays 0.13 um = sky130 poly.8 minimum), widening the gap to the vd input-gate poly from
0.21 to 0.28 um.  Backup: pixel_4tile_work.before-trim.gds"""
import pya, shutil
shutil.copy("pixel_4tile_work.gds", "pixel_4tile_work.before-trim.gds")
ly = pya.Layout(); ly.read("pixel_4tile_work.gds"); px = ly.cell("openDVS_pixel"); poly = ly.find_layer(66, 20)
cut = pya.Region(pya.Box(10500, 2600, 12020, 2755)); r = pya.Region(px.shapes(poly))
before = r.count(); r = (r - cut).merged(); px.shapes(poly).clear(); px.shapes(poly).insert(r)
ly.write("pixel_4tile_work.gds"); print("poly shapes %d -> %d; nRst gate bottom now at y=2.755" % (before, r.count()))
