#!/usr/bin/env python3
"""
Find comparator thresholds from a coarse DC sweep and run fine sweeps.

Called from ngspice .control block:
  shell python3 find_comp_thresholds.py <coarse_rawfile> <spice_file>

1. Reads coarse raw file, finds ON/OFF thresholds (VDD/2 crossings)
2. Generates modified spice files with fine DC sweep ranges
3. Runs ngspice on each fine sweep file
"""

import sys
import os
import subprocess
import numpy as np
from spicelib import RawRead

MARGIN = 0.025  # V margin around threshold for fine sweep (51 points at 1mV)


def get_trace(raw, names, step):
    """Try multiple trace names, return first that works."""
    for name in names:
        try:
            return np.array(raw.get_trace(name).get_wave(step))
        except Exception:
            continue
    raise ValueError(f"Could not find any of: {names}")


def find_crossing(sweep, signal, threshold):
    """Find sweep value where signal crosses threshold (falling)."""
    above = signal >= threshold
    crossings = np.where(above[:-1] & ~above[1:])[0]
    if len(crossings) == 0:
        crossings = np.where(~above[:-1] & above[1:])[0]
    if len(crossings) == 0:
        return None
    i = crossings[0]
    s0, s1 = signal[i], signal[i + 1]
    if abs(s1 - s0) < 1e-30:
        return sweep[i]
    frac = (threshold - s0) / (s1 - s0)
    return sweep[i] + frac * (sweep[i + 1] - sweep[i])


def make_fine_spice(orig_spice, out_spice, vlo, vhi, rawname):
    """Copy original spice file, replacing the coarse dc command with a fine one."""
    with open(orig_spice, 'r') as f:
        lines = f.readlines()

    with open(out_spice, 'w') as f:
        for line in lines:
            stripped = line.strip().lower()
            # Replace the coarse dc sweep command
            if stripped.startswith('dc vvdiff_pex') and 'vvdiff_pex' in stripped:
                f.write(f"dc vvdiff_pex {vlo} {vhi} 1m\n")
            elif stripped.startswith('write '):
                f.write(f"write {rawname}\n")
            # Skip the shell call to this script to avoid recursion
            elif 'find_comp_thresholds.py' in line:
                continue
            # Skip the source command for the inc file
            elif stripped.startswith('source comp_thresholds'):
                continue
            else:
                f.write(line)


def main():
    rawfile = sys.argv[1]
    spicefile = sys.argv[2]

    raw = RawRead(rawfile)
    steps = raw.get_steps()

    vdiff = np.real(np.array(raw.get_trace('v(v-sweep)').get_wave(steps[0])))

    v_on = get_trace(raw, [
        'v(xpix2x2.pix[0].on)',
        'v(xpix2x2.xpix[0].on)',
    ], steps[0])
    v_noff = get_trace(raw, [
        'v(xpix2x2.pix[0].noff)',
        'v(xpix2x2.xpix[0].noff)',
    ], steps[0])

    vdd = np.max(vdiff)
    vth = vdd / 2.0

    von_th = find_crossing(vdiff, np.real(v_on), vth)
    voff_th = find_crossing(vdiff, np.real(v_noff), vth)

    if von_th is None:
        print("WARNING: ON threshold not found, using full range")
        von_th = vdd / 2.0
    if voff_th is None:
        print("WARNING: OFF threshold not found, using full range")
        voff_th = vdd / 2.0

    von_lo = max(0, von_th - MARGIN)
    von_hi = min(vdd, von_th + MARGIN)
    voff_lo = max(0, voff_th - MARGIN)
    voff_hi = min(vdd, voff_th + MARGIN)

    print(f"ON  threshold ~ {von_th:.3f} V, fine sweep: [{von_lo:.3f}, {von_hi:.3f}]")
    print(f"OFF threshold ~ {voff_th:.3f} V, fine sweep: [{voff_lo:.3f}, {voff_hi:.3f}]")

    spice_dir = os.path.dirname(os.path.abspath(spicefile))

    # Generate and run ON fine sweep
    on_spice = os.path.join(spice_dir, 'tb_PixelComparators_dc_on.spice')
    make_fine_spice(spicefile, on_spice, von_lo, von_hi, 'tb_PixelComparators_dc_on.raw')
    print("Running ON fine sweep...")
    subprocess.run(['ngspice', '-b', on_spice], cwd=spice_dir)

    # Generate and run OFF fine sweep
    off_spice = os.path.join(spice_dir, 'tb_PixelComparators_dc_off.spice')
    make_fine_spice(spicefile, off_spice, voff_lo, voff_hi, 'tb_PixelComparators_dc_off.raw')
    print("Running OFF fine sweep...")
    subprocess.run(['ngspice', '-b', off_spice], cwd=spice_dir)

    print("Done! Fine sweep results in:")
    print(f"  tb_PixelComparators_dc_on.raw")
    print(f"  tb_PixelComparators_dc_off.raw")


if __name__ == '__main__':
    main()
