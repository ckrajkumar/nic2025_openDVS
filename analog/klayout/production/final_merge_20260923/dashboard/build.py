import json
d = open("data.json").read().replace("</", "<\\/")
t = open("template.html").read()
assert "/*DATA*/" in t
open("dashboard.html", "w").write(t.replace("/*DATA*/", d))
print("dashboard.html", len(t) + len(d), "chars")
