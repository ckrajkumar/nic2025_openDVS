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
according to what we need!} 680 -480 0 0 0.5 0.5 {}
T {Need to add decaps
to appropriate rail!} 610 -700 0 0 0.5 0.5 {}
N 100 -730 100 -670 {lab=VddA18}
N 120 -730 120 -670 {lab=GndA}
N 180 -730 180 -670 {lab=BiasCB[7:0]}
N 280 -730 280 -670 {lab=BufferN}
N 300 -730 300 -670 {lab=BufferP}
N 430 -600 490 -600 {lab=Bias}
N 430 -520 490 -520 {lab=GndA}
N 100 460 100 520 {lab=rx}
N 130 460 130 520 {lab=BiasCB[0]}
N 160 460 160 520 {lab=BiasCB[1]}
N 190 460 190 520 {lab=BiasCB[2]}
N 220 460 220 520 {lab=BiasCB[3]}
N 250 460 250 520 {lab=BiasCB[4]}
N 280 460 280 520 {lab=BiasCB[5]}
N 310 460 310 520 {lab=BiasCB[6]}
N 340 460 340 520 {lab=BiasCB[7]}
N 70 460 70 520 {lab=GndA}
N 70 220 70 280 {lab=VddA18}
N 100 220 100 280 {lab=PowerDown}
N 130 220 130 280 {lab=VMasterBiasN}
N 160 220 160 280 {lab=VMasterBiasP}
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
N -160 -90 60 -90 {lab=nLowBiasInterfaceEn[10:0]}
N -160 -70 60 -70 {lab=CoarseOneHotLowBiasEn[10:0]}
N -160 -270 60 -270 {lab=CoarseOneHot_bit7[10:0]}
N -160 -110 60 -110 {lab=LowBiasInterfaceEn[10:0]}
N -160 -30 60 -30 {lab=nLowBiasBuffEn[10:0]}
N -160 -50 60 -50 {lab=LowBiasBuffEn[10:0]}
N -160 -590 60 -590 {lab=FineCode_bit7[10:0]}
N -160 -430 60 -430 {lab=nFineCode_bit7[10:0]}
N -160 -10 60 -10 {lab=NBiasEn[10:0]}
N -160 10 60 10 {lab=PBiasEn[10:0]}
N -160 50 60 50 {lab=BiasDisable[10:0]}
N -160 30 60 30 {lab=BiasEnable[10:0]}
N -160 -250 60 -250 {lab=CoarseOneHot_bit6[10:0]}
N -160 -230 60 -230 {lab=CoarseOneHot_bit5[10:0]}
N -160 -210 60 -210 {lab=CoarseOneHot_bit4[10:0]}
N -160 -190 60 -190 {lab=CoarseOneHot_bit3[10:0]}
N -160 -170 60 -170 {lab=CoarseOneHot_bit2[10:0]}
N -160 -150 60 -150 {lab=CoarseOneHot_bit1[10:0]}
N -160 -130 60 -130 {lab=CoarseOneHot_bit0[10:0]}
N -160 -410 60 -410 {lab=nFineCode_bit6[10:0]}
N -160 -390 60 -390 {lab=nFineCode_bit5[10:0]}
N -160 -370 60 -370 {lab=nFineCode_bit4[10:0]}
N -160 -350 60 -350 {lab=nFineCode_bit3[10:0]}
N -160 -330 60 -330 {lab=nFineCode_bit2[10:0]}
N -160 -310 60 -310 {lab=nFineCode_bit1[10:0]}
N -160 -570 60 -570 {lab=FineCode_bit6[10:0]}
N -160 -550 60 -550 {lab=FineCode_bit5[10:0]}
N -160 -530 60 -530 {lab=FineCode_bit4[10:0]}
N -160 -510 60 -510 {lab=FineCode_bit3[10:0]}
N -160 -490 60 -490 {lab=FineCode_bit2[10:0]}
N -160 -470 60 -470 {lab=FineCode_bit1[10:0]}
N -160 -450 60 -450 {lab=FineCode_bit0[10:0]}
N -160 -290 60 -290 {lab=nFineCode_bit0[10:0]}
C {iopin.sym} -360 -970 0 1 {name=p75 lab=VddA18}
C {iopin.sym} -360 -950 0 1 {name=p76 lab=GndA}
C {lab_wire.sym} 100 -730 3 0 {name=p2 sig_type=std_logic lab=VddA18}
C {opin.sym} -360 -860 2 1 {name=p90 lab=BufferN}
C {opin.sym} -360 -840 2 1 {name=p91 lab=BufferP}
C {iopin.sym} -360 -700 0 1 {name=p92 lab=rx}
C {BiasBranch.sym} -100 -540 0 0 {name=xBiasBranch[10:0]}
C {BiasMasternCoarse.sym} 170 370 0 0 {name=xBiasMasternCoarse}
C {lab_wire.sym} 120 -730 3 0 {name=p1 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 180 -730 3 0 {name=p4 sig_type=std_logic lab=BiasCB[7:0]}
C {lab_wire.sym} 280 -730 3 0 {name=p7 sig_type=std_logic lab=BufferN}
C {lab_wire.sym} 300 -730 3 0 {name=p8 sig_type=std_logic lab=BufferP}
C {lab_wire.sym} 100 520 3 1 {name=p11 sig_type=std_logic lab=rx}
C {lab_wire.sym} 130 520 3 1 {name=p12 sig_type=std_logic lab=BiasCB[0]}
C {lab_wire.sym} 160 520 3 1 {name=p13 sig_type=std_logic lab=BiasCB[1]}
C {lab_wire.sym} 190 520 3 1 {name=p14 sig_type=std_logic lab=BiasCB[2]}
C {lab_wire.sym} 220 520 3 1 {name=p15 sig_type=std_logic lab=BiasCB[3]}
C {lab_wire.sym} 250 520 3 1 {name=p16 sig_type=std_logic lab=BiasCB[4]}
C {lab_wire.sym} 280 520 3 1 {name=p17 sig_type=std_logic lab=BiasCB[5]}
C {lab_wire.sym} 310 520 3 1 {name=p18 sig_type=std_logic lab=BiasCB[6]}
C {lab_wire.sym} 340 520 3 1 {name=p19 sig_type=std_logic lab=BiasCB[7]}
C {lab_wire.sym} 70 520 3 1 {name=p20 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 70 220 3 0 {name=p21 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 100 220 3 0 {name=p22 sig_type=std_logic lab=PowerDown}
C {lab_wire.sym} 130 220 3 0 {name=p23 sig_type=std_logic lab=VMasterBiasN}
C {lab_wire.sym} 160 220 3 0 {name=p24 sig_type=std_logic lab=VMasterBiasP}
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
C {lab_wire.sym} 490 -520 0 0 {name=p38 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 490 -600 0 0 {name=p9 sig_type=std_logic lab=Bias}
C {ipin.sym} -280 -500 2 1 {name=p6 lab=FineCodeBuffer[7:0]}
C {ipin.sym} -610 0 2 1 {name=p10 lab=CoarseOneHot_bit7[10:0]}
C {lab_wire.sym} -160 -590 0 1 {name=p28 sig_type=std_logic lab=FineCode_bit7[10:0]}
C {lab_wire.sym} -160 -970 0 1 {name=p33 sig_type=std_logic lab=FineCodeBuffer[7:0]}
C {lab_wire.sym} -160 -430 0 1 {name=p39 sig_type=std_logic lab=nFineCode_bit7[10:0]}
C {lab_wire.sym} -160 -950 0 1 {name=p40 sig_type=std_logic lab=nFineCodeBuffer[7:0]}
C {ipin.sym} -280 -480 2 1 {name=p41 lab=nFineCodeBuffer[7:0]}
C {ipin.sym} -280 -460 2 1 {name=p43 lab=CoarseOneHotBuffer[7:0]}
C {ipin.sym} -610 30 2 1 {name=p45 lab=LowBiasInterfaceEn[10:0]}
C {ipin.sym} -610 50 2 1 {name=p46 lab=nLowBiasInterfaceEn[10:0]}
C {ipin.sym} -610 70 2 1 {name=p47 lab=CoarseOneHotLowBiasEn[10:0]}
C {ipin.sym} -610 90 2 1 {name=p48 lab=LowBiasBuffEn[10:0]}
C {ipin.sym} -610 110 2 1 {name=p49 lab=nLowBiasBuffEn[10:0]}
C {ipin.sym} -280 -440 2 1 {name=p50 lab=LowBiasInterfaceEnBuffer}
C {ipin.sym} -280 -420 2 1 {name=p51 lab=nLowBiasInterfaceEnBuffer}
C {ipin.sym} -280 -400 2 1 {name=p52 lab=CoarseOneHotLowBiasEnBuffer}
C {lab_wire.sym} -160 -930 0 1 {name=p53 sig_type=std_logic lab=CoarseOneHotBuffer[7:0]}
C {lab_wire.sym} -160 -910 0 1 {name=p54 sig_type=std_logic lab=LowBiasInterfaceEnBuffer}
C {lab_wire.sym} -160 -890 0 1 {name=p55 sig_type=std_logic lab=nLowBiasInterfaceEnBuffer}
C {lab_wire.sym} -160 -870 0 1 {name=p56 sig_type=std_logic lab=CoarseOneHotLowBiasEnBuffer}
C {lab_wire.sym} -160 -110 0 1 {name=p57 sig_type=std_logic lab=LowBiasInterfaceEn[10:0]}
C {lab_wire.sym} -160 -90 0 1 {name=p58 sig_type=std_logic lab=nLowBiasInterfaceEn[10:0]}
C {lab_wire.sym} -160 -70 0 1 {name=p59 sig_type=std_logic lab=CoarseOneHotLowBiasEn[10:0]}
C {lab_wire.sym} -160 -270 0 1 {name=p60 sig_type=std_logic lab=CoarseOneHot_bit7[10:0]}
C {lab_wire.sym} -160 -50 0 1 {name=p61 sig_type=std_logic lab=LowBiasBuffEn[10:0]}
C {lab_wire.sym} -160 -30 0 1 {name=p62 sig_type=std_logic lab=nLowBiasBuffEn[10:0]}
C {ipin.sym} -360 -740 2 1 {name=p3 lab=PowerDown}
C {lab_wire.sym} -160 -10 0 1 {name=p26 sig_type=std_logic lab=NBiasEn[10:0]}
C {lab_wire.sym} -160 10 0 1 {name=p63 sig_type=std_logic lab=PBiasEn[10:0]}
C {lab_wire.sym} -160 30 0 1 {name=p64 sig_type=std_logic lab=BiasEnable[10:0]}
C {lab_wire.sym} -160 50 0 1 {name=p65 sig_type=std_logic lab=BiasDisable[10:0]}
C {ipin.sym} -610 130 2 1 {name=p66 lab=NBiasEn[10:0]}
C {ipin.sym} -610 150 2 1 {name=p67 lab=PBiasEn[10:0]}
C {ipin.sym} -610 170 2 1 {name=p68 lab=BiasEnable[10:0]}
C {ipin.sym} -610 190 2 1 {name=p69 lab=BiasDisable[10:0]}
C {lab_wire.sym} -160 -250 0 1 {name=p70 sig_type=std_logic lab=CoarseOneHot_bit6[10:0]}
C {lab_wire.sym} -160 -230 0 1 {name=p71 sig_type=std_logic lab=CoarseOneHot_bit5[10:0]}
C {lab_wire.sym} -160 -210 0 1 {name=p72 sig_type=std_logic lab=CoarseOneHot_bit4[10:0]}
C {lab_wire.sym} -160 -190 0 1 {name=p73 sig_type=std_logic lab=CoarseOneHot_bit3[10:0]}
C {lab_wire.sym} -160 -170 0 1 {name=p74 sig_type=std_logic lab=CoarseOneHot_bit2[10:0]}
C {lab_wire.sym} -160 -150 0 1 {name=p77 sig_type=std_logic lab=CoarseOneHot_bit1[10:0]}
C {lab_wire.sym} -160 -130 0 1 {name=p78 sig_type=std_logic lab=CoarseOneHot_bit0[10:0]}
C {lab_wire.sym} -160 -410 0 1 {name=p79 sig_type=std_logic lab=nFineCode_bit6[10:0]}
C {lab_wire.sym} -160 -390 0 1 {name=p80 sig_type=std_logic lab=nFineCode_bit5[10:0]}
C {lab_wire.sym} -160 -370 0 1 {name=p81 sig_type=std_logic lab=nFineCode_bit4[10:0]}
C {lab_wire.sym} -160 -350 0 1 {name=p82 sig_type=std_logic lab=nFineCode_bit3[10:0]}
C {lab_wire.sym} -160 -330 0 1 {name=p83 sig_type=std_logic lab=nFineCode_bit2[10:0]}
C {lab_wire.sym} -160 -310 0 1 {name=p84 sig_type=std_logic lab=nFineCode_bit1[10:0]}
C {lab_wire.sym} -160 -570 0 1 {name=p86 sig_type=std_logic lab=FineCode_bit6[10:0]}
C {lab_wire.sym} -160 -550 0 1 {name=p87 sig_type=std_logic lab=FineCode_bit5[10:0]}
C {lab_wire.sym} -160 -530 0 1 {name=p88 sig_type=std_logic lab=FineCode_bit4[10:0]}
C {lab_wire.sym} -160 -510 0 1 {name=p89 sig_type=std_logic lab=FineCode_bit3[10:0]}
C {lab_wire.sym} -160 -490 0 1 {name=p93 sig_type=std_logic lab=FineCode_bit2[10:0]}
C {lab_wire.sym} -160 -470 0 1 {name=p94 sig_type=std_logic lab=FineCode_bit1[10:0]}
C {lab_wire.sym} -160 -450 0 1 {name=p95 sig_type=std_logic lab=FineCode_bit0[10:0]}
C {lab_wire.sym} -160 -290 0 1 {name=p85 sig_type=std_logic lab=nFineCode_bit0[10:0]}
C {ipin.sym} -610 -480 2 1 {name=p96 lab=FineCode_bit0[10:0]}
C {ipin.sym} -610 -460 2 1 {name=p97 lab=FineCode_bit1[10:0]}
C {ipin.sym} -610 -440 2 1 {name=p98 lab=FineCode_bit2[10:0]}
C {ipin.sym} -610 -420 2 1 {name=p99 lab=FineCode_bit3[10:0]}
C {ipin.sym} -610 -400 2 1 {name=p100 lab=FineCode_bit4[10:0]}
C {ipin.sym} -610 -380 2 1 {name=p101 lab=FineCode_bit5[10:0]}
C {ipin.sym} -610 -360 2 1 {name=p102 lab=FineCode_bit6[10:0]}
C {ipin.sym} -610 -340 2 1 {name=p103 lab=FineCode_bit7[10:0]}
C {ipin.sym} -610 -310 2 1 {name=p104 lab=nFineCode_bit0[10:0]}
C {ipin.sym} -610 -290 2 1 {name=p105 lab=nFineCode_bit1[10:0]}
C {ipin.sym} -610 -270 2 1 {name=p106 lab=nFineCode_bit2[10:0]}
C {ipin.sym} -610 -250 2 1 {name=p107 lab=nFineCode_bit3[10:0]}
C {ipin.sym} -610 -230 2 1 {name=p108 lab=nFineCode_bit4[10:0]}
C {ipin.sym} -610 -210 2 1 {name=p109 lab=nFineCode_bit5[10:0]}
C {ipin.sym} -610 -190 2 1 {name=p110 lab=nFineCode_bit6[10:0]}
C {ipin.sym} -610 -170 2 1 {name=p111 lab=nFineCode_bit7[10:0]}
C {ipin.sym} -610 -140 2 1 {name=p112 lab=CoarseOneHot_bit0[10:0]}
C {ipin.sym} -610 -120 2 1 {name=p113 lab=CoarseOneHot_bit1[10:0]}
C {ipin.sym} -610 -100 2 1 {name=p114 lab=CoarseOneHot_bit2[10:0]}
C {ipin.sym} -610 -80 2 1 {name=p115 lab=CoarseOneHot_bit3[10:0]}
C {ipin.sym} -610 -60 2 1 {name=p116 lab=CoarseOneHot_bit4[10:0]}
C {ipin.sym} -610 -40 2 1 {name=p117 lab=CoarseOneHot_bit5[10:0]}
C {ipin.sym} -610 -20 2 1 {name=p118 lab=CoarseOneHot_bit6[10:0]}
