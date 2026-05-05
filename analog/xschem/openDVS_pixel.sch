v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 60 -130 80 -130 {lab=vpd}
N 60 -110 80 -110 {lab=PrBp}
N 140 -60 140 -40 {lab=GndA}
N 170 -60 170 -40 {lab=VddA18}
N 210 -130 310 -130 {lab=vpr}
N 290 -110 310 -110 {lab=PrSFBp}
N 370 -60 370 -30 {lab=GndA}
N 400 -60 400 -30 {lab=VddA18}
N 440 -130 510 -130 {lab=vsf}
N 500 -110 510 -110 {lab=DiffBn}
N 480 -90 510 -90 {lab=nRst}
N 640 -130 730 -130 {lab=vdiff}
N 700 -110 730 -110 {lab=OnBn}
N 700 -90 730 -90 {lab=OffBn}
N 860 -140 900 -140 {lab=ON}
N 860 -120 900 -120 {lab=nOFF}
N 170 200 210 200 {lab=RefrBp}
N 170 160 210 160 {lab=pixRst}
N 170 180 210 180 {lab=rowReadON}
N 340 180 380 180 {lab=nRst}
N 640 160 680 160 {lab=rowReadON}
N 640 180 680 180 {lab=rowReadOFF}
N 640 200 680 200 {lab=ON}
N 640 220 680 220 {lab=nOFF}
N 740 250 740 280 {lab=GndA}
N 810 190 840 190 {lab=readLine}
N 570 -60 570 -30 {lab=GndA}
N 600 -60 600 -30 {lab=VddA18}
N 790 -60 790 -30 {lab=GndA}
N 820 -60 820 -30 {lab=VddA18}
N 280 240 280 270 {lab=GndA}
N 310 240 310 270 {lab=VddA18}
N 760 250 760 280 {lab=GndD}
C {lab_wire.sym} 380 180 0 0 {name=p59 sig_type=std_logic lab=nRst}
C {PixelPhotoreceptor.sym} 230 -140 0 0 {name=xpr}
C {iopin.sym} 60 -130 2 0 {name=p54 lab=vpd}
C {iopin.sym} 60 -110 2 0 {name=p60 lab=PrBp}
C {iopin.sym} 140 -40 1 0 {name=p61 lab=GndA
}
C {iopin.sym} 170 -40 1 0 {name=p62 lab=VddA18
}
C {lab_wire.sym} 250 -130 0 0 {name=p1 sig_type=std_logic lab=vpr}
C {PixelSourceFollower.sym} 460 -140 0 0 {name=xsf}
C {iopin.sym} 290 -110 2 0 {name=p2 lab=PrSFBp}
C {lab_wire.sym} 370 -30 3 1 {name=p3 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 400 -30 3 1 {name=p5 sig_type=std_logic lab=VddA18}
C {PixelChangeAmplifier.sym} 660 -140 0 0 {name=xchAmp}
C {lab_wire.sym} 480 -130 0 0 {name=p6 sig_type=std_logic lab=vsf}
C {iopin.sym} 500 -110 2 0 {name=p8 lab=DiffBn}
C {lab_wire.sym} 480 -90 2 0 {name=p9 sig_type=std_logic lab=nRst}
C {iopin.sym} 700 -110 2 0 {name=p13 lab=OnBn}
C {PixelComparators.sym} 880 -140 0 0 {name=xcomp}
C {iopin.sym} 700 -90 2 0 {name=p17 lab=OffBn}
C {lab_wire.sym} 900 -140 0 0 {name=p14 sig_type=std_logic lab=ON}
C {lab_wire.sym} 900 -120 0 0 {name=p18 sig_type=std_logic lab=nOFF}
C {PixelHandshake.sym} 830 170 0 0 {name=xhandshake}
C {PixelResetGen.sym} 360 160 0 0 {name=xrst}
C {iopin.sym} 170 200 2 0 {name=p7 lab=RefrBp}
C {ipin.sym} 170 160 0 0 {name=p10 lab=pixRst}
C {lab_wire.sym} 170 180 2 1 {name=p19 sig_type=std_logic lab=rowReadON}
C {ipin.sym} 640 160 0 0 {name=p22 lab=rowReadON}
C {ipin.sym} 640 180 0 0 {name=p23 lab=rowReadOFF}
C {lab_wire.sym} 640 200 0 1 {name=p24 sig_type=std_logic lab=ON}
C {lab_wire.sym} 640 220 0 1 {name=p25 sig_type=std_logic lab=nOFF}
C {lab_wire.sym} 740 280 3 1 {name=p4 sig_type=std_logic lab=GndA}
C {iopin.sym} 840 190 0 0 {name=p26 lab=readLine}
C {lab_wire.sym} 700 -130 0 0 {name=p27 sig_type=std_logic lab=vdiff}
C {lab_wire.sym} 570 -30 3 1 {name=p11 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 600 -30 3 1 {name=p12 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 790 -30 3 1 {name=p15 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 820 -30 3 1 {name=p16 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 280 270 3 1 {name=p20 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 310 270 3 1 {name=p21 sig_type=std_logic lab=VddA18}
C {iopin.sym} 760 280 1 0 {name=p28 lab=GndD
}
