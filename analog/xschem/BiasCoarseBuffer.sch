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
N -340 -110 -320 -110 {lab=#net1}
N -340 -90 -250 -90 {lab=#net2}
N -340 -70 -180 -70 {lab=#net3}
N 40 -30 280 -30 {lab=#net4}
N -170 -90 280 -90 {lab=#net5}
N -340 -50 -110 -50 {lab=#net6}
N -30 -50 280 -50 {lab=#net7}
N -240 -110 280 -110 {lab=#net8}
N -340 -30 -40 -30 {lab=#net9}
N 110 -10 280 -10 {lab=#net10}
N -340 -10 30 -10 {lab=#net11}
N -340 10 100 10 {lab=#net12}
N 180 10 280 10 {lab=#net13}
N -340 30 170 30 {lab=#net14}
N 250 30 280 30 {lab=#net15}
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
N -100 -70 280 -70 {lab=#net16}
C {BiasCoarseSel8to1.sym} 120 -20 0 0 {name=xSel}
C {BiasDec3to8.sym} -560 -20 0 0 {name=xDec}
C {sky130_stdcells/inv_1.sym} -280 -110 0 0 {name=xinv0 VGND=GndA VNB=GndA VPB=VddA18 VPWR=VddA18 prefix=sky130_fd_sc_hd__ }
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
C {lab_wire.sym} -330 -110 0 0 {name=p13 sig_type=std_logic lab=TI0
spice_ignore=true}
C {lab_wire.sym} 260 -110 0 0 {name=p14 sig_type=std_logic lab=TO0
spice_ignore=true}
C {lab_wire.sym} -330 -90 0 0 {name=p16 sig_type=std_logic lab=TI1
spice_ignore=true}
C {lab_wire.sym} 260 -90 0 0 {name=p17 sig_type=std_logic lab=TO1
spice_ignore=true}
C {lab_wire.sym} -330 -50 0 0 {name=p18 sig_type=std_logic lab=TI3
spice_ignore=true}
C {lab_wire.sym} 260 -50 0 0 {name=p19 sig_type=std_logic lab=TO3
spice_ignore=true}
C {lab_wire.sym} -330 -30 0 0 {name=p20 sig_type=std_logic lab=TI4
spice_ignore=true}
C {lab_wire.sym} 260 -30 0 0 {name=p21 sig_type=std_logic lab=TO4
spice_ignore=true}
C {lab_wire.sym} -330 -10 0 0 {name=p22 sig_type=std_logic lab=TI5
spice_ignore=true}
C {lab_wire.sym} 260 -10 0 0 {name=p24 sig_type=std_logic lab=TO5
spice_ignore=true}
C {lab_wire.sym} -330 10 0 0 {name=p25 sig_type=std_logic lab=TI6
spice_ignore=true}
C {lab_wire.sym} 260 10 0 0 {name=p26 sig_type=std_logic lab=TO6
spice_ignore=true}
C {lab_wire.sym} -330 30 0 0 {name=p27 sig_type=std_logic lab=TI7
spice_ignore=true}
C {lab_wire.sym} 260 30 0 0 {name=p28 sig_type=std_logic lab=TO7
spice_ignore=true}
C {lab_wire.sym} 260 -70 0 0 {name=p29 sig_type=std_logic lab=TO2
spice_ignore=true}
C {lab_wire.sym} -330 -70 0 0 {name=p30 sig_type=std_logic lab=TI2
spice_ignore=true}
C {sky130_stdcells/inv_1.sym} -210 -90 0 0 {name=xinv1 VGND=GndA VNB=GndA VPB=VddA18 VPWR=VddA18 prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/inv_1.sym} -140 -70 0 0 {name=xinv2 VGND=GndA VNB=GndA VPB=VddA18 VPWR=VddA18 prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/inv_1.sym} -70 -50 0 0 {name=xinv3 VGND=GndA VNB=GndA VPB=VddA18 VPWR=VddA18 prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/inv_1.sym} 0 -30 0 0 {name=xinv4 VGND=GndA VNB=GndA VPB=VddA18 VPWR=VddA18 prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/inv_1.sym} 70 -10 0 0 {name=xinv5 VGND=GndA VNB=GndA VPB=VddA18 VPWR=VddA18 prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/inv_1.sym} 140 10 0 0 {name=xinv6 VGND=GndA VNB=GndA VPB=VddA18 VPWR=VddA18 prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/inv_1.sym} 210 30 0 0 {name=xinv7 VGND=GndA VNB=GndA VPB=VddA18 VPWR=VddA18 prefix=sky130_fd_sc_hd__ }
