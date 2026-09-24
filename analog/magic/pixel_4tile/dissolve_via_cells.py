#!/usr/bin/env python3
"""Dissolve CDNS via/device abstraction cells into polygons to match the
reference flatten (pixel_4tile_mag_tiles_flat_ported.gds).

The reference keeps only "real" hierarchy (openDVS_pixel2x2_*, col_periphery*,
openDVS_pixel, dyn_comp_v1, contact$*, sky130 fets, connectors). The raw CDNS
export instead wraps every via stack and transistor in *_MAG leaf cells
(L1M1_MAG, M1M2_MAG, M2M3_MAG, M3M4_MAG, nmos_MAG, pmos_MAG). Those are flat
leaf cells (no children), so we can replace each placement with its
transformed polygons + labels in the parent, then delete the definitions.

Also drops the now-unused pixel_layout_tile / pixel_layout_tile_bot defs.
"""
from __future__ import annotations

import math
import re
import sys
from collections import Counter
from pathlib import Path

import gdstk
import numpy as np

MAG_RE = re.compile(r"^(L1M1|M1M2|M2M3|M3M4|nmos|pmos)_MAG")
DROP_DEFS = {"pixel_layout_tile", "pixel_layout_tile_bot"}


def gds_affine(ref: gdstk.Reference) -> np.ndarray:
    mag = float(ref.magnification)
    ang = math.radians(float(ref.rotation))
    ca, sa = math.cos(ang), math.sin(ang)
    a, b, c = mag, 0.0, 0.0
    d = -mag if ref.x_reflection else mag
    a2, b2 = ca * a - sa * c, ca * b - sa * d
    c2, d2 = sa * a + ca * c, sa * b + ca * d
    ox, oy = float(ref.origin[0]), float(ref.origin[1])
    return np.array([[a2, b2, ox], [c2, d2, oy], [0.0, 0.0, 1.0]], dtype=float)


def transform_polygon(poly: gdstk.Polygon, m: np.ndarray) -> gdstk.Polygon:
    pts = np.asarray(poly.points, dtype=float)
    ones = np.ones((len(pts), 1))
    xy = (m @ np.hstack([pts, ones]).T).T[:, :2]
    return gdstk.Polygon(xy, layer=poly.layer, datatype=poly.datatype)


def transform_label(lab: gdstk.Label, m: np.ndarray) -> gdstk.Label:
    x = m @ np.array([float(lab.origin[0]), float(lab.origin[1]), 1.0])
    return gdstk.Label(
        lab.text,
        (float(x[0]), float(x[1])),
        layer=lab.layer,
        texttype=lab.texttype,
        anchor=lab.anchor,
        rotation=lab.rotation + math.degrees(math.atan2(m[1, 0], m[0, 0])),
        magnification=lab.magnification,
        x_reflection=lab.x_reflection,
    )


def main() -> int:
    src = Path(sys.argv[1])
    dst = Path(sys.argv[2])
    lib = gdstk.read_gds(str(src))
    cells = {c.name: c for c in lib.cells}
    dissolve = {n: c for n, c in cells.items() if MAG_RE.match(n)}
    # sanity: MAG cells must be leaves (no child refs)
    for n, c in dissolve.items():
        if any(r.cell.name not in dissolve for r in c.references) and c.references:
            # allow refs to other MAG cells only; error otherwise
            bad = [r.cell.name for r in c.references if r.cell.name not in dissolve]
            if bad:
                print(f"WARN {n} references non-MAG cells {set(bad)}")
    print("dissolve MAG cells:", len(dissolve))

    added_polys = added_labs = expanded_refs = 0
    for cell in lib.cells:
        if cell.name in dissolve:
            continue
        mag_refs = [r for r in cell.references if r.cell.name in dissolve]
        if not mag_refs:
            continue
        new_polys, new_labs = [], []
        for r in mag_refs:
            T = gds_affine(r)
            sub = dissolve[r.cell.name]
            for p in sub.polygons:
                new_polys.append(transform_polygon(p, T))
            for l in sub.labels:
                new_labs.append(transform_label(l, T))
            expanded_refs += 1
        cell.remove(*mag_refs)
        if new_polys:
            cell.add(*new_polys)
            added_polys += len(new_polys)
        if new_labs:
            cell.add(*new_labs)
            added_labs += len(new_labs)

    print(f"expanded {expanded_refs} via/device placements -> "
          f"{added_polys} polys, {added_labs} labels")

    # Remove dissolved + unused tile definitions
    remove_defs = [cells[n] for n in dissolve]
    remove_defs += [cells[n] for n in DROP_DEFS if n in cells]
    for c in remove_defs:
        lib.remove(c)
    print("removed cell defs:", len(remove_defs))

    top = next(c for c in lib.cells if c.name == "pixel_4tile")
    print("top children:", dict(Counter(r.cell.name for r in top.references).most_common(20)))
    print("remaining cells:", sorted(c.name for c in lib.cells))

    lib.write_gds(str(dst))
    print("wrote", dst, "size", dst.stat().st_size)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
