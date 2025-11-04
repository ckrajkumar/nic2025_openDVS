v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 190 -420 {}
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
N -100 -50 0 -50 {lab=vgp}
N -80 150 0 150 {lab=clamp_leakn}
N -80 -470 0 -470 {lab=clamp_leakp}
N -1040 -290 -1040 -120 {lab=vamp}
N -980 -290 -980 -120 {lab=vout}
N -1010 -170 -1010 -120 {lab=gnd}
N -1010 -290 -1010 -240 {lab=vdd}
N -980 -180 -740 -180 {lab=vout}
N -1100 -180 -1040 -180 {lab=vamp}
N -1010 -80 -1010 -40 {lab=_CLAMP_RST}
N -1010 -380 -1010 -330 {lab=CLAMP_RST}
N 120 -500 290 -500 {lab=vdd}
N 170 -470 250 -470 {lab=clamp_leakp}
N 40 -440 290 -440 {lab=vgn}
N 290 -470 370 -470 {lab=vdd}
N 260 -270 340 -270 {lab=gnd}
N 40 -240 260 -240 {lab=vcm}
N 40 -300 260 -300 {lab=vgn}
N 290 -50 370 -50 {lab=vdd}
N 540 -50 620 -50 {lab=vdd}
N 800 -50 880 -50 {lab=vdd}
N 40 -80 800 -80 {lab=vcm}
N 40 -20 800 -20 {lab=vgp}
N 250 -50 250 -20 {lab=vgp}
N 500 -50 500 -20 {lab=vgp}
N 760 -50 760 -20 {lab=vgp}
N 220 -300 220 -270 {lab=vgn}
N 120 180 260 180 {lab=gnd}
N 260 150 340 150 {lab=gnd}
N 140 150 220 150 {lab=clamp_leakn}
N 40 120 260 120 {lab=vgp}
N -420 -270 -340 -270 {lab=gnd}
N -340 -300 -220 -300 {lab=vdd}
N -340 -240 -140 -240 {lab=vout}
N -170 -270 -140 -270 {lab=gnd}
N -300 -270 -260 -270 {lab=vgn}
N -700 -20 -140 -20 {lab=#net1}
N -700 -80 -140 -80 {lab=vout}
N -370 -50 -340 -50 {lab=vdd}
N -530 -50 -500 -50 {lab=vdd}
N -730 -50 -700 -50 {lab=vdd}
N -170 -50 -140 -50 {lab=vdd}
N -460 -50 -420 -50 {lab=vgp}
N -300 -50 -260 -50 {lab=vgp}
N -660 -50 -620 -50 {lab=vgp}
N -740 -180 -140 -180 {lab=vout}
C {sky130_fd_pr/nfet_01v8.sym} 20 -270 0 0 {name=Mndio
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
C {sky130_fd_pr/pfet_01v8.sym} 20 -50 0 0 {name=Mpdio
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
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 20 -470 0 0 {name=Mpb
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
C {sky130_fd_pr/nfet_01v8.sym} 20 150 0 0 {name=Mnb
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
C {sky130_fd_pr/nfet_01v8.sym} -120 -270 0 1 {name=Mclmp_n
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
C {sky130_fd_pr/pfet_01v8.sym} -120 -50 0 1 {name=Mclmp_p
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
model=pfet_01v8
spiceprefix=X
}
C {iopin.sym} 180 -500 3 0 {name=p1 lab=vdd}
C {iopin.sym} 120 180 1 0 {name=p2 lab=gnd}
C {lab_wire.sym} 120 150 0 0 {name=p3 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 120 -270 0 0 {name=p4 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 120 -470 0 0 {name=p5 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 120 -50 0 0 {name=p6 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -170 -270 0 0 {name=p8 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -190 -300 0 0 {name=p9 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/nfet_01v8.sym} -1010 -100 1 1 {name=Mnsw
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
C {sky130_fd_pr/pfet_01v8.sym} -1010 -310 3 1 {name=Mpsw
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
C {lab_wire.sym} -1010 -240 0 0 {name=p12 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -1010 -170 0 0 {name=p13 sig_type=std_logic lab=gnd}
C {iopin.sym} -1010 -40 0 0 {name=p15 lab=_CLAMP_RST}
C {iopin.sym} -1010 -380 0 0 {name=p14 lab=CLAMP_RST}
C {iopin.sym} -80 -470 0 1 {name=p16 lab=clamp_leakp}
C {iopin.sym} -80 150 0 1 {name=p17 lab=clamp_leakn}
C {iopin.sym} -930 -180 1 1 {name=p18 lab=vout}
C {iopin.sym} -1100 -180 1 1 {name=p19 lab=vamp}
C {opin.sym} -50 -270 3 0 {name=p20 lab=vgn}
C {opin.sym} -50 -50 1 0 {name=p21 lab=vgp}
C {lab_wire.sym} 370 -470 0 0 {name=p22 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 250 -470 0 0 {name=p23 sig_type=std_logic lab=clamp_leakp}
C {lab_wire.sym} 340 -270 0 0 {name=p24 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 370 -50 0 0 {name=p26 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 620 -50 0 0 {name=p27 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 880 -50 0 0 {name=p28 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 340 150 0 0 {name=p25 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 220 150 0 0 {name=p29 sig_type=std_logic lab=clamp_leakn}
C {lab_wire.sym} -390 -270 0 0 {name=p30 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -370 -50 0 0 {name=p7 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -530 -50 0 0 {name=p10 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -730 -50 0 0 {name=p31 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -170 -50 0 0 {name=p32 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -420 -50 0 0 {name=p33 sig_type=std_logic lab=vgp}
C {lab_wire.sym} -260 -50 0 0 {name=p34 sig_type=std_logic lab=vgp}
C {lab_wire.sym} -620 -50 0 0 {name=p35 sig_type=std_logic lab=vgp}
C {lab_wire.sym} -260 -270 0 0 {name=p36 sig_type=std_logic lab=vgn}
C {sky130_fd_pr/pfet_01v8.sym} -320 -50 0 1 {name=Mclmp_p1
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
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} -480 -50 0 1 {name=Mclmp_p2
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
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} -680 -50 0 1 {name=Mclmp_p3
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
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 240 150 0 0 {name=Mnb1
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
C {sky130_fd_pr/pfet_01v8.sym} 270 -470 0 0 {name=Mpb1
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
C {sky130_fd_pr/pfet_01v8.sym} 270 -50 0 0 {name=Mpdio1
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
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 520 -50 0 0 {name=Mpdio2
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
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 780 -50 0 0 {name=Mpdio3
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
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 240 -270 0 0 {name=Mndio1
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
C {sky130_fd_pr/nfet_01v8.sym} -320 -270 0 1 {name=Mclmp_n1
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
C {lab_wire.sym} -430 -20 0 0 {name=p37 sig_type=std_logic lab=gnd}
