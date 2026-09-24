import sys
fn,a,b=sys.argv[1],int(sys.argv[2]),int(sys.argv[3])
import os
C=int(os.environ.get("COL","82"))
pairs=[];cur=None
with open(fn,errors="replace") as f:
    for i,line in enumerate(f,1):
        if i<a: continue
        if i>b: break
        L=line[:C].rstrip(); R=line[C+1:].rstrip() if len(line)>C+1 else ""
        if line.startswith("-----"):
            cur=None; continue
        if L.startswith("Net: ") or L.startswith("(no matching net)") or R.startswith("Net: ") or R.startswith("(no matching net)"):
            cur=[L.strip(),R.strip(),[],[]]; pairs.append(cur); continue
        if cur is not None:
            if L.strip(): cur[2].append(L.strip())
            if R.strip(): cur[3].append(R.strip())
print(len(pairs),"fragment entries")
import collections
for p in pairs:
    print("L:",p[0],"| R:",p[1],"| nL=%d nR=%d"%(len(p[2]),len(p[3])))
    if len(p[2])<12:
        for x in p[2]: print("    L",x)
    if len(p[3])<12:
        for x in p[3]: print("    R",x)
