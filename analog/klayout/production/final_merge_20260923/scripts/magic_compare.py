# python3 magic_compare.py <r19 .drc.report> <final .drc.report> : per-rule counts, split inside/outside the pixel_4tile placement
import sys, re, collections
TILE = (1206.885, 675.665, 1206.885+1541.38+75.885+70.0, 675.665+1713.785+75.665)  # generous box around the tile incl. rings
TS   = (518.0-10, 1083.855-210, 518.0+130, 1083.855+110)
def parse(p):
    rule=None; cnt=collections.Counter(); inside=collections.Counter(); ints=collections.Counter()
    for l in open(p):
        l=l.rstrip("\n")
        if l.startswith("----"): continue
        m=re.match(r"^ *(-?[\d.]+) (-?[\d.]+) (-?[\d.]+) (-?[\d.]+)$", l)
        if m and rule:
            x1,y1,x2,y2=map(float,m.groups()); cnt[rule]+=1
            if TILE[0]<=x1<=TILE[2] and TILE[1]<=y1<=TILE[3]: inside[rule]+=1
            elif TS[0]<=x1<=TS[2] and TS[1]<=y1<=TS[3]: ints[rule]+=1
        elif l.strip() and not m and not l.startswith("user_project_wrapper"): rule=l.strip()
    return cnt, inside, ints
a=parse(sys.argv[1]); b=parse(sys.argv[2])
rules=sorted(set(a[0])|set(b[0]), key=lambda r:-(a[0][r]+b[0][r]))
print("%-78s %8s %8s | %7s %7s | %6s %6s" % ("rule","r19","final","in-tile","in-tile","in-TS","in-TS"))
for r in rules:
    flag = "" if a[0][r]==b[0][r] and a[1][r]==b[1][r] else "  <-- differs"
    print("%-78s %8d %8d | %7d %7d | %6d %6d%s" % (r[:78], a[0][r], b[0][r], a[1][r], b[1][r], a[2][r], b[2][r], flag))
print("total r19 %d final %d" % (sum(a[0].values()), sum(b[0].values())))
