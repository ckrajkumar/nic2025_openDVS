v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -0 60 -0 140 {lab=col_read_on}
N 280 60 280 140 {lab=col_read_off}
N 0 0 280 0 {lab=COL_LINE}
N 140 -60 140 0 {lab=COL_LINE}
N -0 30 60 30 {lab=#net1}
N 0 170 60 170 {lab=#net2}
N 220 170 280 170 {lab=GND}
N 220 30 280 30 {lab=#net3}
N -100 30 -40 30 {lab=READON}
N -100 170 -40 170 {lab=ON}
N 320 170 380 170 {lab=nOFF}
N 320 30 380 30 {lab=READOFF}
N -0 200 0 240 {lab=#net4}
N 280 200 280 240 {lab=GND}
C {sky130_fd_pr/nfet_01v8.sym} -20 30 0 0 {name=M1
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
C {sky130_fd_pr/nfet_01v8.sym} 300 30 0 1 {name=M2
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
C {sky130_fd_pr/nfet_01v8.sym} -20 170 0 0 {name=M3
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
C {sky130_fd_pr/nfet_01v8.sym} 300 170 0 1 {name=M4
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
C {iopin.sym} 380 30 0 0 {name=p1 lab=READOFF}
C {iopin.sym} 380 170 0 0 {name=p2 lab=nOFF}
C {iopin.sym} -100 170 0 1 {name=p3 lab=ON}
C {iopin.sym} -100 30 0 1 {name=p4 lab=READON}
C {iopin.sym} 140 -60 0 1 {name=p5 lab=COL_LINE}
C {lab_wire.sym} 220 170 0 0 {name=p11 sig_type=std_logic lab=GND
}
C {iopin.sym} 280 240 0 1 {name=p7 lab=GND}
C {lab_wire.sym} 0 100 0 0 {name=p12 sig_type=std_logic lab=col_read_on}
C {lab_wire.sym} 280 100 0 0 {name=p13 sig_type=std_logic lab=col_read_off}
C {lab_wire.sym} 220 30 0 0 {name=p6 sig_type=std_logic lab=GND
}
C {lab_wire.sym} 60 30 0 1 {name=p8 sig_type=std_logic lab=GND
}
C {lab_wire.sym} 60 170 0 1 {name=p9 sig_type=std_logic lab=GND
}
C {lab_wire.sym} 0 240 0 1 {name=p10 sig_type=std_logic lab=GND
}
