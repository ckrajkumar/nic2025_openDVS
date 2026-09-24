v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 70 -260 70 -230 {lab=vsource}
N 40 -200 70 -200 {lab=vdd}
N 70 -170 70 -140 {lab=vout}
N 110 -200 140 -200 {lab=vm}
N -10 -270 70 -270 {lab=vsource}
N -100 -260 -100 -230 {lab=vsource}
N -100 -200 -70 -200 {lab=vdd}
N -190 -200 -140 -200 {lab=vp}
N -100 -170 -100 -120 {lab=vdio}
N -100 -270 -10 -270 {lab=vsource}
N -10 -290 -10 -270 {lab=vsource}
N 70 -270 70 -260 {lab=vsource}
N -100 -270 -100 -260 {lab=vsource}
N -60 -80 -40 -80 {lab=vdio}
N -130 -80 -100 -80 {lab=gnd}
N -100 -50 -100 -30 {lab=gnd}
N -40 -80 30 -80 {lab=vdio}
N 70 -80 100 -80 {lab=gnd}
N -100 -120 -100 -110 {lab=vdio}
N 70 -50 70 -30 {lab=gnd}
N -100 -30 70 -30 {lab=gnd}
N -0 -30 -0 -10 {lab=gnd}
N 70 -140 70 -110 {lab=vout}
N -100 -130 -40 -130 {lab=vdio}
N -40 -130 -40 -80 {lab=vdio}
N -10 -380 -10 -350 {lab=vdd}
N -10 -320 20 -320 {lab=vdd}
N 70 -140 100 -140 {lab=vout}
N -70 -320 -50 -320 {lab=vbias}
C {sky130_fd_pr/pfet_01v8.sym} 90 -200 0 1 {name=Minm
W=1
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
C {sky130_fd_pr/pfet_01v8.sym} -120 -200 0 0 {name=Minp
W=1
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
C {sky130_fd_pr/nfet_01v8.sym} -80 -80 0 1 {name=Mdio
W=1
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
C {sky130_fd_pr/nfet_01v8.sym} 50 -80 0 0 {name=Mmirr
W=1
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
C {sky130_fd_pr/pfet_01v8.sym} -30 -320 0 0 {name=Mbias
W=1
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
C {iopin.sym} 0 -10 1 0 {name=p1 lab=gnd}
C {lab_wire.sym} -70 -200 0 0 {name=p3 sig_type=std_logic lab=vdd}
C {ipin.sym} -190 -200 0 0 {name=p8 lab=vp}
C {ipin.sym} 140 -200 2 0 {name=p9 lab=vm}
C {opin.sym} 100 -140 0 0 {name=p10 lab=vout}
C {ipin.sym} -70 -320 0 0 {name=p11 lab=vbias}
C {iopin.sym} -10 -380 1 1 {name=p2 lab=vdd}
C {lab_wire.sym} 40 -200 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 20 -320 0 0 {name=p5 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 100 -80 0 0 {name=p6 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -130 -80 0 0 {name=p12 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -30 -270 0 0 {name=p19 sig_type=std_logic lab=vsource}
C {lab_wire.sym} -40 -130 0 0 {name=p7 sig_type=std_logic lab=vdio}
