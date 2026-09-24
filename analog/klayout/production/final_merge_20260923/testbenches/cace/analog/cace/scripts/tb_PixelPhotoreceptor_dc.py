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
v_vpr = np.real(np.array(rawfile.get_trace('v(vpr)').get_wave(steps[0])))
v_vsf = np.real(np.array(rawfile.get_trace('v(vsf)').get_wave(steps[0])))

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
    # slope is in V per e-fold (CACE converts to mV via unit field)
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
    # Extrapolate the vsf log fit over the full ipd range
    vsf_fit_full = np.polyval(coeffs_vsf, ln_ipd)

    # Deviation threshold: 10% of the fit range in the good segment
    vsf_fit_range = np.abs(coeffs_vsf[0]) * (ln_ipd_fit[-1] - ln_ipd_fit[0])
    dev_thresh = 0.1 * vsf_fit_range if vsf_fit_range > 0 else 0.01

    # Low compression: scan from low ipd upward until measured vsf
    # is within dev_thresh of the fit (first point in the log region)
    ipd_compress_low = ipd[0]  # default: lowest ipd
    for i in range(len(ipd)):
        if np.abs(v_vsf[i] - vsf_fit_full[i]) < dev_thresh:
            ipd_compress_low = ipd[i]
            break

    # High compression: scan from high ipd downward until measured vsf
    # is within dev_thresh of the fit
    ipd_compress_high = ipd[-1]  # default: highest ipd
    for i in range(len(ipd) - 1, -1, -1):
        if np.abs(v_vsf[i] - vsf_fit_full[i]) < dev_thresh:
            ipd_compress_high = ipd[i]
            break
else:
    # Not enough points in the good segment
    slope_vpr = 0.0
    slope_vsf = 0.0
    r2_vpr = 0.0
    r2_vsf = 0.0
    ipd_compress_low = 0.0
    ipd_compress_high = 0.0

# Write results in order matching YAML variables list
# All values in SI base units (V, A, dimensionless)
f = open('{}/{}_{}.data'.format(simpath, filename, simnumber), 'w')
f.write("{} {} {} {} {} {} {} {} {} {}".format(
    vpr_min, vpr_max, vsf_min, vsf_max,
    slope_vpr, slope_vsf, r2_vpr, r2_vsf,
    ipd_compress_low, ipd_compress_high))
f.close()
