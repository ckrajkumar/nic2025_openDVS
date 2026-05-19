#!/usr/bin/env python3
"""
CACE processing script for tb_PixelResetTran_2x2.

Reads transient simulation results from 2x2 pixel array (PEX).
Uses Bsource probe monitors (on_mon, nrst_mon, vdiff_mon) for
internal node access, with fallback to PEX hierarchical names.

Outputs in base SI units (CACE converts to display units):
  refractory_period  — time for nRst to reach 0.9*vdd after pixRst release [s]
  delta_vdiff_ci     — vdiff change from reset to post-nRst-high [V]
  leak_event_period  — time from nRst at vdd to ON crossing vdd/2 [s]
  min_reset_time     — vdiff settling time (1%) during second reset [s]
  vdiff_before_ci    — vdiff during reset (before charge injection) [V]
  vdiff_after_ci     — vdiff after nRst reaches vdd (after charge injection) [V]
"""

import sys
import numpy as np
from spicelib import RawRead

RST1_END = 1e-3
SETTLE_PCT = 0.01


def get_trace(raw, names, step):
    """Try multiple trace names, return first that works."""
    for name in names:
        try:
            return np.real(np.array(raw.get_trace(name).get_wave(step)))
        except Exception:
            continue
    return None


def find_crossing(t, v, threshold, t_start=0, rising=True):
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


def find_settling_time(t, v, t_start, t_end, pct=SETTLE_PCT):
    mask = (t >= t_start) & (t <= t_end)
    t_m, v_m = t[mask], v[mask]
    if len(t_m) < 2:
        return None
    v_final = v_m[-1]
    band = abs(v_final * pct) if abs(v_final) > 1e-12 else 1e-6 * pct
    outside = np.where(np.abs(v_m - v_final) > band)[0]
    if len(outside) == 0:
        return 0.0
    last_outside = outside[-1]
    if last_outside + 1 >= len(t_m):
        return t_m[-1] - t_start
    return t_m[last_outside + 1] - t_start


def main():
    simpath = sys.argv[1]
    filename = sys.argv[2]
    simnumber = sys.argv[3]

    rawfile = '{}/{}_{}.raw'.format(simpath, filename, simnumber)
    raw = RawRead(rawfile)
    steps = raw.get_steps()

    time = np.real(np.array(raw.get_trace('time').get_wave(steps[0])))

    v_nrst = get_trace(raw, [
        'v(nrst_mon)',
        'v(xpix2x2.pix[0].nrst)',
        'v(xpix2x2.xpix[0].nrst)',
    ], steps[0])

    v_vdiff = get_trace(raw, [
        'v(vdiff_mon)',
        'v(xpix2x2.pix[0].vdiff)',
        'v(xpix2x2.xpix[0].vdiff)',
    ], steps[0])

    v_on = get_trace(raw, [
        'v(on_mon)',
        'v(xpix2x2.pix[0].on)',
        'v(xpix2x2.xpix[0].on)',
    ], steps[0])

    v_pixrst = get_trace(raw, ['v(pixrst)'], steps[0])
    v_vdd = get_trace(raw, ['v(vdd)'], steps[0])

    if v_vdd is None:
        print("  [ERROR] could not find v(vdd)", file=sys.stderr)
        outfile = '{}/{}_{}.data'.format(simpath, filename, simnumber)
        with open(outfile, 'w') as f:
            f.write("0 0 0 0 0 0")
        return

    XVDD = np.median(v_vdd)
    VDD_THRESH = 0.9 * XVDD
    VDD_HALF = XVDD / 2

    # --- Measurement 1: Refractory Period [s] ---
    t_nrst_vdd = None
    if v_nrst is not None:
        t_nrst_vdd = find_crossing(time, v_nrst, VDD_THRESH,
                                   t_start=RST1_END, rising=True)
    refractory_period = (t_nrst_vdd - RST1_END) if t_nrst_vdd is not None else 0.0

    # --- Measurement 2: Delta Vdiff Charge Injection [V] ---
    vdiff_during_rst = 0.0
    vdiff_after = 0.0
    if v_vdiff is not None:
        rst_window = (time >= 0.9 * RST1_END) & (time <= RST1_END)
        vdiff_during_rst = np.mean(v_vdiff[rst_window]) if np.any(rst_window) else v_vdiff[0]

        if t_nrst_vdd is not None:
            post_window = (time >= t_nrst_vdd) & (time <= t_nrst_vdd + 100e-6)
            if not np.any(post_window):
                post_window = (time >= t_nrst_vdd) & (time <= t_nrst_vdd + 1e-3)
            vdiff_after = np.mean(v_vdiff[post_window]) if np.any(post_window) else vdiff_during_rst
        else:
            vdiff_after = vdiff_during_rst

    delta_vdiff_ci = vdiff_after - vdiff_during_rst

    # --- Measurement 3: Leak Event Period [s] ---
    t_on_fire = None
    if v_on is not None and t_nrst_vdd is not None:
        t_on_fire = find_crossing(time, v_on, VDD_HALF,
                                  t_start=t_nrst_vdd, rising=True)

    if t_on_fire is not None and t_nrst_vdd is not None:
        leak_event_period = t_on_fire - t_nrst_vdd
    else:
        leak_event_period = 0.0

    # --- Measurement 4: Min Reset Time [s] ---
    min_reset_time = 0.0
    if v_pixrst is not None and v_vdiff is not None:
        t_rst2_start = find_crossing(time, v_pixrst, VDD_HALF,
                                     t_start=RST1_END + 1e-6, rising=True)
        if t_rst2_start is not None:
            t_rst2_end = find_crossing(time, v_pixrst, VDD_HALF,
                                       t_start=t_rst2_start + 1e-6, rising=False)
            if t_rst2_end is None:
                t_rst2_end = time[-1]
            t_settle = find_settling_time(time, v_vdiff, t_rst2_start, t_rst2_end)
            min_reset_time = t_settle if t_settle is not None else 0.0

    # Write results in YAML variables order
    outfile = '{}/{}_{}.data'.format(simpath, filename, simnumber)
    with open(outfile, 'w') as f:
        f.write("{} {} {} {} {} {}".format(
            refractory_period, delta_vdiff_ci, leak_event_period,
            min_reset_time, vdiff_during_rst, vdiff_after))


if __name__ == '__main__':
    main()
