v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
L 4 710 -320 710 -110 {}
L 4 710 -320 1650 -320 {}
L 4 710 -110 1650 -110 {}
L 4 1650 -320 1650 -110 {}
T {Copies coarse current to fine splitter
Branch is chosen depending on coarse current.} 180 -310 0 0 0.4 0.4 {}
T {S1 and S2 are msb coarse bits.
S1 is middle coarse bit
S2 is msb of coarse bits
According to table of coarse currents in BiasBranch
(and because of the unfortunate bit flipping)
these two bits are low for the largest two currents} 160 320 0 0 0.4 0.4 {}
T {Dummy devices} 760 -300 0 0 0.4 0.4 {}
N 560 -140 560 -90 {lab=VddA18}
N 510 -60 560 -60 {lab=VddA18}
N 390 -10 440 -10 {lab=VddA18}
N 690 -10 740 -10 {lab=VddA18}
N 560 -10 650 -10 {lab=OutDioGate}
N 560 -30 560 -10 {lab=OutDioGate}
N 530 -10 560 -10 {lab=OutDioGate}
N 600 -60 630 -60 {lab=Out}
N 440 -100 440 -40 {lab=VddA18}
N 240 130 270 130 {lab=nOut}
N 690 -90 690 -40 {lab=VddA18}
N 490 0 490 50 {lab=VddA18}
N 310 130 360 130 {lab=GndA}
N 310 80 310 100 {lab=OutDioDrain}
N 310 80 440 80 {lab=OutDioDrain}
N 310 160 310 210 {lab=GndA}
N 530 -10 530 50 {lab=OutDioGate}
N 480 -10 530 -10 {lab=OutDioGate}
N 520 50 530 50 {lab=OutDioGate}
N 440 50 460 50 {lab=OutDioDrain}
N 440 20 440 50 {lab=OutDioDrain}
N 490 90 490 130 {lab=nOut}
N 440 50 440 80 {lab=OutDioDrain}
N 440 80 440 150 {lab=OutDioDrain}
N 690 50 690 150 {lab=OutMirr}
N 690 180 740 180 {lab=VddA18}
N 390 180 440 180 {lab=VddA18}
N 480 180 650 180 {lab=nOut}
N 780 110 810 110 {lab=nOut}
N 850 110 900 110 {lab=GndA}
N 850 140 850 190 {lab=GndA}
N 690 50 850 50 {lab=OutMirr}
N 690 20 690 50 {lab=OutMirr}
N 850 50 850 80 {lab=OutMirr}
N 750 370 750 430 {lab=IIn}
N 700 330 750 330 {lab=VddA18}
N 440 210 440 270 {lab=#net1}
N 750 270 1100 270 {lab=#net1}
N 750 270 750 300 {lab=#net1}
N 690 210 690 230 {lab=IOut}
N 1350 0 1400 0 {lab=VddA18}
N 1350 -80 1350 -30 {lab=VddA18}
N 1100 -80 1100 -30 {lab=VddA18}
N 1050 0 1100 0 {lab=VddA18}
N 1350 80 1400 80 {lab=VddA18}
N 1050 80 1100 80 {lab=VddA18}
N 1100 30 1100 50 {lab=nOutDioInt}
N 1350 30 1350 50 {lab=nOutMirrInt}
N 1230 0 1230 80 {lab=nOutDio}
N 1230 0 1310 0 {lab=nOutDio}
N 1230 80 1310 80 {lab=nOutDio}
N 1140 0 1230 0 {lab=nOutDio}
N 1140 80 1230 80 {lab=nOutDio}
N 1100 120 1100 130 {lab=nOutDio}
N 1350 110 1350 130 {lab=nOutMirr}
N 1140 160 1310 160 {lab=Out}
N 1100 190 1100 270 {lab=#net1}
N 1350 190 1350 230 {lab=IOut}
N 890 230 890 430 {lab=IOut}
N 890 230 1350 230 {lab=IOut}
N 440 270 750 270 {lab=#net1}
N 690 230 890 230 {lab=IOut}
N 790 330 800 330 {lab=IIn}
N 750 370 800 370 {lab=IIn}
N 750 360 750 370 {lab=IIn}
N 800 330 800 370 {lab=IIn}
N 1100 120 1230 120 {lab=nOutDio}
N 1100 110 1100 120 {lab=nOutDio}
N 1230 80 1230 120 {lab=nOutDio}
N 1050 160 1100 160 {lab=VddA18}
N 1350 160 1400 160 {lab=VddA18}
N 770 -240 770 -210 {lab=VddA18}
N 770 -240 1560 -240 {lab=VddA18}
N 800 -180 800 -170 {lab=#net2}
N 930 -180 930 -170 {lab=#net3}
N 1100 -180 1100 -170 {lab=#net4}
N 1220 -180 1220 -170 {lab=#net5}
N 1330 -180 1330 -170 {lab=#net6}
N 1460 -180 1460 -170 {lab=#net7}
N 1560 -180 1560 -170 {lab=#net8}
N 330 -160 360 -160 {lab=Out}
N 440 -160 480 -160 {lab=nOut}
N 190 -180 210 -180 {lab=S2}
N 190 -140 210 -140 {lab=S1}
N 770 -210 1560 -210 {lab=VddA18}
N 250 -170 420 -170 {lab=VddA18}
N 250 -150 420 -150 {lab=GndA}
C {sky130_fd_pr/pfet_01v8.sym} 580 -60 0 1 {name=MpDisableOut
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
C {iopin.sym} 230 -70 2 0 {name=p11 lab=GndA}
C {iopin.sym} 230 -90 2 0 {name=p12 lab=VddA18}
C {lab_wire.sym} 560 -140 3 0 {name=p1 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 510 -60 2 0 {name=p2 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 630 -60 0 0 {name=p3 sig_type=std_logic lab=Out}
C {sky130_fd_pr/pfet_01v8.sym} 460 -10 0 1 {name=MpDioOut
W=64
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
C {lab_wire.sym} 390 -10 2 0 {name=p4 sig_type=std_logic lab=VddA18}
C {sky130_fd_pr/pfet_01v8.sym} 670 -10 0 0 {name=MpMirrOut
W=64
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
C {lab_wire.sym} 440 -100 3 0 {name=p5 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 690 -90 3 0 {name=p6 sig_type=std_logic lab=VddA18}
C {sky130_fd_pr/pfet_01v8.sym} 490 70 3 0 {name=MpswDioOut
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
C {sky130_fd_pr/nfet_01v8.sym} 290 130 0 0 {name=MnDisableOutDio
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
C {lab_wire.sym} 240 130 2 0 {name=p7 sig_type=std_logic lab=nOut}
C {lab_wire.sym} 740 -10 0 0 {name=p8 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 490 0 3 0 {name=p9 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 360 130 0 0 {name=p10 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 310 210 1 0 {name=p13 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 490 130 1 0 {name=p14 sig_type=std_logic lab=nOut}
C {sky130_fd_pr/pfet_01v8.sym} 460 180 0 1 {name=MpSelOutDio
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
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 670 180 0 0 {name=MpSelOutMirr1
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
model=pfet_01v8
spiceprefix=X
}
C {lab_wire.sym} 740 180 0 0 {name=p15 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 390 180 0 1 {name=p16 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 540 180 0 1 {name=p18 sig_type=std_logic lab=nOut}
C {sky130_fd_pr/nfet_01v8.sym} 830 110 0 0 {name=MnDisableOutMirr
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
C {lab_wire.sym} 780 110 2 0 {name=p19 sig_type=std_logic lab=nOut}
C {lab_wire.sym} 900 110 0 0 {name=p20 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 850 190 1 0 {name=p21 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 440 90 3 0 {name=p22 sig_type=std_logic lab=OutDioDrain}
C {lab_wire.sym} 690 80 3 0 {name=p23 sig_type=std_logic lab=OutMirr}
C {sky130_fd_pr/pfet_01v8.sym} 770 330 0 1 {name=MpSelOutDio1
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
model=pfet_01v8
spiceprefix=X
}
C {iopin.sym} 750 430 1 0 {name=p24 lab=IIn}
C {lab_wire.sym} 700 330 2 0 {name=p25 sig_type=std_logic lab=VddA18}
C {sky130_fd_pr/pfet_01v8.sym} 1120 0 0 1 {name=MpDionOut1
W=4
L=2
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
C {sky130_fd_pr/pfet_01v8.sym} 1330 0 0 0 {name=MpMirrnOut1
W=4
L=2
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
C {lab_wire.sym} 1400 0 0 0 {name=p27 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 1350 -80 3 0 {name=p28 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 1100 -80 3 0 {name=p29 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 1050 0 0 1 {name=p30 sig_type=std_logic lab=VddA18}
C {sky130_fd_pr/pfet_01v8.sym} 1120 80 0 1 {name=MpDionOut2
W=4
L=2
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
C {sky130_fd_pr/pfet_01v8.sym} 1330 80 0 0 {name=MpMirrnOut2
W=4
L=2
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
C {lab_wire.sym} 1400 80 0 0 {name=p31 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 1050 80 0 1 {name=p32 sig_type=std_logic lab=VddA18}
C {sky130_fd_pr/pfet_01v8.sym} 1120 160 0 1 {name=MpSelnOutDio
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
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 1330 160 0 0 {name=MpSelnOutMirr
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
model=pfet_01v8
spiceprefix=X
}
C {iopin.sym} 890 430 1 0 {name=p33 lab=IOut}
C {lab_wire.sym} 1220 160 0 1 {name=p26 sig_type=std_logic lab=Out}
C {lab_wire.sym} 1190 120 0 0 {name=p34 sig_type=std_logic lab=nOutDio}
C {lab_wire.sym} 1350 120 0 1 {name=p35 sig_type=std_logic lab=nOutMirr}
C {lab_wire.sym} 1050 160 0 1 {name=p36 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 1400 160 0 0 {name=p37 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 1350 40 0 1 {name=p38 sig_type=std_logic lab=nOutMirrInt}
C {lab_wire.sym} 1100 50 0 0 {name=p39 sig_type=std_logic lab=nOutDioInt}
C {sky130_fd_pr/pfet_01v8.sym} 820 -210 0 1 {name=MpDum1
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
C {sky130_fd_pr/pfet_01v8.sym} 950 -210 0 1 {name=MpDum2
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
C {sky130_fd_pr/pfet_01v8.sym} 1080 -210 0 0 {name=MpDum3
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
C {sky130_fd_pr/pfet_01v8.sym} 1200 -210 0 0 {name=MpDum4
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
C {sky130_fd_pr/pfet_01v8.sym} 1310 -210 0 0 {name=MpDum5
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
C {sky130_fd_pr/pfet_01v8.sym} 1440 -210 0 0 {name=MpDum6
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
C {sky130_fd_pr/pfet_01v8.sym} 1540 -210 0 0 {name=MpDum7
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
C {lab_wire.sym} 900 -240 0 0 {name=p17 sig_type=std_logic lab=VddA18}
C {noconn.sym} 800 -170 3 0 {name=l2}
C {noconn.sym} 930 -170 3 0 {name=l1}
C {noconn.sym} 1100 -170 3 0 {name=l3}
C {noconn.sym} 1220 -170 3 0 {name=l4}
C {noconn.sym} 1330 -170 3 0 {name=l5}
C {noconn.sym} 1460 -170 3 0 {name=l6}
C {noconn.sym} 1560 -170 3 0 {name=l7}
C {lab_wire.sym} 340 -160 2 0 {name=p40 sig_type=std_logic lab=Out}
C {lab_wire.sym} 450 -160 2 0 {name=p41 sig_type=std_logic lab=nOut}
C {ipin.sym} 190 -180 0 0 {name=p42 lab=S2}
C {ipin.sym} 190 -140 0 0 {name=p43 lab=S1}
C {lab_wire.sym} 620 -10 0 0 {name=p44 sig_type=std_logic lab=OutDioGate}
C {sky130_fd_sc_hd__nor2_1.sym} 270 -160 0 0 {name=xnor}
C {sky130_fd_sc_hd__inv_1.sym} 400 -160 0 0 {name=xinv}
C {lab_wire.sym} 350 -170 0 0 {name=p45 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 330 -150 2 1 {name=p46 sig_type=std_logic lab=GndA}
