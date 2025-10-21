v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -90 -70 -90 30 {lab=Y}
N -560 -120 -540 -120 {lab=A}
N -560 -140 -530 -140 {lab=VNB}
N -290 30 -290 80 {lab=Y}
N -290 30 -90 30 {lab=Y}
N 70 110 110 110 {lab=VNB}
N -90 30 70 30 {lab=Y}
N 70 30 70 80 {lab=Y}
N -560 -100 -540 -100 {lab=B}
N -560 -160 -530 -160 {lab=VGND}
N -560 -180 -530 -180 {lab=VPB}
N -560 -200 -530 -200 {lab=VPWR}
N 70 140 70 180 {lab=VGND}
N -290 140 -290 180 {lab=VGND}
N -290 110 -250 110 {lab=VNB}
N -560 -80 -540 -80 {lab=Y}
N -350 110 -330 110 {lab=A}
N 10 110 30 110 {lab=B}
N -150 -100 -130 -100 {lab=B}
N -90 -250 -90 -130 {lab=a_109_297#}
N -90 -280 -50 -280 {lab=VPB}
N -150 -280 -130 -280 {lab=A}
N -90 -400 -90 -310 {lab=VPWR}
N -90 -100 -50 -100 {lab=VPB}
N 70 30 160 30 {lab=Y}
C {sky130_fd_pr/nfet_01v8.sym} -310 110 0 0 {name=X1
W=0.64
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
C {ipin.sym} -560 -120 0 0 {name=p32 lab=A}
C {opin.sym} -540 -80 0 0 {name=p1 lab=Y}
C {iopin.sym} -560 -140 2 0 {name=p3 lab=VNB}
C {iopin.sym} -560 -180 2 0 {name=p4 lab=VPB}
C {iopin.sym} -560 -200 2 0 {name=p5 lab=VPWR}
C {sky130_fd_pr/nfet_01v8.sym} 50 110 0 0 {name=X2
W=0.65
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
C {ipin.sym} -560 -100 0 0 {name=p11 lab=B}
C {iopin.sym} -560 -160 2 0 {name=p15 lab=VGND}
C {lab_wire.sym} 70 180 3 1 {name=p2 sig_type=std_logic lab=VGND}
C {lab_wire.sym} 110 110 2 1 {name=p9 sig_type=std_logic lab=VNB}
C {lab_wire.sym} -290 180 3 1 {name=p13 sig_type=std_logic lab=VGND}
C {lab_wire.sym} -250 110 2 1 {name=p16 sig_type=std_logic lab=VNB}
C {lab_wire.sym} -350 110 0 1 {name=p17 sig_type=std_logic lab=A}
C {lab_wire.sym} 10 110 0 1 {name=p19 sig_type=std_logic lab=B}
C {sky130_fd_pr/pfet_01v8_hvt.sym} -110 -100 0 0 {name=X3
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
model=pfet_01v8_hvt
spiceprefix=X
}
C {lab_wire.sym} -150 -100 0 1 {name=p23 sig_type=std_logic lab=B}
C {sky130_fd_pr/pfet_01v8_hvt.sym} -110 -280 0 0 {name=X0
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
model=pfet_01v8_hvt
spiceprefix=X
}
C {lab_wire.sym} -150 -280 0 1 {name=p27 sig_type=std_logic lab=A}
C {lab_wire.sym} -90 -400 3 0 {name=p28 sig_type=std_logic lab=VPWR}
C {lab_wire.sym} -90 -160 3 1 {name=p29 sig_type=std_logic lab=a_109_297#}
C {lab_wire.sym} -50 -280 2 1 {name=p34 sig_type=std_logic lab=VPB}
C {lab_wire.sym} -50 -100 2 1 {name=p30 sig_type=std_logic lab=VPB}
C {lab_wire.sym} 160 30 0 1 {name=p6 sig_type=std_logic lab=Y}
