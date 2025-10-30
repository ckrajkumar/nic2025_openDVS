v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 250 -140 300 -140 {lab=INext}
N 130 -140 130 -110 {lab=IPrev}
N 80 -80 130 -80 {lab=VddA18}
N 220 -100 220 -80 {lab=VGate}
N 170 -80 220 -80 {lab=VGate}
N 50 -140 130 -140 {lab=IPrev}
N 130 -140 190 -140 {lab=IPrev}
N 220 -190 220 -140 {lab=VddA18}
N 80 -10 130 -10 {lab=VddA18}
N 130 -50 130 -40 {lab=#net1}
N 140 60 190 60 {lab=VddA18}
N 190 20 190 30 {lab=#net2}
N 70 60 120 60 {lab=VddA18}
N 70 20 70 30 {lab=#net2}
N 70 20 190 20 {lab=#net2}
N 10 60 30 60 {lab=nSel}
N 230 60 250 60 {lab=Sel}
N 70 90 70 120 {lab=IOut}
N 190 90 190 120 {lab=INOut}
N 170 -10 220 -10 {lab=VGate}
N 220 -80 220 -10 {lab=VGate}
N 220 -80 250 -80 {lab=VGate}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 220 -120 3 0 {name=Mr
W=9
L=1
nf=1
mult=2
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 150 -80 0 1 {name=M2ru
W=9
L=1
nf=1
mult=2
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {iopin.sym} 300 -140 2 1 {name=p1 lab=INext}
C {iopin.sym} 70 120 3 1 {name=p2 lab=IOut}
C {iopin.sym} 50 -140 0 1 {name=p3 lab=IPrev}
C {ipin.sym} 250 -80 0 1 {name=p4 lab=VGate}
C {iopin.sym} -20 -60 0 1 {name=p5 lab=VddA18}
C {lab_wire.sym} 80 -80 2 0 {name=p37 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 220 -190 3 0 {name=p6 sig_type=std_logic lab=VddA18}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 150 -10 0 1 {name=M2rl
W=9
L=1
nf=1
mult=2
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {lab_wire.sym} 80 -10 2 0 {name=p7 sig_type=std_logic lab=VddA18}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 210 60 0 1 {name=MswNOut
W=2
L=0.5
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_hvt
spiceprefix=X
}
C {lab_wire.sym} 140 60 2 0 {name=p8 sig_type=std_logic lab=VddA18}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 50 60 0 0 {name=MswOut
W=2
L=0.5
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_hvt
spiceprefix=X
}
C {lab_wire.sym} 120 60 2 1 {name=p9 sig_type=std_logic lab=VddA18}
C {ipin.sym} 10 60 2 1 {name=p10 lab=nSel}
C {ipin.sym} 250 60 0 1 {name=p11 lab=Sel}
C {iopin.sym} 190 120 3 1 {name=p12 lab=INOut}
