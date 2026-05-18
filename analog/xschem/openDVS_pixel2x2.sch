v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -80 -150 -20 -150 {lab=pixRst[0]}
N -80 -130 -20 -130 {lab=rowReadON[0]}
N -80 -110 -20 -110 {lab=rowReadOFF[0]}
N -80 -70 -20 -70 {lab=vpd00}
N 280 -90 340 -90 {lab=readLine[0]}
N 200 -260 200 -190 {lab=OffBn}
N 180 -260 180 -190 {lab=OnBn}
N 160 -260 160 -190 {lab=DiffBn}
N 140 -260 140 -190 {lab=RefrBp}
N 120 -260 120 -190 {lab=PrSFBp}
N 100 -260 100 -190 {lab=PrBp}
N 100 20 100 90 {lab=GndD}
N 70 20 70 90 {lab=VddA18}
N 40 20 40 90 {lab=GndA}
N 1180 -260 1180 -190 {lab=OffBn}
N 1160 -260 1160 -190 {lab=OnBn}
N 1140 -260 1140 -190 {lab=DiffBn}
N 1120 -260 1120 -190 {lab=RefrBp}
N 1100 -260 1100 -190 {lab=PrSFBp}
N 1080 -260 1080 -190 {lab=PrBp}
N 900 -150 960 -150 {lab=pixRst[1]}
N 900 -130 960 -130 {lab=rowReadON[0]}
N 900 -110 960 -110 {lab=rowReadOFF[0]}
N 1260 -90 1320 -90 {lab=readLine[1]}
N 1080 20 1080 90 {lab=GndD}
N 1050 20 1050 90 {lab=VddA18}
N 1020 20 1020 90 {lab=GndA}
N 900 -70 960 -70 {lab=vpd01}
N -80 420 -20 420 {lab=pixRst[0]}
N -80 440 -20 440 {lab=rowReadON[1]}
N -80 460 -20 460 {lab=rowReadOFF[1]}
N -80 500 -20 500 {lab=vpd10}
N 280 480 340 480 {lab=readLine[0]}
N 200 310 200 380 {lab=OffBn}
N 180 310 180 380 {lab=OnBn}
N 160 310 160 380 {lab=DiffBn}
N 140 310 140 380 {lab=RefrBp}
N 120 310 120 380 {lab=PrSFBp}
N 100 310 100 380 {lab=PrBp}
N 100 590 100 660 {lab=GndD}
N 70 590 70 660 {lab=VddA18}
N 40 590 40 660 {lab=GndA}
N 1180 310 1180 380 {lab=OffBn}
N 1160 310 1160 380 {lab=OnBn}
N 1140 310 1140 380 {lab=DiffBn}
N 1120 310 1120 380 {lab=RefrBp}
N 1100 310 1100 380 {lab=PrSFBp}
N 1080 310 1080 380 {lab=PrBp}
N 900 420 960 420 {lab=pixRst[1]}
N 900 440 960 440 {lab=rowReadON[1]}
N 900 460 960 460 {lab=rowReadOFF[1]}
N 1260 480 1320 480 {lab=readLine[0]}
N 1080 590 1080 660 {lab=GndD}
N 1050 590 1050 660 {lab=VddA18}
N 1020 590 1020 660 {lab=GndA}
N 900 500 960 500 {lab=vpd11}
C {openDVS_pixel.sym} 130 -60 0 0 {name=x1}
C {openDVS_pixel.sym} 1110 -60 0 0 {name=x2}
C {iopin.sym} -620 -100 3 0 {name=p12 lab=GndD}
C {iopin.sym} -590 -100 3 0 {name=p13 lab=Vdd18A}
C {iopin.sym} -560 -100 3 0 {name=p14 lab=GndA}
C {openDVS_pixel.sym} 130 510 0 0 {name=x3}
C {openDVS_pixel.sym} 1110 510 0 0 {name=x4}
C {lab_wire.sym} -50 -70 0 0 {name=p53 sig_type=std_logic lab=vpd00}
C {lab_wire.sym} -40 500 0 0 {name=p54 sig_type=std_logic lab=vpd10}
C {lab_wire.sym} 940 500 0 0 {name=p55 sig_type=std_logic lab=vpd11}
C {lab_wire.sym} 940 -70 0 0 {name=p56 sig_type=std_logic lab=vpd01}
C {iopin.sym} -400 -100 3 0 {name=p57 lab=OffBn}
C {iopin.sym} -420 -100 3 0 {name=p58 lab=OnBn}
C {iopin.sym} -440 -100 3 0 {name=p59 lab=DiffBn}
C {iopin.sym} -460 -100 3 0 {name=p60 lab=RefrBp}
C {iopin.sym} -480 -100 3 0 {name=p61 lab=PrSFBp}
C {iopin.sym} -500 -100 3 0 {name=p62 lab=PrBp}
C {lab_wire.sym} 100 -250 3 0 {name=p3 sig_type=std_logic lab=PrBp}
C {lab_wire.sym} 120 -250 3 0 {name=p6 sig_type=std_logic lab=PrSFBp}
C {lab_wire.sym} 140 -250 3 0 {name=p7 sig_type=std_logic lab=RefrBp}
C {lab_wire.sym} 160 -250 3 0 {name=p8 sig_type=std_logic lab=DiffBn}
C {lab_wire.sym} 180 -250 3 0 {name=p9 sig_type=std_logic lab=OnBn}
C {lab_wire.sym} 200 -250 3 0 {name=p10 sig_type=std_logic lab=OffBn}
C {lab_wire.sym} 1080 -250 3 0 {name=p11 sig_type=std_logic lab=PrBp}
C {lab_wire.sym} 1100 -250 3 0 {name=p15 sig_type=std_logic lab=PrSFBp}
C {lab_wire.sym} 1120 -250 3 0 {name=p16 sig_type=std_logic lab=RefrBp}
C {lab_wire.sym} 1140 -250 3 0 {name=p17 sig_type=std_logic lab=DiffBn}
C {lab_wire.sym} 1160 -250 3 0 {name=p18 sig_type=std_logic lab=OnBn}
C {lab_wire.sym} 1180 -250 3 0 {name=p19 sig_type=std_logic lab=OffBn}
C {lab_wire.sym} 1080 320 3 0 {name=p24 sig_type=std_logic lab=PrBp}
C {lab_wire.sym} 1100 320 3 0 {name=p25 sig_type=std_logic lab=PrSFBp}
C {lab_wire.sym} 1120 320 3 0 {name=p26 sig_type=std_logic lab=RefrBp}
C {lab_wire.sym} 1140 320 3 0 {name=p30 sig_type=std_logic lab=DiffBn}
C {lab_wire.sym} 1160 320 3 0 {name=p31 sig_type=std_logic lab=OnBn}
C {lab_wire.sym} 1180 320 3 0 {name=p32 sig_type=std_logic lab=OffBn}
C {lab_wire.sym} 100 320 3 0 {name=p33 sig_type=std_logic lab=PrBp}
C {lab_wire.sym} 120 320 3 0 {name=p34 sig_type=std_logic lab=PrSFBp}
C {lab_wire.sym} 140 320 3 0 {name=p35 sig_type=std_logic lab=RefrBp}
C {lab_wire.sym} 160 320 3 0 {name=p36 sig_type=std_logic lab=DiffBn}
C {lab_wire.sym} 180 320 3 0 {name=p37 sig_type=std_logic lab=OnBn}
C {lab_wire.sym} 200 320 3 0 {name=p38 sig_type=std_logic lab=OffBn}
C {lab_wire.sym} 40 60 3 0 {name=p40 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 70 60 3 0 {name=p41 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 100 60 3 0 {name=p42 sig_type=std_logic lab=GndD}
C {lab_wire.sym} 40 620 3 0 {name=p43 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 70 620 3 0 {name=p44 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 100 620 3 0 {name=p45 sig_type=std_logic lab=GndD}
C {lab_wire.sym} 1020 60 3 0 {name=p50 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 1050 60 3 0 {name=p51 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 1080 60 3 0 {name=p52 sig_type=std_logic lab=GndD}
C {lab_wire.sym} 1020 620 3 0 {name=p63 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 1050 620 3 0 {name=p64 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 1080 620 3 0 {name=p65 sig_type=std_logic lab=GndD}
C {iopin.sym} -400 40 0 0 {name=p66 lab=readLine[0]}
C {iopin.sym} -400 80 0 0 {name=p67 lab=readLine[1]}
C {iopin.sym} -480 40 0 1 {name=p68 lab=pixRst[0]}
C {iopin.sym} -480 120 0 1 {name=p70 lab=rowReadON[1]}
C {iopin.sym} -480 160 0 1 {name=p71 lab=rowReadOFF[1]}
C {iopin.sym} -320 120 0 1 {name=p72 lab=rowReadON[0]}
C {iopin.sym} -320 160 0 1 {name=p73 lab=rowReadOFF[0]}
C {iopin.sym} -480 80 0 1 {name=p69 lab=pixRst[1]}
C {lab_wire.sym} -40 -150 0 0 {name=p74 sig_type=std_logic lab=pixRst[0]}
C {lab_wire.sym} -40 -130 0 0 {name=p5 sig_type=std_logic lab=rowReadON[0]}
C {lab_wire.sym} -40 -110 0 0 {name=p4 sig_type=std_logic lab=rowReadOFF[0]}
C {lab_wire.sym} 940 -150 0 0 {name=p2 sig_type=std_logic lab=pixRst[1]}
C {lab_wire.sym} 940 -130 0 0 {name=p20 sig_type=std_logic lab=rowReadON[0]}
C {lab_wire.sym} 940 -110 0 0 {name=p21 sig_type=std_logic lab=rowReadOFF[0]}
C {lab_wire.sym} -40 420 0 0 {name=p22 sig_type=std_logic lab=pixRst[0]}
C {lab_wire.sym} -40 440 0 0 {name=p28 sig_type=std_logic lab=rowReadON[1]}
C {lab_wire.sym} -40 460 0 0 {name=p29 sig_type=std_logic lab=rowReadOFF[1]}
C {lab_wire.sym} 930 420 0 0 {name=p39 sig_type=std_logic lab=pixRst[1]}
C {lab_wire.sym} 930 440 0 0 {name=p46 sig_type=std_logic lab=rowReadON[1]}
C {lab_wire.sym} 930 460 0 0 {name=p47 sig_type=std_logic lab=rowReadOFF[1]}
C {lab_wire.sym} 310 480 0 1 {name=p27 sig_type=std_logic lab=readLine[0]}
C {lab_wire.sym} 310 -90 0 1 {name=p1 sig_type=std_logic lab=readLine[0]}
C {lab_wire.sym} 1290 480 0 1 {name=p23 sig_type=std_logic lab=readLine[1]}
C {lab_wire.sym} 1290 -90 0 1 {name=p48 sig_type=std_logic lab=readLine[1]}
