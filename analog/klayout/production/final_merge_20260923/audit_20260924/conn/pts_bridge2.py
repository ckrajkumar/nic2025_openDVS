# graph of (no-met3) nets joined by met3 polygons through via2/via3; path vdiff -> vsf
import pya, collections
ly = pya.Layout(); ly.read(gds)
c = ly.cell("pixel_test_structure")
L = {"li":(67,20),"mcon":(67,44),"met1":(68,20),"via1":(68,44),"met2":(69,20),"via2":(69,44),"via3":(70,44),"met4":(71,20),"via4":(71,44),"met5":(72,20)}
T = {"li":(67,5),"met1":(68,5),"met2":(69,5),"met4":(71,5),"met5":(72,5)}
l2n = pya.LayoutToNetlist(pya.RecursiveShapeIterator(ly, c, []))
reg = {k: l2n.make_layer(ly.find_layer(a,b), k) for k,(a,b) in L.items()}
for k in ["li","met1","met2","met4","met5","via2","via3"]: l2n.connect(reg[k])
for k,(a,b) in T.items(): tl = l2n.make_text_layer(ly.find_layer(a,b), k+"_lbl"); l2n.connect(reg[k], tl)
for a,v,b in [("li","mcon","met1"),("met1","via1","met2"),("met4","via4","met5")]: l2n.connect(reg[a],reg[v]); l2n.connect(reg[v],reg[b])
l2n.connect(reg["met2"], reg["via2"]); l2n.connect(reg["via3"], reg["met4"])
l2n.extract_netlist()
cc = l2n.netlist().circuit_by_name("pixel_test_structure")
flat = True
m3polys = list(pya.Region(c.begin_shapes_rec(ly.find_layer(70,20))).merged().each())
nets = [n for n in cc.each_net()]
# per net: via2+via3 region (recursive)
touch = collections.defaultdict(set)
tr = pya.CplxTrans(ly.dbu)
M3 = pya.Region(); pid = {}
for i,p in enumerate(m3polys): pass
vias = {}
for n in nets:
    r = l2n.shapes_of_net(n, reg["via2"], True) + l2n.shapes_of_net(n, reg["via3"], True)
    if r.count(): vias["%s#%d" % (n.expanded_name(), n.cluster_id)] = r
for i,p in enumerate(m3polys):
    pr = pya.Region(p)
    for nm, r in vias.items():
        if not r.interacting(pr).is_empty(): touch[i].add(nm)
adj = collections.defaultdict(set)
for i, ns in touch.items():
    for a in ns:
        for b in ns:
            if a != b: adj[a].add((b, i))
def find(nm): return [k for k in vias if nm in k.split("#")[0].split(",")]
src, dst = find("vdiff"), find("vsf")
print("src", src, "dst", dst)
from collections import deque
q = deque([(s, [s]) for s in src]); seen = set(src)
while q:
    x, path = q.popleft()
    if x in dst: 
        print("PATH:")
        for j in range(0, len(path)-1, 2): pass
        for el in path: print("   ", el if isinstance(el,str) else ("met3 poly", tr*m3polys[el].bbox()))
        break
    for y, i in adj[x]:
        if y not in seen: seen.add(y); q.append((y, path + [i, y]))
else: print("no path")
