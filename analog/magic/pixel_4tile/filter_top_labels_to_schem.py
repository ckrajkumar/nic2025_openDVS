#!/usr/bin/env python3
"""Keep only schematic top-port labels on pixel_4tile (after tile flatten)."""
from __future__ import annotations

import re
import sys
from pathlib import Path

import gdstk

DIR = Path(__file__).resolve().parent
SCHEM = DIR / "pixel_4tile_schem.spice"
GDS_IN = DIR / "pixel_4tile_mag_tiles_flat.gds"
GDS_OUT = DIR / "pixel_4tile_mag_tiles_flat_ported.gds"


def schem_ports(path: Path) -> set[str]:
    text = path.read_text(errors="replace")
    m = re.search(
        r"^\.subckt\s+pixel_4tile_schem\s+(.*?)(?=\n(?!\s*\+))",
        text,
        re.M | re.S,
    )
    raw = m.group(1).replace("\n+", " ").replace("\n", " ")
    ports: list[str] = []
    for t in raw.split():
        ports.extend([x for x in t.split(",") if x])
    out = set()
    for p in ports:
        a = p.replace("<", "[").replace(">", "]")
        b = p.replace("[", "<").replace("]", ">")
        out |= {p, a, b}
    return out


def main() -> int:
    src = Path(sys.argv[1]) if len(sys.argv) > 1 else GDS_IN
    dst = Path(sys.argv[2]) if len(sys.argv) > 2 else GDS_OUT
    io = schem_ports(SCHEM)
    print(f"schem port name variants: {len(io)}")
    lib = gdstk.read_gds(str(src))
    top = next(c for c in lib.cells if c.name == "pixel_4tile")
    before = len(top.labels)
    remove = [l for l in top.labels if l.text not in io]
    keep = before - len(remove)
    if remove:
        # batch remove
        batch = 20000
        for i in range(0, len(remove), batch):
            top.remove(*remove[i : i + batch])
    print(f"labels {before} -> {keep} (removed {len(remove)})")
    # confirm buses present
    prefs = (
        "array_col_top_left",
        "array_col_top_right",
        "col_event_rst_top_left",
        "col_event_rst_top_right",
    )
    bus = [l for l in top.labels if any(l.text.startswith(p) for p in prefs)]
    print(f"bus labels kept: {len(bus)}")
    lib.write_gds(str(dst))
    print(f"wrote {dst}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
