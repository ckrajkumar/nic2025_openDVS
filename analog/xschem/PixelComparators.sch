v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 990 -660 1020 -660 {lab=vdd}
N 890 -660 890 -600 {lab=vdiff}
N 890 -660 950 -660 {lab=vdiff}
N 900 -330 950 -330 {lab=OnBn}
N 990 -330 1020 -330 {lab=gnd}
N 1290 -300 1290 -260 {lab=gnd}
N 1290 -660 1320 -660 {lab=vdd}
N 1290 -720 1290 -690 {lab=vdd}
N 1190 -660 1190 -600 {lab=vdiff}
N 1190 -660 1250 -660 {lab=vdiff}
N 1200 -330 1250 -330 {lab=OffBn}
N 1290 -330 1320 -330 {lab=gnd}
N 890 -600 1190 -600 {lab=vdiff}
N 1290 -490 1290 -360 {lab=nOFF}
N 990 -500 990 -360 {lab=ON}
N 990 -730 990 -690 {lab=vdd}
N 730 -600 890 -600 {lab=vdiff}
N 990 -300 990 -260 {lab=gnd}
N 990 -500 1050 -500 {lab=ON}
N 990 -630 990 -500 {lab=ON}
N 1290 -490 1350 -490 {lab=nOFF}
N 1290 -630 1290 -490 {lab=nOFF}
C {sky130_fd_pr/nfet_01v8.sym} 970 -330 0 0 {name=MonBias
W=2
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
C {lab_wire.sym} 1020 -660 0 0 {name=p18 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 990 -720 0 0 {name=p19 sig_type=std_logic lab=vdd}
C {iopin.sym} 900 -330 2 0 {name=p21 lab=OnBn}
C {lab_wire.sym} 1020 -330 0 0 {name=p4 sig_type=std_logic lab=gnd}
C {sky130_fd_pr/nfet_01v8.sym} 1270 -330 0 0 {name=MoffBias
W=2
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
C {lab_wire.sym} 1290 -260 0 0 {name=p31 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1320 -660 0 0 {name=p32 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1290 -720 0 0 {name=p33 sig_type=std_logic lab=vdd}
C {iopin.sym} 1200 -330 2 0 {name=p34 lab=OffBn}
C {lab_wire.sym} 1320 -330 0 0 {name=p35 sig_type=std_logic lab=gnd}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 970 -660 0 0 {name=Mon
W=2
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
C {sky130_fd_pr/pfet_01v8_hvt.sym} 1270 -660 0 0 {name=Moff
W=2
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
C {iopin.sym} 990 -730 3 0 {name=p5 lab=vdd}
C {iopin.sym} 730 -600 2 0 {name=p6 lab=vdiff}
C {iopin.sym} 990 -260 1 0 {name=p7 lab=gnd
}
C {iopin.sym} 1050 -500 0 0 {name=p3 lab=ON}
C {iopin.sym} 1350 -490 0 0 {name=p8 lab=nOFF}
