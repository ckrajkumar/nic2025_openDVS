# Instance-pin-level connectivity comparison: Magic extraction top cell vs gate-level verilog.
import re,sys,collections
ext,vfile=sys.argv[1],sys.argv[2]
SKIP=re.compile(r"(decap|fill|tapvpwrvgnd)")
txt=open(ext).read().replace("\n+"," ").split("\n")
subs={}
for l in txt:
    if l.startswith(".subckt"): t=l.split(); subs[t[1]]=t[2:]
top=[i for i,l in enumerate(txt) if l.startswith(".subckt user_project_wrapper")][0]
tports=subs["user_project_wrapper"]
L={}  # inst -> (cell, {pin:net})
for l in txt[top+1:]:
    if l.startswith(".ends"): break
    if not l.startswith("X"): continue
    t=[x for x in l.split() if "=" not in x]; cell=t[-1]
    if SKIP.search(cell): continue
    L[t[0][1:].replace(chr(92),"")]=(cell,dict(zip(subs[cell],t[1:-1])))
v=open(vfile).read()
m=re.search(r"module\s+user_project_wrapper\b",v); body=v[m.end():v.index("endmodule",m.end())]
# split statements on ; (escaped ids end at whitespace; no ; inside)
def norm(s): s=s.strip(); return s[1:].strip() if s.startswith("\\") else s
V={}; assigns=[]
for st in body.split(";"):
    s=st.strip()
    if not s or re.match(r"(wire|input|output|inout|reg)\b",s): continue
    if s.startswith("assign"):
        a,b=s[6:].split("=",1); assigns.append((norm(a),norm(b))); continue
    mm=re.match(r"(\S+)\s+(\\\S+|\S+)\s*\((.*)\)\s*$",s,re.S)
    if not mm: continue
    cell,inst,pl=mm.group(1),norm(mm.group(2)),mm.group(3)
    if SKIP.search(cell): continue
    conns={}
    for pm in re.finditer(r"\.(\w+)\s*\(",pl):
        k=pm.end(); d=1; s0=k
        while d>0:
            c=pl[k]
            if c=="\\":
                while not pl[k].isspace(): k+=1
                continue
            if c=="(": d+=1
            elif c==")": d-=1
            k+=1
        e=pl[s0:k-1].strip()
        items=[norm(x) for x in re.findall(r"\\\S+|[^\s,{}]+",e[1:-1])] if e.startswith("{") else ([norm(e)] if e else [])
        if len(items)==1 and not e.startswith("{"): conns[pm.group(1)]=items[0]
        else:
            for i,it in enumerate(items): conns["%s[%d]"%(pm.group(1),len(items)-1-i)]=it
    V[inst.replace(chr(92),"")]=(cell,conns)
print("layout insts",len(L),"verilog insts",len(V))
print("insts only in layout:",len(set(L)-set(V)),sorted(set(L)-set(V))[:10])
print("insts only in verilog:",len(set(V)-set(L)),sorted(set(V)-set(L))[:10])
# union-find over ("L",net) and ("V",net)
par={}
def f(x):
    par.setdefault(x,x)
    while par[x]!=x: par[x]=par[par[x]]; x=par[x]
    return x
def u(a,b): par[f(a)]=f(b)
AS={}
for a,b in assigns: u(("V",a),("V",b))
import copy
for p in tports: u(("L",p),("V",p))  # top ports equal by name
celldiff=0; pinonlyV=collections.Counter(); pinonlyL=collections.Counter()
for inst in set(L)&set(V):
    lc,lp=L[inst]; vc,vp=V[inst]
    if lc!=vc: celldiff+=1; continue
    for p in set(lp)|set(vp):
        if p in lp and p in vp: u(("L",lp[p]),("V",vp[p]))
        elif p in vp: pinonlyV[(vc,p)]+=1
        else: pinonlyL[(lc,p)]+=1; f(("L",lp[p]))
print("cell-type differences:",celldiff)
print("pins only in verilog (cell,pin):",pinonlyV.most_common(8))
print("pins only in layout  (cell,pin):",pinonlyL.most_common(12))
comp=collections.defaultdict(lambda:[set(),set()])
for x in list(par):
    r=f(x); comp[r][0 if x[0]=="L" else 1].add(x[1])
# verilog nets that are merged only through assign statements count as one
apar={}
def fa(x):
    apar.setdefault(x,x)
    while apar[x]!=x: x=apar[x]
    return x
for a,b in assigns: apar[fa(a)]=fa(b)
bad=[(ls,vs) for ls,vs in comp.values() if len(ls)>1 or len(set(fa(x) for x in vs))>1]
declared=set(norm(x) for x in re.findall(r"wire\s+(\\\S+|[^;\s]+)\s*;",body))
used=set(x for c in comp.values() for x in c[1])
print("declared wires",len(declared),"declared but never connected:",len(declared-used),sorted(declared-used)[:15])
print("components",len(comp),"with >1 layout or >1 verilog net:",len(bad))
for ls,vs in sorted(bad,key=lambda c:-len(c[0])-len(c[1]))[:40]:
    print("  L(%d):"%len(ls),sorted(ls)[:8]," V(%d):"%len(vs),sorted(vs)[:8])
onlyL=[ls for ls,vs in comp.values() if not vs]; onlyV=[vs for ls,vs in comp.values() if not ls]
print("layout nets w/o verilog partner:",len(onlyL),[sorted(x)[:3] for x in onlyL[:10]])
print("verilog nets w/o layout partner:",len(onlyV),[sorted(x)[:3] for x in onlyV[:10]])
