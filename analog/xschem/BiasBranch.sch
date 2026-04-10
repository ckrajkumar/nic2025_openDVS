v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Rail pin defines the default
bias value at startup} -650 -830 0 0 0.3 0.3 {}
T {The complete circuit for one configurable bias current} -570 -1120 0 0 1.3 1.3 {}
T {Fine bits are encoded linearly} 260 -570 0 0 0.3 0.3 {}
N 200 -860 240 -860 {lab=IInDiv}
N 410 -830 440 -830 {lab=IOutDiv}
N 760 -830 790 -830 {lab=VBiasOut}
N -90 -980 -90 -920 {lab=VddA18}
N 120 -990 120 -930 {lab=VddA18}
N 310 -990 310 -930 {lab=VddA18}
N 510 -1000 510 -940 {lab=VddA18}
N 210 -840 210 -790 {lab=BiasVGate}
N 210 -790 240 -790 {lab=BiasVGate}
N -90 -700 -90 -660 {lab=GndA}
N 160 -710 160 -580 {lab=nLowBiasInterfaceEn}
N 140 -710 140 -590 {lab=LowBiasInterfaceEn}
N 120 -710 120 -670 {lab=GndA}
N 310 -710 310 -670 {lab=GndA}
N 510 -720 510 -680 {lab=GndA}
N 530 -720 530 -680 {lab=BufferN}
N 530 -1000 530 -940 {lab=BufferP}
N 590 -1000 590 -940 {lab=Rail}
N 350 -710 350 -610 {lab=FineCode[7:0]}
N 370 -710 370 -610 {lab=nFineCode[7:0]}
N -310 -820 -160 -820 {lab=BiasCB[7:0]}
N -310 -800 -160 -800 {lab=CoarseOneHot[7:0]}
N -310 -780 -160 -780 {lab=CoarseOneHotLowBiasEn}
N 50 -840 50 -820 {lab=BiasVGate}
N 50 -840 210 -840 {lab=BiasVGate}
N 570 -720 570 -600 {lab=LowBiasBufEn}
N 590 -720 590 -600 {lab=nLowBiasBufEn}
N 610 -720 610 -600 {lab=BiasDisable}
N 630 -720 630 -600 {lab=BiasEnable}
N 650 -720 650 -600 {lab=NBiasEn}
N 670 -720 670 -600 {lab=PBiasEn}
N 20 -820 50 -820 {lab=BiasVGate}
C {iopin.sym} -360 -970 0 1 {name=p75 lab=VddA18}
C {iopin.sym} -360 -950 0 1 {name=p76 lab=GndA}
C {BiasCoarseFineInterface.sym} -110 -800 0 0 {name=xCoarse2Fine}
C {BiasDividerFine.sym} 80 -800 0 0 {name=xDivFine}
C {BiasBuffers.sym} 280 -810 0 0 {name=xBuffs}
C {opin.sym} 790 -830 2 1 {name=p1 lab=VBiasOut}
C {lab_wire.sym} -90 -980 1 1 {name=p2 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 120 -990 1 1 {name=p3 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 310 -990 1 1 {name=p4 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 510 -1000 3 0 {name=p5 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 210 -840 3 0 {name=p7 sig_type=std_logic lab=BiasVGate}
C {lab_wire.sym} 240 -860 0 0 {name=p8 sig_type=std_logic lab=IInDiv}
C {lab_wire.sym} 440 -830 0 0 {name=p9 sig_type=std_logic lab=IOutDiv}
C {lab_wire.sym} -310 -780 0 1 {name=p17 sig_type=std_logic lab=CoarseOneHotLowBiasEn}
C {lab_wire.sym} -90 -660 3 1 {name=p18 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 160 -580 3 1 {name=p22 sig_type=std_logic lab=nLowBiasInterfaceEn}
C {lab_wire.sym} 140 -590 3 1 {name=p23 sig_type=std_logic lab=LowBiasInterfaceEn}
C {lab_wire.sym} 120 -670 3 1 {name=p24 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 310 -670 3 1 {name=p25 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 510 -680 3 1 {name=p36 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 530 -680 3 1 {name=p37 sig_type=std_logic lab=BufferN}
C {lab_wire.sym} 530 -1000 3 0 {name=p38 sig_type=std_logic lab=BufferP}
C {lab_wire.sym} 590 -1000 3 0 {name=p39 sig_type=std_logic lab=Rail}
C {lab_wire.sym} 650 -600 3 1 {name=p46 sig_type=std_logic lab=NBiasEn}
C {lab_wire.sym} 670 -600 3 1 {name=p47 sig_type=std_logic lab=PBiasEn}
C {ipin.sym} -360 -900 2 1 {name=p88 lab=BiasCB[7:0]}
C {ipin.sym} -360 -860 2 1 {name=p90 lab=BufferN}
C {ipin.sym} -360 -840 2 1 {name=p91 lab=BufferP}
C {iopin.sym} -360 -820 0 1 {name=p92 lab=Rail}
C {ipin.sym} -360 -560 2 1 {name=p6 lab=LowBiasInterfaceEn}
C {ipin.sym} -360 -540 2 1 {name=p34 lab=nLowBiasInterfaceEn}
C {ipin.sym} -360 -520 2 1 {name=p26 lab=FineCode[7:0]}
C {ipin.sym} -360 -500 2 1 {name=p27 lab=nFineCode[7:0]}
C {lab_wire.sym} 350 -610 3 1 {name=p28 sig_type=std_logic lab=FineCode[7:0]}
C {lab_wire.sym} 370 -610 3 1 {name=p29 sig_type=std_logic lab=nFineCode[7:0]}
C {BiasCoarseSel8to1.sym} -320 -790 0 0 {name=xCoarseSel8to1}
C {lab_wire.sym} -310 -820 0 1 {name=p10 sig_type=std_logic lab=BiasCB[7:0]}
C {ipin.sym} -360 -480 2 1 {name=p11 lab=CoarseOneHot[7:0]}
C {ipin.sym} -360 -460 2 1 {name=p12 lab=CoarseOneHotLowBiasEn}
C {lab_wire.sym} -310 -800 0 1 {name=p13 sig_type=std_logic lab=CoarseOneHot[7:0]}
C {lab_wire.sym} 630 -600 3 1 {name=p14 sig_type=std_logic lab=BiasEnable}
C {lab_wire.sym} 610 -600 3 1 {name=p15 sig_type=std_logic lab=BiasDisable}
C {lab_wire.sym} 590 -600 3 1 {name=p16 sig_type=std_logic lab=nLowBiasBufEn}
C {lab_wire.sym} 570 -600 3 1 {name=p19 sig_type=std_logic lab=LowBiasBufEn}
C {ipin.sym} -360 -600 2 1 {name=p20 lab=LowBiasBufEn}
C {ipin.sym} -360 -580 2 1 {name=p21 lab=nLowBiasBufEn}
C {ipin.sym} -360 -440 2 1 {name=p30 lab=BiasEnable}
C {ipin.sym} -360 -420 2 1 {name=p31 lab=BiasDisable}
C {ipin.sym} -360 -400 2 1 {name=p32 lab=NBiasEn}
C {ipin.sym} -360 -380 2 1 {name=p33 lab=PBiasEn}
