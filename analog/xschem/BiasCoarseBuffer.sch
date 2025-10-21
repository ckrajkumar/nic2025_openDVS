v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {IBIT<2:0> selects coarse current
000 selects largest current
001 selects second largest current
...
111 selects smallest current} -540 -310 0 0 0.2 0.2 {}
T {BiasCB0 is the largest coarse current
BiasCB7 is the smallest coarse current} 360 -350 0 0 0.2 0.2 {}
N -340 -110 -320 -110 {lab=TI0}
N -340 -90 -250 -90 {lab=TI1}
N -340 -70 -180 -70 {lab=TI2}
N 40 -30 280 -30 {lab=TO4}
N -170 -90 280 -90 {lab=TO1}
N -340 -50 -110 -50 {lab=TI3}
N -30 -50 280 -50 {lab=TO3}
N -240 -110 280 -110 {lab=TO0}
N -340 -30 -40 -30 {lab=TI4}
N 110 -10 280 -10 {lab=TO5}
N -340 -10 30 -10 {lab=TI5}
N -340 10 100 10 {lab=TI6}
N 180 10 280 10 {lab=TO6}
N -340 30 170 30 {lab=TI7}
N 250 30 280 30 {lab=TO7}
N -410 -200 -410 -150 {lab=VddA18}
N 350 -200 350 -150 {lab=VddA18}
N -410 70 -410 120 {lab=GndA}
N 350 70 350 120 {lab=GndA}
N 390 -210 390 -150 {lab=BiasCB7}
N 410 -210 410 -150 {lab=BiasCB6}
N 430 -210 430 -150 {lab=BiasCB5}
N 450 -210 450 -150 {lab=BiasCB4}
N 470 -210 470 -150 {lab=BiasCB3}
N 490 -210 490 -150 {lab=BiasCB2}
N 510 -210 510 -150 {lab=BiasCB1}
N 530 -210 530 -150 {lab=BiasCB0}
N -510 -110 -480 -110 {lab=IBIT0}
N -510 -90 -480 -90 {lab=IBIT1}
N -510 -70 -480 -70 {lab=IBIT2}
N 580 -40 610 -40 {lab=CoarseOut}
N -100 -70 280 -70 {lab=TO2}
N -300 -120 -260 -120 {lab=VddA18}
N -300 -100 -260 -100 {lab=GndA}
N -230 -100 -190 -100 {lab=VddA18}
N -230 -80 -190 -80 {lab=GndA}
N -160 -80 -120 -80 {lab=VddA18}
N -160 -60 -120 -60 {lab=GndA}
N -90 -60 -50 -60 {lab=VddA18}
N -90 -40 -50 -40 {lab=GndA}
N -20 -40 20 -40 {lab=VddA18}
N -20 -20 20 -20 {lab=GndA}
N 50 -20 90 -20 {lab=VddA18}
N 50 0 90 0 {lab=GndA}
N 120 0 160 0 {lab=VddA18}
N 120 20 160 20 {lab=GndA}
N 190 20 230 20 {lab=VddA18}
N 190 40 230 40 {lab=GndA}
C {BiasCoarseSel8to1.sym} 120 -20 0 0 {name=xSel}
C {BiasDec3to8.sym} -560 -20 0 0 {name=xDec}
C {iopin.sym} -300 -310 0 0 {name=p75 lab=VddA18}
C {iopin.sym} -300 -290 0 0 {name=p76 lab=GndA}
C {lab_wire.sym} -410 -200 3 0 {name=p37 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 350 -200 3 0 {name=p1 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} -410 120 3 1 {name=p2 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 350 120 3 1 {name=p3 sig_type=std_logic lab=GndA}
C {ipin.sym} 390 -210 1 0 {name=p52 lab=BiasCB7}
C {ipin.sym} 410 -210 1 0 {name=p4 lab=BiasCB6}
C {ipin.sym} 430 -210 1 0 {name=p5 lab=BiasCB5}
C {ipin.sym} 450 -210 1 0 {name=p6 lab=BiasCB4}
C {ipin.sym} 470 -210 1 0 {name=p7 lab=BiasCB3}
C {ipin.sym} 490 -210 1 0 {name=p8 lab=BiasCB2}
C {ipin.sym} 510 -210 1 0 {name=p9 lab=BiasCB1}
C {ipin.sym} 530 -210 1 0 {name=p10 lab=BiasCB0}
C {ipin.sym} -510 -110 0 0 {name=p11 lab=IBIT0}
C {ipin.sym} -510 -90 0 0 {name=p15 lab=IBIT1}
C {ipin.sym} -510 -70 0 0 {name=p23 lab=IBIT2}
C {iopin.sym} 610 -40 0 0 {name=p12 lab=CoarseOut}
C {lab_wire.sym} -330 -110 0 0 {name=p13 sig_type=std_logic lab=TI0}
C {lab_wire.sym} -330 -90 0 0 {name=p16 sig_type=std_logic lab=TI1}
C {lab_wire.sym} -330 -70 0 0 {name=p18 sig_type=std_logic lab=TI2}
C {lab_wire.sym} -330 -50 0 0 {name=p20 sig_type=std_logic lab=TI3}
C {lab_wire.sym} -330 -30 0 0 {name=p22 sig_type=std_logic lab=TI4}
C {lab_wire.sym} -330 -10 0 0 {name=p25 sig_type=std_logic lab=TI5}
C {lab_wire.sym} -330 10 0 0 {name=p27 sig_type=std_logic lab=TI6}
C {lab_wire.sym} -330 30 0 0 {name=p30 sig_type=std_logic lab=TI7}
C {lab_wire.sym} 270 -110 0 0 {name=p31 sig_type=std_logic lab=TO0}
C {lab_wire.sym} 270 -90 0 0 {name=p32 sig_type=std_logic lab=TO1}
C {lab_wire.sym} 270 -70 0 0 {name=p33 sig_type=std_logic lab=TO2}
C {lab_wire.sym} 270 -50 0 0 {name=p34 sig_type=std_logic lab=TO3}
C {lab_wire.sym} 270 -30 0 0 {name=p35 sig_type=std_logic lab=TO4}
C {lab_wire.sym} 270 -10 0 0 {name=p36 sig_type=std_logic lab=TO5}
C {lab_wire.sym} 270 10 0 0 {name=p38 sig_type=std_logic lab=TO6}
C {lab_wire.sym} 270 30 0 0 {name=p39 sig_type=std_logic lab=TO7}
C {sky130_fd_sc_hd__inv_1.sym} -280 -110 0 0 {name=xinv0}
C {lab_wire.sym} -270 -120 0 0 {name=p14 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} -270 -100 0 0 {name=p17 sig_type=std_logic lab=GndA}
C {lab_wire.sym} -200 -100 0 0 {name=p19 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} -200 -80 0 0 {name=p21 sig_type=std_logic lab=GndA}
C {lab_wire.sym} -130 -80 0 0 {name=p28 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} -130 -60 0 0 {name=p29 sig_type=std_logic lab=GndA}
C {lab_wire.sym} -60 -60 0 0 {name=p40 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} -60 -40 0 0 {name=p41 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 10 -40 0 0 {name=p42 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 10 -20 0 0 {name=p43 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 80 -20 0 0 {name=p44 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 80 0 0 0 {name=p45 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 150 0 0 0 {name=p46 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 150 20 0 0 {name=p47 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 220 20 0 0 {name=p48 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 220 40 0 0 {name=p49 sig_type=std_logic lab=GndA}
C {sky130_fd_sc_hd__inv_1.sym} -210 -90 0 0 {name=xinv1}
C {sky130_fd_sc_hd__inv_1.sym} -140 -70 0 0 {name=xinv2}
C {sky130_fd_sc_hd__inv_1.sym} -70 -50 0 0 {name=xinv3}
C {sky130_fd_sc_hd__inv_1.sym} 0 -30 0 0 {name=xinv4}
C {sky130_fd_sc_hd__inv_1.sym} 70 -10 0 0 {name=xinv5}
C {sky130_fd_sc_hd__inv_1.sym} 140 10 0 0 {name=xinv6}
C {sky130_fd_sc_hd__inv_1.sym} 210 30 0 0 {name=xinv7}
