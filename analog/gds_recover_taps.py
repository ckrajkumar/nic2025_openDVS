#!/usr/bin/env python3
"""Recover the `tap` layer (65/44) in a GDS coming from the closed
SkyWater-for-Cadence (S130) PDK, where taps are drawn as plain diff (65/20).

Without this, magic/klayout (open PDK) and the Cadence-distributed PDK read
former taps as source/drain diffusion -> wrong device recognition, broken
substrate connectivity in extraction.

Tap identification (boolean, context-based):
  n-tap = diff AND nsdm (93/44) AND     nwell (64/20)   (n+ contact to nwell)
  p-tap = diff AND psdm (94/20) AND NOT nwell           (p+ contact to psub)
Everything matching is moved from diff 65/20 to tap 65/44; MOS S/D regions
(nsdm outside nwell, psdm inside nwell) are left on diff.

NOTE: booleans need full geometric context, so the output is FLATTENED
(single cell).  Fine for DRC/extraction in magic/klayout; do not use it as
an editable hierarchical layout.

Usage: gds_recover_taps.py IN.gds OUT.gds [--top CELLNAME]
"""
import argparse
import sys

import gdstk

DIFF = (65, 20)
TAP = (65, 44)
NWELL = (64, 20)
NSDM = (93, 44)
PSDM = (94, 20)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("input")
    ap.add_argument("output")
    ap.add_argument("--top", help="top cell name (default: single top cell)")
    args = ap.parse_args()

    lib = gdstk.read_gds(args.input)
    if args.top:
        top = next((c for c in lib.cells if c.name == args.top), None)
        if top is None:
            sys.exit("ERROR: cell %r not found" % args.top)
    else:
        tops = lib.top_level()
        if len(tops) != 1:
            sys.exit("ERROR: %d top cells (%s) -- pick one with --top"
                     % (len(tops), ", ".join(c.name for c in tops)))
        top = tops[0]

    top.flatten()

    by_key = {}
    for p in top.polygons:
        by_key.setdefault((p.layer, p.datatype), []).append(p)
    for key in (DIFF, NWELL, NSDM, PSDM):
        by_key.setdefault(key, [])
    if not by_key[DIFF]:
        sys.exit("ERROR: no diff (65/20) shapes found")

    diff, nwell = by_key[DIFF], by_key[NWELL]
    ntap = gdstk.boolean(gdstk.boolean(diff, by_key[NSDM], "and"),
                         nwell, "and")
    ptap_all = gdstk.boolean(diff, by_key[PSDM], "and")
    ptap = gdstk.boolean(ptap_all, nwell, "not")
    taps = ntap + ptap
    new_diff = gdstk.boolean(diff, taps, "not")

    out_lib = gdstk.Library(name=lib.name, unit=lib.unit,
                            precision=lib.precision)
    out = out_lib.new_cell(top.name)
    for p in top.polygons:
        if (p.layer, p.datatype) != DIFF:
            out.add(p)
    for p in top.paths:
        out.add(p)
    for t in top.labels:
        out.add(t)
    for p in new_diff:
        p.layer, p.datatype = DIFF
        out.add(p)
    for p in taps:
        p.layer, p.datatype = TAP
        out.add(p)
    out_lib.write_gds(args.output)

    a_tap = sum(p.area() for p in taps)
    a_diff = sum(p.area() for p in new_diff)
    sys.stderr.write(
        "recovered %d tap polygons (%.2f um^2); diff now %.2f um^2 "
        "(flattened cell %r) -> %s\n"
        % (len(taps), a_tap, a_diff, top.name, args.output))


if __name__ == "__main__":
    main()
