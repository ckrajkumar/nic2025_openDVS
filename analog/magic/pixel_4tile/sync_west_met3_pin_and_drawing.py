#!/usr/bin/env python3
"""
sync_west_met3_pin_and_drawing.py

Python/KLayout port of Cadence SKILL script:
  sync_west_met3_pin_and_drawing.il  (ABsyncWestMet3PinAndDrawing)

Synchronizes met3:drawing (70/20) with met3:pin (70/16) along the west
edge so drawing fully encloses the pin stubs and ties into the internal
core traces (default +0.50 um east overlap).

Operates on shapes in the *top cell only* (matches Cadence cv~>shapes).

Default is dry-run (no write), matching the SKILL script with dbSave disabled.

Examples:
  # Inspect only
  python3 sync_west_met3_pin_and_drawing.py pixel_4tile_mag.gds

  # Write a new GDS
  python3 sync_west_met3_pin_and_drawing.py pixel_4tile_mag.gds \\
      --write -o pixel_4tile_mag_met3_sync.gds

  # West pins only (skip full-die power straps that start at the left edge)
  python3 sync_west_met3_pin_and_drawing.py pixel_4tile_mag.gds \\
      --max-pin-width 80 --write -o pixel_4tile_mag_met3_sync.gds
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

import klayout.db as pya

# sky130 open-PDK / Cadence stream map (see sky130A.map)
MET3_DRAWING = (70, 20)  # met3 drawing / net
MET3_PIN = (70, 16)  # met3 pin
MET3_LABEL = (70, 5)  # met3 label text


def um_to_dbu(um: float, dbu: float) -> int:
    return int(round(um / dbu))


def dbu_to_um(v: int, dbu: float) -> float:
    return v * dbu


def shape_bbox_um(shape: pya.Shape, dbu: float) -> tuple[float, float, float, float]:
    b = shape.bbox()
    return (
        dbu_to_um(b.left, dbu),
        dbu_to_um(b.bottom, dbu),
        dbu_to_um(b.right, dbu),
        dbu_to_um(b.top, dbu),
    )


def boxes_overlap(
    a: tuple[float, float, float, float], b: tuple[float, float, float, float]
) -> bool:
    ax1, ay1, ax2, ay2 = a
    bx1, by1, bx2, by2 = b
    return ax1 < bx2 and bx1 < ax2 and ay1 < by2 and by1 < ay2


def is_box_like(shape: pya.Shape) -> bool:
    return shape.is_box() or shape.is_polygon() or shape.is_path()


def nearest_label(
    labels: list[tuple[float, float, str]],
    x1: float,
    y1: float,
    x2: float,
    y2: float,
    max_dist: float = 2.0,
) -> str:
    """Find a met3 label near the pin bbox center."""
    cx, cy = 0.5 * (x1 + x2), 0.5 * (y1 + y2)
    best, best_d = "unnamed", max_dist
    for lx, ly, text in labels:
        # Prefer labels that fall inside/near the pin box
        if (x1 - max_dist) <= lx <= (x2 + max_dist) and (y1 - max_dist) <= ly <= (
            y2 + max_dist
        ):
            d = abs(lx - cx) + abs(ly - cy)
            if d < best_d:
                best, best_d = text, d
    return best


def collect_top_shapes(cell: pya.Cell, layer_idx: int) -> list[pya.Shape]:
    return [s for s in cell.each_shape(layer_idx) if is_box_like(s)]


def collect_labels(cell: pya.Cell, layer_idx: int, dbu: float) -> list[tuple[float, float, str]]:
    out = []
    for s in cell.each_shape(layer_idx):
        if s.is_text():
            t = s.text
            out.append((dbu_to_um(t.x, dbu), dbu_to_um(t.y, dbu), t.string))
    return out


def set_shape_box_um(
    shape: pya.Shape, x1: float, y1: float, x2: float, y2: float, dbu: float
) -> None:
    box = pya.Box(
        um_to_dbu(x1, dbu),
        um_to_dbu(y1, dbu),
        um_to_dbu(x2, dbu),
        um_to_dbu(y2, dbu),
    )
    if shape.is_box():
        shape.box = box
    else:
        # Replace polygon/path stub with an axis-aligned box (matches Cadence
        # bBox assignment intent for peripheral stubs).
        shape.polygon = pya.Polygon(box)


def sync_west_met3(
    layout: pya.Layout,
    *,
    cell_name: str | None,
    x_cutoff: float,
    core_overlap: float,
    max_pin_width: float | None,
    stub_x_tol: float = 0.20,
    search_pad: float = 0.05,
) -> tuple[int, int, int]:
    """
    Returns (count_synced, count_created, count_skipped).
    """
    dbu = layout.dbu
    top = layout.cell(cell_name) if cell_name else layout.top_cell()
    if top is None:
        raise SystemExit("No top cell found in GDS.")

    pin_idx = layout.layer(*MET3_PIN)
    drw_idx = layout.layer(*MET3_DRAWING)
    lab_idx = layout.layer(*MET3_LABEL)

    pins = collect_top_shapes(top, pin_idx)
    drawings = collect_top_shapes(top, drw_idx)
    labels = collect_labels(top, lab_idx, dbu)

    west_pins = []
    skipped = 0
    for pin in pins:
        x1, y1, x2, y2 = shape_bbox_um(pin, dbu)
        if x1 > x_cutoff:
            continue
        width = x2 - x1
        if max_pin_width is not None and width > max_pin_width:
            skipped += 1
            continue
        west_pins.append((pin, x1, y1, x2, y2))

    print("=" * 72)
    print(f"Synchronizing met3:drawing with met3:pin on West edge of: {top.name}")
    print(
        f"West X Cutoff: <= {x_cutoff:5.3f}um | Core Interface Overlap: +{core_overlap:4.2f}um"
    )
    if max_pin_width is not None:
        print(f"Max pin width filter: {max_pin_width:g}um (skipped {skipped})")
    print("=" * 72)
    print(f"Found {len(west_pins)} formal met3:pin shapes to synchronize.")

    count_synced = 0
    count_created = 0

    for pin, x1, y1, x2, y2 in west_pins:
        net_name = nearest_label(labels, x1, y1, x2, y2)
        search = (
            x1 - search_pad,
            y1 - search_pad,
            x2 + core_overlap,
            y2 + search_pad,
        )

        matched = []
        for dwg in drawings:
            dx1, dy1, dx2, dy2 = shape_bbox_um(dwg, dbu)
            if boxes_overlap(search, (dx1, dy1, dx2, dy2)):
                matched.append((dwg, dx1, dy1, dx2, dy2))

        if matched:
            # Adjust existing drawing stubs at this pin (SKILL: if(validDrawings ...))
            for dwg, dx1, dy1, dx2, dy2 in matched:
                # Only modify peripheral stubs that start near the pin's west edge
                if abs(dx1 - x1) < stub_x_tol:
                    new_x2 = max(x2 + core_overlap, dx2)
                    set_shape_box_um(dwg, x1, y1, new_x2, y2, dbu)
                    count_synced += 1
                    print(
                        f"[SYNCED] Net: {net_name:<25s} | met3:drawing updated to Y: "
                        f"[{y1:5.3f}, {y2:5.3f}]"
                    )
        else:
            # No drawing under the pin: create one to enclose it
            new_box = pya.Box(
                um_to_dbu(x1, dbu),
                um_to_dbu(y1, dbu),
                um_to_dbu(x2 + core_overlap, dbu),
                um_to_dbu(y2, dbu),
            )
            top.shapes(drw_idx).insert(new_box)
            count_created += 1
            print(
                f"[CREATED] Net: {net_name:<25s} | met3:drawing created at "
                f"[{y1:5.3f}, {y2:5.3f}]"
            )

    print("=" * 72)
    print(
        f"SUCCESS: {count_synced} drawing shapes synchronized, "
        f"{count_created} created to enclose pins."
    )
    return count_synced, count_created, skipped


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    here = Path(__file__).resolve().parent
    p = argparse.ArgumentParser(
        description="Sync west-edge met3:drawing with met3:pin (SKILL ABsyncWestMet3PinAndDrawing port)."
    )
    p.add_argument(
        "gds",
        nargs="?",
        default=str(here / "pixel_4tile_mag.gds"),
        help="Input GDS (default: pixel_4tile_mag.gds next to this script)",
    )
    p.add_argument(
        "-o",
        "--output",
        type=str,
        default=None,
        help="Output GDS path (default: <input>_met3_sync.gds when --write)",
    )
    p.add_argument(
        "--cell",
        type=str,
        default=None,
        help="Top/edit cell name (default: GDS top cell)",
    )
    p.add_argument(
        "--x-cutoff",
        type=float,
        default=100.0,
        help="West edge: process pins with left edge X <= this (um). Default: 100.0",
    )
    p.add_argument(
        "--core-overlap",
        type=float,
        default=0.50,
        help="Extra east extension of drawing past pin right edge (um). Default: 0.50",
    )
    p.add_argument(
        "--max-pin-width",
        type=float,
        default=None,
        help="Skip pins wider than this (um). Useful to ignore full-die straps. "
        "Recommended for pixel_4tile: 80",
    )
    p.add_argument(
        "--write",
        action="store_true",
        help="Write output GDS (default: dry-run / inspect only)",
    )
    return p.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    src = Path(args.gds).expanduser().resolve()
    if not src.is_file():
        print(f"ERROR: GDS not found: {src}", file=sys.stderr)
        return 1

    layout = pya.Layout()
    layout.read(str(src))

    sync_west_met3(
        layout,
        cell_name=args.cell,
        x_cutoff=args.x_cutoff,
        core_overlap=args.core_overlap,
        max_pin_width=args.max_pin_width,
    )

    if not args.write:
        print("Layout NOT saved to disk. Re-run with --write to write GDS.")
        print("=" * 72)
        return 0

    out = (
        Path(args.output).expanduser().resolve()
        if args.output
        else src.with_name(src.stem + "_met3_sync.gds")
    )
    layout.write(str(out))
    print(f"Wrote: {out}")
    print("=" * 72)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
