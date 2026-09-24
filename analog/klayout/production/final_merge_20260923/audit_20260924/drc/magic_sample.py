# Sample Magic-new item boxes; flat KLayout width/space checks in a 3 um window around each, in the given GDS.
import pya, random, re, collections, sys
random.seed(1)
def parse(p):
    rule=None; d=collections.defaultdict(set)
    for l in open(p):
        l=l.rstrip("\n")
        if l.startswith("----"): continue
        m=re.match(r"^ *(-?[\d.]+) (-?[\d.]+) (-?[\d.]+) (-?[\d.]+)$", l)
        if m and rule: d[rule].add(tuple(float(v) for v in m.groups()))
        elif l.strip() and not m and not l.startswith("user_project_wrapper"): rule=l.strip()
    return d
Bs=parse(base); Ns=parse(new)
L = pya.Layout(); L.read(gds); top = L.top_cell()
chk = {"li.3": ((67,20), 0.17), "met1.2": ((68,20), 0.14), "met2.2": ((69,20), 0.14), "met3.2": ((70,20), 0.3), "met5.2": ((72,20), 1.6)}
tot = collections.Counter(); hits = collections.Counter()
for r in Ns:
    add = sorted(Ns[r] - Bs.get(r, set()))
    if not add: continue
    key = next((k for k in chk if "(" + k + ")" in r), None)
    samp = random.sample(add, min(40, len(add)))
    for b in samp:
        w = pya.DBox(b[0]-3, b[1]-3, b[2]+3, b[3]+3).to_itype(L.dbu)
        if key:
            (l, d), s = chk[key]
            reg = pya.Region(top.begin_shapes_rec_touching(L.find_layer(l, d), w)); reg.merge()
            reg = reg & pya.Region(w.enlarged(2000, 2000))
            v = reg.space_check(int(round(s/L.dbu))) + reg.width_check(int(round(s/L.dbu)))
            v = v.edges().interacting(pya.Region(w)) if hasattr(v, "edges") else v
            n = v.count(); tot[r] += 1; hits[r] += (n > 0)
            if n: print("VIOL", r, b, n)
        else:
            tot[r] += 1
    print("%-70s sampled %d, KLayout flat violations in %d samples%s" % (r[:70], tot[r], hits[r], "" if key else " (no KLayout equivalent checked)"))
