#!/usr/bin/env python3
"""
CACE processing script for tb_PixelComparators_dc_2x2.

Measures ON/OFF thresholds from DC sweep of 2x2 pixel array (PEX),
then calculates input-referred thresholds using results from
PixelGainAC_2x2 and PixelResetTran_2x2 runs matched by conditions.

Uses Bsource probe monitors (on_mon, noff_mon) for comparator outputs,
and v(v-sweep) for the swept vdiff voltage.

Outputs:
  vthresh_on       — Vdiff where ON crosses vdd/2 (falling) [V]
  vthresh_off      — Vdiff where nOFF crosses vdd/2 (falling) [V]
  on_thresh_input  — ON threshold referred to input [dimensionless]
  off_thresh_input — OFF threshold referred to input [dimensionless]
"""

import sys
import os
import glob
import numpy as np
import yaml
from spicelib import RawRead


def get_trace(raw, names, step):
    """Try multiple trace names, return first that works."""
    for name in names:
        try:
            return np.real(np.array(raw.get_trace(name).get_wave(step)))
        except Exception:
            continue
    return None


def find_crossing(x, y, threshold, direction='rising'):
    """Find x value where y crosses threshold."""
    if direction == 'rising':
        below = y < threshold
        crossings = np.where(below[:-1] & ~below[1:])[0]
    else:  # falling
        above = y > threshold
        crossings = np.where(above[:-1] & ~above[1:])[0]

    if len(crossings) == 0:
        return None

    i = crossings[0]
    y0, y1 = y[i], y[i + 1]
    if abs(y1 - y0) < 1e-30:
        return x[i]
    frac = (threshold - y0) / (y1 - y0)
    return x[i] + frac * (x[i + 1] - x[i])


def lookup_cace_result(runs_dir, param_name, var_names, match_conds):
    """
    Search CACE run directories for matching conditions and return
    the requested variables from the .data file.
    """
    var_orders = {
        'pixel_ac_gain': [
            'vpr_dc', 'vsf_dc', 'pr_gain_dc', 'sf_gain_dc',
            'champ_gain_mid', 'champ_ol_gain_mid',
            'f3db_vpr', 'f3db_sf', 'f3db_champ_lp', 'f3db_champ_hp',
        ],
        'reset_tran': [
            'refractory_period', 'delta_vdiff_ci', 'leak_event_period',
            'min_reset_time', 'vdiff_before_ci', 'vdiff_after_ci',
        ],
    }

    if param_name not in var_orders:
        print(f"  [lookup] Unknown parameter: {param_name}", file=sys.stderr)
        return None

    order = var_orders[param_name]
    var_indices = {}
    for vn in var_names:
        if vn in order:
            var_indices[vn] = order.index(vn)
        else:
            print(f"  [lookup] Variable {vn} not in {param_name}", file=sys.stderr)
            return None

    run_dirs = sorted(glob.glob(os.path.join(runs_dir, 'RUN_*')), reverse=True)

    for run_dir in run_dirs:
        param_dir = os.path.join(run_dir, 'parameters', param_name)
        if not os.path.isdir(param_dir):
            continue

        for sub in sorted(os.listdir(param_dir)):
            sub_path = os.path.join(param_dir, sub)
            if not os.path.isdir(sub_path) or not sub.startswith('run_'):
                continue

            cond_file = os.path.join(sub_path, 'conditions.yaml')
            if not os.path.exists(cond_file):
                continue

            with open(cond_file) as f:
                cond = yaml.safe_load(f)

            match = True
            for key, val in match_conds.items():
                cond_val = str(cond.get(key, ''))
                if cond_val != str(val):
                    match = False
                    break

            if not match:
                continue

            data_files = glob.glob(os.path.join(sub_path, '*.data'))
            if not data_files:
                continue

            with open(data_files[0]) as f:
                values = f.read().strip().split()

            if len(values) != len(order):
                continue

            result = {}
            for vn, idx in var_indices.items():
                result[vn] = float(values[idx])

            return result

    return None


def main():
    simpath = sys.argv[1]
    filename = sys.argv[2]
    simnumber = sys.argv[3]

    cond_file = os.path.join(simpath, 'conditions.yaml')
    with open(cond_file) as f:
        cond = yaml.safe_load(f)

    corner = str(cond.get('corner', 'tt'))
    temperature = str(cond.get('temperature', '27'))
    vdd_str = str(cond.get('vdd', '1.8'))
    vdd = float(vdd_str)

    match_conds = {
        'corner': corner,
        'temperature': temperature,
        'vdd': vdd_str,
    }

    root_dir = cond.get('root', os.path.join(simpath, '..', '..', '..', '..'))
    runs_dir = os.path.join(root_dir, 'runs')

    rawfile = os.path.join(simpath, f'{filename}_{simnumber}.raw')
    raw = RawRead(rawfile)
    steps = raw.get_steps()

    # Sweep variable — Vvdiff_pex DC sweep
    vdiff = get_trace(raw, ['v(v-sweep)', 'v(xpix2x2.pix[0].vdiff)'], steps[0])
    if vdiff is None:
        # Fallback: reconstruct from raw sweep index
        vdiff = np.real(np.array(raw.get_trace('v(vdiff)').get_wave(steps[0])))

    # Comparator outputs via Bsource probes
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

    if v_on is None or v_noff is None:
        print("  [ERROR] Could not find ON or nOFF traces", file=sys.stderr)
        outfile = os.path.join(simpath, f'{filename}_{simnumber}.data')
        with open(outfile, 'w') as f:
            f.write("0 0 0 0")
        return

    threshold = vdd / 2.0

    vthresh_on = find_crossing(vdiff, v_on, threshold, direction='falling')
    if vthresh_on is None:
        vthresh_on = 0.0
        print(f"  [WARN] ON threshold not found", file=sys.stderr)

    vthresh_off = find_crossing(vdiff, v_noff, threshold, direction='falling')
    if vthresh_off is None:
        vthresh_off = 0.0
        print(f"  [WARN] OFF threshold not found", file=sys.stderr)

    on_thresh_input = 0.0
    off_thresh_input = 0.0

    gain_data = lookup_cace_result(
        runs_dir, 'pixel_ac_gain',
        ['vsf_dc', 'champ_gain_mid'],
        match_conds,
    )

    reset_data = lookup_cace_result(
        runs_dir, 'reset_tran',
        ['vdiff_after_ci'],
        match_conds,
    )

    if gain_data and reset_data:
        vsf_dc = gain_data['vsf_dc']
        champ_gain_mid = gain_data['champ_gain_mid']
        vdiff_after_ci = reset_data['vdiff_after_ci']

        denom = vsf_dc * champ_gain_mid
        if abs(denom) > 1e-30:
            on_thresh_input = -(vthresh_on - vdiff_after_ci) / denom
            off_thresh_input = (vthresh_off - vdiff_after_ci) / denom
        else:
            print(f"  [WARN] vsf_dc*champ_gain_mid ~ 0", file=sys.stderr)
    else:
        if not gain_data:
            print(f"  [WARN] No matching PixelGainAC_2x2 run for {match_conds}",
                  file=sys.stderr)
        if not reset_data:
            print(f"  [WARN] No matching PixelResetTran_2x2 run for {match_conds}",
                  file=sys.stderr)

    outfile = os.path.join(simpath, f'{filename}_{simnumber}.data')
    with open(outfile, 'w') as f:
        f.write(f"{vthresh_on} {vthresh_off} {on_thresh_input} {off_thresh_input}")


if __name__ == '__main__':
    main()
