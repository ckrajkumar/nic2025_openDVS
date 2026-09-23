# python3 magic_ts_items.py <drc.report> : Magic DRC items inside the pixel_test_structure placement, in TS-local coordinates
import sys, re, collections
X0, Y0 = 518.0, 1083.855
TS = (X0-10, Y0-210, X0+130, Y0+110)
rule=None; items=collections.defaultdict(list)
for l in open(sys.argv[1]):
    l=l.rstrip("\n")
    if l.startswith("----"): continue
    m=re.match(r"^ *(-?[\d.]+) (-?[\d.]+) (-?[\d.]+) (-?[\d.]+)$", l)
    if m and rule:
        x1,y1,x2,y2=map(float,m.groups())
        if TS[0]<=x1<=TS[2] and TS[1]<=y1<=TS[3]: items[rule].append((round(x1-X0,3),round(y1-Y0,3),round(x2-X0,3),round(y2-Y0,3)))
    elif l.strip() and not m and not l.startswith("user_project_wrapper"): rule=l.strip()
for r,v in items.items():
    xs=sorted(set(round(b[0],1) for b in v)); ys=sorted(set(round(b[1],1) for b in v))
    print("== %s: %d items; x %s..%s y %s..%s" % (r, len(v), min(xs), max(xs), min(ys), max(ys)))
    for b in v[:8]: print("   ", b)
