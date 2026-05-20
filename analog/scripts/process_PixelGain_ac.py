#!/usr/bin/env python3
"""
Post-processing script for tb_PixelGain_ac_2x2.

Called from ngspice .control block:
  shell python3 process_PixelGain_ac.py <rawfile>

Reads Pix[0] internal nets from the 2x2 AC raw file, computes magnitudes,
and writes a new raw file (*_mag.raw) with real-valued magnitude signals:
  mag_vpd, mag_vpr, mag_vsf, mag_vdiff, mag_vd

Tries PEX net names first (xpix2x2.pix[0].*), falls back to schematic names
(xpix2x2.xpix[0].*).
"""

import sys
import os
import numpy as np
from spicelib import RawRead, RawWrite, Trace


def get_trace(raw, names, step):
    """Try multiple trace names, return first that works."""
    for name in names:
        try:
            return np.array(raw.get_trace(name).get_wave(step))
        except Exception:
            continue
    raise ValueError(f"Could not find any of: {names}")


def main():
    rawfile = sys.argv[1]
    raw = RawRead(rawfile)
    steps = raw.get_steps()

    freq = np.abs(np.array(raw.get_trace('frequency').get_wave(steps[0])))

    # Pix[0] nets — try PEX path first, then schematic path
    v_vpd = get_trace(raw, ['v(vpd0_in)', 'v(vpd0)'], steps[0])
    v_vpr = get_trace(raw, [
        'v(xpix2x2.pix[0].vpr)',
        'v(xpix2x2.xpix[0].vpr)',
    ], steps[0])
    v_vsf = get_trace(raw, [
        'v(xpix2x2.pix[0].vsf)',
        'v(xpix2x2.xpix[0].vsf)',
    ], steps[0])
    v_vdiff = get_trace(raw, [
        'v(xpix2x2.pix[0].vdiff)',
        'v(xpix2x2.xpix[0].vdiff)',
    ], steps[0])
    v_vd = get_trace(raw, [
        'v(xpix2x2.pix[0].vd)',
        'v(xpix2x2.xpix[0].xchamp.vd)',
    ], steps[0])

    mag_vpd = np.abs(v_vpd)
    mag_vpr = np.abs(v_vpr)
    mag_vsf = np.abs(v_vsf)
    mag_vdiff = np.abs(v_vdiff)
    mag_vd = np.abs(v_vd)

    # Write magnitude signals to a new raw file
    outfile = os.path.splitext(rawfile)[0] + '_mag.raw'

    n = len(freq)
    with open(outfile, 'w') as f:
        f.write("Title: AC Magnitude Pix[0]\n")
        f.write("Date: \n")
        f.write("Plotname: AC Analysis\n")
        f.write("Flags: real\n")
        f.write(f"No. Variables: 6\n")
        f.write(f"No. Points: {n}\n")
        f.write("Variables:\n")
        f.write("\t0\tfrequency\tfrequency\n")
        f.write("\t1\tmag_vpd\tvolts\n")
        f.write("\t2\tmag_vpr\tvolts\n")
        f.write("\t3\tmag_vsf\tvolts\n")
        f.write("\t4\tmag_vdiff\tvolts\n")
        f.write("\t5\tmag_vd\tvolts\n")
        f.write("Values:\n")
        for i in range(n):
            f.write(f" {i}\t{freq[i]:.12e}\n")
            f.write(f"\t{mag_vpd[i]:.12e}\n")
            f.write(f"\t{mag_vpr[i]:.12e}\n")
            f.write(f"\t{mag_vsf[i]:.12e}\n")
            f.write(f"\t{mag_vdiff[i]:.12e}\n")
            f.write(f"\t{mag_vd[i]:.12e}\n")

    print(f"Wrote {outfile} ({n} points)")


if __name__ == '__main__':
    main()
