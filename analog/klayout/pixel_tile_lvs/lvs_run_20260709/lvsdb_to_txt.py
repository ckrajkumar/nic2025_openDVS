#!/usr/bin/env python3
"""Extract human-readable summary from a KLayout LVS .lvsdb report."""

from __future__ import annotations

import sys

import pya


def main() -> int:
    if len(sys.argv) != 3:
        print(f"usage: {sys.argv[0]} <input.lvsdb> <output.txt>", file=sys.stderr)
        return 2

    src, dst = sys.argv[1], sys.argv[2]
    db = pya.ReportDatabase("lvs")
    db.load(src)

    lines: list[str] = []
    lines.append(f"LVS report: {src}")
    lines.append(f"Description: {db.description}")
    lines.append(f"Original file: {db.original_file}")
    lines.append(f"Generator: {db.generator}")
    lines.append(f"Cells: {db.num_cells()}")
    lines.append("")

    for ci in range(db.num_cells()):
        cell = db.cell_by_index(ci)
        lines.append("=" * 72)
        lines.append(f"Cell: {cell.name}")
        lines.append("-" * 72)

        for cat in db.categories_per_cell(ci):
            items = db.items(cat)
            if not items:
                continue
            lines.append(f"[{cat.name}] ({len(items)} item(s))")
            for i, item in enumerate(items):
                if i >= 50:
                    lines.append(f"  ... ({len(items) - 50} more)")
                    break
                lines.append(f"  {item.to_string()}")

        lines.append("")

    text = "\n".join(lines) + "\n"
    with open(dst, "w", encoding="utf-8") as f:
        f.write(text)
    print(f"Wrote {dst} ({len(lines)} lines)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
