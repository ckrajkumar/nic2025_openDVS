#!/usr/bin/env python3
"""Prepend 2-pin ps2dn stub to layout/schematic spice for Netgen LVS."""

from __future__ import annotations

import sys
from pathlib import Path

STUB = """* 2-pin LVS stub for Magic photodiode parasitic (avoids dummy_25/26)
.subckt sky130_fd_pr__model__parasitic__diode_ps2dn PLUS MINUS
.ends

"""


def add_stub(src: Path, dst: Path) -> None:
    text = src.read_text(encoding="utf-8", errors="replace")
    if "2-pin LVS stub" not in text:
        text = STUB + text
    dst.write_text(text, encoding="utf-8")


def main(argv: list[str]) -> int:
    if len(argv) != 3:
        print(f"Usage: {argv[0]} <src.spice> <dst.spice>", file=sys.stderr)
        return 1
    add_stub(Path(argv[1]), Path(argv[2]))
    print(f"Wrote {argv[2]}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
