# From the cf_precheck Magic extraction: for each analog macro instance in the top subckt, map port -> top net and count
# how many times that top net appears on any other device/instance line in the top subckt.
import gzip, sys, re, json, collections
f = sys.argv[1]; outp = sys.argv[2]
lines = []
cur = ""
for l in gzip.open(f, "rt"):
    l = l.rstrip("\n")
    if l.startswith("+"): cur += " " + l[1:]
    else:
        if cur: lines.append(cur)
        cur = l
lines.append(cur)
subckts = {}; body = {}; name = None
for l in lines:
    t = l.split()
    if not t: continue
    if t[0].lower() == ".subckt": name = t[1]; subckts[name] = t[2:]; body[name] = []
    elif t[0].lower() == ".ends": name = None
    elif name: body[name].append(t)
topn = "user_project_wrapper"
MAC = ["BiasBranchnMasterx11","pixel_4tile","pixel_test_structure","photodiode_test_structure"]
use = collections.Counter()
for t in body[topn]:
    if t[0][0] in "Xx":
        # X name nets... subckt [params]
        k = len(t)-1
        while "=" in t[k]: k -= 1
        for n in t[1:k]: use[n] += 1
    elif t[0][0] not in "*":
        for n in t[1:4]: use[n] += 1
for n in subckts[topn]: use[n] += 0
res = {}
for t in body[topn]:
    if t[0][0] not in "Xx": continue
    k = len(t)-1
    while "=" in t[k]: k -= 1
    sub = t[k]
    if sub in MAC:
        nets = t[1:k]; ports = subckts[sub]
        assert len(nets) == len(ports), (sub, len(nets), len(ports))
        res[sub] = {"inst": t[0], "map": {p: [n, use[n]-1, n in subckts[topn]] for p, n in zip(ports, nets)}}
        print(sub, t[0], len(ports), "ports; ports whose top net has no other use:",
              [(p, n) for p, n in zip(ports, nets) if use[n] <= 1 and n not in subckts[topn]])
json.dump(res, open(outp, "w"), indent=0)
