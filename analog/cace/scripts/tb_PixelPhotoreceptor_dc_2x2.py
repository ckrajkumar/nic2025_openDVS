import numpy as np
import sys
from spicelib import RawRead

simpath = sys.argv[1]
filename = sys.argv[2]
simnumber = sys.argv[3]

rawfile = RawRead('{}/{}_{}.raw'.format(simpath, filename, simnumber))
steps = rawfile.get_steps()

# DC sweep: v(exp) is the sweep variable (log10 of ipd)
v_exp = np.real(np.array(rawfile.get_trace('v(exp)').get_wave(steps[0])))

# Internal nets of Pix[0] inside the 2x2 array
# Schematic hierarchy: xpix2x2.xpix[0].vpr / .vsf
# PEX hierarchy:       xpix2x2.pix[0].vpr  / .vsf
traces = rawfile.get_trace_names()
if 'v(xpix2x2.xpix[0].vpr)' in traces:
    vpr_trace = 'v(xpix2x2.xpix[0].vpr)'
    vsf_trace = 'v(xpix2x2.xpix[0].vsf)'
else:
    vpr_trace = 'v(xpix2x2.pix[0].vpr)'
    vsf_trace = 'v(xpix2x2.pix[0].vsf)'

v_vpr = np.real(np.array(rawfile.get_trace(vpr_trace).get_wave(steps[0])))
v_vsf = np.real(np.array(rawfile.get_trace(vsf_trace).get_wave(steps[0])))

# ipd = 10^v_exp
ipd = np.power(10.0, v_exp)
ln_ipd = np.log(10) * v_exp  # = ln(ipd)

# Min/max of vpr and vsf across the ipd sweep
vpr_min = np.min(v_vpr)
vpr_max = np.max(v_vpr)
vsf_min = np.min(v_vsf)
vsf_max = np.max(v_vsf)

# --- Find the "good log" segment: vpr > 200mV AND vsf < 1.6V ---
log_mask = (v_vpr > 0.2) & (v_vsf < 1.6)

if np.sum(log_mask) >= 3:
    ln_ipd_fit = ln_ipd[log_mask]
    v_vpr_fit = v_vpr[log_mask]
    v_vsf_fit = v_vsf[log_mask]

    # Log domain slope: fit v vs ln(ipd) in the good segment
    coeffs_vpr = np.polyfit(ln_ipd_fit, v_vpr_fit, 1)
    slope_vpr = coeffs_vpr[0]

    coeffs_vsf = np.polyfit(ln_ipd_fit, v_vsf_fit, 1)
    slope_vsf = coeffs_vsf[0]

    # R-squared in the good segment
    def r_squared(x, y):
        coeffs = np.polyfit(x, y, 1)
        y_fit = np.polyval(coeffs, x)
        ss_res = np.sum((y - y_fit) ** 2)
        ss_tot = np.sum((y - np.mean(y)) ** 2)
        if ss_tot == 0:
            return 0.0
        return 1.0 - ss_res / ss_tot

    r2_vpr = r_squared(ln_ipd_fit, v_vpr_fit)
    r2_vsf = r_squared(ln_ipd_fit, v_vsf_fit)

    # --- Compression points ---
    vsf_fit_full = np.polyval(coeffs_vsf, ln_ipd)
    vsf_fit_range = np.abs(coeffs_vsf[0]) * (ln_ipd_fit[-1] - ln_ipd_fit[0])
    dev_thresh = 0.1 * vsf_fit_range if vsf_fit_range > 0 else 0.01

    ipd_compress_low = ipd[0]
    for i in range(len(ipd)):
        if np.abs(v_vsf[i] - vsf_fit_full[i]) < dev_thresh:
            ipd_compress_low = ipd[i]
            break

    ipd_compress_high = ipd[-1]
    for i in range(len(ipd) - 1, -1, -1):
        if np.abs(v_vsf[i] - vsf_fit_full[i]) < dev_thresh:
            ipd_compress_high = ipd[i]
            break
else:
    slope_vpr = 0.0
    slope_vsf = 0.0
    r2_vpr = 0.0
    r2_vsf = 0.0
    ipd_compress_low = 0.0
    ipd_compress_high = 0.0

# Write results in order matching YAML variables list
f = open('{}/{}_{}.data'.format(simpath, filename, simnumber), 'w')
f.write("{} {} {} {} {} {} {} {} {} {}".format(
    vpr_min, vpr_max, vsf_min, vsf_max,
    slope_vpr, slope_vsf, r2_vpr, r2_vsf,
    ipd_compress_low, ipd_compress_high))
f.close()
