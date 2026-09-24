v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Fine bits are encoded linearly} 300 -660 0 0 0.3 0.3 {}
N 200 -860 240 -860 {lab=IInDiv}
N 410 -830 540 -830 {lab=BufferN}
N 120 -990 120 -930 {lab=VddA18}
N 310 -990 310 -930 {lab=VddA18}
N 210 -840 210 -790 {lab=BiasVGate}
N 50 -840 210 -840 {lab=BiasVGate}
N 210 -790 240 -790 {lab=BiasVGate}
N 120 -710 120 -670 {lab=GndA}
N 310 -710 310 -670 {lab=GndA}
N 540 -830 540 -790 {lab=BufferN}
N 540 -830 600 -830 {lab=BufferN}
N 600 -830 600 -760 {lab=BufferN}
N 580 -760 600 -760 {lab=BufferN}
N 540 -730 540 -690 {lab=GndA}
N 500 -760 540 -760 {lab=GndA}
N 660 -730 660 -690 {lab=GndA}
N 660 -760 700 -760 {lab=GndA}
N 600 -760 620 -760 {lab=BufferN}
N 660 -820 660 -790 {lab=BufferP}
N 660 -820 730 -820 {lab=BufferP}
N 660 -840 660 -820 {lab=BufferP}
N 730 -870 730 -820 {lab=BufferP}
N 700 -870 730 -870 {lab=BufferP}
N 660 -960 660 -900 {lab=VddA18}
N 600 -870 660 -870 {lab=VddA18}
N -70 -1000 -70 -940 {lab=VddA18}
N -70 -720 -70 -680 {lab=GndA}
N -290 -840 -140 -840 {lab=BiasCB[7:0]}
N -290 -820 -140 -820 {lab=CoarseOneHot[7:0]}
N -290 -800 -140 -800 {lab=CoarseOneHotLowBiasEn}
N 50 -840 50 -820 {lab=BiasVGate}
N 40 -840 50 -840 {lab=BiasVGate}
N 350 -710 350 -610 {lab=FineCode[7:0]}
N 370 -710 370 -610 {lab=nFineCode[7:0]}
N 160 -710 160 -580 {lab=nLowBiasInterfaceEn}
N 140 -710 140 -590 {lab=LowBiasInterfaceEn}
C {iopin.sym} -430 -980 0 1 {name=p75 lab=VddA18}
C {iopin.sym} -430 -960 0 1 {name=p76 lab=GndA}
C {BiasCoarseFineInterface.sym} -110 -800 0 0 {name=xCoarse2Fine}
C {BiasDividerFine.sym} 80 -800 0 0 {name=xDivFine}
C {opin.sym} -450 -800 2 1 {name=p1 lab=BufferN}
C {lab_wire.sym} 120 -990 1 1 {name=p3 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 310 -990 1 1 {name=p4 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 210 -840 3 0 {name=p7 sig_type=std_logic lab=BiasVGate}
C {lab_wire.sym} 240 -860 0 0 {name=p8 sig_type=std_logic lab=IInDiv}
C {lab_wire.sym} 440 -830 0 0 {name=p9 sig_type=std_logic lab=BufferN}
C {lab_wire.sym} 120 -670 3 1 {name=p24 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 310 -670 3 1 {name=p25 sig_type=std_logic lab=GndA}
C {ipin.sym} -430 -910 2 1 {name=p88 lab=BiasCB[7:0]}
C {ipin.sym} -430 -870 2 1 {name=p90 lab=BufferN}
C {ipin.sym} -430 -850 2 1 {name=p91 lab=BufferP}
C {opin.sym} -450 -780 2 1 {name=p37 lab=BufferP}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 680 -870 0 1 {name=MpDio
W=6
L=3
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
C {sky130_fd_pr/nfet_01v8_lvt.sym} 560 -760 0 1 {name=MnDio
W=6
L=6
nf=1 
mult=16
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {lab_wire.sym} 540 -690 3 1 {name=p38 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 500 -760 0 1 {name=p39 sig_type=std_logic lab=GndA}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 640 -760 0 0 {name=MnMirr
W=6
L=6
nf=1 
mult=16
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {lab_wire.sym} 660 -690 1 0 {name=p40 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 700 -760 0 0 {name=p41 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 730 -820 0 0 {name=p42 sig_type=std_logic lab=BufferP}
C {lab_wire.sym} 660 -960 1 1 {name=p43 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 600 -870 0 1 {name=p44 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} -70 -1000 1 1 {name=p5 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} -290 -800 0 1 {name=p6 sig_type=std_logic lab=CoarseOneHotLowBiasEn}
C {lab_wire.sym} -70 -680 3 1 {name=p36 sig_type=std_logic lab=GndA}
C {BiasCoarseSel8to1.sym} -300 -810 0 0 {name=xCoarseSel8to1}
C {lab_wire.sym} -290 -840 0 1 {name=p45 sig_type=std_logic lab=BiasCB[7:0]}
C {lab_wire.sym} -290 -820 0 1 {name=p46 sig_type=std_logic lab=CoarseOneHot[7:0]}
C {lab_wire.sym} 350 -610 3 1 {name=p28 sig_type=std_logic lab=FineCode[7:0]}
C {lab_wire.sym} 370 -610 3 1 {name=p29 sig_type=std_logic lab=nFineCode[7:0]}
C {lab_wire.sym} 160 -580 3 1 {name=p22 sig_type=std_logic lab=nLowBiasInterfaceEn}
C {lab_wire.sym} 140 -590 3 1 {name=p23 sig_type=std_logic lab=LowBiasInterfaceEn}
C {ipin.sym} -430 -730 2 1 {name=p2 lab=LowBiasInterfaceEn}
C {ipin.sym} -430 -710 2 1 {name=p34 lab=nLowBiasInterfaceEn}
C {ipin.sym} -430 -690 2 1 {name=p26 lab=FineCode[7:0]}
C {ipin.sym} -430 -670 2 1 {name=p27 lab=nFineCode[7:0]}
C {ipin.sym} -430 -650 2 1 {name=p11 lab=CoarseOneHot[7:0]}
C {ipin.sym} -430 -630 2 1 {name=p12 lab=CoarseOneHotLowBiasEn}
