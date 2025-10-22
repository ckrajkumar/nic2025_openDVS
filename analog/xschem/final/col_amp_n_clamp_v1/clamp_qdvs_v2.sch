v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 40 -50 120 -50 {lab=vdd}
N 40 -270 120 -270 {lab=gnd}
N 0 -320 0 -270 {lab=vgn}
N 0 -320 40 -320 {lab=vgn}
N 40 -320 40 -300 {lab=vgn}
N 0 -50 0 0 {lab=vgp}
N 40 -20 40 0 {lab=vgp}
N 0 0 40 0 {lab=vgp}
N 40 0 40 120 {lab=vgp}
N 40 -440 40 -320 {lab=vgn}
N 40 150 120 150 {lab=gnd}
N 40 180 120 180 {lab=gnd}
N 40 -470 120 -470 {lab=vdd}
N 40 -500 120 -500 {lab=vdd}
N 40 -240 40 -80 {lab=vcm}
N -140 -240 -140 -80 {lab=vout}
N -100 -270 0 -270 {lab=vgn}
N -220 -300 -140 -300 {lab=vdd}
N -220 -270 -140 -270 {lab=gnd}
N -220 -50 -140 -50 {lab=vdd}
N -220 -20 -140 -20 {lab=gnd}
N -100 -50 0 -50 {lab=vgp}
N -80 150 0 150 {lab=clamp_leakn}
N -80 -470 0 -470 {lab=clamp_leakp}
N -440 -270 -440 -100 {lab=vamp}
N -380 -270 -380 -100 {lab=vout}
N -410 -150 -410 -100 {lab=gnd}
N -410 -270 -410 -220 {lab=vdd}
N -380 -160 -140 -160 {lab=vout}
N -500 -160 -440 -160 {lab=vamp}
N -410 -60 -410 -20 {lab=_CLAMP_RST}
N -410 -360 -410 -310 {lab=CLAMP_RST}
C {sky130_fd_pr/nfet_01v8.sym} 20 -270 0 0 {name=M1
W=0.75
L=0.5
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
C {sky130_fd_pr/pfet_01v8.sym} 20 -50 0 0 {name=M2
W=1.5
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
C {sky130_fd_pr/pfet_01v8.sym} 20 -470 0 0 {name=M3
W=1.5
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
C {sky130_fd_pr/nfet_01v8.sym} 20 150 0 0 {name=M4
W=0.75
L=0.5
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
C {sky130_fd_pr/nfet_01v8.sym} -120 -270 0 1 {name=M5
W=0.75
L=0.5
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
C {sky130_fd_pr/pfet_01v8.sym} -120 -50 0 1 {name=M6
W=1.5
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
C {iopin.sym} 120 -500 0 0 {name=p1 lab=vdd}
C {iopin.sym} 120 180 0 0 {name=p2 lab=gnd}
C {lab_wire.sym} 120 150 0 0 {name=p3 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 120 -270 0 0 {name=p4 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 120 -470 0 0 {name=p5 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 120 -50 0 0 {name=p6 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -190 -50 0 0 {name=p7 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -190 -270 0 0 {name=p8 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -190 -300 0 0 {name=p9 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -190 -20 0 0 {name=p10 sig_type=std_logic lab=gnd}
C {sky130_fd_pr/nfet_01v8.sym} -410 -80 1 1 {name=M7
W=0.75
L=0.5
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
C {sky130_fd_pr/pfet_01v8.sym} -410 -290 3 1 {name=M8
W=1.5
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
C {iopin.sym} 40 -150 0 0 {name=p11 lab=vcm}
C {lab_wire.sym} -410 -220 0 0 {name=p12 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -410 -150 0 0 {name=p13 sig_type=std_logic lab=gnd}
C {iopin.sym} -410 -20 0 0 {name=p15 lab=_CLAMP_RST}
C {iopin.sym} -410 -360 0 0 {name=p14 lab=CLAMP_RST}
C {iopin.sym} -80 -470 0 1 {name=p16 lab=clamp_leakp}
C {iopin.sym} -80 150 0 1 {name=p17 lab=clamp_leakn}
C {iopin.sym} -300 -160 1 1 {name=p18 lab=vout}
C {iopin.sym} -500 -160 1 1 {name=p19 lab=vamp}
C {opin.sym} -50 -270 3 0 {name=p20 lab=vgn}
C {opin.sym} -50 -50 1 0 {name=p21 lab=vgp}
