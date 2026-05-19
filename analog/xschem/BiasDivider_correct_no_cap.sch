v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 410 -280 470 -280 {lab=VOut0}
N 1310 -280 1360 -280 {lab=GndA}
N 530 -220 530 -160 {lab=IOut1}
N 350 -220 350 -160 {lab=IOut0}
N 70 -220 110 -220 {lab=VddA18}
N 70 -280 70 -220 {lab=VddA18}
N 70 -280 110 -280 {lab=VddA18}
N 110 -280 110 -250 {lab=VddA18}
N 110 -190 110 -130 {lab=VddA18}
N 530 -370 530 -340 {lab=IIn}
N 350 -370 530 -370 {lab=IIn}
N 350 -370 350 -340 {lab=IIn}
N 210 -280 290 -280 {lab=VddA18}
N 250 -220 260 -220 {lab=IIn}
N 210 -280 210 -250 {lab=VddA18}
N 210 -160 210 -130 {lab=IIn}
N 190 -220 210 -220 {lab=VddA18}
N 190 -280 210 -280 {lab=VddA18}
N 260 -370 350 -370 {lab=IIn}
N 590 -280 650 -280 {lab=VOut1}
N 710 -220 710 -160 {lab=IOut2}
N 710 -370 710 -340 {lab=IIn}
N 530 -370 710 -370 {lab=IIn}
N 770 -280 830 -280 {lab=VOut2}
N 890 -220 890 -160 {lab=IOut3}
N 890 -370 890 -340 {lab=IIn}
N 710 -370 890 -370 {lab=IIn}
N 950 -280 1010 -280 {lab=VOut3}
N 1070 -220 1070 -160 {lab=IOut4}
N 1070 -370 1070 -340 {lab=IIn}
N 890 -370 1070 -370 {lab=IIn}
N 1130 -280 1190 -280 {lab=VOut4}
N 1250 -220 1250 -160 {lab=IOut5}
N 1250 -370 1250 -340 {lab=IIn}
N 1070 -370 1250 -370 {lab=IIn}
N 70 -130 110 -130 {lab=VddA18}
N 70 -220 70 -130 {lab=VddA18}
N 210 -160 260 -160 {lab=IIn}
N 210 -190 210 -160 {lab=IIn}
N 260 -220 260 -160 {lab=IIn}
N 190 -280 190 -220 {lab=VddA18}
N 150 -280 190 -280 {lab=VddA18}
N 260 -370 260 -220 {lab=IIn}
N 150 -280 150 -220 {lab=VddA18}
N 110 -280 150 -280 {lab=VddA18}
C {BiasDividerCell.sym} 290 -220 0 0 {name=xDivCell0}
C {iopin.sym} -20 -310 2 0 {name=p1 lab=GndA}
C {iopin.sym} -20 -290 2 0 {name=p2 lab=VddA18}
C {iopin.sym} -20 -270 2 0 {name=p3 lab=IIn}
C {iopin.sym} -20 -250 2 0 {name=p4 lab=IOut0}
C {iopin.sym} -20 -230 2 0 {name=p5 lab=IOut1}
C {lab_wire.sym} 1360 -280 0 0 {name=p6 sig_type=std_logic lab=GndA}
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
C {lab_wire.sym} 710 -160 3 1 {name=p11 sig_type=std_logic lab=IOut2}
C {lab_wire.sym} 890 -160 3 1 {name=p12 sig_type=std_logic lab=IOut3}
C {lab_wire.sym} 1070 -160 3 1 {name=p13 sig_type=std_logic lab=IOut4}
C {BiasDividerCell.sym} 1190 -220 0 0 {name=xDivCell5}
C {lab_wire.sym} 1250 -160 3 1 {name=p14 sig_type=std_logic lab=IOut5}
C {BiasDividerCell.sym} 470 -220 0 0 {name=xDivCell1}
C {BiasDividerCell.sym} 650 -220 0 0 {name=xDivCell2}
C {BiasDividerCell.sym} 830 -220 0 0 {name=xDivCell3}
C {BiasDividerCell.sym} 1010 -220 0 0 {name=xDivCell4}
C {lab_wire.sym} 70 -280 0 1 {name=p15 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 420 -280 0 1 {name=p16 sig_type=std_logic lab=VOut0}
C {lab_wire.sym} 600 -280 0 1 {name=p17 sig_type=std_logic lab=VOut1}
C {lab_wire.sym} 780 -280 0 1 {name=p18 sig_type=std_logic lab=VOut2}
C {lab_wire.sym} 960 -280 0 1 {name=p19 sig_type=std_logic lab=VOut3}
C {lab_wire.sym} 1140 -280 0 1 {name=p20 sig_type=std_logic lab=VOut4}
C {iopin.sym} -20 -210 2 0 {name=p21 lab=IOut2}
C {iopin.sym} -20 -190 2 0 {name=p22 lab=IOut3}
C {iopin.sym} -20 -170 2 0 {name=p23 lab=IOut4}
C {iopin.sym} -20 -150 2 0 {name=p24 lab=IOut5}
