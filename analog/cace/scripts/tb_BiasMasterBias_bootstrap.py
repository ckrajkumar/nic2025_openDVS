import numpy as np
import sys
from spicelib import RawRead

simpath = sys.argv[1]
filename = sys.argv[2]
simnumber = sys.argv[3]

rawfile = RawRead('{}/{}_{}.raw'.format(simpath, filename, simnumber))
steps = rawfile.get_steps()

time = np.real(np.array(rawfile.get_trace('time').get_wave(steps[0])))
v_master_bias_n = np.real(np.array(rawfile.get_trace('v(vmasterbiasn)').get_wave(steps[0])))
v_master_bias_p = np.real(np.array(rawfile.get_trace('v(vmasterbiasp)').get_wave(steps[0])))
v_powerdown = np.real(np.array(rawfile.get_trace('v(powerdown)').get_wave(steps[0])))
v_vdd = np.real(np.array(rawfile.get_trace('v(vdd)').get_wave(steps[0])))

# Final values (last sample)
vn_final = v_master_bias_n[-1]
vp_final = v_master_bias_p[-1]
vdd_final = v_vdd[-1]

# Margin of VMasterBiasP from VDD (should be >= 100mV)
vp_margin = vdd_final - vp_final

# Find when PowerDown crosses below 10% of vdd (falling edge)
pd_threshold = 0.1 * vdd_final
pd_fall_idx = 0
for i in range(len(time) - 1):
    if v_powerdown[i] > pd_threshold and v_powerdown[i + 1] <= pd_threshold:
        pd_fall_idx = i + 1
        break


def calc_settling_time(sig, final_val, start_idx, time_vec):
    """Find settling time: last time signal was outside 1% tolerance of final value."""
    if abs(final_val) < 1e-6:
        tol = 1e-3
    else:
        tol = abs(final_val * 0.01)

    # Search backwards from end to find last excursion outside tolerance
    for i in range(len(sig) - 1, start_idx, -1):
        if abs(sig[i] - final_val) > tol:
            if i + 1 < len(time_vec):
                return time_vec[i + 1] - time_vec[start_idx]
            else:
                return time_vec[-1] - time_vec[start_idx]
    return 0.0


tsettle_n = calc_settling_time(v_master_bias_n, vn_final, pd_fall_idx, time)
tsettle_p = calc_settling_time(v_master_bias_p, vp_final, pd_fall_idx, time)

f = open('{}/{}_{}.data'.format(simpath, filename, simnumber), 'w')
f.write("{} {} {} {} {}".format(vn_final, vp_final, vp_margin, tsettle_n, tsettle_p))
f.close()
