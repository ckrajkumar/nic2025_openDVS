v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -350 -50 -350 -20 {lab=vdd}
N -350 40 -350 70 {lab=vpd}
N -380 10 -350 10 {lab=gnd}
N 230 -140 230 -110 {lab=vdd}
N 230 -80 260 -80 {lab=vdd}
N 230 120 230 160 {lab=gnd}
N 230 90 260 90 {lab=vdd}
N 230 20 340 20 {lab=vsf}
N -80 20 180 20 {lab=vpr}
N 140 -80 190 -80 {lab=PrSFBp}
N 230 20 230 60 {lab=vsf}
N -160 -60 -120 -60 {lab=PrBp}
N 1430 50 1470 50 {lab=rowReadON}
N -350 80 -350 110 {lab=vpd}
N -350 170 -350 200 {lab=gnd}
N -480 80 -480 100 {lab=vpd}
N -480 80 -350 80 {lab=vpd}
N -80 20 -80 40 {lab=vpr}
N -80 100 -80 140 {lab=gnd}
N -80 10 -80 20 {lab=vpr}
N -80 -120 -80 -90 {lab=vdd}
N -350 70 -120 70 {lab=vpd}
N -310 10 -80 10 {lab=vpr}
N -80 -60 -50 -60 {lab=vdd}
N -80 70 -50 70 {lab=gnd}
N 180 20 180 90 {lab=vpr}
N 180 90 190 90 {lab=vpr}
N 400 20 400 100 {lab=vd}
N 400 100 440 100 {lab=vd}
N 400 20 510 20 {lab=vd}
N 500 100 550 100 {lab=vdiff}
N 550 80 550 100 {lab=vdiff}
N 550 380 550 420 {lab=gnd}
N 470 350 510 350 {lab=DiffBn}
N 550 20 580 20 {lab=vdd}
N 550 -40 550 -10 {lab=vdd}
N 790 380 790 420 {lab=gnd}
N 790 20 820 20 {lab=vdd}
N 790 -40 790 -10 {lab=vdd}
N 690 20 690 80 {lab=vdiff}
N 690 20 750 20 {lab=vdiff}
N 230 -50 230 20 {lab=vsf}
N -350 70 -350 80 {lab=vpd}
N -80 -30 -80 10 {lab=vpr}
N 700 350 750 350 {lab=OnBn}
N 550 50 550 80 {lab=vdiff}
N 550 350 580 350 {lab=gnd}
N 790 350 820 350 {lab=gnd}
N 1090 380 1090 420 {lab=gnd}
N 1090 20 1120 20 {lab=vdd}
N 1090 -40 1090 -10 {lab=vdd}
N 990 20 990 80 {lab=vdiff}
N 990 20 1050 20 {lab=vdiff}
N 1000 350 1050 350 {lab=OffBn}
N 1090 350 1120 350 {lab=gnd}
N 550 80 690 80 {lab=vdiff}
N 1510 80 1510 110 {lab=readLineONpd}
N 1510 170 1510 210 {lab=gnd}
N 1430 140 1470 140 {lab=ON}
N 1730 50 1770 50 {lab=rowReadOFF}
N 1810 80 1810 110 {lab=readLineOFFpd}
N 1810 170 1810 210 {lab=gnd}
N 1730 140 1770 140 {lab=nOFF}
N 1510 -20 1510 20 {lab=readLine}
N 1660 -20 1810 -20 {lab=readLine}
N 1810 -20 1810 20 {lab=readLine}
N 1660 -130 1660 -20 {lab=readLine}
N 1510 -20 1660 -20 {lab=readLine}
N 1510 140 1540 140 {lab=gnd}
N 1810 140 1840 140 {lab=gnd}
N 1810 50 1840 50 {lab=gnd}
N 400 100 400 200 {lab=vd}
N 400 200 440 200 {lab=vd}
N 500 200 550 200 {lab=vdiff}
N 550 200 550 320 {lab=vdiff}
N 550 100 550 200 {lab=vdiff}
N 690 80 990 80 {lab=vdiff}
N 470 170 470 200 {lab=vdd}
N 470 240 470 280 {lab=nRst}
N 450 740 450 780 {lab=gnd}
N 450 710 480 710 {lab=gnd}
N 450 660 450 680 {lab=nRst}
N 450 550 450 580 {lab=vdd}
N 450 610 480 610 {lab=vdd}
N 370 610 410 610 {lab=RefrBp}
N 450 660 625 660 {lab=nRst}
N 450 640 450 660 {lab=nRst}
N 1090 50 1090 320 {lab=nOFF}
N 790 50 790 320 {lab=ON}
N 390 710 410 710 {lab=pixRst}
N 625 660 625 680 {lab=nRst}
N 595 720 595 760 {lab=vdd}
N 625 760 655 760 {lab=vdd}
N 655 725 655 760 {lab=vdd}
N 625 720 625 760 {lab=vdd}
N 595 760 625 760 {lab=vdd}
N 1510 50 1540 50 {lab=gnd}
C {sky130_fd_pr/cap_mim_m3_1.sym} 370 20 3 0 {name=C1 model=cap_mim_m3_1 W=1 L=1 MF=16 spiceprefix=X}
C {sky130_fd_pr/nfet_01v8.sym} -330 10 0 1 {name=Mpd
W=0.5
L=0.15
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
C {lab_pin.sym} 230 0 2 0 {name=p2 sig_type=std_logic lab=vsf}
C {ipin.sym} 1430 50 0 0 {name=p4 lab=rowReadON}
C {lab_wire.sym} -380 10 0 1 {name=p17 sig_type=std_logic lab=gnd}
C {iopin.sym} -160 -60 2 0 {name=p9 lab=PrBp}
C {iopin.sym} -350 -50 3 0 {name=p8 lab=vdd}
C {lab_wire.sym} 230 -140 0 0 {name=p20 sig_type=std_logic lab=vdd}
C {iopin.sym} -480 100 1 0 {name=p22 lab=vpd}
C {iopin.sym} 140 -80 2 0 {name=p7 lab=PrSFBp}
C {iopin.sym} -350 200 1 0 {name=p1 lab=gnd}
C {lab_wire.sym} 230 160 0 0 {name=p11 sig_type=std_logic lab=gnd}
C {sky130_fd_pr/nfet_01v8.sym} -100 70 0 0 {name=Mpr_amp
W=0.5
L=0.15
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
C {lab_wire.sym} -80 140 0 0 {name=p25 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -80 -120 0 0 {name=p26 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -50 -60 0 0 {name=p27 sig_type=std_logic lab=vdd}
C {lab_pin.sym} -30 20 2 0 {name=p28 sig_type=std_logic lab=vpr}
C {lab_wire.sym} -50 70 0 0 {name=p29 sig_type=std_logic lab=gnd}
C {sky130_fd_pr/photodiode.sym} -350 140 0 0 {name=D1
model=photodiode
area=25
perim=20
spiceprefix=X
}
C {lab_wire.sym} 260 -80 0 0 {name=p3 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 260 90 0 0 {name=p5 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/cap_mim_m3_1.sym} 470 100 3 0 {name=C2 model=cap_mim_m3_1 W=1 L=1 MF=2 spiceprefix=X}
C {sky130_fd_pr/nfet_01v8.sym} 530 350 0 0 {name=MchAmpBias
W=1
L=2
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
C {lab_wire.sym} 550 420 0 0 {name=p6 sig_type=std_logic lab=gnd}
C {iopin.sym} 470 350 2 0 {name=p10 lab=DiffBn}
C {lab_wire.sym} 580 20 0 0 {name=p13 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 550 -40 0 0 {name=p14 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/nfet_01v8.sym} 770 350 0 0 {name=MonBias
W=1
L=2
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
C {lab_wire.sym} 790 420 0 0 {name=p15 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 820 20 0 0 {name=p18 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 790 -40 0 0 {name=p19 sig_type=std_logic lab=vdd}
C {iopin.sym} 700 350 2 0 {name=p21 lab=OnBn}
C {lab_wire.sym} 580 350 0 0 {name=p12 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 820 350 0 0 {name=p16 sig_type=std_logic lab=gnd}
C {lab_pin.sym} 440 20 2 0 {name=p23 sig_type=std_logic lab=vd}
C {lab_pin.sym} 630 80 2 0 {name=p24 sig_type=std_logic lab=vdiff}
C {lab_pin.sym} 790 120 2 0 {name=p30 sig_type=std_logic lab=ON}
C {sky130_fd_pr/nfet_01v8.sym} 1070 350 0 0 {name=MoffBias
W=1
L=2
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
C {lab_wire.sym} 1090 420 0 0 {name=p31 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1120 20 0 0 {name=p32 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1090 -40 0 0 {name=p33 sig_type=std_logic lab=vdd}
C {iopin.sym} 1000 350 2 0 {name=p34 lab=OffBn}
C {lab_wire.sym} 1120 350 0 0 {name=p35 sig_type=std_logic lab=gnd}
C {lab_pin.sym} 1090 120 2 0 {name=p36 sig_type=std_logic lab=nOFF}
C {sky130_fd_pr/nfet_01v8.sym} 1490 50 0 0 {name=MswON
W=0.5
L=0.15
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
C {sky130_fd_pr/nfet_01v8.sym} 1490 140 0 0 {name=MoutON
W=0.5
L=0.15
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
C {lab_wire.sym} 1510 210 0 0 {name=p37 sig_type=std_logic lab=gnd}
C {lab_pin.sym} 1430 140 2 0 {name=p38 sig_type=std_logic lab=ON}
C {ipin.sym} 1730 50 0 0 {name=p39 lab=rowReadOFF}
C {sky130_fd_pr/nfet_01v8.sym} 1790 50 0 0 {name=MswOFF
W=0.5
L=0.15
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
C {sky130_fd_pr/nfet_01v8.sym} 1790 140 0 0 {name=MoutOFF
W=0.5
L=0.15
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
C {lab_wire.sym} 1810 210 0 0 {name=p40 sig_type=std_logic lab=gnd}
C {lab_pin.sym} 1730 140 2 0 {name=p41 sig_type=std_logic lab=nOFF}
C {iopin.sym} 1660 -130 3 0 {name=p42 lab=readLine}
C {lab_wire.sym} 1540 140 0 0 {name=p43 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1840 140 0 0 {name=p44 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1840 50 0 0 {name=p45 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 470 170 3 0 {name=p46 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 470 280 0 0 {name=p47 sig_type=std_logic lab=nRst}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 470 220 3 0 {name=Mrst
W=1
L=0.15
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_hvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_hvt.sym} -100 -60 0 0 {name=MprBias
W=1
L=0.15
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_hvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 210 -80 0 0 {name=MsfBias
W=2
L=8
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_hvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 530 20 0 0 {name=MchAmp
W=1
L=2
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_hvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 770 20 0 0 {name=Mon
W=1
L=2
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_hvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 1070 20 0 0 {name=Moff
W=1
L=2
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_hvt
spiceprefix=X
}
C {ipin.sym} 390 710 0 0 {name=p49 lab=pixRst}
C {lab_wire.sym} 450 780 0 0 {name=p54 sig_type=std_logic lab=gnd}
C {sky130_fd_pr/nfet_01v8.sym} 430 710 0 0 {name=MrefrInv
W=0.5
L=0.15
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
C {lab_wire.sym} 480 710 0 0 {name=p55 sig_type=std_logic lab=gnd}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 430 610 0 0 {name=MrefrBias
W=2
L=8
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_hvt
spiceprefix=X
}
C {lab_wire.sym} 450 550 0 0 {name=p56 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 480 610 0 0 {name=p57 sig_type=std_logic lab=vdd}
C {iopin.sym} 370 610 2 0 {name=p58 lab=RefrBp}
C {lab_wire.sym} 560 660 0 0 {name=p59 sig_type=std_logic lab=nRst}
C {lab_wire.sym} 1510 100 0 0 {name=p71 sig_type=std_logic lab=readLineONpd}
C {lab_wire.sym} 1810 100 0 0 {name=p72 sig_type=std_logic lab=readLineOFFpd}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 625 700 1 0 {name=McapRefr
W=8
L=8
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_hvt
spiceprefix=X
}
C {lab_wire.sym} 595 755 0 0 {name=p48 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1540 50 0 0 {name=p50 sig_type=std_logic lab=gnd}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 210 90 0 0 {name=MsfBias1
W=1
L=2
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_hvt
spiceprefix=X
}
