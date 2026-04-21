#!/usr/bin/env python3
"""
CACE processing script for tb_PixelResetTran.

Outputs in base SI units (CACE converts to display units):
  refractory_period  — time for nRst to reach 0.9*vdd after pixRst release [s]
  delta_vdiff_ci     — vdiff change from reset to post-nRst-high [V]
  leak_event_period  — time from nRst at vdd to ON crossing vdd/2 [s]
  min_reset_time     — vdiff settling time (1%) during second reset [s]
  mrst_id            — Mrst drain current during normal operation [A]
  mrst_ibd           — Mrst bulk-drain current during normal operation [A]
  mrst_ibs           — Mrst bulk-source current during normal operation [A]
  vdiff_before_ci     — vdiff during reset (before charge injection) [V]
  vdiff_after_ci      — vdiff after nRst reaches vdd (after charge injection) [V]
"""

import sys
import numpy as np
from spicelib import RawRead

RST1_END = 1e-3
SETTLE_PCT = 0.01


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


def get_value_at(t, v, t_target):
    """Interpolate v at t_target."""
    i = np.searchsorted(t, t_target)
    if i == 0:
        return v[0]
    if i >= len(t):
        return v[-1]
    dt = t[i] - t[i - 1]
    if dt == 0:
        return v[i]
    frac = (t_target - t[i - 1]) / dt
    return v[i - 1] + frac * (v[i] - v[i - 1])


def main():
    simpath = sys.argv[1]
    filename = sys.argv[2]
    simnumber = sys.argv[3]

    rawfile = '{}/{}_{}.raw'.format(simpath, filename, simnumber)
    raw = RawRead(rawfile)
    steps = raw.get_steps()

    time = np.real(np.array(raw.get_trace('time').get_wave(steps[0])))
    v_nrst = np.real(np.array(raw.get_trace('v(nrst)').get_wave(steps[0])))
    v_vdiff = np.real(np.array(raw.get_trace('v(vdiff)').get_wave(steps[0])))
    v_pixrst = np.real(np.array(raw.get_trace('v(pixrst)').get_wave(steps[0])))
    v_vdd = np.real(np.array(raw.get_trace('v(vdd)').get_wave(steps[0])))

    try:
        v_on = np.real(np.array(raw.get_trace('v(on)').get_wave(steps[0])))
    except Exception:
        v_on = None

    # Read Mrst device currents (ngspice wraps saved device params in i(...))
    try:
        mrst_id_vec = np.real(np.array(
            raw.get_trace('i(@m.xchamp.xmrst.msky130_fd_pr__pfet_01v8_hvt[id])').get_wave(steps[0])))
    except Exception:
        mrst_id_vec = None
    try:
        mrst_ibd_vec = np.real(np.array(
            raw.get_trace('i(@m.xchamp.xmrst.msky130_fd_pr__pfet_01v8_hvt[ibd])').get_wave(steps[0])))
    except Exception:
        mrst_ibd_vec = None
    try:
        mrst_ibs_vec = np.real(np.array(
            raw.get_trace('i(@m.xchamp.xmrst.msky130_fd_pr__pfet_01v8_hvt[ibs])').get_wave(steps[0])))
    except Exception:
        mrst_ibs_vec = None

    XVDD = np.median(v_vdd)
    VDD_THRESH = 0.9 * XVDD
    VDD_HALF = XVDD / 2

    # --- Measurement 1: Refractory Period [s] ---
    t_nrst_vdd = find_crossing(time, v_nrst, VDD_THRESH, t_start=RST1_END, rising=True)
    if t_nrst_vdd is not None:
        refractory_period = t_nrst_vdd - RST1_END
    else:
        refractory_period = 0.0

    # --- Measurement 2: Delta Vdiff Charge Injection [V] ---
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
        t_on_fire = find_crossing(time, v_on, VDD_HALF, t_start=t_nrst_vdd, rising=True)

    if t_on_fire is not None and t_nrst_vdd is not None:
        leak_event_period = t_on_fire - t_nrst_vdd
    else:
        leak_event_period = 0.0

    # --- Measurement 4: Min Reset Time [s] ---
    # Find second pixRst rise (the alter-driven one) — always present
    t_rst2_start = find_crossing(time, v_pixrst, VDD_HALF,
                                 t_start=RST1_END + 1e-6, rising=True)

    if t_rst2_start is not None:
        t_rst2_end = find_crossing(time, v_pixrst, VDD_HALF,
                                   t_start=t_rst2_start + 1e-6, rising=False)
        if t_rst2_end is None:
            t_rst2_end = time[-1]
        t_settle = find_settling_time(time, v_vdiff, t_rst2_start, t_rst2_end)
        min_reset_time = t_settle if t_settle is not None else 0.0
    else:
        min_reset_time = 0.0

    # --- Measurement 5-7: Mrst currents during normal operation ---
    # "Normal operation" = nRst at vdd, ON low, after initial reset release
    # Sample at midpoint between nRst reaching vdd and ON firing
    if t_nrst_vdd is not None and t_on_fire is not None:
        t_sample = (t_nrst_vdd + t_on_fire) / 2
    elif t_nrst_vdd is not None:
        t_sample = t_nrst_vdd + 1e-3  # 1ms after nRst reaches vdd
    else:
        t_sample = RST1_END + 1e-3

    mrst_id = get_value_at(time, mrst_id_vec, t_sample) if mrst_id_vec is not None else 0.0
    mrst_ibd = get_value_at(time, mrst_ibd_vec, t_sample) if mrst_ibd_vec is not None else 0.0
    mrst_ibs = get_value_at(time, mrst_ibs_vec, t_sample) if mrst_ibs_vec is not None else 0.0

    # Write results in YAML variables order
    outfile = '{}/{}_{}.data'.format(simpath, filename, simnumber)
    with open(outfile, 'w') as f:
        f.write("{} {} {} {} {} {} {} {} {}".format(
            refractory_period, delta_vdiff_ci, leak_event_period,
            min_reset_time, mrst_id, mrst_ibd, mrst_ibs,
            vdiff_during_rst, vdiff_after))


if __name__ == '__main__':
    main()
