v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 -300 -510 {}
P 4 1 -300 -490 {}
T {Need to connect to the right rails
according to what we need!} 430 -530 0 0 0.5 0.5 {}
T {Need to add decaps
to appropriate rail!} 930 -730 0 0 0.5 0.5 {}
N 110 -750 110 -690 {lab=VddA18}
N 130 -750 130 -690 {lab=GndA}
N 190 -750 190 -690 {lab=BiasCB[7:0]}
N 290 -750 290 -690 {lab=BufferN}
N 310 -750 310 -690 {lab=BufferP}
N 440 -620 500 -620 {lab=Bias}
N 440 -540 500 -540 {lab=GndA}
N 150 -90 150 -30 {lab=rx}
N 180 -90 180 -30 {lab=BiasCB[0]}
N 210 -90 210 -30 {lab=BiasCB[1]}
N 240 -90 240 -30 {lab=BiasCB[2]}
N 270 -90 270 -30 {lab=BiasCB[3]}
N 300 -90 300 -30 {lab=BiasCB[4]}
N 330 -90 330 -30 {lab=BiasCB[5]}
N 360 -90 360 -30 {lab=BiasCB[6]}
N 390 -90 390 -30 {lab=BiasCB[7]}
N 120 -90 120 -30 {lab=GndA}
N 120 -330 120 -270 {lab=VddA18}
N 150 -330 150 -270 {lab=PowerDown}
N 180 -330 180 -270 {lab=VMasterBiasN}
N 210 -330 210 -270 {lab=VMasterBiasP}
N 100 -1120 100 -1060 {lab=VddA18}
N 120 -1120 120 -1060 {lab=GndA}
N 180 -1120 180 -1060 {lab=BiasCB[7:0]}
N 280 -1120 280 -1060 {lab=BufferN}
N 300 -1120 300 -1060 {lab=BufferP}
N 430 -990 490 -990 {lab=BufferN}
N 430 -1010 490 -1010 {lab=BufferP}
N -160 -950 60 -950 {lab=nFineCodeBuffer[7:0]}
N -160 -890 60 -890 {lab=nLowBiasInterfaceEnBuffer}
N -160 -870 60 -870 {lab=CoarseOneHotLowBiasEnBuffer}
N -160 -970 60 -970 {lab=FineCodeBuffer[7:0]}
N -160 -930 60 -930 {lab=CoarseOneHotBuffer[7:0]}
N -160 -910 60 -910 {lab=LowBiasInterfaceEnBuffer}
N -150 -530 70 -530 {lab=nLowBiasInterfaceEn}
N -150 -510 70 -510 {lab=CoarseOneHotLowBiasEn}
N -150 -570 70 -570 {lab=CoarseOneHot[7:0]}
N -150 -550 70 -550 {lab=LowBiasInterfaceEn}
N -150 -470 70 -470 {lab=nLowBiasBuffEn}
N -150 -490 70 -490 {lab=LowBiasBuffEn}
N -150 -610 70 -610 {lab=FineCode[7:0]}
N -150 -590 70 -590 {lab=nFineCode[7:0]}
N -150 -450 70 -450 {lab=NBiasEn}
N -150 -430 70 -430 {lab=PBiasEn}
N -150 -390 70 -390 {lab=PBiasEn}
N -150 -410 70 -410 {lab=BiasEnable}
C {iopin.sym} -360 -970 0 1 {name=p75 lab=VddA18}
C {iopin.sym} -360 -950 0 1 {name=p76 lab=GndA}
C {lab_wire.sym} 110 -750 3 0 {name=p2 sig_type=std_logic lab=VddA18}
C {opin.sym} -360 -860 2 1 {name=p90 lab=BufferN}
C {opin.sym} -360 -840 2 1 {name=p91 lab=BufferP}
C {iopin.sym} -360 -700 0 1 {name=p92 lab=rx}
C {BiasBranch.sym} -90 -560 0 0 {name=xBiasBranch}
C {BiasMasternCoarse.sym} 220 -180 0 0 {name=xBiasMasternCoarse}
C {lab_wire.sym} 130 -750 3 0 {name=p1 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 190 -750 3 0 {name=p4 sig_type=std_logic lab=BiasCB[7:0]}
C {lab_wire.sym} 290 -750 3 0 {name=p7 sig_type=std_logic lab=BufferN}
C {lab_wire.sym} 310 -750 3 0 {name=p8 sig_type=std_logic lab=BufferP}
C {lab_wire.sym} 150 -30 3 1 {name=p11 sig_type=std_logic lab=rx}
C {lab_wire.sym} 180 -30 3 1 {name=p12 sig_type=std_logic lab=BiasCB[0]}
C {lab_wire.sym} 210 -30 3 1 {name=p13 sig_type=std_logic lab=BiasCB[1]}
C {lab_wire.sym} 240 -30 3 1 {name=p14 sig_type=std_logic lab=BiasCB[2]}
C {lab_wire.sym} 270 -30 3 1 {name=p15 sig_type=std_logic lab=BiasCB[3]}
C {lab_wire.sym} 300 -30 3 1 {name=p16 sig_type=std_logic lab=BiasCB[4]}
C {lab_wire.sym} 330 -30 3 1 {name=p17 sig_type=std_logic lab=BiasCB[5]}
C {lab_wire.sym} 360 -30 3 1 {name=p18 sig_type=std_logic lab=BiasCB[6]}
C {lab_wire.sym} 390 -30 3 1 {name=p19 sig_type=std_logic lab=BiasCB[7]}
C {lab_wire.sym} 120 -30 3 1 {name=p20 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 120 -330 3 0 {name=p21 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 150 -330 3 0 {name=p22 sig_type=std_logic lab=PowerDown}
C {lab_wire.sym} 180 -330 3 0 {name=p23 sig_type=std_logic lab=VMasterBiasN}
C {lab_wire.sym} 210 -330 3 0 {name=p24 sig_type=std_logic lab=VMasterBiasP}
C {BiasBranchBuffer.sym} -100 -930 0 0 {name=xBiasBuffer}
C {lab_wire.sym} 100 -1120 3 0 {name=p5 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 120 -1120 3 0 {name=p25 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 180 -1120 3 0 {name=p27 sig_type=std_logic lab=BiasCB[7:0]}
C {lab_wire.sym} 280 -1120 3 0 {name=p29 sig_type=std_logic lab=BufferN}
C {lab_wire.sym} 300 -1120 3 0 {name=p30 sig_type=std_logic lab=BufferP}
C {lab_wire.sym} 490 -990 0 0 {name=p31 sig_type=std_logic lab=BufferN}
C {lab_wire.sym} 490 -1010 0 0 {name=p32 sig_type=std_logic lab=BufferP}
C {opin.sym} -360 -820 2 1 {name=p34 lab=VMasterBiasN}
C {opin.sym} -360 -800 2 1 {name=p35 lab=VMasterBiasP}
C {opin.sym} -360 -780 2 1 {name=p36 lab=BiasCB[7:0]}
C {opin.sym} -360 -760 2 1 {name=p37 lab=Bias}
C {lab_wire.sym} 500 -540 0 0 {name=p38 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 500 -620 0 0 {name=p9 sig_type=std_logic lab=Bias}
C {ipin.sym} -280 -500 2 1 {name=p6 lab=FineCodeBuffer[7:0]}
C {ipin.sym} -610 -500 2 1 {name=p10 lab=FineCode[7:0]}
C {lab_wire.sym} -150 -610 0 1 {name=p28 sig_type=std_logic lab=FineCode[7:0]}
C {lab_wire.sym} -160 -970 0 1 {name=p33 sig_type=std_logic lab=FineCodeBuffer[7:0]}
C {lab_wire.sym} -150 -590 0 1 {name=p39 sig_type=std_logic lab=nFineCode[7:0]}
C {lab_wire.sym} -160 -950 0 1 {name=p40 sig_type=std_logic lab=nFineCodeBuffer[7:0]}
C {ipin.sym} -280 -480 2 1 {name=p41 lab=nFineCodeBuffer[7:0]}
C {ipin.sym} -610 -480 2 1 {name=p42 lab=nFineCode[7:0]}
C {ipin.sym} -280 -460 2 1 {name=p43 lab=CoarseOneHotBuffer[7:0]}
C {ipin.sym} -610 -460 2 1 {name=p44 lab=CoarseOneHot[7:0]}
C {ipin.sym} -610 -440 2 1 {name=p45 lab=LowBiasInterfaceEn}
C {ipin.sym} -610 -420 2 1 {name=p46 lab=nLowBiasInterfaceEn}
C {ipin.sym} -610 -400 2 1 {name=p47 lab=CoarseOneHotLowBiasEn}
C {ipin.sym} -610 -380 2 1 {name=p48 lab=LowBiasBuffEn}
C {ipin.sym} -610 -360 2 1 {name=p49 lab=nLowBiasBuffEn}
C {ipin.sym} -280 -440 2 1 {name=p50 lab=LowBiasInterfaceEnBuffer}
C {ipin.sym} -280 -420 2 1 {name=p51 lab=nLowBiasInterfaceEnBuffer}
C {ipin.sym} -280 -400 2 1 {name=p52 lab=CoarseOneHotLowBiasEnBuffer}
C {lab_wire.sym} -160 -930 0 1 {name=p53 sig_type=std_logic lab=CoarseOneHotBuffer[7:0]}
C {lab_wire.sym} -160 -910 0 1 {name=p54 sig_type=std_logic lab=LowBiasInterfaceEnBuffer}
C {lab_wire.sym} -160 -890 0 1 {name=p55 sig_type=std_logic lab=nLowBiasInterfaceEnBuffer}
C {lab_wire.sym} -160 -870 0 1 {name=p56 sig_type=std_logic lab=CoarseOneHotLowBiasEnBuffer}
C {lab_wire.sym} -150 -550 0 1 {name=p57 sig_type=std_logic lab=LowBiasInterfaceEn}
C {lab_wire.sym} -150 -530 0 1 {name=p58 sig_type=std_logic lab=nLowBiasInterfaceEn}
C {lab_wire.sym} -150 -510 0 1 {name=p59 sig_type=std_logic lab=CoarseOneHotLowBiasEn}
C {lab_wire.sym} -150 -570 0 1 {name=p60 sig_type=std_logic lab=CoarseOneHot[7:0]}
C {lab_wire.sym} -150 -490 0 1 {name=p61 sig_type=std_logic lab=LowBiasBuffEn}
C {lab_wire.sym} -150 -470 0 1 {name=p62 sig_type=std_logic lab=nLowBiasBuffEn}
C {ipin.sym} -360 -740 2 1 {name=p3 lab=PowerDown}
C {lab_wire.sym} -150 -450 0 1 {name=p26 sig_type=std_logic lab=NBiasEn}
C {lab_wire.sym} -150 -430 0 1 {name=p63 sig_type=std_logic lab=PBiasEn}
C {lab_wire.sym} -150 -410 0 1 {name=p64 sig_type=std_logic lab=BiasEnable}
C {lab_wire.sym} -150 -390 0 1 {name=p65 sig_type=std_logic lab=BiasDisable}
C {ipin.sym} -610 -340 2 1 {name=p66 lab=NBiasEn}
C {ipin.sym} -610 -320 2 1 {name=p67 lab=PBiasEn}
C {ipin.sym} -610 -300 2 1 {name=p68 lab=BiasEnable}
C {ipin.sym} -610 -280 2 1 {name=p69 lab=BiasDisable}
