#!/usr/bin/env python3
"""One-level flatten of failing tile cells into pixel_4tile.

Dissolves pixel_layout_tile / pixel_layout_tile_bot instances into the top
cell, keeping openDVS_pixel2x2_{top,bot} and col_periphery_1x2 as instances
(those cells already pass LVS).

Also ensures array_col_top_* / col_event_rst_top_* labels:
  - keep the copy that sits on a per-bit metal5 finger (like the working bot)
  - drop floating <> copies that sit ~2.65um from a shared m4 strap
    (Magic snaps those onto the strap and merge-shorts all bits)
  - schem-style [] names; no extra pads (fingers already provide metal)
"""
from __future__ import annotations

import math
import sys
from collections import Counter
from pathlib import Path

import gdstk
import numpy as np

DIR = Path(__file__).resolve().parent
GDS_IN = DIR / "pixel_4tile_mag_lvs.gds"
GDS_OUT = DIR / "pixel_4tile_mag_tiles_flat.gds"

TILE_CELLS = {"pixel_layout_tile", "pixel_layout_tile_bot"}
BUS_PREFS = (
    "array_col_top_left",
    "array_col_top_right",
    "col_event_rst_top_left",
    "col_event_rst_top_right",
)
# sky130 metal5 drawing
M5_LAYER, M5_DATATYPE = 71, 20
# label layer already used for these buses
LAB_LAYER, LAB_TEXTTYPE = 71, 5


def gds_affine(ref: gdstk.Reference) -> np.ndarray:
    """3x3 affine: magnify, x-reflect, rotate(deg), translate (GDS order)."""
    mag = float(ref.magnification)
    ang = math.radians(float(ref.rotation))
    ca, sa = math.cos(ang), math.sin(ang)
    # scale + optional mirror about x (y -> -y)
    a = mag
    b = 0.0
    c = 0.0
    d = -mag if ref.x_reflection else mag
    # rotate
    a2, b2 = ca * a - sa * c, ca * b - sa * d
    c2, d2 = sa * a + ca * c, sa * b + ca * d
    ox, oy = float(ref.origin[0]), float(ref.origin[1])
    return np.array([[a2, b2, ox], [c2, d2, oy], [0.0, 0.0, 1.0]], dtype=float)


def compose_affine(outer: np.ndarray, inner: np.ndarray) -> np.ndarray:
    return outer @ inner


def affine_to_ref_params(m: np.ndarray) -> tuple[tuple[float, float], float, bool, float]:
    """Decompose affine into origin, rotation_deg, x_reflection, magnification.

    Assumes similarity transform (no shear) as produced by GDS refs.
    """
    a, b, ox = m[0, 0], m[0, 1], m[0, 2]
    c, d, oy = m[1, 0], m[1, 1], m[1, 2]
    # Detect reflection: det < 0
    det = a * d - b * c
    xrefl = det < 0
    mag = math.hypot(a, c)
    if mag == 0:
        return (ox, oy), 0.0, False, 1.0
    # If reflected, undo y-flip before measuring angle: columns of linear part
    # After GDS: R * S * MIRROR. With mirror, linear = R @ [[m,0],[0,-m]]
    if xrefl:
        # linear maps (1,0)->(a,c), (0,1)->(b,d) with d-ish negative scale
        ang = math.degrees(math.atan2(c, a))
    else:
        ang = math.degrees(math.atan2(c, a))
    return (ox, oy), ang, xrefl, mag


def transform_point(m: np.ndarray, x: float, y: float) -> tuple[float, float]:
    v = m @ np.array([x, y, 1.0])
    return float(v[0]), float(v[1])


def transform_polygon(poly: gdstk.Polygon, m: np.ndarray) -> gdstk.Polygon:
    pts = np.asarray(poly.points, dtype=float)
    ones = np.ones((len(pts), 1))
    xy = (m @ np.hstack([pts, ones]).T).T[:, :2]
    return gdstk.Polygon(xy, layer=poly.layer, datatype=poly.datatype)


def transform_label(lab: gdstk.Label, m: np.ndarray) -> gdstk.Label:
    x, y = transform_point(m, float(lab.origin[0]), float(lab.origin[1]))
    return gdstk.Label(
        lab.text,
        (x, y),
        layer=lab.layer,
        texttype=lab.texttype,
        anchor=lab.anchor,
        rotation=lab.rotation + math.degrees(math.atan2(m[1, 0], m[0, 0])),
        magnification=lab.magnification,
        x_reflection=lab.x_reflection,
    )


def norm_name(t: str) -> str:
    return t.replace("<", "[").replace(">", "]")


def is_bus(text: str) -> bool:
    return any(text.startswith(p) for p in BUS_PREFS)


def one_level_flatten(top: gdstk.Cell) -> dict[str, int]:
    stats = {"tile_refs_removed": 0, "child_refs_added": 0, "polys_added": 0, "labs_added": 0}
    to_remove = [r for r in top.references if r.cell.name in TILE_CELLS]
    new_refs: list[gdstk.Reference] = []
    new_polys: list[gdstk.Polygon] = []
    new_labs: list[gdstk.Label] = []

    for tile_ref in to_remove:
        tile = tile_ref.cell
        T = gds_affine(tile_ref)
        for cref in tile.references:
            origin, ang, xrefl, mag = affine_to_ref_params(compose_affine(T, gds_affine(cref)))
            new_refs.append(
                gdstk.Reference(
                    cref.cell,
                    origin=origin,
                    rotation=ang,
                    x_reflection=xrefl,
                    magnification=mag,
                )
            )
            stats["child_refs_added"] += 1
        for poly in tile.polygons:
            new_polys.append(transform_polygon(poly, T))
            stats["polys_added"] += 1
        for lab in tile.labels:
            new_labs.append(transform_label(lab, T))
            stats["labs_added"] += 1
        stats["tile_refs_removed"] += 1

    if to_remove:
        top.remove(*to_remove)
    if new_refs:
        top.add(*new_refs)
    if new_polys:
        top.add(*new_polys)
    if new_labs:
        top.add(*new_labs)
    return stats


def _on_m5_finger(x: float, y: float, m5_polys: list) -> bool:
    """True if point lies on a narrow per-bit m5 finger (not a wide strap)."""
    for p in m5_polys:
        bb = p.bounding_box()
        if not (bb[0][0] <= x <= bb[1][0] and bb[0][1] <= y <= bb[1][1]):
            continue
        w = bb[1][0] - bb[0][0]
        h = bb[1][1] - bb[0][1]
        # reject wide horizontal straps; accept column fingers (w small)
        if w <= 5.0 and h >= 0.2:
            return True
    return False


def ensure_bus_ports(top: gdstk.Cell) -> dict[str, int]:
    """Keep one schem-style [] label per bus bit on a per-bit m5 finger.

    Layout has both <> and [] copies. The <> copies sit ~2.65um from a
    chip-wide m4 strap; Magic attaches them to that strap and merge-shorts
    every bit. The [] copies sit on isolated vertical m5 fingers (same
    pattern as the working bot buses) — keep those, drop the rest, no pads.
    """
    stats = {"bus_kept": 0, "bus_removed": 0, "pads_added": 0, "chose_finger": 0}
    bus_labs = [l for l in top.labels if is_bus(l.text)]
    m5_polys = [
        p
        for p in top.polygons
        if p.layer == M5_LAYER and p.datatype == M5_DATATYPE
    ]

    by_norm: dict[str, list[gdstk.Label]] = {}
    for lab in bus_labs:
        by_norm.setdefault(norm_name(lab.text), []).append(lab)

    remove: list[gdstk.Label] = []
    keep: list[gdstk.Label] = []
    for nname, group in by_norm.items():
        def score(lab: gdstk.Label) -> tuple:
            x, y = float(lab.origin[0]), float(lab.origin[1])
            on_finger = _on_m5_finger(x, y, m5_polys)
            # lower is better: on-finger first, then prefer [] text
            return (0 if on_finger else 1, 0 if "[" in lab.text else 1)

        ordered = sorted(group, key=score)
        chosen = ordered[0]
        if score(chosen)[0] == 0:
            stats["chose_finger"] += 1
        remove.extend(ordered[1:])
        keep.append(chosen)
        stats["bus_kept"] += 1
        stats["bus_removed"] += len(ordered) - 1

    if remove:
        top.remove(*remove)

    for lab in keep:
        lab.layer = LAB_LAYER
        lab.texttype = LAB_TEXTTYPE
        lab.text = norm_name(lab.text)
    return stats


M4_LAYER = 70
M4_DATATYPES = (16, 20)
FINGER_CLEAR_MARGIN_UM = 0.15  # expand hole beyond finger so Magics can't attach to m4


def clear_m4_under_bus_fingers(top: gdstk.Cell) -> dict[str, int]:
    """Punch m4 clear under each top-bus m5 finger.

    Magics prefers the chip-wide m4 strap that overlaps the m5 fingers and
    attaches all top-bus labels to that one net. Removing m4 under each
    finger forces port attachment onto the per-bit m5.
    """
    stats = {"holes": 0, "straps_cut": 0, "m4_removed": 0, "m4_added": 0}
    bus_labs = [l for l in top.labels if is_bus(l.text)]
    m5_polys = [
        p for p in top.polygons if p.layer == M5_LAYER and p.datatype == M5_DATATYPE
    ]
    m4_polys = [
        p for p in top.polygons if p.layer == M4_LAYER and p.datatype in M4_DATATYPES
    ]
    if not bus_labs or not m4_polys:
        return stats

    holes: list[gdstk.Polygon] = []
    for lab in bus_labs:
        x, y = float(lab.origin[0]), float(lab.origin[1])
        # tallest narrow m5 finger under the label
        best = None
        for p in m5_polys:
            bb = p.bounding_box()
            if not (bb[0][0] <= x <= bb[1][0] and bb[0][1] <= y <= bb[1][1]):
                continue
            w = bb[1][0] - bb[0][0]
            h = bb[1][1] - bb[0][1]
            if w > 5.0:
                continue
            if best is None or h > best[0]:
                best = (h, bb)
        if best is None:
            # fallback: small hole around label
            m = 0.5
            holes.append(
                gdstk.rectangle((x - m, y - m), (x + m, y + m), layer=M4_LAYER, datatype=20)
            )
        else:
            _, bb = best
            m = FINGER_CLEAR_MARGIN_UM
            holes.append(
                gdstk.rectangle(
                    (bb[0][0] - m, bb[0][1] - m),
                    (bb[1][0] + m, bb[1][1] + m),
                    layer=M4_LAYER,
                    datatype=20,
                )
            )
        stats["holes"] += 1

    if not holes:
        return stats

    # Only cut wide straps that actually overlap holes (avoid touching unrelated m4)
    hole_bbs = [h.bounding_box() for h in holes]

    def overlaps_any_hole(bb) -> bool:
        for hb in hole_bbs:
            if not (
                bb[1][0] < hb[0][0]
                or hb[1][0] < bb[0][0]
                or bb[1][1] < hb[0][1]
                or hb[1][1] < bb[0][1]
            ):
                return True
        return False

    to_cut = []
    for p in m4_polys:
        bb = p.bounding_box()
        w = bb[1][0] - bb[0][0]
        if w < 100:  # only chip-wide straps
            continue
        if overlaps_any_hole(bb):
            to_cut.append(p)

    if not to_cut:
        return stats

    # Boolean subtract holes from each strap; replace originals
    new_pieces: list[gdstk.Polygon] = []
    for strap in to_cut:
        dt = strap.datatype
        result = gdstk.boolean(strap, holes, "not", layer=M4_LAYER, datatype=dt)
        if result is None:
            result = []
        for piece in result:
            piece.layer = M4_LAYER
            piece.datatype = dt
            new_pieces.append(piece)
        stats["straps_cut"] += 1

    top.remove(*to_cut)
    stats["m4_removed"] = len(to_cut)
    if new_pieces:
        top.add(*new_pieces)
        stats["m4_added"] = len(new_pieces)
    return stats


def main() -> int:
    src = Path(sys.argv[1]) if len(sys.argv) > 1 else GDS_IN
    dst = Path(sys.argv[2]) if len(sys.argv) > 2 else GDS_OUT
    print(f"reading {src}")
    lib = gdstk.read_gds(str(src))
    cells = {c.name: c for c in lib.cells}
    if "pixel_4tile" not in cells:
        print("ERROR: pixel_4tile not found", file=sys.stderr)
        return 1
    top = cells["pixel_4tile"]
    print("before refs", Counter(r.cell.name for r in top.references).most_common(10))
    print("before labels", len(top.labels), "polys", len(top.polygons))

    st = one_level_flatten(top)
    print("flatten:", st)
    print("after refs", Counter(r.cell.name for r in top.references).most_common(10))

    st2 = ensure_bus_ports(top)
    print("bus ports:", st2)
    st3 = clear_m4_under_bus_fingers(top)
    print("m4 clear under fingers:", st3)
    bus = [l for l in top.labels if is_bus(l.text)]
    print("bus labels final", len(bus), "unique", len({l.text for l in bus}))

    print(f"writing {dst}")
    lib.write_gds(str(dst))
    print("done", dst, "size", dst.stat().st_size)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
