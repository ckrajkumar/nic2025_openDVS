import sys,re,collections
def subs(fn):
    lines=open(fn).read().replace("\n+"," ").split("\n"); d={}
    for l in lines:
        if l.startswith(".subckt"): t=l.split(); d[t[1]]=t[2:]
    return d
a=subs(sys.argv[1]); b=subs(sys.argv[2])
for c in sys.argv[3:]:
    pa,pb=set(a[c]),set(b[c])
    print(c,"ext ports",len(pa),"ref ports",len(pb))
    def base(p): return re.sub(r"_uq\d+$","",re.sub(r"^.*/","",re.sub(r"\[\d+\]","[]",p)))
    ca=collections.Counter(base(p) for p in pa if not re.match(r"(row|col|array|readLine|vpd|pixRst)",base(p)))
    cb=collections.Counter(base(p) for p in pb if not re.match(r"(row|col|array|readLine|vpd|pixRst)",base(p)))
    print("  ext:",dict(ca)); print("  ref:",dict(cb))
    print("  only-ext sample:",sorted(pa-pb)[:8], len(pa-pb)); print("  only-ref sample:",sorted(pb-pa)[:8],len(pb-pa))
