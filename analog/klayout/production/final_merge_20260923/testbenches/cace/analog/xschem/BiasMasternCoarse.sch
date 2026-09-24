v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 780 -310 780 -250 {lab=BiasCB0}
N 810 -310 810 -250 {lab=BiasCB1}
N 840 -310 840 -250 {lab=BiasCB2}
N 870 -310 870 -250 {lab=BiasCB3}
N 900 -310 900 -250 {lab=BiasCB4}
N 930 -310 930 -250 {lab=BiasCB5}
N 960 -310 960 -250 {lab=BiasCB6}
N 990 -310 990 -250 {lab=BiasCB7}
N 720 -310 720 -250 {lab=GndA}
N 440 -310 440 -250 {lab=GndA}
N 720 -550 720 -490 {lab=VddA18}
N 440 -550 440 -490 {lab=VddA18}
N 230 -400 290 -400 {lab=PowerDown}
N 370 -310 370 -250 {lab=IR}
N 510 -310 510 -180 {lab=VMasterBiasN}
N 510 -610 510 -490 {lab=VMasterBiasP}
N 590 -420 670 -420 {lab=Coarse1}
N 590 -380 670 -380 {lab=Coarse2}
N 310 -180 310 -160 {lab=VMasterBiasN}
N 610 -180 760 -180 {lab=VMasterBiasN}
N 760 -180 760 -160 {lab=VMasterBiasN}
N 610 -180 610 -160 {lab=VMasterBiasN}
N 510 -180 610 -180 {lab=VMasterBiasN}
N 470 -180 470 -160 {lab=VMasterBiasN}
N 310 -180 470 -180 {lab=VMasterBiasN}
N 470 -180 510 -180 {lab=VMasterBiasN}
N 310 -100 310 -60 {lab=GndA}
N 470 -100 470 -60 {lab=GndA}
N 610 -100 610 -60 {lab=GndA}
N 760 -100 760 -60 {lab=GndA}
C {ipin.sym} 100 -280 0 0 {name=p1 lab=PowerDown}
C {opin.sym} 80 -260 0 0 {name=p2 lab=VMasterBiasN}
C {iopin.sym} 100 -220 2 0 {name=p3 lab=VddA18}
C {iopin.sym} 100 -200 2 0 {name=p4 lab=GndA}
C {iopin.sym} 100 -180 2 0 {name=p5 lab=IR}
C {opin.sym} 80 -240 0 0 {name=p6 lab=VMasterBiasP}
C {iopin.sym} 100 -160 2 0 {name=p7 lab=BiasCB0}
C {iopin.sym} 100 -140 2 0 {name=p8 lab=BiasCB1}
C {iopin.sym} 100 -120 2 0 {name=p9 lab=BiasCB2}
C {iopin.sym} 100 -100 2 0 {name=p10 lab=BiasCB3}
C {iopin.sym} 100 -80 2 0 {name=p11 lab=BiasCB4}
C {iopin.sym} 100 -60 2 0 {name=p12 lab=BiasCB5}
C {iopin.sym} 100 -40 2 0 {name=p13 lab=BiasCB6}
C {iopin.sym} 100 -20 2 0 {name=p14 lab=BiasCB7}
C {BiasMasterBias.sym} 440 -400 0 0 {name=xBiasMasterBias}
C {lab_wire.sym} 230 -400 0 1 {name=p15 sig_type=std_logic lab=PowerDown}
C {BiasCoarseMBDivider.sym} 820 -400 0 0 {name=xMBDiv}
C {lab_wire.sym} 870 -250 3 1 {name=p30 sig_type=std_logic lab=BiasCB3}
C {lab_wire.sym} 900 -250 3 1 {name=p33 sig_type=std_logic lab=BiasCB4}
C {lab_wire.sym} 930 -250 3 1 {name=p36 sig_type=std_logic lab=BiasCB5}
C {lab_wire.sym} 960 -250 3 1 {name=p39 sig_type=std_logic lab=BiasCB6}
C {lab_wire.sym} 990 -250 3 1 {name=p42 sig_type=std_logic lab=BiasCB7}
C {lab_wire.sym} 780 -250 3 1 {name=p16 sig_type=std_logic lab=BiasCB0}
C {lab_wire.sym} 810 -250 3 1 {name=p17 sig_type=std_logic lab=BiasCB1}
C {lab_wire.sym} 840 -250 3 1 {name=p18 sig_type=std_logic lab=BiasCB2}
C {lab_wire.sym} 720 -250 3 1 {name=p19 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 440 -250 3 1 {name=p20 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 720 -550 3 0 {name=p21 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 440 -550 3 0 {name=p22 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 370 -250 3 1 {name=p23 sig_type=std_logic lab=IR}
C {lab_wire.sym} 510 -190 3 1 {name=p24 sig_type=std_logic lab=VMasterBiasN}
C {lab_wire.sym} 510 -610 3 0 {name=p25 sig_type=std_logic lab=VMasterBiasP}
C {lab_wire.sym} 600 -420 0 1 {name=p26 sig_type=std_logic lab=Coarse1}
C {lab_wire.sym} 600 -380 0 1 {name=p27 sig_type=std_logic lab=Coarse2}
C {sky130_fd_pr/cap_mim_m3_1.sym} 310 -130 0 0 {name=C1 model=cap_mim_m3_1 W=17.42 L=363.855 MF=1 spiceprefix=X}
C {sky130_fd_pr/cap_mim_m3_1.sym} 470 -130 0 0 {name=C2 model=cap_mim_m3_1 W=30 L=145 MF=1 spiceprefix=X}
C {sky130_fd_pr/cap_mim_m3_1.sym} 610 -130 0 0 {name=C3 model=cap_mim_m3_1 W=30 L=145 MF=1 spiceprefix=X}
C {sky130_fd_pr/cap_mim_m3_1.sym} 760 -130 0 0 {name=C4 model=cap_mim_m3_1 W=30 L=145 MF=1 spiceprefix=X}
C {lab_wire.sym} 310 -60 3 1 {name=p28 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 470 -60 3 1 {name=p29 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 610 -60 3 1 {name=p31 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 760 -60 3 1 {name=p32 sig_type=std_logic lab=GndA}
