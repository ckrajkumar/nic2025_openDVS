v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Fine bits are encoded linearly} 300 -660 0 0 0.3 0.3 {}
N 40 -820 50 -820 {lab=BiasVGate}
N 200 -860 240 -860 {lab=IInDiv}
N 560 -820 690 -820 {lab=BufferN}
N -90 -990 -90 -930 {lab=VddA18}
N 120 -990 120 -930 {lab=VddA18}
N 310 -990 310 -930 {lab=VddA18}
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
N -570 -710 -510 -710 {lab=IBIT[15]}
N -570 -680 -510 -680 {lab=IBIT[3]}
N -570 -650 -510 -650 {lab=IBIT[2]}
N -570 -620 -510 -620 {lab=IBIT[1]}
N -570 -590 -510 -590 {lab=IBIT[0]}
N 690 -820 690 -780 {lab=BufferN}
N 690 -820 750 -820 {lab=BufferN}
N 750 -820 750 -750 {lab=BufferN}
N 730 -750 750 -750 {lab=BufferN}
N 690 -720 690 -680 {lab=GndA}
N 650 -750 690 -750 {lab=GndA}
N 810 -720 810 -680 {lab=GndA}
N 810 -750 850 -750 {lab=GndA}
N 750 -750 770 -750 {lab=BufferN}
N 810 -810 810 -780 {lab=BufferP}
N 810 -810 880 -810 {lab=BufferP}
N 810 -830 810 -810 {lab=BufferP}
N 880 -860 880 -810 {lab=BufferP}
N 850 -860 880 -860 {lab=BufferP}
N 810 -950 810 -890 {lab=VddA18}
N 750 -860 810 -860 {lab=VddA18}
N -570 -560 -510 -560 {lab=PowerDown}
N -570 -530 -510 -530 {lab=BiasCB[7:0]}
C {iopin.sym} -360 -970 0 1 {name=p75 lab=VddA18}
C {iopin.sym} -360 -950 0 1 {name=p76 lab=GndA}
C {BiasCoarseBuffer.sym} -320 -800 0 0 {name=xCoarseBuf}
C {BiasCoarseFineInterface.sym} -110 -800 0 0 {name=xCoarse2Fine}
C {BiasDividerFine.sym} 80 -800 0 0 {name=xDivFine}
C {opin.sym} -380 -790 2 1 {name=p1 lab=BufferN}
C {lab_wire.sym} -90 -990 1 1 {name=p2 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 120 -990 1 1 {name=p3 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 310 -990 1 1 {name=p4 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 210 -840 3 0 {name=p7 sig_type=std_logic lab=BiasVGate}
C {lab_wire.sym} 240 -860 0 0 {name=p8 sig_type=std_logic lab=IInDiv}
C {lab_wire.sym} 590 -820 0 0 {name=p9 sig_type=std_logic lab=BufferN}
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
C {sky130_stdcells/inv_12.sym} -50 -570 0 0 {name=xInvLatch VGND=GndA VNB=GndA VPB=VddA18 VPWR=VddA18 prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/inv_12.sym} 80 -570 0 0 {name=xInvnLatch VGND=GndA VNB=GndA VPB=VddA18 VPWR=VddA18 prefix=sky130_fd_sc_hd__ }
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
C {noconn.sym} -510 -620 2 0 {name=l7}
C {lab_wire.sym} -570 -620 0 1 {name=p5 sig_type=std_logic lab=IBIT[1]}
C {noconn.sym} -510 -590 2 0 {name=l8}
C {lab_wire.sym} -570 -590 0 1 {name=p36 sig_type=std_logic lab=IBIT[0]}
C {opin.sym} -380 -770 2 1 {name=p37 lab=BufferP}
C {sky130_fd_pr/pfet_01v8.sym} 830 -860 0 1 {name=MpDio
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
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 710 -750 0 1 {name=MnDio
W=6
L=6
nf=1 
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {lab_wire.sym} 690 -680 3 1 {name=p38 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 650 -750 0 1 {name=p39 sig_type=std_logic lab=GndA}
C {sky130_fd_pr/nfet_01v8.sym} 790 -750 0 0 {name=MnMirr
W=6
L=6
nf=1 
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {lab_wire.sym} 810 -680 1 0 {name=p40 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 850 -750 0 0 {name=p41 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 880 -810 0 0 {name=p42 sig_type=std_logic lab=BufferP}
C {lab_wire.sym} 810 -950 1 1 {name=p43 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 750 -860 0 1 {name=p44 sig_type=std_logic lab=VddA18}
C {noconn.sym} -510 -560 2 0 {name=l9}
C {lab_wire.sym} -570 -560 0 1 {name=p45 sig_type=std_logic lab=PowerDown}
C {noconn.sym} -510 -530 2 0 {name=l10}
C {lab_wire.sym} -570 -530 0 1 {name=p46 sig_type=std_logic lab=BiasCB[7:0]}
C {noconn.sym} -360 -820 2 0 {name=l11}
