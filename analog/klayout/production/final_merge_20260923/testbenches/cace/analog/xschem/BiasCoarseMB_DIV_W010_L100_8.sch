v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -40 -340 0 -340 {lab=BiasCB3}
N 0 -340 0 -320 {lab=BiasCB3}
N 0 -290 10 -290 {lab=GndA}
N 0 -440 0 -340 {lab=BiasCB3}
N 0 -260 0 -240 {lab=s27}
N 0 -210 10 -210 {lab=GndA}
N 0 -180 0 -160 {lab=s26}
N 0 -130 10 -130 {lab=GndA}
N 0 -100 0 -80 {lab=s25}
N 0 -50 10 -50 {lab=GndA}
N 0 -20 0 0 {lab=s24}
N 0 30 10 30 {lab=GndA}
N 0 60 0 80 {lab=s23}
N 0 110 10 110 {lab=GndA}
N 0 140 0 160 {lab=s22}
N 0 190 10 190 {lab=GndA}
N 0 220 0 240 {lab=s21}
N 0 270 10 270 {lab=GndA}
N 0 300 0 340 {lab=GndA}
N -40 -340 -40 270 {lab=BiasCB3}
C {sky130_fd_pr/nfet_01v8_lvt.sym} -20 -290 0 0 {name=MNDioCB3
W=1	
L=10
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
C {lab_wire.sym} 10 -290 2 1 {name=p29 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 0 -370 3 1 {name=p30 sig_type=std_logic lab=BiasCB}
C {sky130_fd_pr/nfet_01v8_lvt.sym} -20 -210 0 0 {name=M17
W=1	
L=10
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
C {lab_wire.sym} 10 -210 2 1 {name=p48 sig_type=std_logic lab=GndA}
C {sky130_fd_pr/nfet_01v8_lvt.sym} -20 -130 0 0 {name=M18
W=1	
L=10
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
C {lab_wire.sym} 10 -130 2 1 {name=p49 sig_type=std_logic lab=GndA}
C {sky130_fd_pr/nfet_01v8_lvt.sym} -20 -50 0 0 {name=M19
W=1	
L=10
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
C {lab_wire.sym} 10 -50 2 1 {name=p50 sig_type=std_logic lab=GndA}
C {sky130_fd_pr/nfet_01v8_lvt.sym} -20 30 0 0 {name=M20
W=1	
L=10
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
C {lab_wire.sym} 10 30 2 1 {name=p51 sig_type=std_logic lab=GndA}
C {sky130_fd_pr/nfet_01v8_lvt.sym} -20 110 0 0 {name=M21
W=1	
L=10
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
C {lab_wire.sym} 10 110 2 1 {name=p52 sig_type=std_logic lab=GndA}
C {sky130_fd_pr/nfet_01v8_lvt.sym} -20 190 0 0 {name=M22
W=1	
L=10
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
C {lab_wire.sym} 10 190 2 1 {name=p53 sig_type=std_logic lab=GndA}
C {sky130_fd_pr/nfet_01v8_lvt.sym} -20 270 0 0 {name=M23
W=1	
L=10
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
C {lab_wire.sym} 10 270 2 1 {name=p54 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 0 230 3 1 {name=p66 sig_type=std_logic lab=s21}
C {lab_wire.sym} 0 150 3 1 {name=p67 sig_type=std_logic lab=s22}
C {lab_wire.sym} 0 70 3 1 {name=p74 sig_type=std_logic lab=s23}
C {lab_wire.sym} 0 -10 3 1 {name=p75 sig_type=std_logic lab=s24}
C {lab_wire.sym} 0 -90 3 1 {name=p78 sig_type=std_logic lab=s25}
C {lab_wire.sym} 0 -170 3 1 {name=p79 sig_type=std_logic lab=s26}
C {lab_wire.sym} 0 -250 3 1 {name=p80 sig_type=std_logic lab=s27}
C {iopin.sym} 0 -440 2 0 {name=p10 lab=BiasCB}
C {iopin.sym} 0 340 2 0 {name=p4 lab=GndA}
