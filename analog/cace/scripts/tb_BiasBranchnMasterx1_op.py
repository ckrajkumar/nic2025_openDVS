import numpy as np
import sys
from spicelib import RawRead

simpath = sys.argv[1]
filename = sys.argv[2]
simnumber = sys.argv[3]

rawfile = RawRead('{}/{}_{}.raw'.format(simpath, filename, simnumber))
steps = rawfile.get_steps()

vdd = rawfile.get_trace('v(vdd)').get_wave(steps[0])[0]
iout_pmos = rawfile.get_trace('i(vmeas_iout_pmos)').get_wave(steps[0])[0]
iout_nmos = rawfile.get_trace('i(vmeas_iout_nmos)').get_wave(steps[0])[0]

bias_is_ntype = rawfile.get_trace('v(nbiasenabled)').get_wave(steps[0])[0] > vdd/2

if(bias_is_ntype):
    bias_type = 'n'
    iout = iout_nmos
else:
    bias_type = 'p'
    iout = iout_pmos

fine_bit = np.array([0.0]*8)
fine_bit[0] = rawfile.get_trace('v(FineBit0)').get_wave(steps[0])[0]/vdd
fine_bit[1] = rawfile.get_trace('v(FineBit1)').get_wave(steps[0])[0]/vdd
fine_bit[2] = rawfile.get_trace('v(FineBit2)').get_wave(steps[0])[0]/vdd
fine_bit[3] = rawfile.get_trace('v(FineBit3)').get_wave(steps[0])[0]/vdd
fine_bit[4] = rawfile.get_trace('v(FineBit4)').get_wave(steps[0])[0]/vdd
fine_bit[5] = rawfile.get_trace('v(FineBit5)').get_wave(steps[0])[0]/vdd
fine_bit[6] = rawfile.get_trace('v(FineBit6)').get_wave(steps[0])[0]/vdd
fine_bit[7] = rawfile.get_trace('v(FineBit7)').get_wave(steps[0])[0]/vdd
fine_code=0
for i in range(0,len(fine_bit)):
    fine_code = fine_code + int(fine_bit[i]*2**i)

coarse_bit = np.array([0.0]*3)
coarse_bit[0] = rawfile.get_trace('v(CoarseBit0)').get_wave(steps[0])[0]/vdd
coarse_bit[1] = rawfile.get_trace('v(CoarseBit1)').get_wave(steps[0])[0]/vdd
coarse_bit[2] = rawfile.get_trace('v(CoarseBit2)').get_wave(steps[0])[0]/vdd
coarse_code=0
for i in range(0,len(coarse_bit)):
    coarse_code = coarse_code + int(coarse_bit[i]*2**i)


vdsat_masterbias_mnbias = rawfile.get_trace("v(@m.xBias.xBiasMasternCoarse.xBiasMasterBias.xMNBias.msky130_fd_pr__nfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_masterbias_mnbiasdio  = rawfile.get_trace("v(@m.xBias.xBiasMasternCoarse.xBiasMasterBias.xMNBiasDio.msky130_fd_pr__nfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_masterbias_mnbiascascdio = rawfile.get_trace("v(@m.xBias.xBiasMasternCoarse.xBiasMasterBias.xMNBiasCascDio.msky130_fd_pr__nfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_masterbias_mnbiascasc = rawfile.get_trace("v(@m.xBias.xBiasMasternCoarse.xBiasMasterBias.xMNBiasCasc.msky130_fd_pr__nfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_masterbias_mpbias = rawfile.get_trace("v(@m.xBias.xBiasMasternCoarse.xBiasMasterBias.xMPBias.msky130_fd_pr__pfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_masterbias_mpbiasdio = rawfile.get_trace("v(@m.xBias.xBiasMasternCoarse.xBiasMasterBias.xMPBiasDio.msky130_fd_pr__pfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_masterbias_mnmirr1 = rawfile.get_trace("v(@m.xBias.xBiasMasternCoarse.xBiasMasterBias.xMNMirr1.msky130_fd_pr__nfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_masterbias_mnmirr2 = rawfile.get_trace("v(@m.xBias.xBiasMasternCoarse.xBiasMasterBias.xMNMirr2.msky130_fd_pr__nfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_masterbias_mnmirrcasc2 = rawfile.get_trace("v(@m.xBias.xBiasMasternCoarse.xBiasMasterBias.xMNMirrCasc1.msky130_fd_pr__nfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_masterbias_mnmirrcasc2 = rawfile.get_trace("v(@m.xBias.xBiasMasternCoarse.xBiasMasterBias.xMNMirrCasc2.msky130_fd_pr__nfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_coarsebuf_mmirrb0 = rawfile.get_trace("v(@m.xBias.xBiasBranch.xCoarseBuf.xSel.xMmirrB0.msky130_fd_pr__nfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_coarsebuf_mmirrb1 = rawfile.get_trace("v(@m.xBias.xBiasBranch.xCoarseBuf.xSel.xMmirrB1.msky130_fd_pr__nfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_coarsebuf_mmirrb2 = rawfile.get_trace("v(@m.xBias.xBiasBranch.xCoarseBuf.xSel.xMmirrhB2.msky130_fd_pr__nfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_coarsebuf_mmirrb3 = rawfile.get_trace("v(@m.xBias.xBiasBranch.xCoarseBuf.xSel.xMmirrhB3.msky130_fd_pr__nfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_coarsebuf_mmirrb4to7 = rawfile.get_trace("v(@m.xBias.xBiasBranch.xCoarseBuf.xSel.xMmirrhB4t07.msky130_fd_pr__nfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_coarse2fine_mpdioout = rawfile.get_trace("v(@m.xBias.xBiasBranch.xCoarse2Fine.xMpDioOut.msky130_fd_pr__pfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_coarse2fine_mpmirrout = rawfile.get_trace("v(@m.xBias.xBiasBranch.xCoarse2Fine.xMpMirrOut.msky130_fd_pr__pfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_coarse2fine_mpdionout = rawfile.get_trace("v(@m.xBias.xBiasBranch.xCoarse2Fine.xMpDionOut2.msky130_fd_pr__pfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_coarse2fine_mpmirrnout = rawfile.get_trace("v(@m.xBias.xBiasBranch.xCoarse2Fine.xMpMirrnOut2.msky130_fd_pr__pfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_buffs_mndio = rawfile.get_trace("v(@m.xBias.xBiasBranch.xBuffs.xMnDio.msky130_fd_pr__nfet_01v8[vdsat])").get_wave(steps[0])[0]
vdsat_buffs_mnmirr = rawfile.get_trace("v(@m.xBias.xBiasBranch.xBuffs.xMnMirr.msky130_fd_pr__nfet_01v8[vdsat])").get_wave(steps[0])[0]
vdsat_buffs_mnmirrbuffbias = rawfile.get_trace("v(@m.xBias.xBiasBranch.xBuffs.xMnMirrBuffBias.msky130_fd_pr__nfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_buffs_mnmirrbuffb0 = rawfile.get_trace("v(@m.xBias.xBiasBranch.xBuffs.xMnMirrBuffB0.msky130_fd_pr__nfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_buffs_mnmirrbuffnb0 = rawfile.get_trace("v(@m.xBias.xBiasBranch.xBuffs.xMnMirrBuffnB0.msky130_fd_pr__nfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_buffs_mpdio = rawfile.get_trace("v(@m.xBias.xBiasBranch.xBuffs.xMpDio.msky130_fd_pr__pfet_01v8[vdsat])").get_wave(steps[0])[0]
vdsat_buffs_mpmirrbuffbias = rawfile.get_trace("v(@m.xBias.xBiasBranch.xBuffs.xMpMirrBuffBias.msky130_fd_pr__pfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_buffs_mpmirrbuffb0 = rawfile.get_trace("v(@m.xBias.xBiasBranch.xBuffs.xMpMirrBuffB0.msky130_fd_pr__pfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_buffs_mpmirrbuffnb0 = rawfile.get_trace("v(@m.xBias.xBiasBranch.xBuffs.xMpMirrBuffnB0.msky130_fd_pr__pfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_biasbuffer_mndio = rawfile.get_trace("v(@m.xBias.xBiasBuffer.xMnDio.msky130_fd_pr__nfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_biasbuffer_mnmirr = rawfile.get_trace("v(@m.xBias.xBiasBuffer.xMnMirr.msky130_fd_pr__nfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
vdsat_biasbuffer_mnpdio = rawfile.get_trace("v(@m.xBias.xBiasBuffer.xMpDio.msky130_fd_pr__pfet_01v8_lvt[vdsat])").get_wave(steps[0])[0]
id_masterbias_mnbias  = rawfile.get_trace("i(@m.xBias.xBiasMasternCoarse.xBiasMasterBias.xMNBias.msky130_fd_pr__nfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_masterbias_mnbiasdio = rawfile.get_trace("i(@m.xBias.xBiasMasternCoarse.xBiasMasterBias.xMNBiasDio.msky130_fd_pr__nfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_masterbias_xmnmirr1 = rawfile.get_trace("i(@m.xBias.xBiasMasternCoarse.xBiasMasterBias.xMNMirr1.msky130_fd_pr__nfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_masterbias_xmnmirr2 = rawfile.get_trace("i(@m.xBias.xBiasMasternCoarse.xBiasMasterBias.xMNMirr2.msky130_fd_pr__nfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_mbdiv_cb0 = rawfile.get_trace("i(@m.xBias.xBiasMasternCoarse.xMBDiv.xMNDioCB0.msky130_fd_pr__nfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_mbdiv_cb1 = rawfile.get_trace("i(@m.xBias.xBiasMasternCoarse.xMBDiv.xMNDioCB1.msky130_fd_pr__nfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_mbdiv_cb2 = rawfile.get_trace("i(@m.xBias.xBiasMasternCoarse.xMBDiv.xMNDioCB2.msky130_fd_pr__nfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_mbdiv_cb3 = rawfile.get_trace("i(@m.xBias.xBiasMasternCoarse.xMBDiv.xMNDioCB3.msky130_fd_pr__nfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_mbdiv_cb4 = rawfile.get_trace("i(@m.xBias.xBiasMasternCoarse.xMBDiv.xMNDioCB4.msky130_fd_pr__nfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_mbdiv_cb5 = rawfile.get_trace("i(@m.xBias.xBiasMasternCoarse.xMBDiv.xMNDioCB5.msky130_fd_pr__nfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_mbdiv_cb6 = rawfile.get_trace("i(@m.xBias.xBiasMasternCoarse.xMBDiv.xMNDioCB6.msky130_fd_pr__nfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_mbdiv_cb7 = rawfile.get_trace("i(@m.xBias.xBiasMasternCoarse.xMBDiv.xMNDioCB7.msky130_fd_pr__nfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_coarsebuf_mmirrb0 = rawfile.get_trace("i(@m.xBias.xBiasBranch.xCoarseBuf.xSel.xMmirrB0.msky130_fd_pr__nfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_coarsebuf_mmirrb1 = rawfile.get_trace("i(@m.xBias.xBiasBranch.xCoarseBuf.xSel.xMmirrB1.msky130_fd_pr__nfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_coarsebuf_mmirrb2 = rawfile.get_trace("i(@m.xBias.xBiasBranch.xCoarseBuf.xSel.xMmirrhB2.msky130_fd_pr__nfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_coarsebuf_mmirrb3 = rawfile.get_trace("i(@m.xBias.xBiasBranch.xCoarseBuf.xSel.xMmirrhB3.msky130_fd_pr__nfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_coarsebuf_mmirrb4to7 = rawfile.get_trace("i(@m.xBias.xBiasBranch.xCoarseBuf.xSel.xMmirrhB4t07.msky130_fd_pr__nfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_coarse2fine_mpdioout = rawfile.get_trace("i(@m.xBias.xBiasBranch.xCoarse2Fine.xMpDioOut.msky130_fd_pr__pfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_coarse2fine_mpmirrout = rawfile.get_trace("i(@m.xBias.xBiasBranch.xCoarse2Fine.xMpMirrOut.msky130_fd_pr__pfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_coarse2fine_mpdionout = rawfile.get_trace("i(@m.xBias.xBiasBranch.xCoarse2Fine.xMpDionOut2.msky130_fd_pr__pfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_coarse2fine_mpmirrnout = rawfile.get_trace("i(@m.xBias.xBiasBranch.xCoarse2Fine.xMpMirrnOut2.msky130_fd_pr__pfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_coarse2fine_mpindio = rawfile.get_trace("i(@m.xBias.xBiasBranch.xCoarse2Fine.xMpInDio.msky130_fd_pr__pfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_buffs_mndio = rawfile.get_trace("i(@m.xBias.xBiasBranch.xBuffs.xMnDio.msky130_fd_pr__nfet_01v8[id])").get_wave(steps[0])[0]
id_buffs_mnmirr = rawfile.get_trace("i(@m.xBias.xBiasBranch.xBuffs.xMnMirr.msky130_fd_pr__nfet_01v8[id])").get_wave(steps[0])[0]
id_buffs_mnmirrbuffbias = rawfile.get_trace("i(@m.xBias.xBiasBranch.xBuffs.xMnMirrBuffBias.msky130_fd_pr__nfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_buffs_mnmirrbuffb0 = rawfile.get_trace("i(@m.xBias.xBiasBranch.xBuffs.xMnMirrBuffB0.msky130_fd_pr__nfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_buffs_mnmirrbuffnb0 = rawfile.get_trace("i(@m.xBias.xBiasBranch.xBuffs.xMnMirrBuffnB0.msky130_fd_pr__nfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_buffs_mpdio = rawfile.get_trace("i(@m.xBias.xBiasBranch.xBuffs.xMpDio.msky130_fd_pr__pfet_01v8[id])").get_wave(steps[0])[0]
id_buffs_mpmirrbuffbias = rawfile.get_trace("i(@m.xBias.xBiasBranch.xBuffs.xMpMirrBuffBias.msky130_fd_pr__pfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_buffs_mpmirrbuffb0 = rawfile.get_trace("i(@m.xBias.xBiasBranch.xBuffs.xMpMirrBuffB0.msky130_fd_pr__pfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_buffs_mpmirrbuffnb0 = rawfile.get_trace("i(@m.xBias.xBiasBranch.xBuffs.xMpMirrBuffnB0.msky130_fd_pr__pfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_biasbuffer_mndio = rawfile.get_trace("i(@m.xBias.xBiasBuffer.xMnDio.msky130_fd_pr__nfet_01v8_lvt[id])").get_wave(steps[0])[0]
id_biasbuffer_mnmirr = rawfile.get_trace("i(@m.xBias.xBiasBuffer.xMnMirr.msky130_fd_pr__nfet_01v8_lvt[id])").get_wave(steps[0])[0]

if(coarse_code == 0):
    vdsat_coarsebuf_mmirr = vdsat_coarsebuf_mmirrb0
    id_coarsebuf_mmirr = id_coarsebuf_mmirrb0
    vdsat_coarse2fine_mpdio = vdsat_coarse2fine_mpdioout
    id_coarse2fine_mpdio = id_coarse2fine_mpdioout
    vdsat_coarse2fine_mpmirr = vdsat_coarse2fine_mpmirrout
    id_coarse2fine_mpmirr = id_coarse2fine_mpmirrout
    vdsat_coarse2fine_mpmirr = vdsat_coarse2fine_mpmirrnout
    id_coarse2fine_mpmirr = id_coarse2fine_mpmirrnout
    vdsat_buffs_mnmirrbuff = vdsat_buffs_mnmirrbuffnb0
    vdsat_buffs_mpmirrbuff = vdsat_buffs_mpmirrbuffnb0
    id_buffs_mnmirrbuff = vdsat_buffs_mnmirrbuffnb0
    id_buffs_mpmirrbuff = vdsat_buffs_mpmirrbuffnb0
elif(coarse_code == 1):
    vdsat_coarsebuf_mmirr = vdsat_coarsebuf_mmirrb1
    id_coarsebuf_mmirr = id_coarsebuf_mmirrb1
    vdsat_coarse2fine_mpdio = vdsat_coarse2fine_mpdioout
    id_coarse2fine_mpdio = id_coarse2fine_mpdioout
    vdsat_coarse2fine_mpmirr = vdsat_coarse2fine_mpmirrnout
    id_coarse2fine_mpmirr = id_coarse2fine_mpmirrnout
    vdsat_buffs_mnmirrbuff = vdsat_buffs_mnmirrbuffnb0
    vdsat_buffs_mpmirrbuff = vdsat_buffs_mpmirrbuffnb0
    id_buffs_mnmirrbuff = vdsat_buffs_mnmirrbuffnb0
    id_buffs_mpmirrbuff = vdsat_buffs_mpmirrbuffnb0
elif(coarse_code == 2):
    vdsat_coarsebuf_mmirr = vdsat_coarsebuf_mmirrb2
    id_coarsebuf_mmirr = id_coarsebuf_mmirrb2
    vdsat_coarse2fine_mpdio = vdsat_coarse2fine_mpdionout
    id_coarse2fine_mpdio = id_coarse2fine_mpdionout
    vdsat_coarse2fine_mpmirr = vdsat_coarse2fine_mpmirrnout
    id_coarse2fine_mpmirr = id_coarse2fine_mpmirrnout
    vdsat_coarse2fine_mpmirr = vdsat_coarse2fine_mpmirrnout
    id_coarse2fine_mpmirr = id_coarse2fine_mpmirrnout
    vdsat_buffs_mnmirrbuff = vdsat_buffs_mnmirrbuffnb0
    vdsat_buffs_mpmirrbuff = vdsat_buffs_mpmirrbuffnb0
    id_buffs_mnmirrbuff = vdsat_buffs_mnmirrbuffnb0
    id_buffs_mpmirrbuff = vdsat_buffs_mpmirrbuffnb0
elif(coarse_code == 3):
    vdsat_coarsebuf_mmirr = vdsat_coarsebuf_mmirrb3
    id_coarsebuf_mmirr = id_coarsebuf_mmirrb3
    vdsat_coarse2fine_mpdio = vdsat_coarse2fine_mpdionout
    id_coarse2fine_mpdio = id_coarse2fine_mpdionout
    vdsat_coarse2fine_mpmirr = vdsat_coarse2fine_mpmirrnout
    id_coarse2fine_mpmirr = id_coarse2fine_mpmirrnout
    vdsat_buffs_mnmirrbuff = vdsat_buffs_mnmirrbuffnb0
    vdsat_buffs_mpmirrbuff = vdsat_buffs_mpmirrbuffnb0
    id_buffs_mnmirrbuff = vdsat_buffs_mnmirrbuffnb0
    id_buffs_mpmirrbuff = vdsat_buffs_mpmirrbuffnb0
elif(coarse_code == 4):
    vdsat_coarsebuf_mmirr = vdsat_coarsebuf_mmirrb4to7
    id_coarsebuf_mmirr = id_coarsebuf_mmirrb4to7
    vdsat_coarse2fine_mpdio = vdsat_coarse2fine_mpdionout
    id_coarse2fine_mpdio = id_coarse2fine_mpdionout
    vdsat_coarse2fine_mpmirr = vdsat_coarse2fine_mpmirrnout
    id_coarse2fine_mpmirr = id_coarse2fine_mpmirrnout
    vdsat_buffs_mnmirrbuff = vdsat_buffs_mnmirrbuffb0
    vdsat_buffs_mpmirrbuff = vdsat_buffs_mpmirrbuffb0
    id_buffs_mnmirrbuff = vdsat_buffs_mnmirrbuffb0
    id_buffs_mpmirrbuff = vdsat_buffs_mpmirrbuffb0
elif(coarse_code == 5):
    vdsat_coarsebuf_mmirr = vdsat_coarsebuf_mmirrb4to7
    id_coarsebuf_mmirr = id_coarsebuf_mmirrb4to7
    vdsat_coarse2fine_mpdio = vdsat_coarse2fine_mpdionout
    id_coarse2fine_mpdio = id_coarse2fine_mpdionout
    vdsat_coarse2fine_mpmirr = vdsat_coarse2fine_mpmirrnout
    id_coarse2fine_mpmirr = id_coarse2fine_mpmirrnout
    vdsat_buffs_mnmirrbuff = vdsat_buffs_mnmirrbuffb0
    vdsat_buffs_mpmirrbuff = vdsat_buffs_mpmirrbuffb0
    id_buffs_mnmirrbuff = vdsat_buffs_mnmirrbuffb0
    id_buffs_mpmirrbuff = vdsat_buffs_mpmirrbuffb0
elif(coarse_code == 6):
    vdsat_coarsebuf_mmirr = vdsat_coarsebuf_mmirrb4to7
    id_coarsebuf_mmirr = id_coarsebuf_mmirrb4to7
    vdsat_coarse2fine_mpdio = vdsat_coarse2fine_mpdionout
    id_coarse2fine_mpdio = id_coarse2fine_mpdionout
    vdsat_coarse2fine_mpmirr = vdsat_coarse2fine_mpmirrnout
    id_coarse2fine_mpmirr = id_coarse2fine_mpmirrnout
    vdsat_buffs_mnmirrbuff = vdsat_buffs_mnmirrbuffb0
    vdsat_buffs_mpmirrbuff = vdsat_buffs_mpmirrbuffb0
    id_buffs_mnmirrbuff = vdsat_buffs_mnmirrbuffb0
    id_buffs_mpmirrbuff = vdsat_buffs_mpmirrbuffb0
elif(coarse_code == 7):
    vdsat_coarsebuf_mmirr = vdsat_coarsebuf_mmirrb4to7
    id_coarsebuf_mmirr = id_coarsebuf_mmirrb4to7
    vdsat_coarse2fine_mpdio = vdsat_coarse2fine_mpdionout
    id_coarse2fine_mpdio = id_coarse2fine_mpdionout
    vdsat_coarse2fine_mpmirr = vdsat_coarse2fine_mpmirrnout
    id_coarse2fine_mpmirr = id_coarse2fine_mpmirrnout
    vdsat_buffs_mnmirrbuff = vdsat_buffs_mnmirrbuffb0
    vdsat_buffs_mpmirrbuff = vdsat_buffs_mpmirrbuffb0
    id_buffs_mnmirrbuff = vdsat_buffs_mnmirrbuffb0
    id_buffs_mpmirrbuff = vdsat_buffs_mpmirrbuffb0

f = open('{}/{}_{}.data'.format(simpath, filename,simnumber), 'w')
 
f.write("{} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {} {}".format(
    coarse_code,
    fine_code,
    iout,
    vdsat_masterbias_mnbias,
    vdsat_masterbias_mnbiasdio,
    vdsat_masterbias_mnbiascascdio,
    vdsat_masterbias_mnbiascasc,
    vdsat_masterbias_mpbias,
    vdsat_masterbias_mpbiasdio,
    vdsat_masterbias_mnmirr1,
    vdsat_masterbias_mnmirr2,
    vdsat_masterbias_mnmirrcasc2,
    vdsat_masterbias_mnmirrcasc2,
    vdsat_coarsebuf_mmirr,
    vdsat_coarse2fine_mpdio,
    vdsat_coarse2fine_mpmirr,
    vdsat_buffs_mndio,
    vdsat_buffs_mnmirr,
    vdsat_buffs_mnmirrbuffbias,
    vdsat_buffs_mnmirrbuff,
    vdsat_buffs_mpdio,
    vdsat_buffs_mpmirrbuffbias,
    vdsat_buffs_mpmirrbuff,
    vdsat_biasbuffer_mndio,
    vdsat_biasbuffer_mnmirr,
    vdsat_biasbuffer_mnpdio,
    id_masterbias_mnbias,
    id_masterbias_mnbiasdio,
    id_masterbias_xmnmirr1,
    id_masterbias_xmnmirr2,
    id_mbdiv_cb0,
    id_mbdiv_cb1,
    id_mbdiv_cb2,
    id_mbdiv_cb3,
    id_mbdiv_cb4,
    id_mbdiv_cb5,
    id_mbdiv_cb6,
    id_mbdiv_cb7,
    id_coarsebuf_mmirr,
    id_coarse2fine_mpdio,
    id_coarse2fine_mpmirr,
    id_coarse2fine_mpindio,
    id_buffs_mndio,
    id_buffs_mnmirr,
    id_buffs_mnmirrbuffbias,
    id_buffs_mnmirrbuff,
    id_buffs_mpdio,
    id_buffs_mpmirrbuffbias,
    id_buffs_mpmirrbuff,
    id_biasbuffer_mndio,
    id_biasbuffer_mnmirr
))

f.close()
