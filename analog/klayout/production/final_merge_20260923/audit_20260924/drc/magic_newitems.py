# python3 magic_newitems.py BASE.report NEW.report : per rule, items in NEW not in BASE (exact box match) and vice versa;
# new items located: tile box / TS box / near an r20 join (within 5 um of the 20 met4 extensions or 20 met5 stubs) / near r21b via / other.
import sys, re, collections
def parse(p):
    rule=None; d=collections.defaultdict(collections.Counter)
    for l in open(p):
        l=l.rstrip("\n")
        if l.startswith("----"): continue
        m=re.match(r"^ *(-?[\d.]+) (-?[\d.]+) (-?[\d.]+) (-?[\d.]+)$", l)
        if m and rule: d[rule][tuple(round(float(v),3) for v in m.groups())]+=1
        elif l.strip() and not m and not l.startswith("user_project_wrapper"): rule=l.strip()
    return d
A=parse(sys.argv[1]); B=parse(sys.argv[2])
X=[1263.04+153.6*i for i in range(10)]
M4=[(x,584.49,x+1.6,725.715+30) for x in X]+[(x,2234.055,x+1.6,2379.41) for x in X]
Y=[809.13+153.18*i for i in range(10)]
M5=[(1190.29,y,1206.885,y+1.6) for y in Y]+[(2748.265,y,2764.87,y+1.6) for y in Y]
VIA=[(403.4,2622.28,403.77,2622.56)]
TILE=(1131,600,2823.265,2389.45); TS=(518,880,638.24,1180)
def near(b, boxes, h):
    return any(b[0]<=q[2]+h and b[2]>=q[0]-h and b[1]<=q[3]+h and b[3]>=q[1]-h for q in boxes)
def inside(b,q): return q[0]<=b[0] and b[2]<=q[2] and q[1]<=b[1] and b[3]<=q[3]
def cls(b):
    if near(b,M4,10): return "near-r20-met4"
    if near(b,M5,10): return "near-r20-met5"
    if near(b,VIA,10): return "near-r21b-via"
    if inside(b,TILE): return "tile-other"
    if inside(b,TS): return "TS"
    return "other"
for r in sorted(set(A)|set(B)):
    add=B[r]-A[r]; rem=A[r]-B[r]
    if not add and not rem: continue
    c=collections.Counter(); ex=collections.defaultdict(list)
    for b,n in add.items():
        k=cls(b); c[k]+=n
        if len(ex[k])<4: ex[k].append(b)
    cr=collections.Counter(cls(b) for b in rem.elements())
    print("%s\n   base %d new %d | added %d by class %s | removed %d by class %s" % (r, sum(A[r].values()), sum(B[r].values()), sum(add.values()), dict(c), sum(rem.values()), dict(cr)))
    for k,v in ex.items(): print("      e.g. %s: %s" % (k, v))
    # bounding boxes of added clusters: coarse grid 50um
    g=collections.Counter()
    for b in add.elements(): g[(int(b[0]//100)*100, int(b[1]//100)*100)]+=1
    print("      added per 100um cell (top 12):", g.most_common(12))
