#!/usr/bin/env python3
"""
CACE processing script for tb_PixelAutoReadLine_tran_2x2.

Reads transient simulation results from 2x2 pixel array auto-readLine
event-driven testbench. Measures event count, timing, readLine swing,
and reset recovery.

Uses Bsource probe monitors (on_mon, noff_mon, vdiff_mon) for
internal node access, with fallback to PEX hierarchical names.

Outputs:
  event_count         — Total number of ON/OFF events detected [dimensionless]
  first_event_time    — Time of first event [s]
  mean_event_period   — Mean time between consecutive events [s]
  readline_swing      — Peak readLine voltage swing during read [V]
  reset_recovery_time — Time for vdiff to settle after reset [s]
"""

import sys
import numpy as np
from spicelib import RawRead


def get_trace(raw, names, step):
    """Try multiple trace names, return first that works."""
    for name in names:
        try:
            return np.real(np.array(raw.get_trace(name).get_wave(step)))
        except Exception:
            continue
    return None


def find_crossings(t, v, threshold, t_start=0, rising=True):
    """Find all times where signal crosses threshold."""
    mask = t >= t_start
    t_m, v_m = t[mask], v[mask]
    if rising:
        idxs = np.where((v_m[:-1] < threshold) & (v_m[1:] >= threshold))[0]
    else:
        idxs = np.where((v_m[:-1] > threshold) & (v_m[1:] <= threshold))[0]

    times = []
    for i in idxs:
        dv = v_m[i + 1] - v_m[i]
        if abs(dv) < 1e-30:
            times.append(t_m[i])
        else:
            frac = (threshold - v_m[i]) / dv
            times.append(t_m[i] + frac * (t_m[i + 1] - t_m[i]))
    return np.array(times)


def main():
    simpath = sys.argv[1]
    filename = sys.argv[2]
    simnumber = sys.argv[3]

    rawfile = '{}/{}_{}.raw'.format(simpath, filename, simnumber)
    raw = RawRead(rawfile)
    steps = raw.get_steps()

    time = np.real(np.array(raw.get_trace('time').get_wave(steps[0])))

    v_on = get_trace(raw, [
        'v(on_mon)',
        'v(xpix2x2.pix[0].on)',
        'v(xpix2x2.xpix[0].on)',
    ], steps[0])

    v_noff = get_trace(raw, [
        'v(noff_mon)',
        'v(xpix2x2.pix[0].noff)',
        'v(xpix2x2.xpix[0].noff)',
    ], steps[0])

    v_vdiff = get_trace(raw, [
        'v(vdiff_mon)',
        'v(xpix2x2.pix[0].vdiff)',
        'v(xpix2x2.xpix[0].vdiff)',
    ], steps[0])

    v_readline = get_trace(raw, [
        'v(readline)',
        'v(readline0)',
    ], steps[0])

    v_vdd = get_trace(raw, ['v(vdd)'], steps[0])

    if v_vdd is None:
        print("  [ERROR] could not find v(vdd)", file=sys.stderr)
        outfile = '{}/{}_{}.data'.format(simpath, filename, simnumber)
        with open(outfile, 'w') as f:
            f.write("0 0 0 0 0")
        return

    XVDD = np.median(v_vdd)
    VDD_THRESH_ON = 0.9 * XVDD
    VDD_THRESH_NOFF = 0.1 * XVDD
    SETTLE_TIME = 10e-3  # skip first 10ms settling

    # --- Find all events ---
    event_times = []

    if v_on is not None:
        on_times = find_crossings(time, v_on, VDD_THRESH_ON,
                                  t_start=SETTLE_TIME, rising=True)
        event_times.extend(on_times.tolist())

    if v_noff is not None:
        off_times = find_crossings(time, v_noff, VDD_THRESH_NOFF,
                                   t_start=SETTLE_TIME, rising=False)
        event_times.extend(off_times.tolist())

    event_times = sorted(event_times)

    # Remove duplicate events closer than 50us (same event detected twice)
    if len(event_times) > 1:
        filtered = [event_times[0]]
        for t_ev in event_times[1:]:
            if t_ev - filtered[-1] > 50e-6:
                filtered.append(t_ev)
        event_times = filtered

    event_count = len(event_times)
    first_event_time = event_times[0] if event_count > 0 else 0.0

    if event_count >= 2:
        periods = np.diff(event_times)
        mean_event_period = np.mean(periods)
    else:
        mean_event_period = 0.0

    # --- ReadLine swing ---
    readline_swing = 0.0
    if v_readline is not None:
        # ReadLine is normally pulled high; swing = VDD - min(readLine)
        readline_swing = XVDD - np.min(v_readline)

    # --- Reset recovery time ---
    # Find vdiff settling after last reset event
    reset_recovery_time = 0.0
    if v_vdiff is not None and event_count > 0:
        # Look at vdiff after the last event + readout sequence (~105us)
        t_last_reset = event_times[-1] + 105e-6
        mask = (time >= t_last_reset) & (time <= t_last_reset + 1e-3)
        if np.sum(mask) > 2:
            t_m = time[mask]
            v_m = v_vdiff[mask]
            v_final = v_m[-1]
            band = max(abs(v_final * 0.01), 1e-6 * 0.01)
            outside = np.where(np.abs(v_m - v_final) > band)[0]
            if len(outside) > 0 and outside[-1] + 1 < len(t_m):
                reset_recovery_time = t_m[outside[-1] + 1] - t_last_reset
            elif len(outside) == 0:
                reset_recovery_time = 0.0
            else:
                reset_recovery_time = t_m[-1] - t_last_reset

    # Write results in YAML variables order
    outfile = '{}/{}_{}.data'.format(simpath, filename, simnumber)
    with open(outfile, 'w') as f:
        f.write("{} {} {} {} {}".format(
            event_count, first_event_time, mean_event_period,
            readline_swing, reset_recovery_time))


if __name__ == '__main__':
    main()
