v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -40 -250 0 -250 {lab=BiasCB7}
N 0 -250 0 -230 {lab=BiasCB7}
N 0 -200 10 -200 {lab=GndA}
N 0 -350 0 -250 {lab=BiasCB7}
N 0 -170 0 -150 {lab=s67}
N 0 -120 10 -120 {lab=GndA}
N 0 -90 0 -70 {lab=s66}
N 0 -40 10 -40 {lab=GndA}
N -40 -250 -40 360 {lab=BiasCB7}
N 0 -10 0 10 {lab=s65}
N 0 40 10 40 {lab=GndA}
N 0 70 0 90 {lab=s64}
N 0 120 10 120 {lab=GndA}
N 0 150 0 170 {lab=s63}
N 0 200 10 200 {lab=GndA}
N 0 230 0 250 {lab=s62}
N 0 280 10 280 {lab=GndA}
N 0 310 0 330 {lab=s61}
N 0 360 10 360 {lab=GndA}
N 0 390 0 430 {lab=GndA}
C {lab_wire.sym} 0 -280 3 1 {name=p42 sig_type=std_logic lab=BiasCB}
C {sky130_fd_pr/nfet_01v8_lvt.sym} -20 -200 0 0 {name=MNDioCB7
W=0.5
L=20
nf=1 
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {lab_wire.sym} 10 -200 2 1 {name=p89 sig_type=std_logic lab=GndA}
C {sky130_fd_pr/nfet_01v8_lvt.sym} -20 -120 0 0 {name=M44
W=0.5
L=20
nf=1 
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {lab_wire.sym} 10 -120 2 1 {name=p94 sig_type=std_logic lab=GndA}
C {sky130_fd_pr/nfet_01v8_lvt.sym} -20 -40 0 0 {name=M45
W=0.5
L=20
nf=1 
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {lab_wire.sym} 10 -40 2 1 {name=p95 sig_type=std_logic lab=GndA}
C {sky130_fd_pr/nfet_01v8_lvt.sym} -20 40 0 0 {name=M46
W=0.5
L=20
nf=1 
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {lab_wire.sym} 10 40 2 1 {name=p96 sig_type=std_logic lab=GndA}
C {sky130_fd_pr/nfet_01v8_lvt.sym} -20 120 0 0 {name=M47
W=0.5
L=20
nf=1 
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {lab_wire.sym} 10 120 2 1 {name=p97 sig_type=std_logic lab=GndA}
C {sky130_fd_pr/nfet_01v8_lvt.sym} -20 200 0 0 {name=M48
W=0.5
L=20
nf=1 
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {lab_wire.sym} 10 200 2 1 {name=p98 sig_type=std_logic lab=GndA}
C {sky130_fd_pr/nfet_01v8_lvt.sym} -20 280 0 0 {name=M49
W=0.5
L=20
nf=1 
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {lab_wire.sym} 10 280 2 1 {name=p99 sig_type=std_logic lab=GndA}
C {sky130_fd_pr/nfet_01v8_lvt.sym} -20 360 0 0 {name=M50
W=0.5
L=20
nf=1 
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {lab_wire.sym} 10 360 2 1 {name=p100 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 0 320 3 1 {name=p113 sig_type=std_logic lab=s61}
C {lab_wire.sym} 0 240 3 1 {name=p114 sig_type=std_logic lab=s62}
C {lab_wire.sym} 0 160 3 1 {name=p115 sig_type=std_logic lab=s63}
C {lab_wire.sym} 0 80 3 1 {name=p116 sig_type=std_logic lab=s64}
C {lab_wire.sym} 0 0 3 1 {name=p117 sig_type=std_logic lab=s65}
C {lab_wire.sym} 0 -80 3 1 {name=p118 sig_type=std_logic lab=s66}
C {lab_wire.sym} 0 -160 3 1 {name=p119 sig_type=std_logic lab=s67}
C {iopin.sym} 0 -350 2 0 {name=p14 lab=BiasCB}
C {iopin.sym} 0 430 2 0 {name=p4 lab=GndA}
