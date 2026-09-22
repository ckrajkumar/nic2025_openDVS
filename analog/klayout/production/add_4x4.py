"""(Re)build the openDVS_pixel_4x4 cell in the production working layout as a faithful 4x4 window
of pixel_layout_tile: the 2 x 2 block of openDVS_pixel2x2_top *instances* (so pixel / 2x2 edits
propagate) plus copies of the tile-level shapes clipped to the block (row straps, implants, vias)
and the tile-level via instances inside it. Tile-level edits do NOT propagate (they are copies).

  klayout -b -r add_4x4.py [-rd gds=pixel_4tile_work.gds] [-rd col=15 -rd row=10]

col/row select which 2x2 block of the 32 x 32 array is windowed (0-based, interior by default).
Regenerates the cell every run (it is derived, never hand-edited).
"""
import pya

gds = globals().get("gds", "pixel_4tile_work.gds")
name = globals().get("name", "openDVS_pixel_4x4")
tile_name = globals().get("tile", "pixel_layout_tile")
col = int(globals().get("col", 15))
row = int(globals().get("row", 10))
PITCH = 24000                       # dbu; 2x2 pitch in pixel_layout_tile
N = 32                              # 2x2 cells per tile side

ly = pya.Layout()
ly.read(gds)
tile = ly.cell(tile_name)
if tile is None:
    raise SystemExit("no cell %s in %s" % (tile_name, gds))

# array origin: lowest-left 2x2 instance origin
origins = [i.trans.disp for i in tile.each_inst() if i.cell.name.startswith("openDVS_pixel2x2")]
ox, oy = min(p.x for p in origins), min(p.y for p in origins)
bb2x2 = ly.cell("openDVS_pixel2x2_top").bbox()
x0 = ox + bb2x2.left + col * PITCH
y0 = oy + bb2x2.bottom + row * PITCH
box = pya.Box(x0, y0, x0 + 2 * PITCH, y0 + 2 * PITCH)
shift = pya.Trans(pya.Vector(-x0, -y0))

if ly.has_cell(name):
    ly.delete_cell(ly.cell(name).cell_index())
new = ly.create_cell(name)

n_inst = {}
for inst in tile.each_inst():
    if box.contains(inst.trans.disp):
        ci = inst.cell_inst
        ci.transform(shift)
        new.insert(ci)
        n_inst[inst.cell.name] = n_inst.get(inst.cell.name, 0) + 1
n_shapes = 0
rbox = pya.Region(box)
for li in ly.layer_indexes():
    dst = new.shapes(li)
    for s in tile.shapes(li).each():
        if s.is_text():
            if box.contains(s.text_pos):
                dst.insert(s.text.transformed(shift)); n_shapes += 1
        else:
            for p in (pya.Region(s.polygon) & rbox).each():
                dst.insert(p.transformed(shift)); n_shapes += 1
ly.write(gds)
print("%s = window col %d row %d of %s, box %s" % (name, col, row, tile_name, box))
print("  instances:", n_inst)
print("  clipped tile shapes:", n_shapes, " bbox:", new.bbox())
print("  top cells:", [c.name for c in ly.top_cells()])
