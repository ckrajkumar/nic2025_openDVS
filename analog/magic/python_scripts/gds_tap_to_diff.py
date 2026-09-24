#!/usr/bin/env python3
"""Remap the open-PDK/Cadence-distributed `tap` layer onto `diff` so a GDS
can be streamed into the closed SkyWater-for-Cadence (S130) PDK environment.

The S130 PDK has no tap layer: taps are plain diff (65/20) distinguished by
implant/well context, and S130.layermap deliberately contains no 65/44 entry
("removed duplicate mapping of layers (tap/diff)").  Streaming a magic /
open-PDK / Cadence-distributed GDS in with S130.layermap silently drops every
tap shape -> floating bulks in LVS, tap-density DRC errors.

Run this BEFORE stream-in.  Hierarchy is preserved.

Usage: gds_tap_to_diff.py IN.gds OUT.gds
"""
import sys

import gdstk

# (layer, datatype) remaps: open/CDNS tap purposes -> S130 diff purposes
SHAPE_MAP = {
    (65, 44): (65, 20),   # tap.drawing  -> diff.drawing
    (65, 48): (65, 16),   # tap.pin      -> diff.pin
    (65, 60): (65, 4),    # tap.boundary -> diff.boundary
    (65, 41): (65, 23),   # tap.net      -> diff.net
}
LABEL_MAP = {
    (65, 5): (65, 6),     # tap.label    -> diff.label
}


def main():
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    src, dst = sys.argv[1], sys.argv[2]
    lib = gdstk.read_gds(src)
    n_shapes = n_labels = 0
    for cell in lib.cells:
        for p in cell.polygons:
            key = (p.layer, p.datatype)
            if key in SHAPE_MAP:
                p.layer, p.datatype = SHAPE_MAP[key]
                n_shapes += 1
        for p in cell.paths:
            key = (p.layers[0], p.datatypes[0])
            if key in SHAPE_MAP:
                sys.stderr.write(
                    "WARNING: path on tap layer %s in cell %s left "
                    "untouched -- convert it to a polygon first\n"
                    % (key, cell.name))
        for t in cell.labels:
            key = (t.layer, t.texttype)
            if key in LABEL_MAP:
                t.layer, t.texttype = LABEL_MAP[key]
                n_labels += 1
    lib.write_gds(dst)
    sys.stderr.write("remapped %d tap shapes and %d tap labels -> %s\n"
                     % (n_shapes, n_labels, dst))


if __name__ == "__main__":
    main()
