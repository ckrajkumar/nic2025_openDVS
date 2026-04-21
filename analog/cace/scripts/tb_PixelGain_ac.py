#!/usr/bin/env python3
"""
CACE processing script for tb_PixelGain_ac.

Outputs in base SI units (CACE converts to display units):
  vpr_dc          — DC level of |V(vpr)| [V/A]
  vsf_dc          — DC level of |V(vsf)| [V/A]
  pr_gain_dc      — PR DC gain (vpr/vpd) [dimensionless]
  sf_gain_dc      — SF DC gain (vsf/vpr) [dimensionless]
  champ_gain_mid  — ChAmp gain at 5Hz (vdiff/vsf) [dimensionless]
  champ_ol_gain_mid — ChAmp open-loop gain at 5Hz (vdiff/vd) [dimensionless]
  f3db_vpr        — 3dB cutoff of |V(vpr)| [Hz]
  f3db_sf         — 3dB cutoff of SF TF [Hz]
  f3db_champ_lp   — LP 3dB cutoff of ChAmp [Hz]
  f3db_champ_hp   — HP 3dB corner of ChAmp [Hz]
"""

import sys
import numpy as np
from spicelib import RawRead

MIDFREQ = 5.0  # Hz


def interp_at_freq(freq, mag, f_target):
    """Interpolate magnitude at a target frequency (log-spaced)."""
    i = np.searchsorted(freq, f_target)
    if i == 0:
        return mag[0]
    if i >= len(freq):
        return mag[-1]
    f0, f1 = freq[i - 1], freq[i]
    if f1 == f0:
        return mag[i]
    frac = (np.log10(f_target) - np.log10(f0)) / (np.log10(f1) - np.log10(f0))
    return mag[i - 1] + frac * (mag[i] - mag[i - 1])


def find_3db_crossing(freq, mag_db, ref_db, direction='falling'):
    """Find frequency where mag_db crosses ref_db - 3."""
    threshold = ref_db - 3.0

    if direction == 'falling':
        above = mag_db >= threshold
        crossings = np.where(above[:-1] & ~above[1:])[0]
        if len(crossings) == 0:
            return None
        i = crossings[0]
    elif direction == 'rising':
        below = mag_db < threshold
        crossings = np.where(below[:-1] & ~below[1:])[0]
        if len(crossings) == 0:
            return None
        i = crossings[-1]
    else:
        return None

    db0, db1 = mag_db[i], mag_db[i + 1]
    if abs(db1 - db0) < 1e-30:
        return freq[i]
    frac = (threshold - db0) / (db1 - db0)
    log_f = np.log10(freq[i]) + frac * (np.log10(freq[i + 1]) - np.log10(freq[i]))
    return 10 ** log_f


def main():
    simpath = sys.argv[1]
    filename = sys.argv[2]
    simnumber = sys.argv[3]

    rawfile = '{}/{}_{}.raw'.format(simpath, filename, simnumber)
    raw = RawRead(rawfile)
    steps = raw.get_steps()

    freq = np.abs(np.array(raw.get_trace('frequency').get_wave(steps[0])))

    v_vpd = np.array(raw.get_trace('v(vpd)').get_wave(steps[0]))
    v_vpr = np.array(raw.get_trace('v(vpr)').get_wave(steps[0]))
    v_vsf = np.array(raw.get_trace('v(vsf)').get_wave(steps[0]))
    v_vdiff = np.array(raw.get_trace('v(vdiff)').get_wave(steps[0]))
    v_vd = np.array(raw.get_trace('v(xchamp.vd)').get_wave(steps[0]))

    mag_vpd = np.abs(v_vpd)
    mag_vpr = np.abs(v_vpr)
    mag_vsf = np.abs(v_vsf)
    mag_vdiff = np.abs(v_vdiff)
    mag_vd = np.abs(v_vd)

    # --- DC measurements (lowest frequency point) ---
    vpr_dc = mag_vpr[0]
    vpd_dc = mag_vpd[0]
    vsf_dc = mag_vsf[0]

    pr_gain_dc = vpr_dc / vpd_dc if vpd_dc > 0 else 0.0
    sf_gain_dc = vsf_dc / mag_vpr[0] if mag_vpr[0] > 0 else 0.0

    # --- Mid-frequency measurements ---
    vdiff_midfreq = interp_at_freq(freq, mag_vdiff, MIDFREQ)
    vsf_at_mid = interp_at_freq(freq, mag_vsf, MIDFREQ)
    vd_at_mid = interp_at_freq(freq, mag_vd, MIDFREQ)
    champ_gain_mid = vdiff_midfreq / vsf_at_mid if vsf_at_mid > 0 else 0.0
    champ_ol_gain_mid = vdiff_midfreq / vd_at_mid if vd_at_mid > 0 else 0.0

    # --- 3dB frequencies ---

    # 1) f3db of vpr magnitude
    vpr_db = 20 * np.log10(mag_vpr + 1e-30)
    vpr_dc_db = vpr_db[0]
    f3db_vpr = find_3db_crossing(freq, vpr_db, vpr_dc_db, direction='falling')
    if f3db_vpr is None:
        f3db_vpr = 0.0

    # 2) f3db of SF transfer function: vsf/vpr
    sf_tf = mag_vsf / (mag_vpr + 1e-30)
    sf_tf_db = 20 * np.log10(sf_tf + 1e-30)
    sf_dc_db = sf_tf_db[0]
    f3db_sf = find_3db_crossing(freq, sf_tf_db, sf_dc_db, direction='falling')
    if f3db_sf is None:
        f3db_sf = 0.0

    # 3) LP cutoff of change amplifier: vdiff/vsf
    champ_tf = mag_vdiff / (mag_vsf + 1e-30)
    champ_tf_db = 20 * np.log10(champ_tf + 1e-30)
    i_mid = np.searchsorted(freq, MIDFREQ)
    champ_mid_db = champ_tf_db[min(i_mid, len(champ_tf_db) - 1)]
    f3db_champ_lp = find_3db_crossing(freq[i_mid:], champ_tf_db[i_mid:],
                                       champ_mid_db, direction='falling')
    if f3db_champ_lp is None:
        f3db_champ_lp = 0.0

    # 4) HP corner of vdiff (3dB below mid-freq value, searching below mid-freq)
    vdiff_db = 20 * np.log10(mag_vdiff + 1e-30)
    vdiff_mid_db = 20 * np.log10(vdiff_midfreq + 1e-30)
    f3db_champ_hp = find_3db_crossing(freq[:i_mid + 1], vdiff_db[:i_mid + 1],
                                       vdiff_mid_db, direction='rising')
    if f3db_champ_hp is None:
        f3db_champ_hp = 0.0

    # Write results — order must match YAML variables list
    outfile = '{}/{}_{}.data'.format(simpath, filename, simnumber)
    with open(outfile, 'w') as f:
        f.write("{} {} {} {} {} {} {} {} {} {}".format(
            vpr_dc, vsf_dc, pr_gain_dc, sf_gain_dc,
            champ_gain_mid, champ_ol_gain_mid,
            f3db_vpr, f3db_sf, f3db_champ_lp, f3db_champ_hp))


if __name__ == '__main__':
    main()
