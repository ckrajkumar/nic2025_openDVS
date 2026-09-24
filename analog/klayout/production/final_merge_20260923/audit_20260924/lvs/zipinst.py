import sys,re
fn,cellname=sys.argv[1],sys.argv[2]
lines=open(fn).read().replace("\n+"," ").split("\n")
subs={}
for l in lines:
    if l.startswith(".subckt"):
        t=l.split(); subs[t[1]]=t[2:]
cur=None
for l in lines:
    if l.startswith(".subckt"): cur=l.split()[1]
    if cur==cellname and l.startswith("X"):
        t=l.split(); name=t[0]
        # find subckt name: last token without =
        toks=[x for x in t[1:] if "=" not in x]
        sc=toks[-1]; nets=toks[:-1]
        pins=subs.get(sc)
        if pins is None: print(name,sc,"no def"); continue
        for p,n in zip(pins,nets):
            if not re.match(r"(row|col|array|dac|vpd|readLine|pixRst|rowRead)",p) or not re.match(r"(row|col|array|dac)",n):
                print(name,sc,p,"->",n)
