v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -50 70 10 70 {lab=VMasterBiasN}
N -50 -40 10 -40 {lab=VCasc}
N -160 -10 -160 40 {lab=#net1}
N 50 20 50 40 {lab=VMasterBiasN}
N -50 10 50 10 {lab=VMasterBiasN}
N -50 10 -50 70 {lab=VMasterBiasN}
N 50 -90 50 -70 {lab=VCasc}
N -50 -100 50 -100 {lab=VCasc}
N -50 -100 -50 -40 {lab=VCasc}
N 50 -150 50 -100 {lab=VCasc}
N 50 -10 50 10 {lab=VMasterBiasN}
N -100 70 -50 70 {lab=VMasterBiasN}
N -100 -40 -50 -40 {lab=VCasc}
N -160 -120 -160 -70 {lab=VMasterBiasP}
N -160 -120 -80 -120 {lab=VMasterBiasP}
N -80 -180 -80 -120 {lab=VMasterBiasP}
N -160 -130 -160 -120 {lab=VMasterBiasP}
N -100 -180 -80 -180 {lab=VMasterBiasP}
N -210 -180 -160 -180 {lab=VddA18}
N 50 -180 100 -180 {lab=VddA18}
N -100 -220 -100 -180 {lab=VMasterBiasP}
N -80 -180 10 -180 {lab=VMasterBiasP}
N -100 -220 -90 -220 {lab=VMasterBiasP}
N -120 -180 -100 -180 {lab=VMasterBiasP}
N -210 -40 -160 -40 {lab=GndA}
N 50 -40 100 -40 {lab=GndA}
N 50 70 100 70 {lab=GndA}
N -210 70 -160 70 {lab=GndA}
N -160 100 -160 130 {lab=IR}
N 50 100 50 150 {lab=GndA}
N 560 80 560 110 {lab=GndA}
N -100 30 -100 70 {lab=VMasterBiasN}
N -100 30 -90 30 {lab=VMasterBiasN}
N -120 70 -100 70 {lab=VMasterBiasN}
N 50 20 150 20 {lab=VMasterBiasN}
N 50 10 50 20 {lab=VMasterBiasN}
N 150 20 150 70 {lab=VMasterBiasN}
N 150 70 170 70 {lab=VMasterBiasN}
N 210 70 260 70 {lab=GndA}
N 210 100 210 150 {lab=GndA}
N 210 -40 260 -40 {lab=GndA}
N 50 -90 150 -90 {lab=VCasc}
N 150 -90 150 -40 {lab=VCasc}
N 50 -100 50 -90 {lab=VCasc}
N 150 -40 170 -40 {lab=VCasc}
N 210 -10 210 40 {lab=#net2}
N 210 -190 210 -70 {lab=ICoarse1}
N 330 20 330 70 {lab=VMasterBiasN}
N 330 70 350 70 {lab=VMasterBiasN}
N 390 70 440 70 {lab=GndA}
N 390 100 390 150 {lab=GndA}
N 390 -40 440 -40 {lab=GndA}
N 330 -90 330 -40 {lab=VCasc}
N 330 -40 350 -40 {lab=VCasc}
N 390 -10 390 40 {lab=#net3}
N 390 -190 390 -70 {lab=ICoarse2}
N 150 -90 330 -90 {lab=VCasc}
N 150 20 330 20 {lab=VMasterBiasN}
N 590 80 590 110 {lab=VddA18}
N -370 90 -370 140 {lab=GndA}
N -370 60 -320 60 {lab=GndA}
N -370 -40 -320 -40 {lab=VddA18}
N -100 -40 -100 10 {lab=VCasc}
N -120 -40 -100 -40 {lab=VCasc}
N -370 10 -100 10 {lab=VCasc}
N -370 10 -370 30 {lab=VCasc}
N -370 -10 -370 10 {lab=VCasc}
N -250 -130 -160 -130 {lab=VMasterBiasP}
N -160 -150 -160 -130 {lab=VMasterBiasP}
N -370 -100 -370 -70 {lab=#net4}
N -420 -130 -370 -130 {lab=GndA}
N -370 -210 -370 -160 {lab=VddA18}
N -540 -130 -460 -130 {lab=VMasterBiasP}
N -460 -90 -250 -90 {lab=VMasterBiasP}
N -250 -130 -250 -90 {lab=VMasterBiasP}
N -330 -130 -250 -130 {lab=VMasterBiasP}
N -580 -210 -580 -160 {lab=VddA18}
N -630 -130 -580 -130 {lab=VddA18}
N -160 -270 -160 -210 {lab=VddA18}
N 50 -270 50 -210 {lab=VddA18}
N -580 -40 -580 -10 {lab=bootstrap}
N -580 -40 -410 -40 {lab=bootstrap}
N -610 30 -610 60 {lab=BiasPowerDown}
N -610 60 -550 60 {lab=BiasPowerDown}
N -550 30 -550 60 {lab=BiasPowerDown}
N -690 60 -610 60 {lab=BiasPowerDown}
N -550 60 -410 60 {lab=BiasPowerDown}
N -580 30 -580 130 {lab=GndA}
N -580 -110 -580 -40 {lab=bootstrap}
N -460 -130 -460 -90 {lab=VMasterBiasP}
C {sky130_fd_pr/nfet_01v8.sym} 30 70 0 0 {name=MNBiasDio
W=20
L=5
nf=1 
mult=4
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 30 -180 0 0 {name=MPBias
W=2
L=20
nf=1
mult=8
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} -140 70 0 1 {name=MNBias
W=20
L=5
nf=1
mult=16
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 30 -40 0 0 {name=MnBiasCascDio
W=1
L=20
nf=1
mult=2
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} -140 -40 0 1 {name=MnBiasCasc
W=1
L=20
nf=1 
mult=8
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} -140 -180 0 1 {name=MPBiasDio
W=2
L=20
nf=1
mult=8
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {lab_wire.sym} -210 -180 0 1 {name=p1 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} -160 -270 3 0 {name=p2 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 100 -180 0 0 {name=p3 sig_type=std_logic lab=VddA18}
C {opin.sym} -90 -220 0 0 {name=p4 lab=VMasterBiasP}
C {lab_wire.sym} -210 -40 0 1 {name=p5 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 100 -40 0 0 {name=p6 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 100 70 0 0 {name=p7 sig_type=std_logic lab=GndA}
C {lab_wire.sym} -210 70 0 1 {name=p8 sig_type=std_logic lab=GndA}
C {iopin.sym} -160 130 1 0 {name=p9 lab=IR}
C {iopin.sym} 590 110 1 0 {name=p11 lab=VddA18
}
C {iopin.sym} 560 110 1 0 {name=p12 lab=GndA
}
C {lab_wire.sym} 50 150 1 0 {name=p10 sig_type=std_logic lab=GndA}
C {opin.sym} -90 30 0 0 {name=p13 lab=VMasterBiasN}
C {lab_wire.sym} -90 -40 1 0 {name=p14 sig_type=std_logic lab=VCasc}
C {sky130_fd_pr/nfet_01v8.sym} 190 70 0 0 {name=MNMirr1
W=20
L=5
nf=4 
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
C {lab_wire.sym} 260 70 0 0 {name=p15 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 210 150 1 0 {name=p16 sig_type=std_logic lab=GndA}
C {sky130_fd_pr/nfet_01v8.sym} 190 -40 0 0 {name=MNMirrCasc1
W=1
L=20
nf=2
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
C {lab_wire.sym} 260 -40 0 0 {name=p17 sig_type=std_logic lab=GndA}
C {iopin.sym} 210 -190 3 0 {name=p18 lab=ICoarse1}
C {sky130_fd_pr/nfet_01v8.sym} 370 70 0 0 {name=MNMirr2
W=20
L=5
nf=4 
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
C {lab_wire.sym} 440 70 0 0 {name=p19 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 390 150 1 0 {name=p20 sig_type=std_logic lab=GndA}
C {sky130_fd_pr/nfet_01v8.sym} 370 -40 0 0 {name=MNMirrCasc2
W=1
L=20
nf=2
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
C {lab_wire.sym} 440 -40 0 0 {name=p21 sig_type=std_logic lab=GndA}
C {iopin.sym} 390 -190 3 0 {name=p22 lab=ICoarse2}
C {sky130_fd_pr/nfet_01v8.sym} -390 60 0 0 {name=MNBS
W=2
L=0.2
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
C {lab_wire.sym} -370 140 1 0 {name=p23 sig_type=std_logic lab=GndA}
C {lab_wire.sym} -320 60 0 0 {name=p24 sig_type=std_logic lab=GndA}
C {sky130_fd_pr/nfet_01v8.sym} -350 -130 2 0 {name=MNBSPU
W=16
L=16
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
C {lab_wire.sym} -420 -130 0 1 {name=p26 sig_type=std_logic lab=GndA}
C {lab_wire.sym} -370 -210 1 1 {name=p27 sig_type=std_logic lab=VddA18}
C {sky130_fd_pr/pfet_01v8.sym} -560 -130 0 1 {name=MPBS
W=2
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
C {lab_wire.sym} -580 -210 1 1 {name=p28 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} -630 -130 0 1 {name=p29 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 50 -270 3 0 {name=p30 sig_type=std_logic lab=VddA18}
C {sky130_fd_pr/nfet_01v8.sym} -580 10 1 0 {name=MNBSCap
W=16
L=16
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
C {lab_wire.sym} -580 130 1 0 {name=p31 sig_type=std_logic lab=GndA}
C {ipin.sym} -690 60 0 0 {name=p32 lab=BiasPowerDown}
C {lab_wire.sym} -460 -40 0 0 {name=p33 sig_type=std_logic lab=bootstrap}
C {sky130_fd_pr/nfet_01v8.sym} -390 -40 2 1 {name=MNBSPU1
W=2
L=0.2
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
C {lab_wire.sym} -320 -40 2 1 {name=p25 sig_type=std_logic lab=VddA18}
