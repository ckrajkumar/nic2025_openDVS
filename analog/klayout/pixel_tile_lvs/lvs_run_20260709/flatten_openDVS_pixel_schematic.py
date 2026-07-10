#!/usr/bin/env python3
"""Flatten openDVS_pixel schematic subckt for unit-level Netgen LVS."""

from __future__ import annotations

import re
from pathlib import Path

SRC = Path(__file__).resolve().parents[1] / "lvs_run_20260709/pixel_4tile_open_lvsfix.spice"
DST = Path(__file__).resolve().parents[1] / "lvs_run_20260709/netgen/openDVS_pixel_flat.spice"
TOP = "openDVS_pixel"


def parse_subckts(text: str) -> dict[str, tuple[list[str], list[str]]]:
    blocks: dict[str, tuple[list[str], list[str]]] = {}
    for m in re.finditer(r"^\.subckt\s+(\S+)\s*(.*?)^\.ends", text, re.M | re.S):
        name = m.group(1)
        body = m.group(2)
        first, *rest = body.split("\n", 1)
        ports = first.strip().split()
        lines = rest[0].splitlines() if rest else []
        blocks[name] = (ports, [ln for ln in lines if ln.strip() and not ln.strip().startswith("*")])
    return blocks


def expand_cell(name: str, blocks: dict[str, tuple[list[str], list[str]]], seen: set[str]) -> list[str]:
    if name in seen:
        raise SystemExit(f"recursive subckt: {name}")
    seen.add(name)
    ports, lines = blocks[name]
    out: list[str] = []
    for ln in lines:
        if not ln.lstrip().startswith("x"):
            out.append(ln)
            continue
        parts = ln.split()
        inst = parts[0]
        cell = parts[-1]
        nports = len(parts) - 2
        nets = parts[1:1 + nports]
        if cell not in blocks:
            raise SystemExit(f"undefined subckt {cell} in {name}")
        sub_ports, sub_lines = blocks[cell]
        if len(nets) != len(sub_ports):
            raise SystemExit(f"port count mismatch {cell}: {len(nets)} vs {len(sub_ports)}")
        mapping = dict(zip(sub_ports, nets))
        sub_seen = set(seen)
        for sub_ln in expand_cell(cell, blocks, sub_seen):
            if sub_ln.lstrip().startswith("x"):
                out.append(sub_ln)
                continue
            tokens = sub_ln.split()
            mapped = []
            for tok in tokens:
                mapped.append(mapping.get(tok, tok))
            out.append(" ".join(mapped))
    return out


def main() -> None:
    text = SRC.read_text(encoding="utf-8", errors="replace")
    blocks = parse_subckts(text)
    if TOP not in blocks:
        raise SystemExit(f"{TOP} not in {SRC}")
    ports, _ = blocks[TOP]
    body = expand_cell(TOP, blocks, set())
    out = [f".subckt {TOP} " + " ".join(ports), *body, ".ends", ""]
    DST.write_text("\n".join(out), encoding="utf-8")
    print(f"Wrote {DST} ({len(body)} device lines)")


if __name__ == "__main__":
    main()
