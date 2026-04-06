v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -60 -170 -20 -170 {lab=BiasCB2}
N -20 -170 -20 -150 {lab=BiasCB2}
N -60 -170 -60 440 {lab=BiasCB2}
N -20 -120 -10 -120 {lab=GndA}
N -20 -270 -20 -170 {lab=BiasCB2}
N -20 -90 -20 -70 {lab=s17}
N -20 -10 -20 10 {lab=s16}
N -20 70 -20 90 {lab=s15}
N -20 150 -20 170 {lab=s14}
N -20 230 -20 250 {lab=s13}
N -20 310 -20 330 {lab=s12}
N -20 390 -20 410 {lab=s11}
N -20 -40 -10 -40 {lab=GndA}
N -20 40 -10 40 {lab=GndA}
N -20 120 -10 120 {lab=GndA}
N -20 200 -10 200 {lab=GndA}
N -20 280 -10 280 {lab=GndA}
N -20 360 -10 360 {lab=GndA}
N -20 470 -20 510 {lab=GndA}
N -20 440 -10 440 {lab=GndA}
C {sky130_fd_pr/nfet_01v8_lvt.sym} -40 -120 0 0 {name=MNDioCB2
W=1.98
L=5
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
C {lab_wire.sym} -10 -120 2 1 {name=p26 sig_type=std_logic lab=GndA}
C {sky130_fd_pr/nfet_01v8_lvt.sym} -40 -40 0 0 {name=M10
W=1.98
L=5
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
C {sky130_fd_pr/nfet_01v8_lvt.sym} -40 40 0 0 {name=M11
W=1.98
L=5
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
C {sky130_fd_pr/nfet_01v8_lvt.sym} -40 120 0 0 {name=M12
W=1.98
L=5
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
C {sky130_fd_pr/nfet_01v8_lvt.sym} -40 200 0 0 {name=M13
W=1.98
L=5
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
C {sky130_fd_pr/nfet_01v8_lvt.sym} -40 280 0 0 {name=M14
W=1.98
L=5
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
C {sky130_fd_pr/nfet_01v8_lvt.sym} -40 360 0 0 {name=M15
W=1.98
L=5
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
C {sky130_fd_pr/nfet_01v8_lvt.sym} -40 440 0 0 {name=M16
W=1.98
L=5
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
C {lab_wire.sym} -10 -40 2 1 {name=p28 sig_type=std_logic lab=GndA}
C {lab_wire.sym} -10 40 2 1 {name=p31 sig_type=std_logic lab=GndA}
C {lab_wire.sym} -10 120 2 1 {name=p34 sig_type=std_logic lab=GndA}
C {lab_wire.sym} -10 200 2 1 {name=p37 sig_type=std_logic lab=GndA}
C {lab_wire.sym} -10 280 2 1 {name=p40 sig_type=std_logic lab=GndA}
C {lab_wire.sym} -10 360 2 1 {name=p43 sig_type=std_logic lab=GndA}
C {lab_wire.sym} -10 440 2 1 {name=p46 sig_type=std_logic lab=GndA}
C {lab_wire.sym} -20 400 3 1 {name=p25 sig_type=std_logic lab=s11}
C {lab_wire.sym} -20 320 3 1 {name=p32 sig_type=std_logic lab=s12}
C {lab_wire.sym} -20 240 3 1 {name=p45 sig_type=std_logic lab=s13}
C {lab_wire.sym} -20 160 3 1 {name=p56 sig_type=std_logic lab=s14}
C {lab_wire.sym} -20 80 3 1 {name=p57 sig_type=std_logic lab=s15}
C {lab_wire.sym} -20 0 3 1 {name=p58 sig_type=std_logic lab=s16}
C {lab_wire.sym} -20 -80 3 1 {name=p59 sig_type=std_logic lab=s17}
C {iopin.sym} -20 510 2 0 {name=p4 lab=GndA}
C {iopin.sym} -20 -270 2 0 {name=p9 lab=BiasCB}
