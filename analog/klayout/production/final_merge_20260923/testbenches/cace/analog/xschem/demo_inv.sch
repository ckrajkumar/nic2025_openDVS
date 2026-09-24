v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -160 -230 -160 -180 {lab=out}
N -200 -260 -200 -150 {lab=in}
N -160 -120 -160 -90 {lab=gd}
N -160 -320 -160 -290 {lab=vdd}
N -160 -260 -130 -260 {lab=vdd}
N -160 -110 -140 -110 {lab=gd}
N -140 -150 -140 -110 {lab=gd}
N -160 -150 -140 -150 {lab=gd}
N -240 -200 -200 -200 {lab=in}
N -160 -200 -120 -200 {lab=out}
C {sky130_fd_pr/nfet_01v8.sym} -180 -150 0 0 {name=Mn
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
C {sky130_fd_pr/pfet_01v8.sym} -180 -260 0 0 {name=Mp
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
model=pfet_01v8
spiceprefix=X
}
C {ipin.sym} -240 -200 0 0 {name=p1 lab=in}
C {iopin.sym} -160 -320 3 0 {name=p2 lab=vdd}
C {iopin.sym} -160 -90 1 0 {name=p3 lab=gd}
C {opin.sym} -120 -200 0 0 {name=p4 lab=out}
C {lab_wire.sym} -130 -260 0 0 {name=p5 sig_type=std_logic lab=vdd}
