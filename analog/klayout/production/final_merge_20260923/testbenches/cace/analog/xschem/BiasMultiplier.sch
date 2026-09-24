v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 410 -280 470 -280 {lab=#net1}
N 590 -280 640 -280 {lab=VddA18}
N 530 -220 530 -160 {lab=IOut1}
N 350 -220 350 -160 {lab=IOut0}
N 70 -220 110 -220 {lab=#net2}
N 70 -280 70 -220 {lab=#net2}
N 70 -280 110 -280 {lab=#net2}
N 110 -280 110 -250 {lab=#net2}
N 110 -190 110 -130 {lab=GndA}
N 530 -370 530 -340 {lab=IIn}
N 350 -370 530 -370 {lab=IIn}
N 350 -370 350 -340 {lab=IIn}
N 150 -370 150 -220 {lab=IIn}
N 260 -370 350 -370 {lab=IIn}
N 210 -280 290 -280 {lab=#net2}
N 250 -220 260 -220 {lab=IIn}
N 260 -370 260 -220 {lab=IIn}
N 210 -280 210 -250 {lab=#net2}
N 190 -280 210 -280 {lab=#net2}
N 210 -190 210 -130 {lab=IIn}
N 190 -220 210 -220 {lab=#net2}
N 190 -280 190 -220 {lab=#net2}
N 110 -280 190 -280 {lab=#net2}
N 150 -370 260 -370 {lab=IIn}
N 210 -160 260 -160 {lab=IIn}
N 260 -220 260 -160 {lab=IIn}
C {BiasMultiplierCell.sym} 290 -220 0 0 {name=xMultCell0}
C {BiasMultiplierCell.sym} 470 -220 0 0 {name=xMultCell1}
C {iopin.sym} -20 -310 2 0 {name=p1 lab=GndA}
C {iopin.sym} -20 -290 2 0 {name=p2 lab=VddA18}
C {iopin.sym} -20 -270 2 0 {name=p3 lab=IIn}
C {iopin.sym} -20 -250 2 0 {name=p4 lab=IOut0}
C {iopin.sym} -20 -230 2 0 {name=p5 lab=IOut1}
C {lab_wire.sym} 640 -280 0 0 {name=p6 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 530 -160 3 1 {name=p7 sig_type=std_logic lab=IOut1}
C {lab_wire.sym} 350 -160 3 1 {name=p8 sig_type=std_logic lab=IOut0}
C {sky130_fd_pr/pfet_01v8.sym} 130 -220 0 1 {name=M1
W=4
L=8
nf=1
mult=2
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {lab_wire.sym} 110 -130 3 1 {name=p9 sig_type=std_logic lab=GndA}
C {sky130_fd_pr/pfet_01v8.sym} 230 -220 0 1 {name=M2
W=4
L=8
nf=1
mult=13
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {lab_wire.sym} 210 -130 3 1 {name=p10 sig_type=std_logic lab=IIn}
C {lab_wire.sym} 420 -280 0 1 {name=p11 sig_type=std_logic lab=VOut0}
C {lab_wire.sym} 230 -280 0 1 {name=p12 sig_type=std_logic lab=VIn}
