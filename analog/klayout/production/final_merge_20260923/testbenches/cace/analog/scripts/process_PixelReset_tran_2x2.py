#!/usr/bin/env python3
"""
Post-processing script for tb_PixelReset_tran_2x2.

Called from ngspice .control block:
  shell python3 process_PixelReset_tran_2x2.py <rawfile>

Reads Pix[0] internal nets from the 2x2 transient raw file and measures:
  - refractory_period: time for nRst to reach 0.9*VDD after pixRst release
  - delta_vdiff_ci: vdiff change from reset to post-nRst-high (charge injection)
  - leak_event_period: time from nRst at VDD to ON crossing VDD/2
  - vdiff_before_ci: vdiff during reset
  - vdiff_after_ci: vdiff after nRst reaches VDD

Tries PEX net names first (xpix2x2.pix[0].*), falls back to schematic names
(xpix2x2.xpix[0].*).
"""

import sys
import numpy as np
from spicelib import RawRead

RST1_END = 1e-3  # reset pulse ends at 1ms


def get_trace(raw, names, step):
    """Try multiple trace names, return first that works."""
    for name in names:
        try:
            return np.real(np.array(raw.get_trace(name).get_wave(step)))
        except Exception:
            continue
    return None


def find_crossing(t, v, threshold, t_start=0, rising=True):
    """Find time where signal crosses threshold."""
    mask = t >= t_start
    t_m, v_m = t[mask], v[mask]
    if rising:
        cross = np.where((v_m[:-1] < threshold) & (v_m[1:] >= threshold))[0]
    else:
        cross = np.where((v_m[:-1] > threshold) & (v_m[1:] <= threshold))[0]
    if len(cross) == 0:
        return None
    i = cross[0]
    dv = v_m[i + 1] - v_m[i]
    if abs(dv) < 1e-30:
        return t_m[i]
    frac = (threshold - v_m[i]) / dv
    return t_m[i] + frac * (t_m[i + 1] - t_m[i])


def main():
    rawfile = sys.argv[1]
    raw = RawRead(rawfile)
    steps = raw.get_steps()

    time = np.real(np.array(raw.get_trace('time').get_wave(steps[0])))

    # Get signals — try PEX paths first, then schematic paths
    v_nrst = get_trace(raw, [
        'v(xpix2x2.pix[0].nrst)',
        'v(xpix2x2.xpix[0].nrst)',
    ], steps[0])

    v_vdiff = get_trace(raw, [
        'v(xpix2x2.pix[0].vdiff)',
        'v(xpix2x2.xpix[0].vdiff)',
    ], steps[0])

    v_on = get_trace(raw, [
        'v(xpix2x2.pix[0].on)',
        'v(xpix2x2.xpix[0].on)',
    ], steps[0])

    v_vdd = get_trace(raw, ['v(vdd)'], steps[0])

    if v_vdd is None:
        print("ERROR: could not find v(vdd)")
        return

    XVDD = np.median(v_vdd)
    VDD_THRESH = 0.9 * XVDD
    VDD_HALF = XVDD / 2.0

    print(f"VDD = {XVDD:.3f} V")
    print()

    # --- Measurement 1: Refractory Period ---
    if v_nrst is not None:
        t_nrst_vdd = find_crossing(time, v_nrst, VDD_THRESH,
                                   t_start=RST1_END, rising=True)
        if t_nrst_vdd is not None:
            refractory_period = t_nrst_vdd - RST1_END
            print(f"=== Refractory Period ===")
            print(f"  nRst reaches 0.9*VDD at t = {t_nrst_vdd*1e3:.4f} ms")
            print(f"  Refractory period = {refractory_period*1e6:.2f} us")
        else:
            t_nrst_vdd = None
            print("WARNING: nRst never reaches 0.9*VDD after reset release")
    else:
        t_nrst_vdd = None
        print("WARNING: nRst signal not found")

    print()

    # --- Measurement 2: Charge Injection on Vdiff ---
    if v_vdiff is not None:
        # Vdiff during reset (last 10% of reset pulse)
        rst_window = (time >= 0.9 * RST1_END) & (time <= RST1_END)
        vdiff_before = np.mean(v_vdiff[rst_window]) if np.any(rst_window) else v_vdiff[0]

        # Vdiff after nRst reaches VDD (100us window)
        if t_nrst_vdd is not None:
            post_window = (time >= t_nrst_vdd) & (time <= t_nrst_vdd + 100e-6)
            if not np.any(post_window):
                post_window = (time >= t_nrst_vdd) & (time <= t_nrst_vdd + 1e-3)
            vdiff_after = np.mean(v_vdiff[post_window]) if np.any(post_window) else vdiff_before
        else:
            vdiff_after = vdiff_before

        delta_vdiff_ci = vdiff_after - vdiff_before

        print(f"=== Charge Injection (Vdiff) ===")
        print(f"  Vdiff during reset   = {vdiff_before*1e3:.2f} mV")
        print(f"  Vdiff after nRst high = {vdiff_after*1e3:.2f} mV")
        print(f"  Delta Vdiff (CI)     = {delta_vdiff_ci*1e3:.2f} mV")
    else:
        print("WARNING: vdiff signal not found")

    print()

    # --- Measurement 3: Leak Event Period (ON fires) ---
    if v_on is not None:
        t_on_fire = find_crossing(time, v_on, VDD_HALF,
                                  t_start=RST1_END, rising=True)
        if t_on_fire is not None:
            print(f"=== ON Event ===")
            print(f"  ON fires at t = {t_on_fire*1e3:.4f} ms")
            if t_nrst_vdd is not None:
                leak_period = t_on_fire - t_nrst_vdd
                print(f"  Leak event period = {leak_period*1e3:.4f} ms "
                      f"(from nRst@VDD to ON fire)")
            else:
                print(f"  Leak event period = {(t_on_fire - RST1_END)*1e3:.4f} ms "
                      f"(from reset release to ON fire)")
        else:
            print("ON comparator never fires during simulation")
    else:
        print("WARNING: ON signal not found")

    print()

    # --- Measurement 4: OFF event ---
    v_noff = get_trace(raw, [
        'v(xpix2x2.pix[0].noff)',
        'v(xpix2x2.xpix[0].noff)',
    ], steps[0])

    if v_noff is not None:
        # OFF fires when nOFF goes LOW (falling below VDD/2)
        t_off_fire = find_crossing(time, v_noff, VDD_HALF,
                                   t_start=RST1_END, rising=False)
        if t_off_fire is not None:
            print(f"=== OFF Event ===")
            print(f"  OFF fires at t = {t_off_fire*1e3:.4f} ms")
        else:
            print("OFF comparator never fires during simulation")
    else:
        print("WARNING: nOFF signal not found")

    print()
    print("=== Summary ===")
    print(f"  Simulation time: {time[0]:.6f} to {time[-1]:.3f} s")
    print(f"  Total data points: {len(time)}")


if __name__ == '__main__':
    main()
