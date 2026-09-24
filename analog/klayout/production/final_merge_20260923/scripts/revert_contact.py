# klayout -b -r revert_contact.py -rd src=in.gds -rd dst=out.gds
# Put back the original met1 of contact$26$1$1 (production: -160..155 x -320..320; the 2026-09-21 22:26 edit narrowed it to -130..130).
import pya
ly = pya.Layout(); ly.read(src)
c = ly.cell("contact$26$1$1"); assert c is not None
m1 = ly.layer(68, 20)
shapes = [s for s in c.shapes(m1).each()]
assert len(shapes) == 1 and shapes[0].box == pya.Box(-130, -320, 130, 320), [s.to_s() for s in shapes]
shapes[0].box = pya.Box(-160, -320, 155, 320)
print("contact$26$1$1 met1 ->", [s.box.to_s() for s in c.shapes(m1).each()], "parents", sum(1 for _ in c.each_parent_inst()))
ly.write(dst)
