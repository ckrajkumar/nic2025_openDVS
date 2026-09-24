v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 130 -340 130 -240 {lab=a_205_297#}
N -560 -120 -540 -120 {lab=A}
N -560 -140 -530 -140 {lab=VNB}
N 130 -210 170 -210 {lab=VPB}
N -290 30 -290 80 {lab=a_27_297#}
N -110 140 -110 180 {lab=VGND}
N -110 110 -70 110 {lab=VNB}
N -290 30 -110 30 {lab=a_27_297#}
N -110 30 -110 80 {lab=a_27_297#}
N -560 -60 -540 -60 {lab=D}
N 70 110 110 110 {lab=VNB}
N -110 30 70 30 {lab=a_27_297#}
N 70 30 70 80 {lab=a_27_297#}
N -560 -100 -540 -100 {lab=B}
N 480 110 520 110 {lab=VNB}
N 420 110 440 110 {lab=a_27_297#}
N 250 30 420 30 {lab=a_27_297#}
N 420 30 420 110 {lab=a_27_297#}
N -560 -80 -540 -80 {lab=C}
N -560 -160 -530 -160 {lab=VGND}
N -560 -180 -530 -180 {lab=VPB}
N -560 -200 -530 -200 {lab=VPWR}
N 70 140 70 180 {lab=VGND}
N 480 140 480 180 {lab=VGND}
N -290 140 -290 180 {lab=VGND}
N -290 110 -250 110 {lab=VNB}
N -580 -30 -560 -30 {lab=X}
N -350 110 -330 110 {lab=A}
N -170 110 -150 110 {lab=D}
N 10 110 30 110 {lab=B}
N 70 -210 90 -210 {lab=C}
N 130 -180 130 -80 {lab=a_109_297#}
N 70 -370 90 -370 {lab=B}
N 250 110 290 110 {lab=VNB}
N 250 140 250 180 {lab=VGND}
N 190 110 210 110 {lab=C}
N 130 30 250 30 {lab=a_27_297#}
N 250 30 250 80 {lab=a_27_297#}
N 130 -520 130 -400 {lab=a_277_297#}
N 130 -550 170 -550 {lab=VPB}
N 70 -550 90 -550 {lab=A}
N 130 -670 130 -580 {lab=VPWR}
N 130 -370 170 -370 {lab=VPB}
N 130 -50 170 -50 {lab=VPB}
N 70 -50 90 -50 {lab=D}
N 130 -20 130 30 {lab=a_27_297#}
N 70 30 130 30 {lab=a_27_297#}
N 420 -50 440 -50 {lab=a_27_297#}
N 420 -50 420 30 {lab=a_27_297#}
N 480 30 480 80 {lab=X}
N 480 -50 520 -50 {lab=VPB}
N 480 -130 480 -80 {lab=VPWR}
N 480 30 530 30 {lab=X}
N 480 -20 480 30 {lab=X}
C {sky130_fd_pr/nfet_01v8.sym} -310 110 0 0 {name=X0
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
C {sky130_fd_pr/pfet_01v8_hvt.sym} 110 -210 0 0 {name=X4
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
C {ipin.sym} -560 -120 0 0 {name=p32 lab=A}
C {opin.sym} -560 -30 0 0 {name=p1 lab=X}
C {iopin.sym} -560 -140 2 0 {name=p3 lab=VNB}
C {iopin.sym} -560 -180 2 0 {name=p4 lab=VPB}
C {iopin.sym} -560 -200 2 0 {name=p5 lab=VPWR}
C {lab_wire.sym} -180 30 0 0 {name=p31 sig_type=std_logic lab=a_27_297#}
C {sky130_fd_pr/nfet_01v8.sym} -130 110 0 0 {name=X1
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
C {lab_wire.sym} -110 180 3 1 {name=p6 sig_type=std_logic lab=VGND}
C {lab_wire.sym} -70 110 2 1 {name=p7 sig_type=std_logic lab=VNB}
C {ipin.sym} -560 -60 0 0 {name=p8 lab=D}
C {sky130_fd_pr/nfet_01v8.sym} 50 110 0 0 {name=X2
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
C {ipin.sym} -560 -100 0 0 {name=p11 lab=B}
C {sky130_fd_pr/nfet_01v8.sym} 460 110 0 0 {name=X3
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
C {ipin.sym} -560 -80 0 0 {name=p14 lab=C}
C {iopin.sym} -560 -160 2 0 {name=p15 lab=VGND}
C {lab_wire.sym} 70 180 3 1 {name=p2 sig_type=std_logic lab=VGND}
C {lab_wire.sym} 110 110 2 1 {name=p9 sig_type=std_logic lab=VNB}
C {lab_wire.sym} 480 180 3 1 {name=p10 sig_type=std_logic lab=VGND}
C {lab_wire.sym} 520 110 2 1 {name=p12 sig_type=std_logic lab=VNB}
C {lab_wire.sym} -290 180 3 1 {name=p13 sig_type=std_logic lab=VGND}
C {lab_wire.sym} -250 110 2 1 {name=p16 sig_type=std_logic lab=VNB}
C {lab_wire.sym} -350 110 0 1 {name=p17 sig_type=std_logic lab=A}
C {lab_wire.sym} -170 110 0 1 {name=p18 sig_type=std_logic lab=D}
C {lab_wire.sym} 10 110 0 1 {name=p19 sig_type=std_logic lab=B}
C {lab_wire.sym} 70 -210 0 1 {name=p20 sig_type=std_logic lab=C}
C {lab_wire.sym} 130 -90 3 1 {name=p21 sig_type=std_logic lab=a_109_297#}
C {lab_wire.sym} 130 -250 3 1 {name=p22 sig_type=std_logic lab=a_205_297#}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 110 -370 0 0 {name=X5
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
C {lab_wire.sym} 70 -370 0 1 {name=p23 sig_type=std_logic lab=B}
C {sky130_fd_pr/nfet_01v8.sym} 230 110 0 0 {name=X6
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
C {lab_wire.sym} 250 180 3 1 {name=p24 sig_type=std_logic lab=VGND}
C {lab_wire.sym} 290 110 2 1 {name=p25 sig_type=std_logic lab=VNB}
C {lab_wire.sym} 190 110 0 1 {name=p26 sig_type=std_logic lab=C}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 110 -550 0 0 {name=X7
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
C {lab_wire.sym} 70 -550 0 1 {name=p27 sig_type=std_logic lab=A}
C {lab_wire.sym} 130 -670 3 0 {name=p28 sig_type=std_logic lab=VPWR}
C {lab_wire.sym} 130 -430 3 1 {name=p29 sig_type=std_logic lab=a_277_297#}
C {lab_wire.sym} 170 -550 2 1 {name=p34 sig_type=std_logic lab=VPB}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 110 -50 0 0 {name=X8
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
C {lab_wire.sym} 70 -50 0 1 {name=p35 sig_type=std_logic lab=D}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 460 -50 0 0 {name=X9
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
C {lab_wire.sym} 480 -130 3 0 {name=p38 sig_type=std_logic lab=VPWR}
C {lab_wire.sym} 530 30 2 1 {name=p39 sig_type=std_logic lab=X}
C {lab_wire.sym} 170 -370 2 1 {name=p30 sig_type=std_logic lab=VPB}
C {lab_wire.sym} 170 -210 2 1 {name=p33 sig_type=std_logic lab=VPB}
C {lab_wire.sym} 170 -50 2 1 {name=p36 sig_type=std_logic lab=VPB}
C {lab_wire.sym} 520 -50 2 1 {name=p37 sig_type=std_logic lab=VPB}
