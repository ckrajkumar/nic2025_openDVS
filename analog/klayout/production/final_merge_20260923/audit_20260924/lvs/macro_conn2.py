import re,collections,sys
ext=sys.argv[1]; vfile=sys.argv[2]
MAC=["BiasBranchnMasterx11","pixel_4tile","pixel_test_structure","photodiode_test_structure"]
txt=open(ext).read().replace("\n+"," ").split("\n")
subs={}
for l in txt:
    if l.startswith(".subckt"): t=l.split(); subs[t[1]]=t[2:]
top=[i for i,l in enumerate(txt) if l.startswith(".subckt user_project_wrapper")][0]
tports=set(subs["user_project_wrapper"])
lfan=collections.Counter(); lmac={}
for l in txt[top+1:]:
    if l.startswith(".ends"): break
    if not l.startswith("X"): continue
    t=[x for x in l.split() if "=" not in x]; cell=t[-1]; nets=t[1:-1]
    for n in nets: lfan[n]+=1
    if cell in MAC: lmac[cell]=dict(zip(subs[cell],nets))
v=open(vfile).read()
tok=re.compile(r"\\\S+|[A-Za-z_][\w$]*(?:\[\d+\])?")
def norm(s): s=s.strip(); return s[1:] if s.startswith("\\") else s
vcount=collections.Counter(norm(x) for x in tok.findall(v))
def parse_inst(cell):
    m=re.search(r"\n\s*"+cell+r"\s+(\\\S+|\S+)\s*\(",v); i=m.end(); depth=1; j=i
    while depth>0:
        c=v[j]
        if c=="\\":
            while not v[j].isspace(): j+=1
            continue
        if c=="(": depth+=1
        elif c==")": depth-=1
        j+=1
    body=v[i:j-1]; conns={}
    for pm in re.finditer(r"\.(\w+)\s*\(",body):
        k=pm.end(); d=1; s=k
        while d>0:
            c=body[k]
            if c=="\\":
                while not body[k].isspace(): k+=1
                continue
            if c=="(": d+=1
            elif c==")": d-=1
            k+=1
        expr=body[s:k-1].strip()
        if expr.startswith("{"):
            items=[norm(x) for x in re.findall(r"\\\S+|[^\s,{}]+",expr[1:-1])]
        else: items=[norm(expr)] if expr else []
        conns[pm.group(1)]=items
    return conns
out=[]
for cell in MAC:
    vc=parse_inst(cell); lc=lmac[cell]
    vflat={}
    for p,items in vc.items():
        if len(items)==1 and p in lc: vflat[p]=items[0]
        else:
            w=len(items)
            for i,it in enumerate(items): vflat["%s[%d]"%(p,w-1-i)]=it
    lp,vp=set(lc),set(vflat)
    print("\n==",cell,"layout pins",len(lp),"verilog pins",len(vp),"only-layout",sorted(lp-vp)[:10],"only-verilog",sorted(vp-lp)[:10])
    v2l=collections.defaultdict(set); l2v=collections.defaultdict(set)
    for p in lp&vp: v2l[vflat[p]].add(lc[p]); l2v[lc[p]].add(vflat[p])
    for vn,ls in v2l.items():
        if len(ls)>1: print("  SPLIT verilog",vn,"->",sorted(ls))
    for ln,vs in l2v.items():
        if len(vs)>1: print("  MERGED layout",ln,"<-",sorted(vs))
    nfl=0
    for p in sorted(lp&vp):
        ln,vn=lc[p],vflat[p]
        lfl = lfan[ln]<=1 and ln not in tports
        vfl = vcount[vn]<=2 and not vn.split("[")[0] in ("analog_io","io_in","io_out","io_oeb","la_data_in","la_data_out","la_oenb","vdda1","vdda2","vssa1","vssa2","vccd1","vccd2","vssd1","vssd2")
        isport_l = ln in tports; isport_v = vn.split("[")[0] in ("analog_io","io_in","io_out","io_oeb","la_data_in","la_data_out","la_oenb","vdda1","vdda2","vssa1","vssa2","vccd1","vccd2","vssd1","vssd2")
        if lfl or vfl or isport_l!=isport_v or (isport_v and ln!=vn):
            nfl+=1; print("  CHECK pin %-28s layout %-45s fan=%d port=%s | verilog %-45s count=%d"%(p,ln,lfan[ln],isport_l,vn,vcount[vn]))
