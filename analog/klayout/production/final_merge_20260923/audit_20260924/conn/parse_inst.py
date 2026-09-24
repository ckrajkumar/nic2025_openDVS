import re, json, glob
res = {}
for f in sorted(glob.glob("inst_*.txt")):
    s = open(f).read()
    head = s.split("(",1)[0].split()
    cell, inst = head[0], head[1]
    body = s.split("(",1)[1]
    # tokenize ports: .name( expr )
    ports = {}
    i = 0
    for m in re.finditer(r"\.(\w+)\(", body):
        pass
    pos = 0
    while True:
        m = re.compile(r"\.(\w+)\(").search(body, pos)
        if not m: break
        depth = 1; j = m.end()
        while depth:
            if body[j] == "(": depth += 1
            elif body[j] == ")": depth -= 1
            j += 1
        expr = body[m.end():j-1].strip()
        pos = j
        if expr.startswith("{"):
            items = [x.strip() for x in expr.strip("{}").split(",")]
        else:
            items = [expr]
        items = [x.lstrip("\\").strip() for x in items]
        n = len(items)
        if n == 1 and not expr.startswith("{"):
            ports[m.group(1)] = items[0]
        else:
            for k, it in enumerate(items): ports["%s[%d]" % (m.group(1), n-1-k)] = it
    res[cell] = {"inst": inst, "ports": ports}
    buses = {}
    for p in ports:
        b = re.sub(r"\[\d+\]", "", p); buses[b] = buses.get(b, 0) + 1
    print(cell, inst, len(ports), buses)
json.dump(res, open("verilog_macro_conn.json", "w"), indent=1)
