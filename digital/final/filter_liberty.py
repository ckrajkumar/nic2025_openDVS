#!/usr/bin/env python3
"""


Usage:
    python3 filter_liberty.py --in sky130_fd_sc_hd__tt_025C_1v80.lib \
        --out sky130_fd_sc_hd__tt_025C_1v80_synth.lib
"""

import argparse
import re
import sys

ALLOW_BASES = {
    "inv", "buf", "clkbuf", "clkinv",
    "and2", "and3", "and4", "nand2", "nand3", "nand4",
    "or2", "or3", "or4", "nor2", "nor3", "nor4",
    "xor2", "xor3", "xnor2", "xnor3", "mux2",
}

# ALLOW_BASES = {
#     "inv", "buf",
#     "and2", "and3", "and4", "nand2", "nand3", "nand4",
#     "or2", "or3", "or4", "nor2", "nor3", "nor4",
#     "xor2", "xor3", "xnor2", "xnor3", "mux2",
# }

CELL_HEADER_RE = re.compile(r'^(\s*)cell\s*\("([A-Za-z0-9_]+)"\)\s*\{', re.MULTILINE)
DRIVE_SUFFIX_RE = re.compile(r'_[0-9]+$')


def base_name(cell_name):
    # e.g. "sky130_fd_sc_hd__and2_0" -> "and2"
    tail = cell_name.rsplit("__", 1)[-1]
    return DRIVE_SUFFIX_RE.sub("", tail)


def find_matching_brace(text, open_brace_idx):
    depth = 0
    i = open_brace_idx
    n = len(text)
    while i < n:
        if text[i] == "{":
            depth += 1
        elif text[i] == "}":
            depth -= 1
            if depth == 0:
                return i
        i += 1
    raise ValueError(f"unbalanced braces starting at offset {open_brace_idx}")


def extract_cell_blocks(text):
    """Returns (preamble, [(cell_name, block_text), ...], trailer)."""
    blocks = []
    first_start = None
    last_end = None

    pos = 0
    while True:
        m = CELL_HEADER_RE.search(text, pos)
        if not m:
            break
        cell_name = m.group(2)
        open_brace_idx = m.end() - 1
        close_brace_idx = find_matching_brace(text, open_brace_idx)
        block_text = text[m.start():close_brace_idx + 1]

        if first_start is None:
            first_start = m.start()
        last_end = close_brace_idx + 1

        blocks.append((cell_name, block_text))
        pos = close_brace_idx + 1

    if first_start is None:
        raise ValueError("found 0 'cell (\"...\") {' blocks - wrong file, or format changed")

    preamble = text[:first_start]
    trailer = text[last_end:]
    return preamble, blocks, trailer


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--in", dest="inp", required=True, help="real, unfiltered sky130_fd_sc_hd*.lib")
    ap.add_argument("--out", required=True, help="filtered liberty to write")
    args = ap.parse_args()

    with open(args.inp, encoding="utf-8") as f:
        text = f.read()

    preamble, blocks, trailer = extract_cell_blocks(text)
    print(f"found {len(blocks)} total cell blocks in {args.inp}", file=sys.stderr)

    kept = [(name, body) for name, body in blocks if base_name(name) in ALLOW_BASES]
    dropped_families = sorted({base_name(name) for name, _ in blocks} - ALLOW_BASES)
    print(f"kept {len(kept)} cells, dropped {len(blocks) - len(kept)} "
          f"(families dropped: {', '.join(dropped_families)})", file=sys.stderr)

    with open(args.out, "w", encoding="utf-8") as f:
        f.write(preamble)
        for _, body in kept:
            f.write(body)
            f.write("\n")
        f.write(trailer)

    print(f"wrote {args.out}", file=sys.stderr)


if __name__ == "__main__":
    main()
