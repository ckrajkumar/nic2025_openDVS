# python3 analyze.py conn_<x>.json  -> compares macro-pin connectivity (KLayout metal L2N) with the gate-level verilog
import json, sys, re, collections
C = json.load(open(sys.argv[1])); VM = json.load(open("verilog_macro_conn.json")); FAN = json.load(open("verilog_fanout.json"))
MAC = list(VM.keys())
PWR = ["vdda1","vdda2","vssa1","vssa2","vccd1","vccd2","vssd1","vssd2"]
NONTERM = re.compile(r"^(sky130_ef_sc_hd__decap|sky130_fd_sc_hd__decap|sky130_fd_sc_hd__fill|sky130_fd_sc_hd__tapvpwrvgnd|vias_gen)")
TOPPORT = re.compile(r"^(analog_io|io_in|io_out|io_oeb|la_|wb|user_|vdd|vss|vcc)")
flags = []
def F(kind, sev, **kw): flags.append(dict(kind=kind, sev=sev, **kw))
def split(nm): return [x for x in nm.split(",") if x]
by_V = collections.defaultdict(set); by_O = collections.defaultdict(set)
checked = 0
for mn in MAC:
    ports = VM[mn]["ports"]; recs = C["macros"][mn]["nets"]
    lab2recs = collections.defaultdict(list)
    for r in recs:
        for l in r["labels"]: lab2recs[l].append(r)
        vs = set(ports[l] for l in r["labels"] if l in ports)
        if len(vs) > 1: F("inner net carries labels of different verilog nets", "check", macro=mn, labels=r["labels"], verilog=sorted(vs), pos=r["label_pos_top"][:2])
        extra = [l for l in r["labels"] if l not in ports]
        if extra and r["is_pin"]:
            o = C["outer"][str(r["outer"])]
            F("non-port label net touched from outside", "check", macro=mn, labels=r["labels"], outer_top_labels=o["top_labels"],
              outer_terms=len(o["terms"]), pos=r["label_pos_top"][:2])
    for P, V in ports.items():
        rs = lab2recs.get(P)
        if not rs: F("verilog port has no label in layout", "undetermined", macro=mn, pin=P, verilog=V); continue
        checked += 1
        vf = [t for t in FAN.get(V, []) if not (t[0] == mn and t[2] == P)]
        v_macros = sorted((t[0], t[2]) for t in vf if t[0] in MAC)
        v_std = collections.Counter(t[0] for t in vf if t[0] not in MAC and not NONTERM.match(t[0]))
        v_is_port = bool(TOPPORT.match(V))
        for r in rs:
            pos = r["label_pos_top"][0][2:]
            if not r["is_pin"]:
                sev = "info (verilog also unconnected)" if not vf and not v_is_port else "FLOATING"
                F("macro pin not touched by any wrapper metal", sev, macro=mn, pin=P, verilog=V, verilog_other_terms=len(vf), pos=pos); continue
            key = str(r["outer"]); o = C["outer"][key]
            by_V[V].add(key); by_O[key].add(V)
            terms = o["terms"]
            me = [t for t in terms if t[0] == mn and P in split(t[2])]
            others = [t for t in terms if not (t[0] == mn and P in split(t[2]))]
            real = [t for t in others if not NONTERM.match(t[0])]
            l_macros = sorted((t[0], p) for t in real if t[0] in MAC for p in split(t[2]) if p in VM[t[0]]["ports"])
            l_std = collections.Counter(t[0] for t in real if t[0] not in MAC)
            tl = o["top_labels"]
            if not real and not tl:
                F("pin lands on wrapper net with no other terminal", "FLOATING", macro=mn, pin=P, verilog=V, verilog_other_terms=len(vf), pos=pos, outer_bbox=o["bbox"])
            if v_is_port and V not in tl:
                F("verilog top port has no metal path to macro pin", "OPEN", macro=mn, pin=P, verilog=V, found_top_labels=tl, pos=pos, outer_bbox=o["bbox"])
            wrong = [x for x in tl if x != V]
            if wrong:
                F("wrapper net carries other top-port labels", "SHORT/MISMATCH", macro=mn, pin=P, verilog=V, found_top_labels=tl, pos=pos)
            if V not in PWR:
                vm = sorted(set(v_macros)); lm = sorted(set(l_macros))
                if vm != lm:
                    F("macro-to-macro terminals differ", "MISMATCH", macro=mn, pin=P, verilog=V, verilog_macro_terms=vm, layout_macro_terms=lm, pos=pos)
                if v_std != l_std:
                    F("std-cell terminal multiset differs", "check", macro=mn, pin=P, verilog=V, verilog_std=dict(v_std), layout_std=dict(l_std), pos=pos)
for key, vs in by_O.items():
    if len(vs) > 1: F("one wrapper net joins several verilog nets", "SHORT", verilog=sorted(vs), top_labels=C["outer"][key]["top_labels"], bbox=C["outer"][key]["bbox"])
for V, os_ in by_V.items():
    if len(os_) > 1: F("one verilog net lands on several wrapper nets", "OPEN?" if V not in PWR else "power split?", verilog=V, wrapper_nets=[(C["outer"][k]["name"], C["outer"][k]["top_labels"], len(C["outer"][k]["terms"])) for k in os_])
# power / analog_io at top level
named = C["top_named_nets"]
for p in PWR + ["analog_io[%d]" % k for k in range(29)]:
    ns = [n for n in named if p in split(n["name"])]
    if len(ns) != 1: F("top label on %d nets" % len(ns), "check", label=p, nets=[(n["name"], n["nsc"]) for n in ns])
for n in named:
    lb = split(n["name"]); pw = [x for x in lb if x in PWR]
    ports_ = set(re.sub(r"\[\d+\]$", "", x) for x in lb)
    if len(pw) > 1 or (pw and len(lb) > len(pw)) or (len(set(lb)) > 1 and any(x.startswith("analog_io") for x in lb)):
        F("top net carries several port labels", "SHORT", net=n["name"], nsc=n["nsc"])
ul = C["unlabelled_power_nets"]
big = sorted(ul, key=lambda x: -x["npw"])[:10]
print("checked verilog macro pins:", checked, " macro pins:", {m: C["macros"][m]["npins"] for m in MAC})
print("unlabelled top nets with std-cell VPWR/VGND/VPB/VNB pins:", len(ul), "largest:", big[:5])
for p in PWR:
    ns = [n for n in named if p in split(n["name"])]
    print("power", p, [(n["name"][:60], n["nsc"]) for n in ns])
print("FLAGS:", len(flags))
for f in flags: print(json.dumps(f))
