# klayout -b -r probe.py -rd gds=<file> -rd cell=<cell> -rd tag=<name>
import pya, sys
sys.path.insert(0, "/home/rpgraca/opendvs_final"); import opendvs_l2n
ly = pya.Layout(); ly.read(gds); c = ly.cell(cell)
l2n = opendvs_l2n.build_l2n(ly, c, threads=8)
def probe(lname, x, y):
    lay = l2n.layer_by_name(lname)
    if lay is None: return "no-layer"
    net = l2n.probe_net(lay, pya.DPoint(x, y))
    return net.expanded_name() if net else "-"
pts = [("li", 9.5, 10.0, "foundry li plate (final only)"), ("li", 10.29, 9.0, "inside plate / r17b ring ext"), ("li", 10.2, 8.3, "r17b L piece foot"), ("li", 10.63, 9.5, "r17b L piece vertical"),
       ("li", 10.0, 10.0, "r17b ring extension"), ("li", 2.45, 7.0, "GndA ring west"), ("poly", 10.8, 10.4, "r17b poly piece"), ("li", 9.0, 11.5, "prod diff->tap area li?"), ("met1", 10.2, 8.2, "r17b met1 at 10.2,8.2"),
       ("li", 10.3, 11.8, "top of plate"), ("li", 8.7, 8.5, "plate SW")]
print("== %s (%s)" % (tag, cell))
for lname, x, y, what in pts:
    print("  %-6s (%5.2f,%5.2f) %-34s -> %s" % (lname, x, y, what, probe(lname, x, y)))
