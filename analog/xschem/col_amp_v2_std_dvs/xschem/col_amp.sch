v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 -120 -160 {}
N 0 -180 -0 -60 {lab=COL_OUT}
N -40 -100 -40 -30 {lab=COL_OUT}
N -40 -100 -0 -100 {lab=COL_OUT}
N -0 0 0 40 {lab=COL_LINE}
N 90 -30 90 10 {lab=GND}
N -0 -30 90 -30 {lab=GND}
N 0 -210 90 -210 {lab=VDD}
N -100 -210 -40 -210 {lab=nCHARGE}
N 0 -280 0 -240 {lab=VDD}
C {sky130_fd_pr/nfet_01v8.sym} -20 -30 0 0 {name=M1
W=1
L=1
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
C {sky130_fd_pr/pfet_01v8.sym} -20 -210 0 0 {name=M2
W=1
L=1
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
C {ipin.sym} -100 -210 0 0 {name=p1 lab=nCHARGE}
C {opin.sym} -40 -100 0 1 {name=p2 lab=COL_OUT}
C {iopin.sym} 0 -280 0 0 {name=p3 lab=VDD}
C {iopin.sym} 90 10 0 0 {name=p5 lab=GND}
C {iopin.sym} 0 40 0 1 {name=p6 lab=COL_LINE}
C {lab_wire.sym} 90 -210 0 1 {name=p4 sig_type=std_logic lab=VDD}
