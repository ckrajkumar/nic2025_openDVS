v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
L 4 210 -380 210 -170 {}
L 4 210 -380 1150 -380 {}
L 4 210 -170 1150 -170 {}
L 4 1150 -380 1150 -170 {}
T {Copies coarse current to fine splitter
Branch is chosen depending on coarse current.} -320 -370 0 0 0.4 0.4 {}
T {S1 and S2 are msb coarse bits.
S1 is middle coarse bit
S2 is msb of coarse bits
According to table of coarse currents in BiasBranch
(and because of the unfortunate bit flipping)
these two bits are low for the largest two currents} -340 260 0 0 0.4 0.4 {}
T {Dummy devices} 260 -360 0 0 0.4 0.4 {}
N 60 -200 60 -150 {lab=VddA18}
N 10 -120 60 -120 {lab=VddA18}
N -110 -70 -60 -70 {lab=VddA18}
N 190 -70 240 -70 {lab=VddA18}
N 60 -70 150 -70 {lab=HighBiasDioGate}
N 60 -90 60 -70 {lab=HighBiasDioGate}
N 30 -70 60 -70 {lab=HighBiasDioGate}
N 100 -120 130 -120 {lab=nLowBiasEn}
N -60 -160 -60 -100 {lab=VddA18}
N -260 70 -230 70 {lab=LowBiasEn}
N 190 -150 190 -100 {lab=VddA18}
N -10 -60 -10 -10 {lab=VddA18}
N -190 70 -140 70 {lab=GndA}
N -190 20 -190 40 {lab=HighBiasDioDrain}
N -190 20 -60 20 {lab=HighBiasDioDrain}
N -190 100 -190 150 {lab=GndA}
N 30 -70 30 -10 {lab=HighBiasDioGate}
N -20 -70 30 -70 {lab=HighBiasDioGate}
N 20 -10 30 -10 {lab=HighBiasDioGate}
N -60 -10 -40 -10 {lab=HighBiasDioDrain}
N -60 -40 -60 -10 {lab=HighBiasDioDrain}
N -10 30 -10 70 {lab=LowBiasEn}
N -60 -10 -60 20 {lab=HighBiasDioDrain}
N -60 20 -60 90 {lab=HighBiasDioDrain}
N 190 -10 190 90 {lab=HighBiasMirr}
N 190 120 240 120 {lab=VddA18}
N -110 120 -60 120 {lab=VddA18}
N -20 120 150 120 {lab=LowBiasEn}
N 280 50 310 50 {lab=LowBiasEn}
N 350 50 400 50 {lab=GndA}
N 350 80 350 130 {lab=GndA}
N 190 -10 350 -10 {lab=HighBiasMirr}
N 190 -40 190 -10 {lab=HighBiasMirr}
N 350 -10 350 20 {lab=HighBiasMirr}
N 250 310 250 370 {lab=IIn}
N 200 270 250 270 {lab=VddA18}
N -60 150 -60 210 {lab=#net1}
N 250 210 600 210 {lab=#net1}
N 250 210 250 240 {lab=#net1}
N 190 150 190 170 {lab=IOut}
N 850 -60 900 -60 {lab=VddA18}
N 850 -140 850 -90 {lab=VddA18}
N 600 -140 600 -90 {lab=VddA18}
N 550 -60 600 -60 {lab=VddA18}
N 850 20 900 20 {lab=VddA18}
N 550 20 600 20 {lab=VddA18}
N 600 -30 600 -10 {lab=LowBiasDioInt}
N 850 -30 850 -10 {lab=LowBiasMirrInt}
N 730 -60 730 20 {lab=LowBiasDioGate}
N 730 -60 810 -60 {lab=LowBiasDioGate}
N 730 20 810 20 {lab=LowBiasDioGate}
N 640 -60 730 -60 {lab=LowBiasDioGate}
N 640 20 730 20 {lab=LowBiasDioGate}
N 600 60 600 70 {lab=LowBiasDioGate}
N 850 50 850 70 {lab=LowBiasMirr}
N 640 100 810 100 {lab=nLowBiasEn}
N 600 130 600 210 {lab=#net1}
N 850 130 850 170 {lab=IOut}
N 390 170 390 370 {lab=IOut}
N 390 170 850 170 {lab=IOut}
N -60 210 250 210 {lab=#net1}
N 190 170 390 170 {lab=IOut}
N 290 270 300 270 {lab=IIn}
N 250 310 300 310 {lab=IIn}
N 250 300 250 310 {lab=IIn}
N 300 270 300 310 {lab=IIn}
N 600 60 730 60 {lab=LowBiasDioGate}
N 600 50 600 60 {lab=LowBiasDioGate}
N 730 20 730 60 {lab=LowBiasDioGate}
N 550 100 600 100 {lab=VddA18}
N 850 100 900 100 {lab=VddA18}
N 270 -300 270 -270 {lab=VddA18}
N 270 -300 1060 -300 {lab=VddA18}
N 300 -240 300 -230 {lab=#net2}
N 430 -240 430 -230 {lab=#net3}
N 600 -240 600 -230 {lab=#net4}
N 720 -240 720 -230 {lab=#net5}
N 830 -240 830 -230 {lab=#net6}
N 960 -240 960 -230 {lab=#net7}
N 1060 -240 1060 -230 {lab=#net8}
N 270 -270 1060 -270 {lab=VddA18}
C {sky130_fd_pr/pfet_01v8.sym} 80 -120 0 1 {name=MpDisableHighBias
W=0.42
L=0.15
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
C {iopin.sym} -270 -130 2 0 {name=p11 lab=GndA}
C {iopin.sym} -270 -150 2 0 {name=p12 lab=VddA18}
C {lab_wire.sym} 60 -200 3 0 {name=p1 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 10 -120 2 0 {name=p2 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 130 -120 0 0 {name=p3 sig_type=std_logic lab=nLowBiasEn}
C {sky130_fd_pr/pfet_01v8_lvt.sym} -40 -70 0 1 {name=MpDioHighBias
W=64
L=0.5
nf=1
mult=8
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {lab_wire.sym} -110 -70 2 0 {name=p4 sig_type=std_logic lab=VddA18}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 170 -70 0 0 {name=MpMirrHighBias
W=64
L=0.5
nf=1
mult=8
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {lab_wire.sym} -60 -160 3 0 {name=p5 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 190 -150 3 0 {name=p6 sig_type=std_logic lab=VddA18}
C {sky130_fd_pr/pfet_01v8.sym} -10 10 3 0 {name=MpswDioHighBias
W=0.42
L=0.5
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
C {sky130_fd_pr/nfet_01v8.sym} -210 70 0 0 {name=MnDisableDioHighBias
W=0.42
L=0.15
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
C {lab_wire.sym} -260 70 2 0 {name=p7 sig_type=std_logic lab=LowBiasEn}
C {lab_wire.sym} 240 -70 0 0 {name=p8 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} -10 -60 3 0 {name=p9 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} -140 70 0 0 {name=p10 sig_type=std_logic lab=GndA}
C {lab_wire.sym} -190 150 1 0 {name=p13 sig_type=std_logic lab=GndA}
C {lab_wire.sym} -10 70 1 0 {name=p14 sig_type=std_logic lab=LowBiasEn}
C {sky130_fd_pr/pfet_01v8_hvt.sym} -40 120 0 1 {name=MpSelDioHighBias
W=5
L=1
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_hvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 170 120 0 0 {name=MpSelMirrHighBias
W=5
L=1
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_hvt
spiceprefix=X
}
C {lab_wire.sym} 240 120 0 0 {name=p15 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} -110 120 0 1 {name=p16 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 40 120 0 1 {name=p18 sig_type=std_logic lab=LowBiasEn}
C {sky130_fd_pr/nfet_01v8.sym} 330 50 0 0 {name=MnDisableOutMirr
W=0.42
L=0.15
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
C {lab_wire.sym} 280 50 2 0 {name=p19 sig_type=std_logic lab=LowBiasEn}
C {lab_wire.sym} 400 50 0 0 {name=p20 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 350 130 1 0 {name=p21 sig_type=std_logic lab=GndA}
C {lab_wire.sym} -60 30 3 0 {name=p22 sig_type=std_logic lab=HighBiasDioDrain}
C {lab_wire.sym} 190 20 3 0 {name=p23 sig_type=std_logic lab=HighBiasMirr}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 270 270 0 1 {name=MpInDio
W=9
L=1
nf=1
mult=2
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {iopin.sym} 250 370 1 0 {name=p24 lab=IIn}
C {lab_wire.sym} 200 270 2 0 {name=p25 sig_type=std_logic lab=VddA18}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 620 -60 0 1 {name=MpDioLowBias1
W=4
L=2
nf=1
mult=2
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 830 -60 0 0 {name=MpMirrLowBias1
W=4
L=2
nf=1
mult=2
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {lab_wire.sym} 900 -60 0 0 {name=p27 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 850 -140 3 0 {name=p28 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 600 -140 3 0 {name=p29 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 550 -60 0 1 {name=p30 sig_type=std_logic lab=VddA18}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 620 20 0 1 {name=MpDioLowBias2
W=4
L=2
nf=1
mult=2
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 830 20 0 0 {name=MpMirrLowBias2
W=4
L=2
nf=1
mult=2
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {lab_wire.sym} 900 20 0 0 {name=p31 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 550 20 0 1 {name=p32 sig_type=std_logic lab=VddA18}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 620 100 0 1 {name=MpSelDioLowBias
W=1
L=1
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_hvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 830 100 0 0 {name=MpSelMirrLowBias
W=1
L=1
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_hvt
spiceprefix=X
}
C {iopin.sym} 390 370 1 0 {name=p33 lab=IOut}
C {lab_wire.sym} 720 100 0 1 {name=p26 sig_type=std_logic lab=nLowBiasEn}
C {lab_wire.sym} 690 60 0 0 {name=p34 sig_type=std_logic lab=LowBiasDioGate}
C {lab_wire.sym} 850 60 0 1 {name=p35 sig_type=std_logic lab=LowBiasMirr}
C {lab_wire.sym} 550 100 0 1 {name=p36 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 900 100 0 0 {name=p37 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 850 -20 0 1 {name=p38 sig_type=std_logic lab=LowBiasMirrInt}
C {lab_wire.sym} 600 -10 0 0 {name=p39 sig_type=std_logic lab=LowBiasDioInt}
C {sky130_fd_pr/pfet_01v8.sym} 320 -270 0 1 {name=MpDum1
W=16
L=0.5
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
C {sky130_fd_pr/pfet_01v8.sym} 450 -270 0 1 {name=MpDum2
W=16
L=0.5
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
C {sky130_fd_pr/pfet_01v8.sym} 580 -270 0 0 {name=MpDum3
W=4
L=0.2
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
C {sky130_fd_pr/pfet_01v8.sym} 700 -270 0 0 {name=MpDum4
W=4
L=0.2
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
C {sky130_fd_pr/pfet_01v8.sym} 810 -270 0 0 {name=MpDum5
W=4
L=0.2
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
C {sky130_fd_pr/pfet_01v8.sym} 940 -270 0 0 {name=MpDum6
W=4
L=0.2
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
C {sky130_fd_pr/pfet_01v8.sym} 1040 -270 0 0 {name=MpDum7
W=4
L=0.2
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
C {lab_wire.sym} 400 -300 0 0 {name=p17 sig_type=std_logic lab=VddA18}
C {noconn.sym} 300 -230 3 0 {name=l2}
C {noconn.sym} 430 -230 3 0 {name=l1}
C {noconn.sym} 600 -230 3 0 {name=l3}
C {noconn.sym} 720 -230 3 0 {name=l4}
C {noconn.sym} 830 -230 3 0 {name=l5}
C {noconn.sym} 960 -230 3 0 {name=l6}
C {noconn.sym} 1060 -230 3 0 {name=l7}
C {ipin.sym} -270 -190 0 0 {name=p42 lab=nLowBiasEn}
C {ipin.sym} -270 -170 0 0 {name=p43 lab=LowBiasEn}
C {lab_wire.sym} 120 -70 0 0 {name=p44 sig_type=std_logic lab=HighBiasDioGate}
