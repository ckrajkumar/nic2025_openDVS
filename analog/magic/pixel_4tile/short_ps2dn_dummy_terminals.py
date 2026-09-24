#!/usr/bin/env python3
"""Force Magic photodiode to a 2-pin LVS black-box in a layout SPICE netlist.

Magic extracts sky130 photo diodes as 4-terminal ndiode devices. When
ext2spice emits a 2-pin D-line, netgen still invents floating nets
dummy_25 / dummy_26 (D-devices get unused bulk pins), and openDVS_pixel
shows 26 nets instead of 24.

This script rewrites each ps2dn diode as a 2-pin *subcircuit* instance
(X...) with model name sky130_fd_pr__model__parasitic__diode_ps2dn:

  D0 PLUS MINUS MODEL params
    ->  XD0 PLUS MINUS MODEL params

A 2-pin black-box .subckt stub for the model is inserted/replaced if needed.
Any prior 4-pin rewrite (PLUS MINUS MINUS PLUS) is collapsed back to 2 pins.

Usage:
  short_ps2dn_dummy_terminals.py IN.spice [OUT.spice]
  short_ps2dn_dummy_terminals.py IN.spice          # in-place (writes .bak)
"""
from __future__ import annotations

import re
import shutil
import sys
from pathlib import Path

MODEL = "sky130_fd_pr__model__parasitic__diode_ps2dn"
STUB = f"""* 2-pin LVS stub for Magic photodiode (avoids dummy_25/26)
.subckt {MODEL} PLUS MINUS
.ends

"""
# Instance line: Dname|Xname  <nets...>  MODEL  [params...]
INST_RE = re.compile(
    rf"^([Dx]\S+)\s+(.+?)\s+{re.escape(MODEL)}(\s+.*)?\s*$",
    re.IGNORECASE,
)
# Any existing stub for this model (2- or 4-pin)
STUB_RE = re.compile(
    rf"\*+[^\n]*\n\.subckt\s+{re.escape(MODEL)}\s+[^\n]+\n\.ends\s*\n+",
    re.IGNORECASE,
)
NOTE_RE = re.compile(r"^\* ps2dn dummy-terminal[^\n]*\n", re.MULTILINE)


def to_x_name(name: str) -> str:
    """Ensure instance is an X-subcircuit call so model is the last name token."""
    if name[0] in "Xx":
        return name
    return "X" + name


def rewrite_line(line: str) -> tuple[str, str]:
    """Return (new_line, status) where status is 'rewritten'|'already'|'skip'."""
    m = INST_RE.match(line.rstrip("\n"))
    if not m:
        return line, "skip"

    name, nets_raw, params = m.group(1), m.group(2).strip(), m.group(3) or ""
    nets = nets_raw.split()
    if len(nets) < 2:
        return line, "skip"

    plus, minus = nets[0], nets[1]
    nl = "\n" if line.endswith("\n") else ""
    xname = to_x_name(name)

    if len(nets) == 2 and name[0] in "Xx":
        return line, "already"

    new = f"{xname} {plus} {minus} {MODEL}{params}"
    if nl and not new.endswith("\n"):
        new += nl
    elif not line.endswith("\n") and new.endswith("\n"):
        new = new[:-1]
    return new, "rewritten"


def ensure_stub(body: str) -> str:
    """Replace any existing model stub with the 2-pin stub, or insert one."""
    if STUB_RE.search(body):
        return STUB_RE.sub(STUB, body, count=1)

    lines = body.splitlines(keepends=True)
    i = 0
    while i < len(lines) and (lines[i].startswith("*") or lines[i].strip() == ""):
        i += 1
    return "".join(lines[:i]) + STUB + "".join(lines[i:])


def process(text: str) -> tuple[str, dict[str, int]]:
    counts = {"rewritten": 0, "already": 0}
    out: list[str] = []
    for line in text.splitlines(keepends=True):
        new, status = rewrite_line(line)
        if status == "rewritten":
            counts["rewritten"] += 1
        elif status == "already":
            counts["already"] += 1
        out.append(new)

    body = NOTE_RE.sub("", "".join(out))
    body = ensure_stub(body)

    note = (
        f"* ps2dn 2-pin X-instance {MODEL} "
        f"[{counts['rewritten']} rewritten]\n"
    )
    if "ps2dn 2-pin X-instance" not in body:
        lines = body.splitlines(keepends=True)
        i = 0
        while i < len(lines) and (
            lines[i].startswith("*") or lines[i].strip() == ""
        ):
            i += 1
        body = "".join(lines[:i]) + note + "".join(lines[i:])

    return body, counts


def main(argv: list[str]) -> int:
    if len(argv) not in (2, 3):
        print(__doc__.strip(), file=sys.stderr)
        return 2

    src = Path(argv[1])
    if not src.is_file():
        print(f"ERROR: {src} not found", file=sys.stderr)
        return 1

    dst = Path(argv[2]) if len(argv) == 3 else src
    text = src.read_text(encoding="utf-8", errors="replace")
    new_text, counts = process(text)

    if dst == src:
        bak = src.with_suffix(src.suffix + ".bak")
        shutil.copy2(src, bak)
        print(f"backup: {bak}", file=sys.stderr)

    dst.write_text(new_text, encoding="utf-8")
    print(
        f"wrote {dst}: rewritten={counts['rewritten']} "
        f"already_ok={counts['already']}",
        file=sys.stderr,
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
