#!/usr/bin/env python3
"""
CACE processing script for tb_PixelComparators_dc Monte Carlo.

Same measurements as tb_PixelComparators_dc.py but looks up cross-block
parameters from the equivalent MC trial number (run_N) in pixel_ac_gain_mc
and reset_tran_mc instead of matching by corner/temperature/vdd.

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


def lookup_mc_result(runs_dir, param_name, var_names, run_n):
    """
    Look up results from a MC run by trial number (run_N).

    Searches newest runs first for param_name directory containing run_N.
    """
    var_orders = {
        'pixel_ac_gain_mc': [
            'vpr_dc', 'vsf_dc', 'pr_gain_dc', 'sf_gain_dc',
            'champ_gain_mid', 'champ_ol_gain_mid',
            'f3db_vpr', 'f3db_sf', 'f3db_champ_lp', 'f3db_champ_hp',
        ],
        'reset_tran_mc': [
            'refractory_period', 'delta_vdiff_ci', 'leak_event_period',
            'min_reset_time', 'mrst_id', 'mrst_ibd', 'mrst_ibs',
            'vdiff_before_ci', 'vdiff_after_ci',
        ],
    }

    if param_name not in var_orders:
        print(f"  [lookup_mc] Unknown parameter: {param_name}", file=sys.stderr)
        return None

    order = var_orders[param_name]
    var_indices = {}
    for vn in var_names:
        if vn in order:
            var_indices[vn] = order.index(vn)
        else:
            print(f"  [lookup_mc] Variable {vn} not in {param_name}",
                  file=sys.stderr)
            return None

    run_dirs = sorted(glob.glob(os.path.join(runs_dir, 'RUN_*')), reverse=True)

    for run_dir in run_dirs:
        param_dir = os.path.join(run_dir, 'parameters', param_name)
        if not os.path.isdir(param_dir):
            continue

        # MC collated runs have nested structure: param_name/run_0/run_N/
        # Try nested first, then flat
        for parent in sorted(glob.glob(os.path.join(param_dir, 'run_*'))):
            sub_path = os.path.join(parent, f'run_{run_n}')
            if os.path.isdir(sub_path):
                data_files = glob.glob(os.path.join(sub_path, '*.data'))
                if data_files:
                    with open(data_files[0]) as f:
                        values = f.read().strip().split()
                    if len(values) == len(order):
                        result = {}
                        for vn, idx in var_indices.items():
                            result[vn] = float(values[idx])
                        return result

        # Flat structure: param_name/run_N/
        sub_path = os.path.join(param_dir, f'run_{run_n}')
        if os.path.isdir(sub_path):
            data_files = glob.glob(os.path.join(sub_path, '*.data'))
            if data_files:
                with open(data_files[0]) as f:
                    values = f.read().strip().split()
                if len(values) == len(order):
                    result = {}
                    for vn, idx in var_indices.items():
                        result[vn] = float(values[idx])
                    return result

    return None


def main():
    simpath = sys.argv[1]
    filename = sys.argv[2]
    simnumber = sys.argv[3]

    # Read own conditions
    cond_file = os.path.join(simpath, 'conditions.yaml')
    with open(cond_file) as f:
        cond = yaml.safe_load(f)

    vdd = float(cond.get('vdd', '1.8'))
    run_n = str(cond.get('N', simnumber))

    root_dir = cond.get('root', os.path.join(simpath, '..', '..', '..', '..'))
    runs_dir = os.path.join(root_dir, 'runs')

    # --- Read DC sweep raw file ---
    rawfile = os.path.join(simpath, f'{filename}_{simnumber}.raw')
    raw = RawRead(rawfile)
    steps = raw.get_steps()

    vdiff = np.real(np.array(raw.get_trace('v(vdiff)').get_wave(steps[0])))
    v_on = np.real(np.array(raw.get_trace('v(on)').get_wave(steps[0])))
    v_noff = np.real(np.array(raw.get_trace('v(noff)').get_wave(steps[0])))

    threshold = vdd / 2.0

    vthresh_on = find_crossing(vdiff, v_on, threshold, direction='falling')
    if vthresh_on is None:
        vthresh_on = 0.0
        print(f"  [WARN] ON threshold not found", file=sys.stderr)

    vthresh_off = find_crossing(vdiff, v_noff, threshold, direction='falling')
    if vthresh_off is None:
        vthresh_off = 0.0
        print(f"  [WARN] OFF threshold not found", file=sys.stderr)

    # --- Look up cross-block MC parameters by trial number ---
    on_thresh_input = 0.0
    off_thresh_input = 0.0

    gain_data = lookup_mc_result(
        runs_dir, 'pixel_ac_gain_mc',
        ['vsf_dc', 'champ_gain_mid'],
        run_n,
    )

    reset_data = lookup_mc_result(
        runs_dir, 'reset_tran_mc',
        ['vdiff_after_ci'],
        run_n,
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
            print(f"  [WARN] No matching pixel_ac_gain_mc run_{run_n}",
                  file=sys.stderr)
        if not reset_data:
            print(f"  [WARN] No matching reset_tran_mc run_{run_n}",
                  file=sys.stderr)

    # Write results
    outfile = os.path.join(simpath, f'{filename}_{simnumber}.data')
    with open(outfile, 'w') as f:
        f.write(f"{vthresh_on} {vthresh_off} {on_thresh_input} {off_thresh_input}")


if __name__ == '__main__':
    main()
