v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 350 -50 350 10 {lab=VOUT}
N -290 -170 -290 10 {lab=VBIAS_P}
N -290 40 -250 40 {lab=GndA}
N -250 40 -250 70 {lab=GndA}
N 10 40 10 70 {lab=GndA}
N 50 40 90 40 {lab=GndA}
N 470 40 470 70 {lab=GndA}
N 520 -50 520 10 {lab=N_VIN}
N 480 -80 520 -80 {lab=MAIN_SOURCE}
N 480 -110 480 -80 {lab=MAIN_SOURCE}
N 350 -110 390 -110 {lab=MAIN_SOURCE}
N 390 -110 390 -80 {lab=MAIN_SOURCE}
N 350 -80 390 -80 {lab=MAIN_SOURCE}
N 450 -170 450 -110 {lab=MAIN_SOURCE}
N 90 -50 90 10 {lab=MAIN_BIAS}
N -90 -50 -90 10 {lab=DIODE_LD}
N -30 -200 10 -200 {lab=VDD}
N 10 -230 10 -200 {lab=VDD}
N 450 -200 490 -200 {lab=VDD}
N 490 -230 490 -200 {lab=VDD}
N -290 -200 -260 -200 {lab=VDD}
N -260 -230 -260 -200 {lab=VDD}
N -260 -280 -260 -230 {lab=VDD}
N -330 -200 -330 -130 {lab=VBIAS_P}
N -330 -130 -290 -130 {lab=VBIAS_P}
N -390 40 -330 40 {lab=IBIAS}
N 290 -80 310 -80 {lab=VOUT}
N 290 -80 290 -30 {lab=VOUT}
N 290 -30 350 -30 {lab=VOUT}
N 560 -80 590 -80 {lab=VIN}
N -130 10 -130 40 {lab=DIODE_LD}
N -130 10 -90 10 {lab=DIODE_LD}
N 470 40 520 40 {lab=GndA}
N 580 10 580 40 {lab=MAIN_BIAS}
N 560 40 580 40 {lab=MAIN_BIAS}
N 580 0 580 10 {lab=MAIN_BIAS}
N 30 70 30 140 {lab=GndA}
N 390 -110 520 -110 {lab=MAIN_SOURCE}
N 350 40 470 40 {lab=GndA}
N 350 70 520 70 {lab=GndA}
N 450 -230 490 -230 {lab=VDD}
N -30 -230 10 -230 {lab=VDD}
N -90 70 30 70 {lab=GndA}
N 50 40 50 70 {lab=GndA}
N -100 -200 -70 -200 {lab=VBIAS_P}
N 130 0 130 40 {lab=MAIN_BIAS}
N 90 -0 130 0 {lab=MAIN_BIAS}
N 130 0 580 0 {lab=MAIN_BIAS}
N 130 40 310 40 {lab=MAIN_BIAS}
N 130 -80 290 -80 {lab=VOUT}
N -130 -80 -130 -10 {lab=N_VIN}
N 360 -200 410 -200 {lab=VBIAS_P}
N -290 -230 -260 -230 {lab=VDD}
N -290 70 -250 70 {lab=GndA}
N -90 40 10 40 {lab=GndA}
N 30 70 90 70 {lab=GndA}
N -90 -110 90 -110 {lab=AUX_SOURCE}
N -90 -80 90 -80 {lab=AUX_SOURCE}
N -0 -110 -0 -80 {lab=AUX_SOURCE}
N -30 -170 -30 -110 {lab=AUX_SOURCE}
N -130 -10 520 -10 {lab=N_VIN}
C {sky130_fd_pr/pfet_01v8.sym} -310 -200 0 0 {
name=MpBiasIn
W=1
L=0.4
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} -50 -200 0 0 {
name=MpAuxBias
W=1
L=0.4
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 430 -200 0 0 {
name=MpSrcBias
W=1
L=0.4
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} -110 -80 0 0 {
name=MpAuxNVin
W=6
L=0.4
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 110 -80 0 1 {
name=MpAuxVout
W=6
L=0.4
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 540 -80 0 1 {
name=MpSrcVin
W=6
L=0.4
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 330 -80 0 0 {
name=MpSrcVout
W=6
L=0.4
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} -310 40 0 0 {
name=MnBiasIn
W=15
L=6
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} -110 40 0 0 {
name=MnDiodeLD
W=2
L=0.4
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 110 40 0 1 {
name=MnMainBias
W=2
L=0.4
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 540 40 0 1 {
name=MnNVin
W=2
L=0.4
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 330 40 0 0 {
name=MnVout
W=2
L=0.4
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {iopin.sym} -260 -280 3 0 {name=pVDD lab=VDD}
C {iopin.sym} 30 140 1 0 {name=pGndA lab=GndA}
C {ipin.sym} 590 -80 0 1 {name=pVIN lab=VIN}
C {iopin.sym} -390 40 0 1 {name=pIBIAS lab=IBIAS}
C {iopin.sym} 210 -80 3 0 {name=pVOUT lab=VOUT}
C {lab_pin.sym} -330 -130 0 0 {name=a4 lab=VBIAS_P}
C {lab_pin.sym} -30 -230 0 0 {name=a5 lab=VDD}
C {lab_pin.sym} -100 -200 0 0 {name=a7 lab=VBIAS_P}
C {lab_pin.sym} 450 -230 0 0 {name=a9 lab=VDD}
C {lab_pin.sym} 360 -200 0 0 {name=a11 lab=VBIAS_P}
C {lab_pin.sym} 450 -170 0 0 {name=a12 lab=MAIN_SOURCE}
C {lab_pin.sym} -30 -140 0 0 {name=b1 lab=AUX_SOURCE}
C {lab_pin.sym} -130 -80 0 0 {name=b3 lab=N_VIN}
C {lab_pin.sym} -130 10 0 0 {name=b4 lab=DIODE_LD}
C {lab_pin.sym} 520 -110 0 1 {name=b9 lab=MAIN_SOURCE}
C {lab_pin.sym} 520 -50 0 1 {name=b12 lab=N_VIN}
C {lab_pin.sym} 350 -110 0 0 {name=b13 lab=MAIN_SOURCE}
C {lab_pin.sym} 350 -50 0 0 {name=b16 lab=VOUT}
C {lab_pin.sym} -290 10 0 0 {name=c1 lab=VBIAS_P}
C {lab_pin.sym} -290 70 0 0 {name=c4 lab=GndA}
C {lab_pin.sym} -90 70 0 0 {name=c8 lab=GndA}
C {lab_pin.sym} 90 70 0 1 {name=c12 lab=GndA}
C {lab_pin.sym} 520 10 0 1 {name=c13 lab=N_VIN}
C {lab_pin.sym} 520 70 0 1 {name=c16 lab=GndA}
C {lab_pin.sym} 350 10 0 0 {name=c17 lab=VOUT}
C {lab_pin.sym} 580 0 0 1 {name=c18 lab=MAIN_BIAS}
C {lab_pin.sym} 350 70 0 0 {name=c20 lab=GndA}
