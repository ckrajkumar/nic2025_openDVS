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
    if cell in MAC: lmac[t[0][1:]]=(cell,dict(zip(subs[cell],nets)))
# verilog
v=open(vfile).read()
vfan=collections.Counter()
for m in re.finditer(r"\.(\\?[\w\[\]\.]+)\s*\(\s*([^()]*?)\s*\)",v):
    vfan[m.group(2).strip()]+=1
for m in re.finditer(r"assign\s+(\S+)\s*=\s*(\S+?);",v):
    vfan[m.group(1)]+=1; vfan[m.group(2)]+=1
vmac={}
for cell in MAC:
    for m in re.finditer(cell+r"\s+(\\\S+|\S+)\s*\((.*?)\);",v,re.S):
        conns=dict((a.strip(),b.strip()) for a,b in re.findall(r"\.([\w\[\]]+)\s*\(\s*([^()]*?)\s*\)",m.group(2)))
        vmac[m.group(1)]=(cell,conns)
print("layout macro insts",list(lmac)); print("verilog macro insts",list(vmac))
# pair instances by cell
for vi,(cell,vc) in vmac.items():
    li=[k for k,(c,_) in lmac.items() if c==cell][0]; lc=lmac[li][1]
    lpins=set(lc); vpins=set(vc)
    print("\n==",cell,"verilog pins",len(vpins),"layout pins",len(lpins))
    print("  pins only in verilog:",sorted(vpins-lpins)[:20]); print("  pins only in layout:",sorted(lpins-vpins)[:20])
    # net consistency
    v2l=collections.defaultdict(set)
    for p in vpins&lpins: v2l[vc[p]].add(lc[p])
    for vn,ls in sorted(v2l.items()):
        if len(ls)>1: print("  SPLIT verilog net",vn,"-> layout nets",ls)
    l2v=collections.defaultdict(set)
    for p in vpins&lpins: l2v[lc[p]].add(vc[p])
    for ln,vs in sorted(l2v.items()):
        if len(vs)>1: print("  MERGED layout net",ln,"<- verilog nets",sorted(vs)[:6],len(vs))
    for p in sorted(vpins&lpins):
        ln=lc[p]; vn=vc[p]
        lf=lfan[ln]+(1 if ln in tports else 0); vf=vfan[vn]+(1 if re.sub(r"\[.*","",vn) in ("analog_io","io_in","io_out","io_oeb","la_data_in","la_data_out","la_oenb","vdda1","vdda2","vssa1","vssa2","vccd1","vccd2","vssd1","vssd2") else 0)
        if (lf<=1) != (vf<=1) or (ln in tports)!=(vn.split("[")[0] in ("analog_io","io_in","io_out","io_oeb","la_data_in","la_data_out","la_oenb") or vn in ("vdda1","vdda2","vssa1","vssa2","vccd1","vccd2","vssd1","vssd2")):
            print("  FANOUT/PORT DIFF pin",p,"layout",ln,lf,"port" if ln in tports else "","| verilog",vn,vf)
