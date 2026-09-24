# net -> list of (celltype, instance, pin) for every net touching one of the 4 analog macros, plus analog_io/power usage
import re, json
V = open("/home/rpgraca/opendvs_final/project/verilog/gl/user_project_wrapper.v").read()
mc = json.load(open("verilog_macro_conn.json"))
want = set()
for cell, d in mc.items():
    for p, n in d["ports"].items(): want.add(n)
for k in range(29): want.add("analog_io[%d]" % k)
for p in ["vdda1","vdda2","vssa1","vssa2","vccd1","vccd2","vssd1","vssd2"]: want.add(p)
body = V[V.index(");", V.index("module user_project_wrapper"))+2:]
fan = {n: [] for n in want}
stmt_re = re.compile(r"^\s*(\S+)\s+(\\?\S+)\s*\(", re.S)
cnt = 0
for st in body.split(";"):
    m = stmt_re.match(st)
    if not m or m.group(1) in ("wire","input","output","inout","assign","endmodule"): continue
    cnt += 1
    ct, inm = m.group(1), m.group(2)
    for pm in re.finditer(r"\.(\w+)\(\s*(\{[^}]*\}|[^()]*?)\s*\)", st):
        expr = pm.group(2)
        items = [x.strip().lstrip("\\").strip() for x in expr.strip("{}").split(",")] if expr.startswith("{") else [expr.lstrip("\\").strip()]
        nitem = len(items)
        for k, it in enumerate(items):
            if it in fan:
                pin = pm.group(1) if not expr.startswith("{") else "%s[%d]" % (pm.group(1), nitem-1-k)
                fan[it].append((ct, inm, pin))
print("instances scanned", cnt)
json.dump(fan, open("verilog_fanout.json","w"), indent=0)
for n in sorted(fan):
    if n.startswith("analog_io") or n in ("vdda1","vdda2","vssa1","vssa2","vccd1","vccd2","vssd1","vssd2"):
        print(n, len(fan[n]), sorted(set((c,p) for c,i,p in fan[n]))[:6])
