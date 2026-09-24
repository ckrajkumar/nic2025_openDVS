import sys,collections
fn,a,b=sys.argv[1],int(sys.argv[2]),int(sys.argv[3])
import os
C=int(os.environ.get("COL","82"))
want=set(sys.argv[4:])
cur=None; side=None; data=collections.defaultdict(lambda: collections.defaultdict(dict))
with open(fn,errors="replace") as f:
    for i,line in enumerate(f,1):
        if i<a: continue
        if i>b: break
        L=line[:C].strip(); R=line[C+1:].strip() if len(line)>C+1 else ""
        if line.startswith("-----"): cur=None; continue
        if L.startswith("Net: ") or R.startswith("Net: ") or "(no matching net)" in line:
            cur=(L[5:] if L.startswith("Net: ") else None, R[5:] if R.startswith("Net: ") else None); continue
        if cur:
            for s,t,n in ((0,L,cur[0]),(1,R,cur[1])):
                if n in want and "=" in t:
                    k,v=t.rsplit("=",1); data[n][s][k.strip()]=int(v)
for n in want:
    l,r=data[n][0],data[n][1]
    print("==",n,"layout classes",len(l),"ref classes",len(r))
    for k in sorted(set(l)|set(r)):
        if l.get(k)!=r.get(k): print("   ",k,"layout",l.get(k),"ref",r.get(k))
