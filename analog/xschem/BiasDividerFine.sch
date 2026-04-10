v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 620 -580 700 -580 {lab=Idiv1}
N 420 -580 500 -580 {lab=Idiv2}
N 220 -580 300 -580 {lab=Idiv3}
N 20 -580 100 -580 {lab=Idiv4}
N -180 -580 -100 -580 {lab=Idiv5}
N -380 -580 -300 -580 {lab=Idiv6}
N -580 -580 -500 -580 {lab=Idiv7}
N -660 -710 -660 -620 {lab=IOut}
N 740 -710 740 -620 {lab=IOut}
N 540 -710 540 -620 {lab=IOut}
N 340 -710 340 -620 {lab=IOut}
N 140 -710 140 -620 {lab=IOut}
N -60 -710 -60 -620 {lab=IOut}
N -260 -710 -260 -620 {lab=IOut}
N -460 -710 -460 -620 {lab=IOut}
N 740 -710 930 -710 {lab=IOut}
N 340 -710 540 -710 {lab=IOut}
N 140 -710 340 -710 {lab=IOut}
N -60 -710 140 -710 {lab=IOut}
N -260 -710 -60 -710 {lab=IOut}
N -460 -710 -260 -710 {lab=IOut}
N -660 -710 -460 -710 {lab=IOut}
N 540 -710 740 -710 {lab=IOut}
N -620 -660 -620 -620 {lab=termDio}
N 780 -660 780 -620 {lab=termDio}
N 580 -660 580 -620 {lab=termDio}
N 380 -660 380 -620 {lab=termDio}
N 180 -660 180 -620 {lab=termDio}
N -20 -660 -20 -620 {lab=termDio}
N -220 -660 -220 -620 {lab=termDio}
N -420 -660 -420 -620 {lab=termDio}
N 780 -660 1060 -660 {lab=termDio}
N 580 -660 780 -660 {lab=termDio}
N 380 -660 580 -660 {lab=termDio}
N 180 -660 380 -660 {lab=termDio}
N -20 -660 180 -660 {lab=termDio}
N -220 -660 -20 -660 {lab=termDio}
N -420 -660 -220 -660 {lab=termDio}
N -620 -660 -420 -660 {lab=termDio}
N 980 -630 980 -580 {lab=VddA18}
N 620 -540 650 -540 {lab=VddA18}
N 820 -540 850 -540 {lab=VddA18}
N 420 -540 450 -540 {lab=VddA18}
N 220 -540 250 -540 {lab=VddA18}
N 20 -540 50 -540 {lab=VddA18}
N -180 -540 -150 -540 {lab=VddA18}
N -380 -540 -350 -540 {lab=VddA18}
N -580 -540 -550 -540 {lab=VddA18}
N -730 -850 -700 -850 {lab=FineCode[7:0]}
N -730 -540 -700 -540 {lab=VGate}
N -530 -540 -500 -540 {lab=VGate}
N -330 -540 -300 -540 {lab=VGate}
N -130 -540 -100 -540 {lab=VGate}
N 70 -540 100 -540 {lab=VGate}
N 270 -540 300 -540 {lab=VGate}
N 470 -540 500 -540 {lab=VGate}
N 670 -540 700 -540 {lab=VGate}
N 820 -580 950 -580 {lab=Idiv0}
N 980 -540 980 -510 {lab=VGate}
N 1090 -580 1170 -580 {lab=termDio}
N 1170 -580 1170 -520 {lab=termDio}
N 1090 -490 1130 -490 {lab=termDio}
N 1090 -580 1090 -490 {lab=termDio}
N 1060 -580 1090 -580 {lab=termDio}
N 1170 -490 1200 -490 {lab=GndA}
N 1170 -460 1170 -410 {lab=GndA}
N 1060 -660 1060 -580 {lab=termDio}
N 1010 -580 1060 -580 {lab=termDio}
N -730 -580 -700 -580 {lab=IIn}
N -730 -870 -700 -870 {lab=nFineCode[7:0]}
N -660 -500 -660 -390 {lab=nFineCode[7]}
N -620 -500 -620 -390 {lab=FineCode[7]}
N -460 -500 -460 -390 {lab=nFineCode[6]}
N -420 -500 -420 -390 {lab=FineCode[6]}
N -260 -500 -260 -390 {lab=nFineCode[5]}
N -220 -500 -220 -390 {lab=FineCode[5]}
N -60 -500 -60 -390 {lab=nFineCode[4]}
N -20 -500 -20 -390 {lab=FineCode[4]}
N 140 -500 140 -390 {lab=nFineCode[3]}
N 180 -500 180 -390 {lab=FineCode[3]}
N 340 -500 340 -390 {lab=nFineCode[2]}
N 380 -500 380 -390 {lab=FineCode[2]}
N 540 -500 540 -390 {lab=nFineCode[1]}
N 580 -500 580 -390 {lab=FineCode[1]}
N 740 -500 740 -390 {lab=nFineCode[0]}
N 780 -500 780 -390 {lab=FineCode[0]}
C {iopin.sym} -730 -820 0 1 {name=p75 lab=VddA18}
C {iopin.sym} -730 -800 0 1 {name=p76 lab=GndA}
C {iopin.sym} 930 -710 0 0 {name=p12 lab=IOut}
C {BiasDividerFineCell.sym} 700 -500 0 0 {name=xdiv0}
C {BiasDividerFineCell.sym} 500 -500 0 0 {name=xdiv1}
C {BiasDividerFineCell.sym} 300 -500 0 0 {name=xdiv2}
C {BiasDividerFineCell.sym} 100 -500 0 0 {name=xdiv3}
C {BiasDividerFineCell.sym} -100 -500 0 0 {name=xdiv4}
C {BiasDividerFineCell.sym} -300 -500 0 0 {name=xdiv5}
C {BiasDividerFineCell.sym} -500 -500 0 0 {name=xdiv6}
C {BiasDividerFineCell.sym} -700 -500 0 0 {name=xdiv7}
C {lab_wire.sym} 1150 -580 0 0 {name=p13 sig_type=std_logic lab=termDio}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 980 -560 3 0 {name=MrTerm
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
C {lab_wire.sym} 980 -630 3 0 {name=p14 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 650 -540 0 0 {name=p16 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 850 -540 0 0 {name=p17 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 450 -540 0 0 {name=p18 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 250 -540 0 0 {name=p19 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 50 -540 0 0 {name=p20 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} -150 -540 0 0 {name=p21 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} -350 -540 0 0 {name=p22 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} -550 -540 0 0 {name=p24 sig_type=std_logic lab=VddA18}
C {ipin.sym} -730 -850 0 0 {name=p4 lab=FineCode[7:0]}
C {ipin.sym} -730 -740 2 1 {name=p6 lab=VGate}
C {lab_wire.sym} -730 -540 0 1 {name=p7 sig_type=std_logic lab=VGate}
C {lab_wire.sym} -530 -540 0 1 {name=p8 sig_type=std_logic lab=VGate}
C {lab_wire.sym} -330 -540 0 1 {name=p9 sig_type=std_logic lab=VGate}
C {lab_wire.sym} -130 -540 0 1 {name=p10 sig_type=std_logic lab=VGate}
C {lab_wire.sym} 70 -540 0 1 {name=p37 sig_type=std_logic lab=VGate}
C {lab_wire.sym} 270 -540 0 1 {name=p52 sig_type=std_logic lab=VGate}
C {lab_wire.sym} 470 -540 0 1 {name=p59 sig_type=std_logic lab=VGate}
C {lab_wire.sym} 670 -540 0 1 {name=p60 sig_type=std_logic lab=VGate}
C {lab_wire.sym} 980 -510 3 1 {name=p61 sig_type=std_logic lab=VGate}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 1150 -490 0 0 {name=Mnterm
W=8
L=0.8
nf=1 
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {lab_wire.sym} 1200 -490 0 0 {name=p62 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 1170 -410 1 0 {name=p63 sig_type=std_logic lab=GndA}
C {lab_wire.sym} -560 -580 0 1 {name=p65 sig_type=std_logic lab=Idiv7}
C {lab_wire.sym} -350 -580 0 1 {name=p66 sig_type=std_logic lab=Idiv6}
C {lab_wire.sym} -160 -580 0 1 {name=p67 sig_type=std_logic lab=Idiv5}
C {lab_wire.sym} 40 -580 0 1 {name=p68 sig_type=std_logic lab=Idiv4}
C {lab_wire.sym} 250 -580 0 1 {name=p69 sig_type=std_logic lab=Idiv3}
C {lab_wire.sym} 450 -580 0 1 {name=p70 sig_type=std_logic lab=Idiv2}
C {lab_wire.sym} 650 -580 0 1 {name=p71 sig_type=std_logic lab=Idiv1}
C {lab_wire.sym} 860 -580 0 1 {name=p72 sig_type=std_logic lab=Idiv0}
C {iopin.sym} -730 -580 0 1 {name=p91 lab=IIn}
C {ipin.sym} -730 -870 0 0 {name=p31 lab=nFineCode[7:0]}
C {lab_wire.sym} -660 -390 3 1 {name=p1 sig_type=std_logic lab=nFineCode[7]}
C {lab_wire.sym} -620 -390 3 1 {name=p2 sig_type=std_logic lab=FineCode[7]}
C {lab_wire.sym} -460 -390 3 1 {name=p3 sig_type=std_logic lab=nFineCode[6]}
C {lab_wire.sym} -420 -390 3 1 {name=p5 sig_type=std_logic lab=FineCode[6]}
C {lab_wire.sym} -260 -390 3 1 {name=p11 sig_type=std_logic lab=nFineCode[5]}
C {lab_wire.sym} -220 -390 3 1 {name=p15 sig_type=std_logic lab=FineCode[5]}
C {lab_wire.sym} -60 -390 3 1 {name=p23 sig_type=std_logic lab=nFineCode[4]}
C {lab_wire.sym} -20 -390 3 1 {name=p25 sig_type=std_logic lab=FineCode[4]}
C {lab_wire.sym} 140 -390 3 1 {name=p26 sig_type=std_logic lab=nFineCode[3]}
C {lab_wire.sym} 180 -390 3 1 {name=p27 sig_type=std_logic lab=FineCode[3]}
C {lab_wire.sym} 340 -390 3 1 {name=p28 sig_type=std_logic lab=nFineCode[2]}
C {lab_wire.sym} 380 -390 3 1 {name=p29 sig_type=std_logic lab=FineCode[2]}
C {lab_wire.sym} 540 -390 3 1 {name=p30 sig_type=std_logic lab=nFineCode[1]}
C {lab_wire.sym} 580 -390 3 1 {name=p32 sig_type=std_logic lab=FineCode[1]}
C {lab_wire.sym} 740 -390 3 1 {name=p33 sig_type=std_logic lab=nFineCode[0]}
C {lab_wire.sym} 780 -390 3 1 {name=p34 sig_type=std_logic lab=FineCode[0]}
