v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 100 -100 130 -100 {lab=In}
N 100 20 130 20 {lab=In}
N 100 -90 100 20 {lab=In}
N 170 -30 170 -10 {lab=Out}
N 170 -60 170 -30 {lab=Out}
N 170 -180 170 -130 {lab=VddA18}
N 170 -100 220 -100 {lab=VddA18}
N 170 50 170 100 {lab=GndA}
N 170 20 230 20 {lab=GndA}
N 230 -40 250 -40 {lab=Out}
N 170 -40 230 -40 {lab=Out}
N 170 -70 170 -60 {lab=Out}
N 100 -100 100 -90 {lab=In}
N 50 -40 100 -40 {lab=In}
C {ipin.sym} 50 -40 0 0 {name=p1 lab=In}
C {sky130_fd_pr/pfet_01v8.sym} 150 -100 0 0 {name=Mp
W=0.45
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
C {sky130_fd_pr/nfet_01v8.sym} 150 20 0 0 {name=Mn
W=0.45
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
C {iopin.sym} 100 -150 2 0 {name=p11 lab=GndA}
C {iopin.sym} 100 -170 2 0 {name=p12 lab=VddA18}
C {lab_wire.sym} 170 -180 3 0 {name=p15 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 220 -100 0 0 {name=p17 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 170 100 1 0 {name=p21 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 230 20 2 1 {name=p23 sig_type=std_logic lab=GndA}
C {opin.sym} 250 -40 0 0 {name=p25 lab=Out}
