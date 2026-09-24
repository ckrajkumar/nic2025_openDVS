import pya, sys; sys.path.insert(0, "."); import opendvs_l2n
from collections import Counter
for tag, f in (("pristine", "pixel_4tile_mag_9_1_pruned.gds"), ("work    ", "pixel_4tile_work.gds")):
    ly = pya.Layout(); ly.read(f); c = ly.cell("openDVS_pixel2x2_top"); c.flatten(True)
    l2n = opendvs_l2n.build_l2n(ly, c); top = l2n.netlist().top_circuit(); cnt = Counter(n.name for n in top.each_net() if n.name)
    print("   %s %d nets  %s" % (tag, len(list(top.each_net())), dict(sorted(cnt.items()))))
