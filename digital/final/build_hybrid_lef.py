#!/usr/bin/env python3
"""
Builds a hybrid LEF: self-drawn macros for cells with no real sky130
counterpart, real SkyWater sky130_fd_sc_hd macros (renamed to ACT's
mangled process-name convention) for cells that do.

Reconstructed from REBUILD_RUNBOOK.md's Step 10 (`digital/final/
REBUILD_RUNBOOK.md`) after the original was lost to an untracked-file
cleanup - see that file for the full why/gotcha writeup this
implements:

  - the "real-mapped" cell set is whatever `~/.local/act/act/std/
    cells.act` declares as `export defcell sky130_fd_sc_hd__<name>`
    (today: 14 cells) - found dynamically, never hardcoded, so this
    stays correct as that list grows.
  - each such cell's MACRO...END block is pulled from the real
    SkyWater LEF and renamed `sky130_fd_sc_hd__<name>` ->
    `_0_0std_0_0cells_0_0sky130_fd_sc_hd__<name>` (ACT's `::` -> `_0_0`
    mangling), because phyDB/v2act resolve types by that mangled name
    and the real LEF has bare names.
  - the self-drawn LEF's own MACRO...END block for each of those same
    mangled names is deleted before the real ones are appended -
    loading both is a silent shadowing trap (first-loaded wins, no
    warning), not an override.

Usage:
    python3 build_hybrid_lef.py --self-drawn custom.lef --out output.lef
"""

import argparse
import os
import re
import sys

MANGLE_PREFIX = "_0_0std_0_0cells_0_0"

DEFAULT_ACT_HOME = os.environ.get("ACT_HOME", os.path.expanduser("~/.local/act"))
DEFAULT_PDK_ROOT = os.environ.get("PDK_ROOT", os.path.expanduser("~/.ciel"))
DEFAULT_PDK = os.environ.get("PDK", "sky130A")

DEFCELL_RE = re.compile(r'export\s+defcell\s+(sky130_fd_sc_hd__[A-Za-z0-9_]+)')


def real_mapped_cells(cells_act_path):
    with open(cells_act_path, encoding="utf-8") as f:
        text = f.read()
    names = sorted(set(DEFCELL_RE.findall(text)))
    if not names:
        sys.exit(f"ERROR: no 'export defcell sky130_fd_sc_hd__*' entries found in {cells_act_path}")
    return names


def macro_block_re(name):
    # LEF macro blocks are `MACRO <name>\n ... \nEND <name>\n`, confirmed
    # against the real sky130_fd_sc_hd.lef (no nested MACRO/END of the
    # same name inside a block, so a non-greedy body match is safe).
    return re.compile(
        rf'^MACRO {re.escape(name)}\n(.*?)^END {re.escape(name)}\n?',
        re.MULTILINE | re.DOTALL,
    )


def extract_and_rename_real_macros(real_lef_path, names):
    with open(real_lef_path, encoding="utf-8") as f:
        text = f.read()

    blocks = {}
    missing = []
    for name in names:
        m = macro_block_re(name).search(text)
        if not m:
            missing.append(name)
            continue
        mangled = MANGLE_PREFIX + name
        block = m.group(0)
        block = block.replace(f"MACRO {name}\n", f"MACRO {mangled}\n", 1)
        block = re.sub(rf'^END {re.escape(name)}\s*$', f"END {mangled}", block, flags=re.MULTILINE)
        blocks[name] = block

    if missing:
        sys.exit(
            "ERROR: these real-mapped cells have no MACRO block in "
            f"{real_lef_path}: {', '.join(missing)}"
        )
    return blocks


def strip_self_drawn_duplicates(self_drawn_text, names):
    out = self_drawn_text
    removed = []
    for name in names:
        mangled = MANGLE_PREFIX + name
        pattern = macro_block_re(mangled)
        new_out, n = pattern.subn("", out)
        if n:
            removed.append(mangled)
        out = new_out
    return out, removed


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--self-drawn", required=True, help="self-drawn LEF, e.g. custom.lef")
    ap.add_argument("--out", required=True, help="combined hybrid LEF to write")
    ap.add_argument("--cells-act", default=os.path.join(DEFAULT_ACT_HOME, "act", "std", "cells.act"),
                     help="ACT std cells file declaring real-mapped defcells")
    ap.add_argument("--real-lef", default=os.path.join(
        DEFAULT_PDK_ROOT, DEFAULT_PDK, "libs.ref", "sky130_fd_sc_hd", "lef", "sky130_fd_sc_hd.lef"),
        help="real SkyWater sky130_fd_sc_hd LEF")
    args = ap.parse_args()

    names = real_mapped_cells(args.cells_act)
    print(f"real-mapped cells ({len(names)}): {', '.join(names)}", file=sys.stderr)

    real_blocks = extract_and_rename_real_macros(args.real_lef, names)

    with open(args.self_drawn, encoding="utf-8") as f:
        self_drawn_text = f.read()

    stripped_text, removed = strip_self_drawn_duplicates(self_drawn_text, names)
    if removed:
        print(f"removed self-drawn duplicates for: {', '.join(removed)}", file=sys.stderr)
    else:
        print("WARNING: no self-drawn duplicate macros found to remove - "
              "either none of these cells were self-drawn in this run, or "
              "the mangled-name pattern didn't match (check --self-drawn's "
              "actual MACRO names)", file=sys.stderr)

    combined = stripped_text.rstrip("\n") + "\n\n" + "\n".join(real_blocks.values())

    with open(args.out, "w", encoding="utf-8") as f:
        f.write(combined)

    print(f"wrote {args.out}: {stripped_text.count(chr(10) + 'MACRO ')} self-drawn + "
          f"{len(real_blocks)} real macros", file=sys.stderr)


if __name__ == "__main__":
    main()
