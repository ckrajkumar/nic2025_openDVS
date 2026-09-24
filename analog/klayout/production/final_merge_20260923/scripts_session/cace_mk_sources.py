#!/usr/bin/env python3
"""Build per-source CACE roots for the five 2x2 testbenches (Rui 2026-09-23: "tables with all measurements in cace, schematic vs r19").
   Sources: schem (xschem netlist of openDVS_pixel2x2.sch), r19 / prod (Magic RCC composed netlists of the campaigns),
   calibre (Rui's production Calibre rcc netlist, the one the templates were written for).
   For each source S: ~/opendvs-cace/root_S/{xschem,cace,netlist -> ../analog/*, runs/}, templates rewritten for the
   source's internal node naming, and yamls cace/PixelX_2x2_<cond>_S.yaml with paths.root absolute and xPexType=[S].
   Usage: cace_mk_sources.py <cond: typ|full>"""
import os, re, sys, glob, shutil
HOME = os.path.expanduser("~"); BASE = f"{HOME}/opendvs-cace"; AN = f"{BASE}/analog"
cond = sys.argv[1] if len(sys.argv) > 1 else "typ"
NET = {"schem": f"{AN}/xschem/openDVS_pixel2x2_schem.spice",
       "r19": f"{HOME}/.cache/opencode/opendvs-pex/campaign-edit20260922r19-v1/sources/openDVS_pixel2x2_magic_rcc_composed.spice",
       "prod": f"{HOME}/.cache/opencode/opendvs-pex/campaign-edit20260922prod-v1/sources/openDVS_pixel2x2_magic_rcc_composed.spice",
       "calibre": f"{AN}/openDVS_pixel2x2_rcc_calibre.spice"}
KIND = {"schem": "schem", "r19": "magic", "prod": "magic", "calibre": "calibre"}
P = "xpix2x2.xpix[0]."; MAG = "xpix2x2.xdiffbn_physical_core.opendvs_pixel_0."
TERM = {"mmon.d": "on", "mmrst.g": "nrst", "mmrst.d": "vdiff", "mmsf.g": "vpr", "mmsf.s": "vsf"}
NODES = ("vpr", "vsf", "vdiff", "vd", "on", "noff", "nrst")
def rewrite(text, kind):
    if kind == "calibre": return text
    out = []
    for line in text.split("\n"):
        l = line
        if l.startswith(".save") and (".mm" in l.lower() or "net46" in l):
            continue                      # Calibre-only device-terminal / net saves
        for t, n in TERM.items():
            l = re.sub(re.escape(P + t), P + n, l, flags=re.I)
        if kind == "schem":
            l = re.sub(re.escape(P) + r"vd\b", P + "xchamp.vd", l, flags=re.I)
        elif kind == "magic":
            l = re.sub(re.escape(P) + r"(" + "|".join(NODES) + r")\b", lambda m: MAG + m.group(1), l, flags=re.I)
        out.append(l)
    return "\n".join(out)
for src, net in [(k, v) for k, v in NET.items() if k in (sys.argv[2].split(",") if len(sys.argv) > 2 else NET)]:
    assert os.path.isfile(net), net
    root = f"{BASE}/root_{src}"; os.makedirs(f"{root}/runs", exist_ok=True)
    for d in ("xschem", "cace", "netlist", "scripts"):
        if not os.path.islink(f"{root}/{d}"): os.symlink(f"{AN}/{d}", f"{root}/{d}")
    # DUT file under the xPexType naming
    link = f"{AN}/xschem/openDVS_pixel2x2_{src}.spice"
    if os.path.realpath(link) != os.path.realpath(net):
        if os.path.lexists(link): os.remove(link)
        os.symlink(net, link)
    if KIND[src] == "magic":   # per-corner DUT wrappers: corner nonfet params + ps2dn diode model + the ngspice-unit Magic RCC netlist
        mag = net.replace("_magic_rcc_composed.spice", "_magic_rcc_ngspice.spice")
        for c in ("tt", "ss", "ff", "sf", "fs"):
            open(f"{AN}/xschem/openDVS_pixel2x2_{src}_{c}.spice", "w").write(
                "* CACE DUT wrapper (%s, corner %s)\n.include /usr/local/share/pdk/sky130B/libs.tech/ngspice/corners/%s/nonfet.spice\n"
                ".include /usr/local/share/pdk/sky130B/libs.tech/ngspice/parasitics/sky130_fd_pr__model__parasitic__diode_ps2dn.model.spice\n"
                ".include %s\n" % (src, c, c, mag))
    tdir = f"{AN}/cace/templates_{src}"; os.makedirs(tdir, exist_ok=True)
    for t in glob.glob(f"{AN}/cace/templates/tb_*_2x2.sch"):
        txt = rewrite(open(t).read(), KIND[src])
        if KIND[src] == "magic":
            txt = txt.replace("openDVS_pixel2x2_CACE\\{xPexType\\}.spice", "openDVS_pixel2x2_CACE\\{xPexType\\}_CACE\\{corner\\}.spice")
            txt = re.sub(r"xpix2x2\.xpix\[([123])\]\.", lambda m: "xpix2x2.xdiffbn_physical_core.opendvs_pixel_%s." % m.group(1), txt)
        open(f"{tdir}/{os.path.basename(t)}", "w").write(txt)
    shutil.copy(f"{AN}/cace/templates/xschemrc", f"{tdir}/xschemrc")
    for y in glob.glob(f"{AN}/cace/Pixel*_2x2_{cond}.yaml"):
        s = open(y).read()
        s = re.sub(r"\n  root:\n    description: analog root\n    display: root\n    typical: \S+", f"\n  root:\n    description: analog root\n    display: root\n    typical: {root}", s)
        if "\n  root:\n" not in s:
            s = s.replace("default_conditions:\n", f"default_conditions:\n  root:\n    description: analog root\n    display: root\n    typical: {root}\n", 1)
        s = re.sub(r"paths:\n  root:\s+\S+\n  schematic:\s+xschem\n  netlist:\s+netlist", f"paths:\n  root:             {root}\n  schematic:        xschem\n  netlist:          netlist\n  templates:        cace/templates_{src}", s)
        s = re.sub(r"(\n      xPexType:\n        enumerate: )\[[^\]]*\]", r"\g<1>[%s]" % src, s)
        s = s.replace("typical: schem\n", f"typical: {src}\n")
        open(y.replace(f"_{cond}.yaml", f"_{cond}_{src}.yaml"), "w").write(s)
    print(src, "->", root, "templates", tdir)
