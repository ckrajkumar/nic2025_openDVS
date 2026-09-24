v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -180 -120 -160 -120 {lab=A}
N -180 -140 -150 -140 {lab=VNB}
N -180 -100 -160 -100 {lab=B}
N -180 -160 -150 -160 {lab=VGND}
N -180 -180 -150 -180 {lab=VPB}
N -180 -200 -150 -200 {lab=VPWR}
N 530 230 530 270 {lab=VGND}
N 530 200 570 200 {lab=VNB}
N -180 -80 -160 -80 {lab=X}
N -10 30 10 30 {lab=B}
N 250 40 290 40 {lab=VPB}
N 190 40 210 40 {lab=A}
N 250 -80 250 10 {lab=VPWR}
N 50 30 90 30 {lab=VPB}
N 420 200 490 200 {lab=a_59_75#}
N 530 80 530 170 {lab=X}
N 530 50 570 50 {lab=VPB}
N 530 -70 530 20 {lab=VPWR}
N 420 50 490 50 {lab=a_59_75#}
N 420 120 420 200 {lab=a_59_75#}
N 420 50 420 120 {lab=a_59_75#}
N 250 120 420 120 {lab=a_59_75#}
N 250 120 250 160 {lab=a_59_75#}
N 250 220 250 260 {lab=a_145_75#}
N 250 190 290 190 {lab=VNB}
N 250 320 250 360 {lab=VGND}
N 250 290 290 290 {lab=VNB}
N 190 190 210 190 {lab=A}
N 190 290 210 290 {lab=B}
N 250 100 250 120 {lab=a_59_75#}
N 50 60 50 100 {lab=a_59_75#}
N 50 100 250 100 {lab=a_59_75#}
N 250 70 250 100 {lab=a_59_75#}
N 50 -90 50 0 {lab=VPWR}
C {sky130_fd_pr/nfet_01v8.sym} 510 200 0 0 {name=X0
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
C {ipin.sym} -180 -120 0 0 {name=p32 lab=A}
C {opin.sym} -160 -80 0 0 {name=p1 lab=X}
C {iopin.sym} -180 -140 2 0 {name=p3 lab=VNB}
C {iopin.sym} -180 -180 2 0 {name=p4 lab=VPB}
C {iopin.sym} -180 -200 2 0 {name=p5 lab=VPWR}
C {ipin.sym} -180 -100 0 0 {name=p11 lab=B}
C {iopin.sym} -180 -160 2 0 {name=p15 lab=VGND}
C {lab_wire.sym} 530 270 3 1 {name=p13 sig_type=std_logic lab=VGND}
C {lab_wire.sym} 570 200 2 1 {name=p16 sig_type=std_logic lab=VNB}
C {lab_wire.sym} 190 190 0 1 {name=p17 sig_type=std_logic lab=A}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 30 30 0 0 {name=X4
W=0.42
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
C {lab_wire.sym} -10 30 0 1 {name=p23 sig_type=std_logic lab=B}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 230 40 0 0 {name=X1
W=0.42
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
C {lab_wire.sym} 190 40 0 1 {name=p27 sig_type=std_logic lab=A}
C {lab_wire.sym} 250 -80 3 0 {name=p28 sig_type=std_logic lab=VPWR}
C {lab_wire.sym} 290 40 2 1 {name=p34 sig_type=std_logic lab=VPB}
C {lab_wire.sym} 90 30 2 1 {name=p30 sig_type=std_logic lab=VPB}
C {lab_wire.sym} 350 120 0 1 {name=p7 sig_type=std_logic lab=a_59_75#}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 510 50 0 0 {name=X5
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
C {lab_wire.sym} 530 -70 3 0 {name=p8 sig_type=std_logic lab=VPWR}
C {lab_wire.sym} 570 50 2 1 {name=p10 sig_type=std_logic lab=VPB}
C {lab_wire.sym} 530 130 0 1 {name=p12 sig_type=std_logic lab=X}
C {sky130_fd_pr/nfet_01v8.sym} 230 190 0 0 {name=X2
W=0.42
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
C {lab_wire.sym} 250 360 3 1 {name=p14 sig_type=std_logic lab=VGND}
C {lab_wire.sym} 290 190 2 1 {name=p18 sig_type=std_logic lab=VNB}
C {sky130_fd_pr/nfet_01v8.sym} 230 290 0 0 {name=X3
W=0.42
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
C {lab_wire.sym} 290 290 2 1 {name=p2 sig_type=std_logic lab=VNB}
C {lab_wire.sym} 190 290 0 1 {name=p9 sig_type=std_logic lab=B}
C {lab_wire.sym} 250 250 0 1 {name=p19 sig_type=std_logic lab=a_145_75#}
C {lab_wire.sym} 50 -90 3 0 {name=p6 sig_type=std_logic lab=VPWR}
