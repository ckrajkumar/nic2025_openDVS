v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 280 -410 280 -380 {lab=vdd}
N 280 -350 310 -350 {lab=vdd}
N 190 -350 240 -350 {lab=vbias_p1}
N 280 -320 280 -270 {lab=int_outn}
N 110 -410 110 -380 {lab=vdd}
N 80 -350 110 -350 {lab=vdd}
N 110 -320 110 -290 {lab=int_outp
}
N 150 -350 190 -350 {lab=vbias_p1}
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
N 110 -120 160 -120 {lab=vbias_n}
N 200 -120 230 -120 {lab=gnd}
N 720 -450 720 -420 {lab=vdd}
N 630 -390 680 -390 {lab=vbias_p}
N 810 -300 840 -300 {lab=vdd}
N 610 -300 640 -300 {lab=vdd}
N 640 -270 640 -240 {lab=voutp
}
N 810 -270 810 -240 {lab=voutn}
N 810 -240 900 -240 {lab=voutn}
N 570 -240 640 -240 {lab=voutp}
N 680 -300 700 -300 {lab=voutn}
N 680 -150 700 -150 {lab=voutn}
N 610 -150 640 -150 {lab=gnd}
N 750 -150 770 -150 {lab=voutp}
N 810 -150 840 -150 {lab=gnd}
N 640 -240 640 -180 {lab=voutp}
N 810 -240 810 -180 {lab=voutn}
N 700 -300 700 -150 {lab=voutn}
N 700 -220 810 -220 {lab=voutn}
N 750 -300 750 -150 {lab=voutp}
N 750 -300 770 -300 {lab=voutp}
N 640 -200 750 -200 {lab=voutp}
N 490 -150 610 -150 {lab=gnd}
N 490 -210 490 -180 {lab=voutp}
N 490 -210 640 -210 {lab=voutp}
N 420 -150 450 -150 {lab=int_outn}
N 490 -120 490 -70 {lab=gnd}
N 490 -70 640 -70 {lab=gnd}
N 640 -120 640 -70 {lab=gnd}
N 560 -150 560 -70 {lab=gnd}
N 810 -120 810 -70 {lab=gnd}
N 640 -70 810 -70 {lab=gnd}
N 840 -150 960 -150 {lab=gnd}
N 890 -150 890 -70 {lab=gnd}
N 810 -70 890 -70 {lab=gnd}
N 1000 -150 1030 -150 {lab=int_outp}
N 960 -120 960 -70 {lab=gnd}
N 890 -70 960 -70 {lab=gnd}
N 960 -200 960 -180 {lab=voutn}
N 810 -200 960 -200 {lab=voutn}
N 640 -350 640 -330 {lab=#net1}
N 640 -350 720 -350 {lab=#net1}
N 720 -360 720 -350 {lab=#net1}
N 720 -350 810 -350 {lab=#net1}
N 810 -350 810 -330 {lab=#net1}
N 720 -390 770 -390 {lab=vdd}
N 770 -450 770 -390 {lab=vdd}
N 720 -450 770 -450 {lab=vdd}
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
C {ipin.sym} 110 -120 0 0 {name=p33 lab=vbias_n
}
C {ipin.sym} 50 -240 0 0 {name=p34 lab=vp
}
C {ipin.sym} 340 -240 2 0 {name=p35 lab=vm
}
C {lab_wire.sym} 190 -180 0 0 {name=p36 sig_type=std_logic lab=vsource}
C {lab_wire.sym} 110 -290 0 0 {name=p37 sig_type=std_logic lab=int_outp}
C {lab_wire.sym} 280 -290 0 0 {name=p38 sig_type=std_logic lab=int_outn}
C {sky130_fd_pr/pfet_01v8.sym} 700 -390 0 0 {name=Mmirr4
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
C {lab_wire.sym} 720 -450 0 0 {name=p39 sig_type=std_logic lab=vdd}
C {ipin.sym} 630 -390 0 0 {name=p40 lab=vbias_p

}
C {sky130_fd_pr/pfet_01v8.sym} 790 -300 0 0 {name=Mmirr5
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
C {sky130_fd_pr/pfet_01v8.sym} 660 -300 0 1 {name=Mdio3
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
C {lab_wire.sym} 840 -300 0 0 {name=p41 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 610 -300 0 0 {name=p42 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/nfet_01v8.sym} 660 -150 0 1 {name=Minp4
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
C {lab_wire.sym} 730 -70 0 0 {name=p43 sig_type=std_logic lab=gnd}
C {sky130_fd_pr/nfet_01v8.sym} 790 -150 0 0 {name=Minm4
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
C {sky130_fd_pr/nfet_01v8.sym} 470 -150 0 0 {name=Minm5
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
C {lab_wire.sym} 430 -150 0 0 {name=p44 sig_type=std_logic lab=int_outn}
C {sky130_fd_pr/nfet_01v8.sym} 980 -150 0 1 {name=Minp5
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
C {opin.sym} 900 -240 0 0 {name=p45 lab=voutn}
C {opin.sym} 570 -240 2 0 {name=p46 lab=voutp}
C {lab_pin.sym} 1020 -150 2 0 {name=p47 sig_type=std_logic lab=int_outp
}
C {ipin.sym} 180 -350 1 0 {name=p1 lab=vbias_p1
}
