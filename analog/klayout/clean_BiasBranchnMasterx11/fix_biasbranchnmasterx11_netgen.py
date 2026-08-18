#!/usr/bin/env python3
"""Build Netgen LVS schematic with layout pin order for BiasBranchnMasterx11.

Reads Magic layout extract port order and rewrites the top-level .subckt
declaration to match exactly.  Also applies small net-name fixes required
for pin matching (PowerDown -> PowerDownM on BiasMasterCoarse, etc.).
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

TOP = "BiasBranchnMasterx11"
HERE = Path(__file__).resolve().parent
LAYOUT_SPICE = HERE / "BiasBranchnMasterx11_layout.spice"
SRC_SCHEM = HERE / "BiasBranchnMasterx11_schem.spice"
DST_SCHEM = HERE / "BiasBranchnMasterx11_netgen.spice"

HEADER = """* ============================================================================
* NETGEN LVS SOURCE  (BiasBranchnMasterx11_netgen.spice)
* For Magic/Netgen LVS only.
* ----------------------------------------------------------------------------
* Derived from : BiasBranchnMasterx11_schem.spice
* Port order from: BiasBranchnMasterx11_layout.spice (Magic extract)
* Regenerate   : python3 fix_biasbranchnmasterx11_netgen.py
* ============================================================================
"""


def parse_subckt_ports(text: str, cell: str) -> list[str]:
    """Return ordered port list for a .subckt declaration (no instances)."""
    m = re.search(
        rf"^\.subckt\s+{re.escape(cell)}\s+(.*?)(?=^[xX])",
        text,
        re.M | re.S,
    )
    if not m:
        raise SystemExit(f"subckt {cell} not found (or has no instances)")
    raw = m.group(1)
    ports: list[str] = []
    for line in raw.splitlines():
        s = line.strip()
        if not s or s.startswith("*"):
            continue
        if s.startswith("+"):
            ports.extend(s[1:].split())
        else:
            ports.extend(s.split())
    return ports


def format_subckt_decl(cell: str, ports: list[str]) -> str:
    lines = [f".subckt {cell} {ports[0]}"]
    chunk: list[str] = []
    for pin in ports[1:]:
        chunk.append(pin)
        if len(chunk) == 8:
            lines.append("+ " + " ".join(chunk))
            chunk = []
    if chunk:
        lines.append("+ " + " ".join(chunk))
    return "\n".join(lines)


def extract_top_instances(text: str, cell: str) -> str:
    """Return only x/X instance lines inside the top-level subckt."""
    m = re.search(
        rf"^\.subckt\s+{re.escape(cell)}\s+.*?^(.*?)^\.ends",
        text,
        re.M | re.S,
    )
    if not m:
        raise SystemExit(f"top subckt body for {cell} not found")
    inst_lines: list[str] = []
    in_inst = False
    for line in m.group(1).splitlines():
        s = line.rstrip()
        if not s.strip() or s.strip().startswith("*"):
            continue
        stripped = s.lstrip()
        if stripped[0] in "xX":
            in_inst = True
            inst_lines.append(s)
        elif in_inst and stripped.startswith("+"):
            inst_lines.append(s)
        elif in_inst:
            break
    if not inst_lines:
        raise SystemExit(f"no instances found in top subckt {cell}")
    return "\n".join(inst_lines)


def apply_net_fixes(body: str) -> str:
    """Map schematic net names to layout extract names inside top body."""
    body = re.sub(
        r"(^xBiasMasterCoarse\b.*?\s)PowerDown(\s)",
        r"\1PowerDownM\2",
        body,
        flags=re.M,
    )
    # Magic extract shorts all BiasBranch BufferN/P pins onto the
    # hierarchical nets BiasBranch_9/BufferN|P and leaves the top-level
    # BufferN/BufferP ports floating. Mirror that connectivity here.
    body = re.sub(r"(?<![/\w])BufferN(?![/\w])", "BiasBranch_9/BufferN", body)
    body = re.sub(r"(?<![/\w])BufferP(?![/\w])", "BiasBranch_9/BufferP", body)
    return body


def collect_subckts_after_top(text: str, cell: str) -> str:
    """Return everything after the first top-level .ends (lower subckt definitions)."""
    m = re.search(
        rf"^\.subckt\s+{re.escape(cell)}\s+.*?^\.ends\s*\n(.*)",
        text,
        re.M | re.S,
    )
    if not m:
        return ""
    return m.group(1).lstrip("\n")


def main() -> int:
    layout_path = Path(sys.argv[1]) if len(sys.argv) > 1 else LAYOUT_SPICE
    src_path = Path(sys.argv[2]) if len(sys.argv) > 2 else SRC_SCHEM
    dst_path = Path(sys.argv[3]) if len(sys.argv) > 3 else DST_SCHEM

    layout_text = layout_path.read_text(encoding="utf-8", errors="replace")
    schem_text = src_path.read_text(encoding="utf-8", errors="replace")

    layout_ports = parse_subckt_ports(layout_text, TOP)
    schem_ports_raw = parse_subckt_ports(schem_text, TOP)

    layout_set = set(layout_ports)
    schem_set = set(schem_ports_raw)
    extra_schem = schem_set - layout_set
    missing_schem = layout_set - schem_set

    if extra_schem:
        print(f"INFO: schematic-only port names removed ({len(extra_schem)}): "
              f"{sorted(extra_schem)[:12]}")
    if missing_schem:
        print(f"WARNING: layout ports absent from schematic body ({len(missing_schem)}): "
              f"{sorted(missing_schem)[:12]}")

    body = apply_net_fixes(extract_top_instances(schem_text, TOP))
    lower = collect_subckts_after_top(schem_text, TOP)

    sch_comment = ""
    sch_m = re.search(r"^\*\* sch_path:.*$", schem_text, re.M)
    if sch_m:
        sch_comment = sch_m.group(0) + "\n"

    out = HEADER + sch_comment + format_subckt_decl(TOP, layout_ports) + "\n"
    out += body + "\n.ends\n\n"
    if lower:
        out += lower
        if not out.endswith("\n"):
            out += "\n"

    dst_path.write_text(out, encoding="utf-8")

    out_ports = parse_subckt_ports(out, TOP)
    if out_ports != layout_ports:
        raise SystemExit(
            f"output port mismatch: layout={len(layout_ports)} output={len(out_ports)}"
        )

    print(f"Wrote {dst_path}")
    print(f"  layout ports: {len(layout_ports)} (unique {len(set(layout_ports))})")
    print(f"  schem raw ports: {len(schem_ports_raw)} (unique {len(schem_set)})")
    print(f"  first 8 layout: {layout_ports[:8]}")
    print(f"  has PowerDownM: {'PowerDownM' in layout_ports}")
    print(f"  has BiasDisabled[0]: {'BiasDisabled[0]' in layout_ports}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
