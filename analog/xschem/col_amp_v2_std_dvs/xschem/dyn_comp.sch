v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 280 -410 280 -380 {lab=vdd}
N 280 -350 310 -350 {lab=vdd}
N 190 -350 240 -350 {lab=DETECT}
N 280 -320 280 -270 {lab=int_outn}
N 110 -410 110 -380 {lab=vdd}
N 80 -350 110 -350 {lab=vdd}
N 110 -320 110 -290 {lab=int_outp
}
N 150 -350 190 -350 {lab=DETECT}
N 50 -240 70 -240 {lab=vp}
N 110 -240 140 -240 {lab=gnd}
N 320 -240 340 -240 {lab=vm}
N 250 -240 280 -240 {lab=gnd}
N 110 -290 110 -270 {lab=int_outp}
N 110 -210 110 -180 {lab=vsource}
N 280 -210 280 -180 {lab=vsource}
N 110 -180 280 -180 {lab=vsource}
N 200 -180 200 -150 {lab=vsource}
N 200 -90 200 -60 {lab=gnd}
N 110 -120 160 -120 {lab=DETECT}
N 200 -120 230 -120 {lab=gnd}
N 180 -880 180 -850 {lab=vdd}
N 90 -820 140 -820 {lab=nDETECT}
N 270 -730 300 -730 {lab=vdd}
N 70 -730 100 -730 {lab=vdd}
N 100 -700 100 -670 {lab=#net1
}
N 270 -700 270 -670 {lab=#net2}
N 140 -730 160 -730 {lab=#net2}
N 140 -580 160 -580 {lab=#net2}
N 70 -580 100 -580 {lab=gnd}
N 210 -580 230 -580 {lab=#net1}
N 270 -580 300 -580 {lab=gnd}
N 100 -670 100 -610 {lab=#net1}
N 270 -670 270 -610 {lab=#net2}
N 160 -730 160 -580 {lab=#net2}
N 160 -650 270 -650 {lab=#net2}
N 210 -730 210 -580 {lab=#net1}
N 210 -730 230 -730 {lab=#net1}
N 100 -630 210 -630 {lab=#net1}
N -50 -580 70 -580 {lab=gnd}
N -50 -640 -50 -610 {lab=#net1}
N -50 -640 100 -640 {lab=#net1}
N -120 -580 -90 -580 {lab=int_outp}
N -50 -550 -50 -500 {lab=gnd}
N -50 -500 100 -500 {lab=gnd}
N 100 -550 100 -500 {lab=gnd}
N 20 -580 20 -500 {lab=gnd}
N 270 -550 270 -500 {lab=gnd}
N 100 -500 270 -500 {lab=gnd}
N 300 -580 420 -580 {lab=gnd}
N 350 -580 350 -500 {lab=gnd}
N 270 -500 350 -500 {lab=gnd}
N 460 -580 490 -580 {lab=int_outn}
N 420 -550 420 -500 {lab=gnd}
N 350 -500 420 -500 {lab=gnd}
N 420 -630 420 -610 {lab=#net2}
N 270 -630 420 -630 {lab=#net2}
N 100 -780 100 -760 {lab=#net3}
N 100 -780 180 -780 {lab=#net3}
N 180 -790 180 -780 {lab=#net3}
N 180 -780 270 -780 {lab=#net3}
N 270 -780 270 -760 {lab=#net3}
N 180 -820 230 -820 {lab=vdd}
N 230 -880 230 -820 {lab=vdd}
N 180 -880 230 -880 {lab=vdd}
N -80 -840 -80 -750 {lab=voutn}
N -40 -870 -40 -720 {lab=#net1}
N -140 -720 -80 -720 {lab=gnd}
N -140 -690 -80 -690 {lab=gnd}
N -140 -900 -80 -900 {lab=vdd}
N -140 -870 -80 -870 {lab=vdd}
N -40 -720 -40 -680 {lab=#net1}
N -40 -680 100 -680 {lab=#net1}
N 270 -680 400 -680 {lab=#net2}
N 400 -870 400 -680 {lab=#net2}
N 440 -840 440 -750 {lab=voutp}
N 440 -720 500 -720 {lab=gnd}
N 440 -690 500 -690 {lab=gnd}
N 440 -900 500 -900 {lab=vdd}
N 440 -870 500 -870 {lab=vdd}
C {sky130_fd_pr/pfet_01v8.sym} 260 -350 0 0 {name=Mmirr3
W=1
L=0.5
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 130 -350 0 1 {name=Mdio2
W=1
L=0.5
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 90 -240 0 0 {name=Minm3
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
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 300 -240 0 1 {name=Minp3
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
model=nfet_01v8
spiceprefix=X
}
C {iopin.sym} 110 -410 3 0 {name=p25 lab=vdd}
C {lab_wire.sym} 310 -350 0 0 {name=p26 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 280 -410 0 0 {name=p27 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 80 -350 0 0 {name=p28 sig_type=std_logic lab=vdd}
C {iopin.sym} 200 -60 1 0 {name=p29 lab=gnd}
C {lab_wire.sym} 140 -240 0 0 {name=p30 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 250 -240 0 0 {name=p31 sig_type=std_logic lab=gnd}
C {sky130_fd_pr/nfet_01v8.sym} 180 -120 0 0 {name=Mbias1
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
model=nfet_01v8
spiceprefix=X
}
C {lab_wire.sym} 230 -120 0 0 {name=p32 sig_type=std_logic lab=gnd}
C {ipin.sym} 50 -240 0 0 {name=p34 lab=vp
}
C {ipin.sym} 340 -240 2 0 {name=p35 lab=vm
}
C {lab_wire.sym} 190 -180 0 0 {name=p36 sig_type=std_logic lab=vsource}
C {sky130_fd_pr/pfet_01v8.sym} 160 -820 0 0 {name=Mmirr4
W=1
L=0.5
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {lab_wire.sym} 180 -880 0 0 {name=p39 sig_type=std_logic lab=vdd}
C {ipin.sym} 90 -820 0 0 {name=p40 lab=nDETECT

}
C {sky130_fd_pr/pfet_01v8.sym} 250 -730 0 0 {name=Mmirr5
W=1
L=0.5
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 120 -730 0 1 {name=Mdio3
W=1
L=0.5
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {lab_wire.sym} 300 -730 0 0 {name=p41 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 70 -730 0 0 {name=p42 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/nfet_01v8.sym} 120 -580 0 1 {name=Minp4
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
model=nfet_01v8
spiceprefix=X
}
C {lab_wire.sym} 190 -500 0 0 {name=p43 sig_type=std_logic lab=gnd}
C {sky130_fd_pr/nfet_01v8.sym} 250 -580 0 0 {name=Minm4
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
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} -70 -580 0 0 {name=Minm5
W=1
L=0.15
nf=1 
mult=4
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 440 -580 0 1 {name=Minp5
W=1
L=0.15
nf=1 
mult=4
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {opin.sym} -80 -800 0 1 {name=p45 lab=voutn}
C {opin.sym} 440 -800 2 1 {name=p46 lab=voutp}
C {ipin.sym} 180 -350 1 0 {name=p1 lab=DETECT
}
C {lab_wire.sym} 110 -120 0 0 {name=p2 sig_type=std_logic lab=DETECT}
C {lab_pin.sym} 480 -580 2 0 {name=p47 sig_type=std_logic lab=int_outn
}
C {lab_pin.sym} -110 -580 2 1 {name=p3 sig_type=std_logic lab=int_outp
}
C {lab_pin.sym} 110 -300 2 1 {name=p4 sig_type=std_logic lab=int_outp
}
C {lab_pin.sym} 280 -300 2 0 {name=p5 sig_type=std_logic lab=int_outn
}
C {sky130_fd_pr/pfet_01v8.sym} 420 -870 0 0 {name=Mmirr1
W=2
L=1
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 420 -720 0 0 {name=Minm1
W=1
L=1
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
C {sky130_fd_pr/pfet_01v8.sym} -60 -870 0 1 {name=Mmirr2
W=2
L=1
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} -60 -720 0 1 {name=Minm2
W=1
L=1
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
C {lab_wire.sym} -120 -900 0 0 {name=p6 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -120 -870 0 0 {name=p7 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -110 -690 0 0 {name=p8 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -110 -720 0 0 {name=p9 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 480 -900 0 1 {name=p10 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 480 -870 0 1 {name=p11 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 470 -690 0 1 {name=p12 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 470 -720 0 1 {name=p13 sig_type=std_logic lab=gnd}
