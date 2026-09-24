v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 80 -360 80 -330 {lab=vdd}
N 80 -300 110 -300 {lab=vdd}
N -10 -300 40 -300 {lab=dio}
N 80 -270 80 -220 {lab=out1}
N -90 -360 -90 -330 {lab=vdd}
N -120 -300 -90 -300 {lab=vdd}
N -10 -300 -10 -240 {lab=dio}
N -90 -240 -10 -240 {lab=dio}
N -90 -270 -90 -240 {lab=dio}
N -50 -300 -10 -300 {lab=dio}
N -150 -190 -130 -190 {lab=vm}
N -90 -190 -60 -190 {lab=gnd}
N 120 -190 140 -190 {lab=vp}
N 50 -190 80 -190 {lab=gnd}
N -90 -240 -90 -220 {lab=dio}
N -90 -160 -90 -130 {lab=vsource}
N 80 -160 80 -130 {lab=vsource}
N -90 -130 80 -130 {lab=vsource}
N 0 -130 0 -100 {lab=vsource}
N 290 -230 350 -230 {lab=vout}
N 290 -150 290 -130 {lab=gnd}
N 290 -180 320 -180 {lab=gnd}
N 290 -350 290 -320 {lab=vdd}
N 290 -290 320 -290 {lab=vdd}
N 200 -290 250 -290 {lab=out1}
N 290 -260 290 -210 {lab=vout}
N 200 -180 250 -180 {lab=out1}
N 200 -290 200 -190 {lab=out1}
N 200 -190 200 -180 {lab=out1}
N 80 -250 200 -250 {lab=out1}
N 0 -40 0 -10 {lab=gnd}
N -90 -70 -40 -70 {lab=vbias}
N 0 -70 30 -70 {lab=gnd}
C {sky130_fd_pr/pfet_01v8.sym} 60 -300 0 0 {name=Mmirr
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
C {sky130_fd_pr/pfet_01v8.sym} -70 -300 0 1 {name=Mdio
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
C {sky130_fd_pr/nfet_01v8.sym} -110 -190 0 0 {name=Minm
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
C {sky130_fd_pr/nfet_01v8.sym} 100 -190 0 1 {name=Minp
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
C {sky130_fd_pr/nfet_01v8.sym} 270 -180 0 0 {name=Minvn
W=0.5
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
C {sky130_fd_pr/pfet_01v8.sym} 270 -290 0 0 {name=Minvp
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
C {iopin.sym} -90 -360 3 0 {name=p2 lab=vdd}
C {lab_wire.sym} 110 -300 0 0 {name=p3 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 80 -360 0 0 {name=p1 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 290 -350 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 320 -290 0 0 {name=p5 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -120 -300 0 0 {name=p6 sig_type=std_logic lab=vdd}
C {iopin.sym} 0 -10 1 0 {name=p12 lab=gnd}
C {lab_wire.sym} -60 -190 0 0 {name=p18 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 50 -190 0 0 {name=p7 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 320 -180 0 0 {name=p8 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 290 -130 0 0 {name=p9 sig_type=std_logic lab=gnd}
C {sky130_fd_pr/nfet_01v8.sym} -20 -70 0 0 {name=Mbias
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
C {lab_wire.sym} 30 -70 0 0 {name=p10 sig_type=std_logic lab=gnd}
C {ipin.sym} -90 -70 0 0 {name=p11 lab=vbias}
C {ipin.sym} -150 -190 0 0 {name=p14 lab=vm}
C {ipin.sym} 140 -190 2 0 {name=p15 lab=vp}
C {opin.sym} 350 -230 0 0 {name=p16 lab=vout}
C {lab_wire.sym} 170 -250 0 0 {name=p13 sig_type=std_logic lab=out1}
C {lab_wire.sym} 10 -300 0 0 {name=p17 sig_type=std_logic lab=dio}
C {lab_wire.sym} -10 -130 0 0 {name=p19 sig_type=std_logic lab=vsource}
