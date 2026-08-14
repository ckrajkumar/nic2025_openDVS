#!/usr/bin/env python3
"""
Stitches the final placed GDS: self-drawn cells converted from their
`.rect` files, real SkyWater sky130_fd_sc_hd cells pulled straight from
the real GDS, both instantiated at their placed location/orientation
from a DEF COMPONENTS section into one top-level cell.

Reconstructed from REBUILD_RUNBOOK.md's Step 11 after the original was
lost to an untracked-file cleanup - see that file for the full context.
Reuses `~/actflow/layout/rect2gds.py`'s own layout.conf parser and
per-.rect Component builder directly (imported, not reimplemented) so
this stays in sync with however that script draws geometry.

Each DEF component's cell-type name is ACT's mangled name
(`_0_0...`). Two cases:
  - `rect-dir/<mangled-name>.rect` exists -> self-drawn, convert it.
  - name matches `_0_0std_0_0cells_0_0sky130_fd_sc_hd__<realname>` ->
    real cell, pulled from the real sky130 GDS by <realname> (the real
    GDS's own cells keep their real, unmangled names - only ACT-side
    matching needs the mangled form, same as build_hybrid_lef.py).
Component lookups are cached, so N placed instances of the same cell
type only convert/import that cell once.

Usage:
    python3 build_gds.py --rect-dir rect_gen --def-file output.def --out output.gds
"""

import argparse
import os
import re
import sys

import gdsfactory as gf
gf.gpdk.PDK.activate()

sys.path.insert(0, os.path.expanduser("~/actflow/layout"))
import rect2gds  # noqa: E402  (path must be set up first)

DEFAULT_ACT_HOME = os.environ.get("ACT_HOME", os.path.expanduser("~/.local/act"))
DEFAULT_PDK_ROOT = os.environ.get("PDK_ROOT", os.path.expanduser("~/.ciel"))
DEFAULT_PDK = os.environ.get("PDK", "sky130A")
DEFAULT_TECH = "sky130l"

REAL_MANGLED_RE = re.compile(r'^_0_0std_0_0cells_0_0(sky130_fd_sc_hd__[A-Za-z0-9_]+)$')

# DEF FN/FE/FS/FW = mirror about the Y-axis (flip X) composed with the
# same rotation angle as N/W/S/E respectively. This is the standard LEF/
# DEF orientation convention; not yet exercised against a real placed
# design here (the upstream ring-synthesis stage is broken independently
# - see REBUILD_RUNBOOK.md Step 2/5 - so there's no output.def to test
# against yet). Spot-check the first hybrid GDS this produces once that's
# unblocked.
ORIENT = {
    "N":  (0,   False),
    "W":  (90,  False),
    "S":  (180, False),
    "E":  (270, False),
    "FN": (0,   True),
    "FW": (90,  True),
    "FS": (180, True),
    "FE": (270, True),
}


def real_mapped_names(cells_act_path):
    with open(cells_act_path, encoding="utf-8") as f:
        text = f.read()
    return set(re.findall(r'export\s+defcell\s+(sky130_fd_sc_hd__[A-Za-z0-9_]+)', text))


def parse_def_components(def_path):
    with open(def_path, encoding="utf-8") as f:
        text = f.read()

    m = re.search(r'UNITS\s+DISTANCE\s+MICRONS\s+(\d+)\s*;', text)
    if not m:
        sys.exit(f"ERROR: no 'UNITS DISTANCE MICRONS <n> ;' line found in {def_path}")
    units = int(m.group(1))

    m = re.search(r'\bCOMPONENTS\b.*?;(.*?)END\s+COMPONENTS', text, re.DOTALL)
    if not m:
        sys.exit(f"ERROR: no COMPONENTS...END COMPONENTS section found in {def_path}")
    body = m.group(1)

    components = []
    for stmt in body.split(";"):
        toks = stmt.split()
        if len(toks) < 2 or toks[0] != "-":
            continue
        inst_name, cell_type = toks[1], toks[2]

        placed_idx = None
        for kw in ("PLACED", "FIXED", "COVER"):
            if kw in toks:
                placed_idx = toks.index(kw)
                break
        if placed_idx is None:
            sys.exit(f"ERROR: component '{inst_name}' has no PLACED/FIXED/COVER location in {def_path}")

        # ... PLACED ( x y ) ORIENT
        x_du = int(toks[placed_idx + 2])
        y_du = int(toks[placed_idx + 3])
        orient = toks[placed_idx + 5]
        if orient not in ORIENT:
            sys.exit(f"ERROR: component '{inst_name}' has unrecognized orientation '{orient}'")

        components.append({
            "name": inst_name,
            "cell_type": cell_type,
            "x": x_du / units,
            "y": y_du / units,
            "orient": orient,
        })

    if not components:
        sys.exit(f"ERROR: parsed 0 components out of {def_path} - check its COMPONENTS section format")
    return components


def build_cell_cache(rect_dir, real_gds_path, layout_conf_path):
    scale, gds, materials, material_text, materials_bloat, metals, metal_pin, \
        metal_text, metals_bloat, vias, via_text, vias_bloat, align = \
        rect2gds.parse_conf_file(layout_conf_path)

    cache = {}

    def get(cell_type):
        if cell_type in cache:
            return cache[cell_type]

        rect_path = os.path.join(rect_dir, cell_type + ".rect")
        if os.path.isfile(rect_path):
            comp = rect2gds.parse_layout_file(
                filepath=rect_path, gds=gds, materials=materials,
                materials_bloat=materials_bloat, material_text=material_text,
                vias=vias, vias_bloat=vias_bloat, via_text=via_text,
                metals=metals, metals_bloat=metals_bloat, metal_pin=metal_pin,
                metal_text=metal_text, align=align, scale=scale,
            )
            cache[cell_type] = comp
            return comp

        m = REAL_MANGLED_RE.match(cell_type)
        if m:
            real_name = m.group(1)
            comp = gf.import_gds(real_gds_path, cellname=real_name)
            cache[cell_type] = comp
            return comp

        sys.exit(
            f"ERROR: cell type '{cell_type}' is neither a self-drawn "
            f".rect in {rect_dir} nor a recognized real-mapped mangled "
            "name (_0_0std_0_0cells_0_0sky130_fd_sc_hd__*)"
        )

    return get


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--rect-dir", required=True, help="dir of self-drawn .rect files, e.g. rect_gen")
    ap.add_argument("--def-file", required=True, help="placed DEF, e.g. output.def")
    ap.add_argument("--out", required=True, help="final GDS to write")
    ap.add_argument("--top", default="top", help="top-level cell name (default: top)")
    ap.add_argument("--cells-act", default=os.path.join(DEFAULT_ACT_HOME, "act", "std", "cells.act"))
    ap.add_argument("--layout-conf", default=os.path.join(DEFAULT_ACT_HOME, "conf", DEFAULT_TECH, "layout.conf"))
    ap.add_argument("--real-gds", default=os.path.join(
        DEFAULT_PDK_ROOT, DEFAULT_PDK, "libs.ref", "sky130_fd_sc_hd", "gds", "sky130_fd_sc_hd.gds"))
    args = ap.parse_args()

    # sanity check only - build_cell_cache's per-instance error already
    # catches an actually-missing real cell; this just gives an earlier,
    # clearer signal if cells.act and the DEF disagree about what's real.
    real_mapped_names(args.cells_act)

    components = parse_def_components(args.def_file)
    print(f"parsed {len(components)} placed components from {args.def_file}", file=sys.stderr)

    get_cell = build_cell_cache(args.rect_dir, args.real_gds, args.layout_conf)

    top = gf.Component(args.top)
    for comp in components:
        cell = get_cell(comp["cell_type"])
        ref = top.add_ref(cell, name=comp["name"])
        angle, mirror = ORIENT[comp["orient"]]
        if mirror:
            ref.mirror_x()
        if angle:
            ref.rotate(angle)
        ref.dmove((0, 0), (comp["x"], comp["y"]))

    top.write_gds(args.out, with_metadata=False)
    unique_types = len({c["cell_type"] for c in components})
    print(f"wrote {args.out}: {len(components)} instances of {unique_types} unique cell types",
          file=sys.stderr)


if __name__ == "__main__":
    main()
