v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 520 -870 590 -870 {lab=vpd}
N 540 -850 590 -850 {lab=PrBp}
N 720 -870 780 -870 {lab=vpr}
N 730 -850 780 -850 {lab=PrSFBp}
N 910 -870 1040 -870 {lab=vsf}
N 970 -830 1040 -830 {lab=nRst}
N 970 -850 1040 -850 {lab=DiffBn}
N 1170 -870 1230 -870 {lab=vdiff}
N 650 -800 650 -750 {lab=gnd}
N 680 -800 680 -750 {lab=vdd}
N 840 -800 840 -750 {lab=gnd}
N 870 -800 870 -750 {lab=vdd}
N 1100 -800 1100 -750 {lab=gnd}
N 1130 -800 1130 -750 {lab=vdd}
C {PixelPhotoreceptor.sym} 740 -880 0 0 {name=xpr}
C {PixelSourceFollower.sym} 930 -880 0 0 {name=xsf}
C {PixelChangeAmplifier.sym} 1190 -880 0 0 {name=xChAmp}
C {iopin.sym} 520 -870 2 0 {name=p1 lab=vpd}
C {iopin.sym} 540 -850 2 0 {name=p2 lab=PrBp}
C {iopin.sym} 730 -850 2 0 {name=p3 lab=PrSFBp}
C {iopin.sym} 970 -830 2 0 {name=p4 lab=nRst}
C {iopin.sym} 970 -850 2 0 {name=p5 lab=DiffBn}
C {iopin.sym} 1230 -870 0 0 {name=p6 lab=vdiff}
C {iopin.sym} 720 -870 2 0 {name=p7 lab=vpr}
C {iopin.sym} 910 -870 2 0 {name=p8 lab=vsf}
C {lab_wire.sym} 650 -750 1 1 {name=p9 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 680 -750 1 1 {name=p10 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 840 -750 1 1 {name=p11 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 870 -750 1 1 {name=p12 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1100 -750 3 1 {name=p13 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1130 -750 3 1 {name=p14 sig_type=std_logic lab=vdd}
C {iopin.sym} 650 -750 1 0 {name=p15 lab=gnd}
C {iopin.sym} 680 -750 3 0 {name=p16 lab=vdd}
