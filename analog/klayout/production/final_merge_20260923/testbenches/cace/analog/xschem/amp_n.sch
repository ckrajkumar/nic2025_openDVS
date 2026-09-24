v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 70 -170 70 -140 {lab=vdd}
N 70 -110 100 -110 {lab=vdd}
N -20 -110 30 -110 {lab=vdio}
N 70 -80 70 -30 {lab=vout}
N -100 -170 -100 -140 {lab=vdd}
N -130 -110 -100 -110 {lab=vdd}
N -20 -110 -20 -50 {lab=vdio}
N -100 -50 -20 -50 {lab=vdio}
N -100 -80 -100 -50 {lab=vdio}
N -60 -110 -20 -110 {lab=vdio}
N -160 0 -140 0 {lab=vp}
N -100 0 -70 0 {lab=gnd}
N 40 0 70 0 {lab=gnd}
N -100 -50 -100 -30 {lab=vdio}
N -100 30 -100 60 {lab=vsource}
N 70 30 70 60 {lab=vsource}
N -100 60 70 60 {lab=vsource}
N -10 60 -10 90 {lab=vsource}
N -10 150 -10 200 {lab=gnd}
N -100 -170 70 -170 {lab=vdd}
N -10 -200 -10 -170 {lab=vdd}
N -10 120 30 120 {lab=gnd}
N 70 -60 150 -60 {lab=vout}
N 110 -0 150 0 {lab=vm}
N -100 120 -50 120 {lab=vbias}
C {sky130_fd_pr/pfet_01v8.sym} 50 -110 0 0 {name=Mmirr
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
C {sky130_fd_pr/pfet_01v8.sym} -80 -110 0 1 {name=Mdio
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
C {sky130_fd_pr/nfet_01v8.sym} -120 0 0 0 {name=Minp
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
C {sky130_fd_pr/nfet_01v8.sym} 90 0 0 1 {name=Minm
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
C {sky130_fd_pr/nfet_01v8.sym} -30 120 0 0 {name=Mbias
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
C {iopin.sym} -10 200 1 0 {name=p1 lab=gnd}
C {iopin.sym} -10 -200 3 0 {name=p2 lab=vdd}
C {lab_wire.sym} 100 -110 0 0 {name=p3 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -130 -110 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -70 0 0 0 {name=p5 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 40 0 0 0 {name=p6 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 30 120 0 0 {name=p7 sig_type=std_logic lab=gnd}
C {ipin.sym} -160 0 0 0 {name=p8 lab=vp}
C {ipin.sym} 150 0 2 0 {name=p9 lab=vm}
C {opin.sym} 150 -60 0 0 {name=p10 lab=vout}
C {ipin.sym} -100 120 0 0 {name=p11 lab=vbias}
C {lab_wire.sym} -20 60 0 0 {name=p19 sig_type=std_logic lab=vsource}
C {lab_wire.sym} 0 -110 0 0 {name=p12 sig_type=std_logic lab=vdio}
