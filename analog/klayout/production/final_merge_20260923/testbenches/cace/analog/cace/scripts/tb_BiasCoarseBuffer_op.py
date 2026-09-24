import numpy as np
import sys
from spicelib import RawRead

simpath = sys.argv[1]
filename = sys.argv[2]
simnumber = sys.argv[3]

rawfile = RawRead('{}/{}_{}.raw'.format(simpath, filename, simnumber))
steps = rawfile.get_steps()

vdd = rawfile.get_trace('v(vdd)').get_wave(steps[0])[0]

in_bit = np.array([0.0]*8)
in_bit[0] = rawfile.get_trace('v(bit0)').get_wave(steps[0])[0]/vdd
in_bit[1] = rawfile.get_trace('v(bit1)').get_wave(steps[0])[0]/vdd
in_bit[2] = rawfile.get_trace('v(bit2)').get_wave(steps[0])[0]/vdd
in_code = int(np.round(in_bit[2]*4+in_bit[1]*2+in_bit[0],0))

dec_bit=np.array([0.0]*8)
dec_bit[0] = rawfile.get_trace('v(xCoarseBuf.TO0)').get_wave(steps[0])[0]
dec_bit[1] = rawfile.get_trace('v(xCoarseBuf.TO1)').get_wave(steps[0])[0]
dec_bit[2] = rawfile.get_trace('v(xCoarseBuf.TO2)').get_wave(steps[0])[0]
dec_bit[3] = rawfile.get_trace('v(xCoarseBuf.TO3)').get_wave(steps[0])[0]
dec_bit[4] = rawfile.get_trace('v(xCoarseBuf.TO4)').get_wave(steps[0])[0]
dec_bit[5] = rawfile.get_trace('v(xCoarseBuf.TO5)').get_wave(steps[0])[0]
dec_bit[6] = rawfile.get_trace('v(xCoarseBuf.TO6)').get_wave(steps[0])[0]
dec_bit[7] = rawfile.get_trace('v(xCoarseBuf.TO7)').get_wave(steps[0])[0]

detect_thresh = 0.02
right_bit_is_set = 1 if (np.abs(dec_bit[in_code] - vdd) < detect_thresh) else 0
other_bits_are_zero = 1 if (np.abs(np.sum(np.abs(dec_bit[0:in_code])) + np.sum(np.abs(dec_bit[in_code+1:])) < detect_thresh)) else 0


icoarse = rawfile.get_trace('i(Vmeas_ICoarse)').get_wave(steps[0])[0]

mirr_bit0_drain = rawfile.get_trace('v(xCoarseBuf.XSel.MirrB0_drain)').get_wave(steps[0])[0]
mirr_bit1_drain = rawfile.get_trace('v(xCoarseBuf.XSel.MirrB1_drain)').get_wave(steps[0])[0]
mirr_bit2_drain = rawfile.get_trace('v(xCoarseBuf.XSel.MirrB2_drain)').get_wave(steps[0])[0]
mirr_bit3_drain = rawfile.get_trace('v(xCoarseBuf.XSel.MirrB3_drain)').get_wave(steps[0])[0]
mirr_bit4o5o6o7_drain = rawfile.get_trace('v(xCoarseBuf.XSel.MirrB4o5o6o7_drain)').get_wave(steps[0])[0]
vgate_mirr_bit0 = rawfile.get_trace('v(BiasCB<0>)').get_wave(steps[0])[0]
vgate_mirr_bit1 = rawfile.get_trace('v(BiasCB<1>)').get_wave(steps[0])[0]
vgate_mirr_bit2 = rawfile.get_trace('v(BiasCB<2>)').get_wave(steps[0])[0]
vgate_mirr_bit3 = rawfile.get_trace('v(BiasCB<3>)').get_wave(steps[0])[0]
vgate_mirr_bit4o5o6o7 = rawfile.get_trace('v(xCoarseBuf.XSel.MirrB4o5o6o7_gate)').get_wave(steps[0])[0]
vbiascb0 = rawfile.get_trace('v(BiasCB<0>)').get_wave(steps[0])[0]
vbiascb1 = rawfile.get_trace('v(BiasCB<1>)').get_wave(steps[0])[0]
vbiascb2 = rawfile.get_trace('v(BiasCB<2>)').get_wave(steps[0])[0]
vbiascb3 = rawfile.get_trace('v(BiasCB<3>)').get_wave(steps[0])[0]
vbiascb4 = rawfile.get_trace('v(BiasCB<4>)').get_wave(steps[0])[0]
vbiascb5 = rawfile.get_trace('v(BiasCB<5>)').get_wave(steps[0])[0]
vbiascb6 = rawfile.get_trace('v(BiasCB<6>)').get_wave(steps[0])[0]
vbiascb7 = rawfile.get_trace('v(BiasCB<7>)').get_wave(steps[0])[0]

vds_mirr_bit0 = mirr_bit0_drain
vds_mirr_bit1 = mirr_bit1_drain
vds_mirr_bit2 = mirr_bit2_drain
vds_mirr_bit3 = mirr_bit3_drain
vds_mirr_bit4o5o6o7 = mirr_bit4o5o6o7_drain

vcoarse = rawfile.get_trace('v(VGate)').get_wave(steps[0])[0]
vcoarse_diff_to_drain_bit0 = vcoarse - mirr_bit0_drain
vcoarse_diff_to_drain_bit1 = vcoarse - mirr_bit1_drain
vcoarse_diff_to_drain_bit2 = vcoarse - mirr_bit2_drain
vcoarse_diff_to_drain_bit3 = vcoarse - mirr_bit3_drain
vcoarse_diff_to_drain_bit4o5o6o7 = vcoarse - mirr_bit4o5o6o7_drain

vgate_bit4o5o6o7_to_vbiascb4 = vgate_mirr_bit4o5o6o7 - vbiascb4
vgate_bit4o5o6o7_to_vbiascb5 = vgate_mirr_bit4o5o6o7 - vbiascb5
vgate_bit4o5o6o7_to_vbiascb6 = vgate_mirr_bit4o5o6o7 - vbiascb6
vgate_bit4o5o6o7_to_vbiascb7 = vgate_mirr_bit4o5o6o7 - vbiascb7

if(in_code == 0):
    vds_mirr_selected = vds_mirr_bit0
    max_vds_mirr_not_selected = np.max([vds_mirr_bit1,vds_mirr_bit2,vds_mirr_bit3,vds_mirr_bit4o5o6o7])
    vcoarse_diff_to_drain_selected = vcoarse_diff_to_drain_bit0
    vgate_bit4o5o6o7_to_vbias_selected = 0
elif(in_code == 1):
    vds_mirr_selected = vds_mirr_bit1
    max_vds_mirr_not_selected = np.max([vds_mirr_bit0,vds_mirr_bit2,vds_mirr_bit3,vds_mirr_bit4o5o6o7])
    vcoarse_diff_to_drain_selected = vcoarse_diff_to_drain_bit1
    vgate_bit4o5o6o7_to_vbias_selected = 0
elif(in_code == 2):
    vds_mirr_selected = vds_mirr_bit2
    max_vds_mirr_not_selected = np.max([vds_mirr_bit0,vds_mirr_bit1,vds_mirr_bit3,vds_mirr_bit4o5o6o7])
    vcoarse_diff_to_drain_selected = vcoarse_diff_to_drain_bit2
    vgate_bit4o5o6o7_to_vbias_selected = 0
elif(in_code == 3):
    vds_mirr_selected = vds_mirr_bit3
    max_vds_mirr_not_selected = np.max([vds_mirr_bit0,vds_mirr_bit1,vds_mirr_bit2,vds_mirr_bit4o5o6o7])
    vcoarse_diff_to_drain_selected = vcoarse_diff_to_drain_bit3
    vgate_bit4o5o6o7_to_vbias_selected = 0
elif(in_code == 4):
    vds_mirr_selected = vds_mirr_bit4o5o6o7
    max_vds_mirr_not_selected = np.max([vds_mirr_bit0,vds_mirr_bit1,vds_mirr_bit2,vds_mirr_bit3])
    vcoarse_diff_to_drain_selected = vcoarse_diff_to_drain_bit4o5o6o7
    vgate_bit4o5o6o7_to_vbias_selected = vgate_bit4o5o6o7_to_vbiascb4
elif(in_code == 5):
    vds_mirr_selected = vds_mirr_bit4o5o6o7
    max_vds_mirr_not_selected = np.max([vds_mirr_bit0,vds_mirr_bit1,vds_mirr_bit2,vds_mirr_bit3])
    vcoarse_diff_to_drain_selected = vcoarse_diff_to_drain_bit4o5o6o7
    vgate_bit4o5o6o7_to_vbias_selected = vgate_bit4o5o6o7_to_vbiascb5
elif(in_code == 6):
    vds_mirr_selected = vds_mirr_bit4o5o6o7
    max_vds_mirr_not_selected = np.max([vds_mirr_bit0,vds_mirr_bit1,vds_mirr_bit2,vds_mirr_bit3])
    vcoarse_diff_to_drain_selected = vcoarse_diff_to_drain_bit4o5o6o7
    vgate_bit4o5o6o7_to_vbias_selected = vgate_bit4o5o6o7_to_vbiascb6
elif(in_code == 7):
    vds_mirr_selected = vds_mirr_bit4o5o6o7
    max_vds_mirr_not_selected = np.max([vds_mirr_bit0,vds_mirr_bit1,vds_mirr_bit2,vds_mirr_bit3])
    vcoarse_diff_to_drain_selected = vcoarse_diff_to_drain_bit4o5o6o7
    vgate_bit4o5o6o7_to_vbias_selected = vgate_bit4o5o6o7_to_vbiascb7

f = open('{}/{}_{}.data'.format(simpath, filename,simnumber), 'w')
 
f.write("{} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {}".format(
    in_code,
    right_bit_is_set,
    other_bits_are_zero,
    icoarse,
    vds_mirr_selected,
    max_vds_mirr_not_selected,
    vcoarse_diff_to_drain_selected,
    vgate_bit4o5o6o7_to_vbias_selected,
    dec_bit[0],
    dec_bit[1],
    dec_bit[2],
    dec_bit[3],
    dec_bit[4],
    dec_bit[5],
    dec_bit[6],
    dec_bit[7],
    vds_mirr_bit0,
    vds_mirr_bit1,
    vds_mirr_bit2,
    vds_mirr_bit3,
    vds_mirr_bit4o5o6o7,
    vgate_mirr_bit0,
    vgate_mirr_bit1,
    vgate_mirr_bit2,
    vgate_mirr_bit3,
    vgate_mirr_bit4o5o6o7,
    vgate_bit4o5o6o7_to_vbiascb4,
    vgate_bit4o5o6o7_to_vbiascb5,
    vgate_bit4o5o6o7_to_vbiascb6,
    vgate_bit4o5o6o7_to_vbiascb7,
    vcoarse_diff_to_drain_bit0,
    vcoarse_diff_to_drain_bit1,
    vcoarse_diff_to_drain_bit2,
    vcoarse_diff_to_drain_bit3,
    vcoarse_diff_to_drain_bit4o5o6o7,
))

f.close()
