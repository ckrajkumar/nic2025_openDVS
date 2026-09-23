# klayout -b -r pdn_over_tile.py -rd wrapper=... : does the wrapper's own met4/met5 PDN run over the tile / the array?
import pya
ly = pya.Layout(); ly.read(wrapper); top = ly.top_cell()
tc = ly.cell("pixel_4tile"); inst = [i for i in top.each_inst() if i.cell.name == "pixel_4tile"][0]; T = inst.cplx_trans
tile_bbox = tc.bbox().transformed(T); arr = pya.Box(1206885, 675665+40050, 1206885+1541380, 675665+1598390)
print("tile bbox", tile_bbox.to_s(), "array (GndA met5 plane) bbox", arr.to_s())
for nm,(a,b) in [("met4",(71,20)),("met5",(72,20))]:
    r = pya.Region(top.shapes(ly.layer(a,b)))
    over_tile = r & pya.Region(tile_bbox); over_arr = r & pya.Region(arr)
    print("wrapper top-level %s: pieces inside the tile bbox %d (area %.0f um2), inside the array %d (area %.0f um2)" % (nm, over_tile.count(), over_tile.area()/1e6, over_arr.count(), over_arr.area()/1e6))
    if over_tile.count():
        xs = sorted(set(round(p.bbox().left/1000) for p in over_tile.each()))[:10]; print("   sample x (um):", xs, " y-extent of the first:", [ (p.bbox().bottom/1000, p.bbox().top/1000) for p in list(over_tile.each())[:3]])
# tile's own met5 plane connection to the west inner bar: via3 arrays on the bar -> where do they land (met3 strips of the periphery)?
