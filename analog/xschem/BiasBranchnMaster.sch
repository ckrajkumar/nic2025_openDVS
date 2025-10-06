v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Need to connect to the right rails
according to what we need!} 430 -530 0 0 0.5 0.5 {}
T {Need to add decaps
to appropriate rail!} 930 -730 0 0 0.5 0.5 {}
N 110 -750 110 -690 {lab=VddA18}
N 130 -750 130 -690 {lab=GndA}
N 170 -750 170 -690 {lab=PowerDown}
N 190 -750 190 -690 {lab=BiasCB[7:0]}
N 210 -750 210 -690 {lab=IBIT[15:0]}
N 290 -750 290 -690 {lab=BufferN}
N 310 -750 310 -690 {lab=BufferP}
N 440 -620 500 -620 {lab=Bias[30:0]}
N 440 -540 500 -540 {lab=#net1}
N -20 -580 70 -580 {lab=latchen[30:0]}
N 160 -140 160 -80 {lab=rx}
N 190 -140 190 -80 {lab=BiasCB[0]}
N 220 -140 220 -80 {lab=BiasCB[1]}
N 250 -140 250 -80 {lab=BiasCB[2]}
N 280 -140 280 -80 {lab=BiasCB[3]}
N 310 -140 310 -80 {lab=BiasCB[4]}
N 340 -140 340 -80 {lab=BiasCB[5]}
N 370 -140 370 -80 {lab=BiasCB[6]}
N 400 -140 400 -80 {lab=BiasCB[7]}
N 130 -140 130 -80 {lab=GndA}
N 130 -380 130 -320 {lab=VddA18}
N 160 -380 160 -320 {lab=PowerDown}
N 190 -380 190 -320 {lab=VMasterBiasN}
N 220 -380 220 -320 {lab=VMasterBiasP}
N 100 -1120 100 -1060 {lab=VddA18}
N 120 -1120 120 -1060 {lab=GndA}
N 160 -1120 160 -1060 {lab=PowerDown}
N 180 -1120 180 -1060 {lab=BiasCB[7:0]}
N 200 -1120 200 -1060 {lab=IBIT[15:0]}
N 280 -1120 280 -1060 {lab=BufferN}
N 300 -1120 300 -1060 {lab=BufferP}
N 430 -940 490 -940 {lab=BufferN}
N 430 -970 490 -970 {lab=BufferP}
N -20 -950 70 -950 {lab=latchen[31]}
C {iopin.sym} -360 -970 0 1 {name=p75 lab=VddA18}
C {iopin.sym} -360 -950 0 1 {name=p76 lab=GndA}
C {lab_wire.sym} 110 -750 3 0 {name=p2 sig_type=std_logic lab=VddA18}
C {ipin.sym} -360 -920 2 1 {name=p87 lab=latchen[31:0]}
C {ipin.sym} -360 -900 2 1 {name=p88 lab=IBIT[15:0]}
C {ipin.sym} -360 -880 2 1 {name=p89 lab=PowerDown}
C {opin.sym} -360 -860 2 1 {name=p90 lab=BufferN}
C {opin.sym} -360 -840 2 1 {name=p91 lab=BufferP}
C {iopin.sym} -360 -820 0 1 {name=p92 lab=rx}
C {BiasBranch.sym} -90 -560 0 0 {name=xBiasBranch[30:0]}
C {BiasMasternCoarse.sym} 230 -230 0 0 {name=xBiasMasternCoarse}
C {lab_wire.sym} 130 -750 3 0 {name=p1 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 170 -750 3 0 {name=p3 sig_type=std_logic lab=PowerDown}
C {lab_wire.sym} 190 -750 3 0 {name=p4 sig_type=std_logic lab=BiasCB[7:0]}
C {lab_wire.sym} 210 -750 3 0 {name=p6 sig_type=std_logic lab=IBIT[15:0]}
C {lab_wire.sym} 290 -750 3 0 {name=p7 sig_type=std_logic lab=BufferN}
C {lab_wire.sym} 310 -750 3 0 {name=p8 sig_type=std_logic lab=BufferP}
C {opin.sym} 500 -620 2 1 {name=p9 lab=Bias[30:0]}
C {lab_wire.sym} -20 -580 0 1 {name=p10 sig_type=std_logic lab=latchen[30:0]}
C {lab_wire.sym} 160 -80 3 1 {name=p11 sig_type=std_logic lab=rx}
C {lab_wire.sym} 190 -80 3 1 {name=p12 sig_type=std_logic lab=BiasCB[0]}
C {lab_wire.sym} 220 -80 3 1 {name=p13 sig_type=std_logic lab=BiasCB[1]}
C {lab_wire.sym} 250 -80 3 1 {name=p14 sig_type=std_logic lab=BiasCB[2]}
C {lab_wire.sym} 280 -80 3 1 {name=p15 sig_type=std_logic lab=BiasCB[3]}
C {lab_wire.sym} 310 -80 3 1 {name=p16 sig_type=std_logic lab=BiasCB[4]}
C {lab_wire.sym} 340 -80 3 1 {name=p17 sig_type=std_logic lab=BiasCB[5]}
C {lab_wire.sym} 370 -80 3 1 {name=p18 sig_type=std_logic lab=BiasCB[6]}
C {lab_wire.sym} 400 -80 3 1 {name=p19 sig_type=std_logic lab=BiasCB[7]}
C {lab_wire.sym} 130 -80 3 1 {name=p20 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 130 -380 3 0 {name=p21 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 160 -380 3 0 {name=p22 sig_type=std_logic lab=PowerDown}
C {lab_wire.sym} 190 -380 3 0 {name=p23 sig_type=std_logic lab=VMasterBiasN}
C {lab_wire.sym} 220 -380 3 0 {name=p24 sig_type=std_logic lab=VMasterBiasP}
C {BiasBranchBuffer.sym} -100 -930 0 0 {name=xBiasBuffer}
C {lab_wire.sym} 100 -1120 3 0 {name=p5 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 120 -1120 3 0 {name=p25 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 160 -1120 3 0 {name=p26 sig_type=std_logic lab=PowerDown}
C {lab_wire.sym} 180 -1120 3 0 {name=p27 sig_type=std_logic lab=BiasCB[7:0]}
C {lab_wire.sym} 200 -1120 3 0 {name=p28 sig_type=std_logic lab=IBIT[15:0]}
C {lab_wire.sym} 280 -1120 3 0 {name=p29 sig_type=std_logic lab=BufferN}
C {lab_wire.sym} 300 -1120 3 0 {name=p30 sig_type=std_logic lab=BufferP}
C {lab_wire.sym} 490 -940 0 0 {name=p31 sig_type=std_logic lab=BufferN}
C {lab_wire.sym} 490 -970 0 0 {name=p32 sig_type=std_logic lab=BufferP}
C {lab_wire.sym} -20 -950 0 1 {name=p33 sig_type=std_logic lab=latchen[31]}
