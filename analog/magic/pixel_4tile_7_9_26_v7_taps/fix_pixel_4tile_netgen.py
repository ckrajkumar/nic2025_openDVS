#!/usr/bin/env python3
"""Fix pixel_4tile_schem.spice for Magic/Netgen LVS pin matching."""

from __future__ import annotations

import re
from pathlib import Path

DIR = Path(__file__).resolve().parent
SRC = DIR / "pixel_4tile_schem.spice"
LAYOUT = DIR / "pixel_4tile_layout.spice"
REPORT = DIR / "comp.out"
DST = DIR / "pixel_4tile_schem.spice"

STUB = """* 2-pin LVS stub for Magic photodiode parasitic (avoids dummy_25/26)
.subckt sky130_fd_pr__model__parasitic__diode_ps2dn PLUS MINUS
.ends

"""

LPAT = re.compile(r"^[\w\[\]#/.-]+$")
RPAT = re.compile(r"^[\w\[\]#/.-]+$")
NO_PIN = re.compile(r"^\(no pin, node is (.+)\)$")


def norm(name: str) -> str:
    return name.replace("<", "[").replace(">", "]").strip()


def expand_token(token: str) -> list[str]:
    token = token.strip()
    if "," in token:
        return [x.strip() for x in token.split(",") if x.strip()]
    return [token] if token else []


def parse_subckt_ports(text: str, cell: str) -> list[str]:
    m = re.search(
        rf"\.subckt\s+{re.escape(cell)}\s+(.*?)(?=\n(?!\s*\+))",
        text,
        re.IGNORECASE | re.DOTALL,
    )
    if not m:
        raise SystemExit(f"subckt {cell} not found")
    raw = m.group(1).replace("\n+", " ").replace("\n", " ")
    ports: list[str] = []
    for tok in raw.split():
        ports.extend(expand_token(tok))
    return ports


def wrap_decl(cell: str, ports: list[str]) -> str:
    lines = [f".subckt {cell} {ports[0]}"]
    chunk: list[str] = []
    for p in ports[1:]:
        chunk.append(p)
        if len(chunk) == 8:
            lines.append("+ " + " ".join(chunk))
            chunk = []
    if chunk:
        lines.append("+ " + " ".join(chunk))
    return "\n".join(lines)


def expand_subckt_declarations(text: str) -> str:
    out: list[str] = []
    i = 0
    lines = text.splitlines(keepends=True)
    while i < len(lines):
        line = lines[i]
        m = re.match(r"^(\.subckt\s+\S+\s+)(.*)$", line, re.I)
        if not m:
            out.append(line)
            i += 1
            continue
        prefix, rest = m.group(1), m.group(2).rstrip("\n")
        tokens: list[str] = []
        for tok in rest.split():
            tokens.extend(expand_token(tok))
        while i + 1 < len(lines) and lines[i + 1].startswith("+"):
            i += 1
            cont = lines[i].lstrip("+").strip()
            for tok in cont.split():
                tokens.extend(expand_token(tok))
        cell = re.match(r"\.subckt\s+(\S+)", prefix, re.I).group(1)
        out.append(wrap_decl(cell, tokens) + "\n")
        i += 1
    return "".join(out)


def parse_pin_table(text: str) -> list[tuple[str | None, str | None]]:
    lines = text.splitlines()
    starts = [i for i, line in enumerate(lines) if line.startswith("Subcircuit pins:")]
    if not starts:
        raise SystemExit("pin-matching table not found")
    start = starts[-1]
    end = None
    for i in range(start + 1, len(lines)):
        if lines[i].startswith("Cell pin lists for pixel_4tile"):
            end = i
            break
    if end is None:
        raise SystemExit("pin table end not found")

    rows: list[tuple[str | None, str | None]] = []
    for line in lines[start + 3 : end]:
        if "|" not in line or line.startswith("---"):
            continue
        left, right = [
            re.sub(r"\s*\*\*Mismatch\*\*", "", x.strip())
            for x in line.split("|", 1)
        ]
        if left.startswith("Circuit"):
            continue
        ln = norm(left) if LPAT.match(left.strip()) else None
        rn_raw = right.strip()
        if NO_PIN.match(rn_raw):
            rn = None
        elif RPAT.match(norm(rn_raw)) and "," not in rn_raw:
            rn = norm(rn_raw)
        else:
            rn = None
        rows.append((ln, rn))
    return rows


def build_rename(rows: list[tuple[str | None, str | None]]) -> dict[str, str]:
    rename: dict[str, str] = {}
    for ln, rn in rows:
        if ln and rn and ln != rn:
            rename[rn] = ln
    return rename


def apply_renames(text: str, rename: dict[str, str]) -> str:
    for old in sorted(rename, key=len, reverse=True):
        new = rename[old]
        text = re.sub(
            rf"(?<![A-Za-z0-9_\[\]#/.-]){re.escape(old)}(?![A-Za-z0-9_\[\]#/.-])",
            new,
            text,
        )
    return text


def fix_vpd_aliases(text: str) -> str:
    mapping = {
        "net1_0": "vpd[3]",
        "net1_1": "vpd[0]",
        "net1_2": "vpd[2]",
        "net1_3": "vpd[1]",
    }
    for old, new in mapping.items():
        text = re.sub(
            rf"(?<![A-Za-z0-9_\[\]]){re.escape(old)}(?![A-Za-z0-9_\[\]])",
            new,
            text,
        )
    return text


def reorder_subckt(text: str, cell: str, ports: list[str]) -> str:
    m = re.search(
        rf"^(\.subckt\s+{re.escape(cell)}\s+.*?)(?=\n(?!\s*\+))",
        text,
        re.IGNORECASE | re.MULTILINE | re.DOTALL,
    )
    if not m:
        return text
    return text[: m.start()] + wrap_decl(cell, ports) + text[m.end() :]


SCH_OPEN_PIXEL_PORTS = [
    "rowReadON", "VddA18", "PrBp", "GndA", "vpd", "rowReadOFF", "pixRst",
    "PrSFBp", "DiffBn", "OnBn", "OffBn", "RefrBp", "readLine", "GndD",
]

# Layout extract label ports alias to functional nets for instance wiring.
OPEN_PIXEL_PORT_FUNC: dict[str, str] = {
    "m2_32_2198#": "rowReadOFF",
    "rowReadOFF": "rowReadOFF",
    "m2_298_1861#": "rowReadOFF",
    "m3_2210_26#": "rowReadOFF",
    "m2_196_1392#": "rowReadOFF",
    "PrSFBp": "PrSFBp",
    "m5_n506_n512#": "PrSFBp",
    "m2_32_2482#": "rowReadON",
    "rowReadON": "rowReadON",
    "m2_32_2254#": "RefrBp",
    "RefrBp": "RefrBp",
    "m3_2462_26#": "readLine",
    "m2_372_2398#": "readLine",
    "readLine": "readLine",
    "VddA18": "VddA18",
    "m3_2084_26#": "vpd",
    "vpd": "vpd",
    "pixRst": "pixRst",
    "PrBp": "PrBp",
    "m3_2714_26#": "GndD",
    "GndD": "GndD",
    "m3_2336_26#": "GndA",
    "GndA": "GndA",
    "OnBn": "OnBn",
    "DiffBn": "DiffBn",
    "OffBn": "OffBn",
    "m3_2588_26#": "OffBn",
}


def extract_subckt_block(text: str, cell: str) -> str:
    m = re.search(
        rf"^\.subckt\s+{re.escape(cell)}\s+.*?^\.ends\s*$",
        text,
        re.IGNORECASE | re.MULTILINE | re.DOTALL,
    )
    if not m:
        raise SystemExit(f"subckt block {cell} not found")
    return m.group(0)


def replace_openDVS_pixel_subckt(text: str, layout_text: str) -> str:
    layout_block = extract_subckt_block(layout_text, "openDVS_pixel")
    m = re.search(
        r"^\.subckt\s+openDVS_pixel\s+.*?^\.ends\s*$",
        text,
        re.IGNORECASE | re.MULTILINE | re.DOTALL,
    )
    if not m:
        raise SystemExit("openDVS_pixel not in schematic")
    return text[: m.start()] + layout_block + "\n" + text[m.end() :]


def rewrite_openDVS_pixel_instances(text: str, layout_ports: list[str]) -> str:
    lines = text.splitlines(keepends=True)
    out: list[str] = []
    i = 0
    n_inst = 0
    while i < len(lines):
        line = lines[i]
        if re.match(r"^x\S+\s", line, re.I) and "openDVS_pixel" not in line:
            block = line
            j = i + 1
            while j < len(lines) and lines[j].startswith("+"):
                block += lines[j]
                j += 1
            flat = block.replace("\n+", " ").replace("\n", " ")
            parts = flat.split()
            if parts[-1].lower() == "opendvs_pixel":
                inst = parts[0]
                old_nets = parts[1:-1]
                if len(old_nets) != len(SCH_OPEN_PIXEL_PORTS):
                    raise SystemExit(
                        f"{inst}: expected {len(SCH_OPEN_PIXEL_PORTS)} nets, got {len(old_nets)}"
                    )
                netmap = dict(zip(SCH_OPEN_PIXEL_PORTS, old_nets))
                new_nets = [netmap[OPEN_PIXEL_PORT_FUNC[p]] for p in layout_ports]
                out.append(f"{inst} " + " ".join(new_nets) + " openDVS_pixel\n")
                n_inst += 1
                i = j
                continue
        out.append(line)
        i += 1
    print(f"  rewrote {n_inst} openDVS_pixel instances")
    return "".join(out)


def main() -> int:
    src = SRC
    bak = SRC.with_suffix(".spice.bak")
    if bak.exists():
        src = bak
    text = src.read_text(encoding="utf-8", errors="replace")
    layout_text = LAYOUT.read_text(encoding="utf-8", errors="replace")
    report = REPORT.read_text(encoding="utf-8", errors="replace")

    text = expand_subckt_declarations(text)
    text = fix_vpd_aliases(text)

    layout_ports = parse_subckt_ports(layout_text, "pixel_4tile")
    rows = parse_pin_table(report)
    rename = build_rename(rows)

    bot_ports = parse_subckt_ports(layout_text, "openDVS_pixel2x2_bot")
    top_ports = parse_subckt_ports(layout_text, "openDVS_pixel2x2_top")
    text = reorder_subckt(text, "openDVS_pixel2x2_bot", bot_ports)
    text = reorder_subckt(text, "openDVS_pixel2x2_top", top_ports)

    open_ports = parse_subckt_ports(layout_text, "openDVS_pixel")
    text = replace_openDVS_pixel_subckt(text, layout_text)
    text = rewrite_openDVS_pixel_instances(text, open_ports)

    # Port order comes directly from layout extract; skip comp.out renames (stale after fixes).
    text = reorder_subckt(text, "pixel_4tile", layout_ports)

    if "2-pin LVS stub" not in text:
        text = STUB + text

    DST.write_text(text, encoding="utf-8")

    schem_ports = parse_subckt_ports(text, "pixel_4tile")
    print(f"Wrote {DST}")
    print(f"  renames skipped (layout port order is authoritative)")
    print(f"  layout ports: {len(layout_ports)}")
    print(f"  schem ports after fix: {len(schem_ports)}")
    print(f"  first 5 layout/schem: {layout_ports[:5]} / {schem_ports[:5]}")
    if layout_ports != schem_ports:
        missing = set(layout_ports) - set(schem_ports)
        extra = set(schem_ports) - set(layout_ports)
        print(f"  WARNING missing={len(missing)} extra={len(extra)}")
        if missing:
            print(f"    missing sample: {sorted(missing)[:5]}")
        if extra:
            print(f"    extra sample: {sorted(extra)[:5]}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
