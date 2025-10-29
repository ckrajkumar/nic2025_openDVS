v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Rail pin defines the default
bias value at startup} -610 -830 0 0 0.3 0.3 {}
T {IBIT[3] selects shifted-source bias in DAVIS} -490 -690 0 0 0.3 0.3 {}
T {IBIT[2] selects cascode bias in DAVIS} -490 -660 0 0 0.3 0.3 {}
T {IBIT0 selects if bias is
enabled or tied to rail} 810 -270 0 0 0.3 0.3 {}
T {IBIT1 selects if bias is
N or P type} 590 -270 0 0 0.3 0.3 {}
T {IBIT[14:12] programe the coarse current.
The bits are flipped, so the coding is
as follows:
000: largest bias current (25uA)
...
111: smallest bias current (11pA)
This is dealt with on the host side
in software.} -60 -270 0 0 0.3 0.3 {}
T {The complete circuit for one configurable bias current} -570 -1120 0 0 1.3 1.3 {}
T {Fine bits are encoded linearly} 300 -660 0 0 0.3 0.3 {}
N 40 -820 50 -820 {lab=BiasVGate}
N 200 -860 240 -860 {lab=IInDiv}
N 560 -820 590 -820 {lab=IOutDiv}
N 910 -820 940 -820 {lab=VBiasOut}
N -90 -990 -90 -930 {lab=VddA18}
N 120 -990 120 -930 {lab=VddA18}
N 310 -990 310 -930 {lab=VddA18}
N 660 -990 660 -930 {lab=VddA18}
N 40 -840 40 -820 {lab=BiasVGate}
N 20 -820 40 -820 {lab=BiasVGate}
N 210 -840 210 -790 {lab=BiasVGate}
N 40 -840 210 -840 {lab=BiasVGate}
N 210 -790 240 -790 {lab=BiasVGate}
N -230 -890 -160 -890 {lab=BiasCB[0]}
N -230 -850 -160 -850 {lab=BiasCB[2]}
N -230 -830 -160 -830 {lab=BiasCB[3]}
N -230 -810 -160 -810 {lab=BiasCB[4]}
N -230 -790 -160 -790 {lab=BiasCB[5]}
N -230 -770 -160 -770 {lab=BiasCB[6]}
N -230 -750 -160 -750 {lab=BiasCB[7]}
N -230 -870 -160 -870 {lab=BiasCB[1]}
N -90 -710 -90 -670 {lab=GndA}
N -70 -710 -70 -670 {lab=bit14}
N -50 -710 -50 -670 {lab=bit13}
N -30 -710 -30 -670 {lab=bit12}
N 160 -710 160 -670 {lab=bit12}
N 140 -710 140 -670 {lab=bit13}
N 120 -710 120 -670 {lab=GndA}
N 310 -710 310 -670 {lab=GndA}
N 330 -710 330 -670 {lab=IBIT[4]}
N 350 -710 350 -670 {lab=IBIT[5]}
N 370 -710 370 -670 {lab=IBIT[6]}
N 390 -710 390 -670 {lab=IBIT[7]}
N 410 -710 410 -670 {lab=IBIT[8]}
N 430 -710 430 -670 {lab=IBIT[9]}
N 450 -710 450 -670 {lab=IBIT[10]}
N 470 -710 470 -670 {lab=IBIT[11]}
N 490 -710 490 -670 {lab=Latch}
N 510 -710 510 -670 {lab=nLatch}
N 660 -710 660 -670 {lab=GndA}
N 680 -710 680 -670 {lab=BufferN}
N 680 -990 680 -930 {lab=BufferP}
N 740 -990 740 -930 {lab=Rail}
N 720 -990 720 -930 {lab=PowerDown}
N 720 -710 720 -670 {lab=bit12}
N 740 -710 740 -670 {lab=bit13}
N 760 -710 760 -670 {lab=bit14}
N 780 -710 780 -670 {lab=BiasDisable}
N 800 -710 800 -670 {lab=BiasEnable}
N 820 -710 820 -670 {lab=NBias}
N 840 -710 840 -670 {lab=PBias}
N -10 -570 40 -570 {lab=nLatch}
N -120 -570 -90 -570 {lab=BiasLatchEnable}
N 120 -570 160 -570 {lab=Latch}
N 0 -340 0 -280 {lab=IBIT[14]}
N -100 -380 -60 -380 {lab=VddA18}
N 60 -380 100 -380 {lab=GndA}
N -100 -420 -60 -420 {lab=nLatch}
N 60 -420 100 -420 {lab=Latch}
N 20 -500 20 -460 {lab=bit14}
N 220 -340 220 -280 {lab=IBIT[13]}
N 120 -380 160 -380 {lab=VddA18}
N 280 -380 320 -380 {lab=GndA}
N 120 -420 160 -420 {lab=nLatch}
N 280 -420 320 -420 {lab=Latch}
N 240 -500 240 -460 {lab=bit13}
N 440 -340 440 -280 {lab=IBIT[12]}
N 340 -380 380 -380 {lab=VddA18}
N 500 -380 540 -380 {lab=GndA}
N 340 -420 380 -420 {lab=nLatch}
N 500 -420 540 -420 {lab=Latch}
N 460 -500 460 -460 {lab=bit12}
N 660 -340 660 -280 {lab=IBIT[1]}
N 560 -380 600 -380 {lab=VddA18}
N 720 -380 760 -380 {lab=GndA}
N 560 -420 600 -420 {lab=nLatch}
N 720 -420 760 -420 {lab=Latch}
N 680 -500 680 -460 {lab=NBias}
N 880 -340 880 -280 {lab=IBIT[0]}
N 780 -380 820 -380 {lab=VddA18}
N 940 -380 980 -380 {lab=GndA}
N 780 -420 820 -420 {lab=nLatch}
N 940 -420 980 -420 {lab=Latch}
N 900 -500 900 -460 {lab=BiasEnable}
N 640 -500 640 -460 {lab=PBias}
N 860 -500 860 -460 {lab=BiasDisable}
N -570 -710 -510 -710 {lab=IBIT[15]}
N -570 -680 -510 -680 {lab=IBIT[3]}
N -570 -650 -510 -650 {lab=IBIT[2]}
N -70 -580 100 -580 {lab=VddA18}
N -70 -560 100 -560 {lab=GndA}
C {iopin.sym} -360 -970 0 1 {name=p75 lab=VddA18}
C {iopin.sym} -360 -950 0 1 {name=p76 lab=GndA}
C {BiasCoarseBuffer.sym} -320 -800 0 0 {name=xCoarseBuf}
C {BiasCoarseFineInterface.sym} -110 -800 0 0 {name=xCoarse2Fine}
C {BiasDividerFine.sym} 80 -800 0 0 {name=xDivFine}
C {BiasBuffers.sym} 430 -800 0 0 {name=xBuffs}
C {opin.sym} 940 -820 2 1 {name=p1 lab=VBiasOut}
C {lab_wire.sym} -90 -990 1 1 {name=p2 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 120 -990 1 1 {name=p3 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 310 -990 1 1 {name=p4 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 660 -990 3 0 {name=p5 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 210 -840 3 0 {name=p7 sig_type=std_logic lab=BiasVGate}
C {lab_wire.sym} 240 -860 0 0 {name=p8 sig_type=std_logic lab=IInDiv}
C {lab_wire.sym} 590 -820 0 0 {name=p9 sig_type=std_logic lab=IOutDiv}
C {lab_wire.sym} -230 -890 0 1 {name=p10 sig_type=std_logic lab=BiasCB[0]}
C {lab_wire.sym} -230 -870 0 1 {name=p11 sig_type=std_logic lab=BiasCB[1]}
C {lab_wire.sym} -230 -850 0 1 {name=p12 sig_type=std_logic lab=BiasCB[2]}
C {lab_wire.sym} -230 -830 0 1 {name=p13 sig_type=std_logic lab=BiasCB[3]}
C {lab_wire.sym} -230 -810 0 1 {name=p14 sig_type=std_logic lab=BiasCB[4]}
C {lab_wire.sym} -230 -790 0 1 {name=p15 sig_type=std_logic lab=BiasCB[5]}
C {lab_wire.sym} -230 -770 0 1 {name=p16 sig_type=std_logic lab=BiasCB[6]}
C {lab_wire.sym} -230 -750 0 1 {name=p17 sig_type=std_logic lab=BiasCB[7]}
C {lab_wire.sym} -90 -670 3 1 {name=p18 sig_type=std_logic lab=GndA}
C {lab_wire.sym} -70 -670 3 1 {name=p19 sig_type=std_logic lab=bit14}
C {lab_wire.sym} -50 -670 3 1 {name=p20 sig_type=std_logic lab=bit13}
C {lab_wire.sym} -30 -670 3 1 {name=p21 sig_type=std_logic lab=bit12}
C {lab_wire.sym} 160 -670 3 1 {name=p22 sig_type=std_logic lab=bit12}
C {lab_wire.sym} 140 -670 3 1 {name=p23 sig_type=std_logic lab=bit13}
C {lab_wire.sym} 120 -670 3 1 {name=p24 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 310 -670 3 1 {name=p25 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 330 -670 3 1 {name=p26 sig_type=std_logic lab=IBIT[4]}
C {lab_wire.sym} 350 -670 3 1 {name=p27 sig_type=std_logic lab=IBIT[5]}
C {lab_wire.sym} 370 -670 3 1 {name=p28 sig_type=std_logic lab=IBIT[6]}
C {lab_wire.sym} 390 -670 3 1 {name=p29 sig_type=std_logic lab=IBIT[7]}
C {lab_wire.sym} 410 -670 3 1 {name=p30 sig_type=std_logic lab=IBIT[8]}
C {lab_wire.sym} 430 -670 3 1 {name=p31 sig_type=std_logic lab=IBIT[9]}
C {lab_wire.sym} 450 -670 3 1 {name=p32 sig_type=std_logic lab=IBIT[10]}
C {lab_wire.sym} 470 -670 3 1 {name=p33 sig_type=std_logic lab=IBIT[11]}
C {lab_wire.sym} 490 -670 3 1 {name=p34 sig_type=std_logic lab=Latch}
C {lab_wire.sym} 510 -670 3 1 {name=p35 sig_type=std_logic lab=nLatch}
C {lab_wire.sym} 660 -670 3 1 {name=p36 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 680 -670 3 1 {name=p37 sig_type=std_logic lab=BufferN}
C {lab_wire.sym} 680 -990 3 0 {name=p38 sig_type=std_logic lab=BufferP}
C {lab_wire.sym} 740 -990 3 0 {name=p39 sig_type=std_logic lab=Rail}
C {lab_wire.sym} 720 -990 3 0 {name=p40 sig_type=std_logic lab=PowerDown}
C {lab_wire.sym} 720 -670 3 1 {name=p41 sig_type=std_logic lab=bit12}
C {lab_wire.sym} 740 -670 3 1 {name=p42 sig_type=std_logic lab=bit13}
C {lab_wire.sym} 760 -670 3 1 {name=p43 sig_type=std_logic lab=bit14}
C {lab_wire.sym} 780 -670 3 1 {name=p44 sig_type=std_logic lab=BiasDisable}
C {lab_wire.sym} 800 -670 3 1 {name=p45 sig_type=std_logic lab=BiasEnable}
C {lab_wire.sym} 820 -670 3 1 {name=p46 sig_type=std_logic lab=NBias}
C {lab_wire.sym} 840 -670 3 1 {name=p47 sig_type=std_logic lab=PBias}
C {ipin.sym} -120 -570 2 1 {name=p48 lab=BiasLatchEnable}
C {lab_wire.sym} 0 -570 0 1 {name=p49 sig_type=std_logic lab=nLatch}
C {lab_wire.sym} 160 -570 0 0 {name=p50 sig_type=std_logic lab=Latch}
C {BiasLatch.sym} -60 -360 0 0 {name=xLatchB14}
C {lab_wire.sym} 0 -280 3 1 {name=p6 sig_type=std_logic lab=IBIT[14]}
C {lab_wire.sym} -100 -380 0 1 {name=p51 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 100 -380 0 0 {name=p52 sig_type=std_logic lab=GndA}
C {lab_wire.sym} -100 -420 0 1 {name=p53 sig_type=std_logic lab=nLatch}
C {lab_wire.sym} 100 -420 0 0 {name=p54 sig_type=std_logic lab=Latch}
C {noconn.sym} -20 -460 1 0 {name=l1}
C {lab_wire.sym} 20 -500 3 0 {name=p55 sig_type=std_logic lab=bit14}
C {BiasLatch.sym} 160 -360 0 0 {name=xLatchB13}
C {lab_wire.sym} 220 -280 3 1 {name=p56 sig_type=std_logic lab=IBIT[13]}
C {lab_wire.sym} 120 -380 0 1 {name=p57 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 320 -380 0 0 {name=p58 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 120 -420 0 1 {name=p59 sig_type=std_logic lab=nLatch}
C {lab_wire.sym} 320 -420 0 0 {name=p60 sig_type=std_logic lab=Latch}
C {noconn.sym} 200 -460 1 0 {name=l2}
C {lab_wire.sym} 240 -500 3 0 {name=p61 sig_type=std_logic lab=bit13}
C {BiasLatch.sym} 380 -360 0 0 {name=xLatchB12}
C {lab_wire.sym} 440 -280 3 1 {name=p62 sig_type=std_logic lab=IBIT[12]}
C {lab_wire.sym} 340 -380 0 1 {name=p63 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 540 -380 0 0 {name=p64 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 340 -420 0 1 {name=p65 sig_type=std_logic lab=nLatch}
C {lab_wire.sym} 540 -420 0 0 {name=p66 sig_type=std_logic lab=Latch}
C {noconn.sym} 420 -460 1 0 {name=l3}
C {lab_wire.sym} 460 -500 3 0 {name=p67 sig_type=std_logic lab=bit12}
C {BiasLatch.sym} 600 -360 0 0 {name=xLatchB1}
C {lab_wire.sym} 660 -280 3 1 {name=p68 sig_type=std_logic lab=IBIT[1]}
C {lab_wire.sym} 560 -380 0 1 {name=p69 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 760 -380 0 0 {name=p70 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 560 -420 0 1 {name=p71 sig_type=std_logic lab=nLatch}
C {lab_wire.sym} 760 -420 0 0 {name=p72 sig_type=std_logic lab=Latch}
C {BiasLatch.sym} 820 -360 0 0 {name=xLatchB0}
C {lab_wire.sym} 880 -280 3 1 {name=p74 sig_type=std_logic lab=IBIT[0]}
C {lab_wire.sym} 780 -380 0 1 {name=p77 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 980 -380 0 0 {name=p78 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 780 -420 0 1 {name=p79 sig_type=std_logic lab=nLatch}
C {lab_wire.sym} 980 -420 0 0 {name=p80 sig_type=std_logic lab=Latch}
C {lab_wire.sym} 680 -500 3 0 {name=p73 sig_type=std_logic lab=NBias}
C {lab_wire.sym} 640 -500 3 0 {name=p82 sig_type=std_logic lab=PBias}
C {lab_wire.sym} 900 -500 3 0 {name=p81 sig_type=std_logic lab=BiasEnable}
C {lab_wire.sym} 860 -500 3 0 {name=p83 sig_type=std_logic lab=BiasDisable}
C {noconn.sym} -510 -710 2 0 {name=l5}
C {lab_wire.sym} -570 -710 0 1 {name=p85 sig_type=std_logic lab=IBIT[15]}
C {noconn.sym} -510 -680 2 0 {name=l4}
C {lab_wire.sym} -570 -680 0 1 {name=p84 sig_type=std_logic lab=IBIT[3]}
C {noconn.sym} -510 -650 2 0 {name=l6}
C {lab_wire.sym} -570 -650 0 1 {name=p86 sig_type=std_logic lab=IBIT[2]}
C {ipin.sym} -360 -920 2 1 {name=p87 lab=IBIT[15:0]}
C {ipin.sym} -360 -900 2 1 {name=p88 lab=BiasCB[7:0]}
C {ipin.sym} -360 -880 2 1 {name=p89 lab=PowerDown}
C {ipin.sym} -360 -860 2 1 {name=p90 lab=BufferN}
C {ipin.sym} -360 -840 2 1 {name=p91 lab=BufferP}
C {iopin.sym} -360 -820 0 1 {name=p92 lab=Rail}
C {sky130_fd_sc_hd__inv_1.sym} -50 -570 0 0 {name=xInvLatch}
C {sky130_fd_sc_hd__inv_1.sym} 80 -570 0 0 {name=xInvnLatch}
C {lab_wire.sym} -10 -580 0 1 {name=p93 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} -10 -560 2 0 {name=p94 sig_type=std_logic lab=GndA}
