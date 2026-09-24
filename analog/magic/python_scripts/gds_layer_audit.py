#!/usr/bin/env python3
"""Audit (layer, datatype) usage of GDS files in the openDVS project and
annotate each pair with its name in the three layer maps:
  - S130.layermap                (closed SkyWater-for-Cadence stream map)
  - sky130_fd_pr_main.layermap   (Cadence-distributed PDK stream map)
  - sky130A.map / .lyp           (open PDK, klayout)
Usage: gds_layer_audit.py FILE.gds [FILE2.gds ...]
With two files, also prints a set diff of their layer pairs.
"""
import os
import re
import sys
from collections import Counter

import gdstk

PROJ = os.path.expanduser(
    "~/research/projects/telluride/2025/nic_eventcam/openDVS-layout")


def load_cadence_map(path):
    """name purpose layer datatype (whitespace separated, # comments)."""
    m = {}
    for line in open(path, errors="replace"):
        line = line.split("#")[0].strip()
        parts = line.split()
        if len(parts) >= 4 and parts[2].isdigit() and parts[3].isdigit():
            key = (int(parts[2]), int(parts[3]))
            m.setdefault(key, "%s.%s" % (parts[0], parts[1]))
    return m


def load_klayout_map(path):
    """klayout .map: name purposes layer datatype."""
    m = {}
    for line in open(path, errors="replace"):
        parts = line.split("#")[0].split()
        if len(parts) >= 4 and parts[-2].isdigit() and parts[-1].isdigit():
            key = (int(parts[-2]), int(parts[-1]))
            m.setdefault(key, "%s.%s" % (parts[0], parts[1]))
    return m


def load_lyp(path):
    """klayout .lyp XML: <name>tag</name> ... <source>l/d@1</source>."""
    m = {}
    txt = open(path, errors="replace").read()
    for block in re.findall(r"<properties>(.*?)</properties>", txt, re.S):
        nm = re.search(r"<name>([^<]*)</name>", block)
        sc = re.search(r"<source>(\d+)/(\d+)@", block)
        if nm and sc:
            key = (int(sc.group(1)), int(sc.group(2)))
            m.setdefault(key, nm.group(1).split("-")[0].strip())
    return m


MAPS = [
    ("S130", load_cadence_map(os.path.join(PROJ, "S130.layermap"))),
    ("CDNS", load_cadence_map(os.path.expanduser(
        "~/sky130/libs/sky130_fd_pr_main/sky130_fd_pr_main.layermap"))),
    ("OPEN", load_klayout_map(os.path.expanduser(
        "~/.ciel/sky130A/libs.tech/klayout/tech/sky130A.map"))),
    ("LYP", load_lyp(os.path.expanduser(
        "~/.ciel/sky130A/libs.tech/klayout/tech/sky130A.lyp"))),
]


def scan(path):
    lib = gdstk.read_gds(path)
    shapes, labels = Counter(), Counter()
    for cell in lib.cells:
        for p in cell.polygons:
            shapes[(p.layer, p.datatype)] += 1
        for p in cell.paths:
            shapes[(p.layers[0], p.datatypes[0])] += 1
        for t in cell.labels:
            labels[(t.layer, t.texttype)] += 1
    return lib, shapes, labels


def names_for(key):
    out = []
    for tag, m in MAPS:
        if key in m:
            out.append("%s:%s" % (tag, m[key]))
    return "  ".join(out) if out else "!! UNMAPPED in all maps"


def report(path):
    lib, shapes, labels = scan(path)
    print("=" * 78)
    print(os.path.relpath(path, PROJ))
    print("  lib=%r  unit=%g  precision=%g  cells=%d"
          % (lib.name, lib.unit, lib.precision, len(lib.cells)))
    for kind, ctr in (("shape", shapes), ("label", labels)):
        for (l, d), n in sorted(ctr.items()):
            print("  %-5s %3d/%-3d %7d   %s" % (kind, l, d, n,
                                                names_for((l, d))))
    return set(shapes) | set(labels)


def main():
    sets = {}
    for path in sys.argv[1:]:
        sets[path] = report(path)
    if len(sets) == 2:
        (fa, sa), (fb, sb) = sets.items()
        print("=" * 78)
        print("DIFF %s vs %s" % (os.path.basename(fa), os.path.basename(fb)))
        for key in sorted(sa - sb):
            print("  only in %-40s %3d/%-3d  %s"
                  % (os.path.basename(fa), key[0], key[1], names_for(key)))
        for key in sorted(sb - sa):
            print("  only in %-40s %3d/%-3d  %s"
                  % (os.path.basename(fb), key[0], key[1], names_for(key)))


if __name__ == "__main__":
    main()
