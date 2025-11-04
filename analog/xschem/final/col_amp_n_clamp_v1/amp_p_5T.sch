v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
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
N 140 -290 140 -270 {lab=vsource}
N 140 -380 140 -350 {lab=vdd}
N 140 -320 170 -320 {lab=vdd}
N 280 -290 280 -270 {lab=vsource}
N 280 -380 280 -350 {lab=vdd}
N 280 -320 310 -320 {lab=vdd}
N 420 -290 420 -270 {lab=vsource}
N 420 -380 420 -350 {lab=vdd}
N 420 -320 450 -320 {lab=vdd}
N 70 -270 420 -270 {lab=vsource}
N 100 -360 100 -320 {lab=vbias}
N 240 -360 240 -320 {lab=vbias}
N 380 -360 380 -320 {lab=vbias}
N 240 -80 270 -80 {lab=gnd}
N 240 -120 240 -110 {lab=vout}
N 70 -120 240 -120 {lab=vout}
N 240 -50 240 -30 {lab=gnd}
N 70 -30 240 -30 {lab=gnd}
N 160 -80 200 -80 {lab=vdio}
N -230 -80 -210 -80 {lab=vdio}
N -300 -80 -270 -80 {lab=gnd}
N -270 -50 -270 -30 {lab=gnd}
N -270 -120 -270 -110 {lab=vdio}
N -270 -30 -100 -30 {lab=gnd}
N -270 -120 -100 -120 {lab=vdio}
N 270 -200 300 -200 {lab=vdd}
N 340 -200 370 -200 {lab=vm}
N 300 -240 300 -230 {lab=vsource}
N 70 -240 300 -240 {lab=vsource}
N 300 -170 300 -160 {lab=vout}
N 70 -160 300 -160 {lab=vout}
N -330 -260 -330 -230 {lab=vsource}
N -330 -200 -300 -200 {lab=vdd}
N -420 -200 -370 -200 {lab=vp}
N -330 -170 -330 -120 {lab=vdio}
N -330 -260 -100 -260 {lab=vsource}
N -330 -120 -270 -120 {lab=vdio}
C {iopin.sym} 0 -10 1 0 {name=p1 lab=gnd}
C {lab_wire.sym} -70 -200 0 0 {name=p3 sig_type=std_logic lab=vdd}
C {iopin.sym} -10 -380 1 1 {name=p2 lab=vdd}
C {lab_wire.sym} 40 -200 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 20 -320 0 0 {name=p5 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 100 -80 0 0 {name=p6 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -130 -80 0 0 {name=p12 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -30 -270 0 0 {name=p19 sig_type=std_logic lab=vsource}
C {lab_wire.sym} -40 -130 0 0 {name=p7 sig_type=std_logic lab=vdio}
C {iopin.sym} 100 -140 2 1 {name=p13 lab=vout}
C {iopin.sym} -70 -320 2 0 {name=p8 lab=vbias}
C {sky130_fd_pr/pfet_01v8.sym} 90 -200 0 1 {name=Minm
W=0.5
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
C {sky130_fd_pr/pfet_01v8.sym} -120 -200 0 0 {name=Minp
W=0.5
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
C {sky130_fd_pr/nfet_01v8.sym} -80 -80 0 1 {name=Mdio
W=0.5
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
C {sky130_fd_pr/nfet_01v8.sym} 50 -80 0 0 {name=Mmirr
W=0.5
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
C {sky130_fd_pr/pfet_01v8.sym} -30 -320 0 0 {name=Mbias
W=0.5
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
C {lab_wire.sym} 170 -320 0 0 {name=p11 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/pfet_01v8.sym} 120 -320 0 0 {name=Mbias1
W=0.5
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
C {lab_wire.sym} 310 -320 0 0 {name=p14 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/pfet_01v8.sym} 260 -320 0 0 {name=Mbias2
W=0.5
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
C {lab_wire.sym} 450 -320 0 0 {name=p15 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/pfet_01v8.sym} 400 -320 0 0 {name=Mbias3
W=0.5
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
C {lab_wire.sym} 140 -380 0 0 {name=p16 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 280 -380 0 0 {name=p17 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 420 -380 0 0 {name=p18 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 100 -360 0 0 {name=p20 sig_type=std_logic lab=vbias}
C {lab_wire.sym} 240 -360 0 0 {name=p21 sig_type=std_logic lab=vbias}
C {lab_wire.sym} 380 -360 0 0 {name=p22 sig_type=std_logic lab=vbias}
C {lab_wire.sym} 270 -80 0 0 {name=p23 sig_type=std_logic lab=gnd}
C {sky130_fd_pr/nfet_01v8.sym} 220 -80 0 0 {name=Mmirr1
W=0.5
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
C {lab_wire.sym} 180 -80 0 0 {name=p24 sig_type=std_logic lab=vdio}
C {lab_wire.sym} -300 -80 0 0 {name=p25 sig_type=std_logic lab=gnd}
C {sky130_fd_pr/nfet_01v8.sym} -250 -80 0 1 {name=Mdio1
W=0.5
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
C {lab_wire.sym} -210 -80 0 0 {name=p26 sig_type=std_logic lab=vdio}
C {iopin.sym} 370 -200 2 1 {name=p27 lab=vm}
C {sky130_fd_pr/pfet_01v8.sym} 320 -200 0 1 {name=Minm1
W=0.5
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
C {lab_wire.sym} 140 -200 0 0 {name=p10 sig_type=std_logic lab=vm}
C {lab_wire.sym} 270 -200 0 0 {name=p28 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -300 -200 0 0 {name=p29 sig_type=std_logic lab=vdd}
C {iopin.sym} -420 -200 2 0 {name=p30 lab=vp}
C {sky130_fd_pr/pfet_01v8.sym} -350 -200 0 0 {name=Minp1
W=0.5
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
C {lab_wire.sym} -190 -200 0 0 {name=p9 sig_type=std_logic lab=vp}
