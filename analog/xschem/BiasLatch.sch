v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -80 120 -50 120 {lab=D}
N -80 -20 -50 -20 {lab=D}
N 10 120 40 120 {lab=int}
N 10 -20 40 -20 {lab=int}
N 40 50 40 120 {lab=int}
N -20 -90 -20 -60 {lab=Latch}
N -20 160 -20 190 {lab=nLatch}
N -80 50 -80 120 {lab=D}
N -80 -20 -80 50 {lab=D}
N 100 130 130 130 {lab=int}
N 100 -20 130 -20 {lab=int}
N 190 130 220 130 {lab=Q}
N 190 -20 220 -20 {lab=Q}
N 220 60 220 130 {lab=Q}
N 70 50 100 50 {lab=int}
N 160 -90 160 -60 {lab=nLatch}
N 160 170 160 200 {lab=Latch}
N 100 50 100 130 {lab=int}
N 100 -20 100 50 {lab=int}
N 40 -20 40 50 {lab=int}
N 70 -170 70 50 {lab=int}
N 40 50 70 50 {lab=int}
N 70 -280 100 -280 {lab=int}
N 70 -170 100 -170 {lab=int}
N 70 -280 70 -170 {lab=int}
N 140 -220 140 -200 {lab=nQ}
N 140 -220 240 -220 {lab=nQ}
N 140 -250 140 -220 {lab=nQ}
N 240 -220 240 -170 {lab=nQ}
N 240 -280 240 -220 {lab=nQ}
N 240 -170 260 -170 {lab=nQ}
N 240 -280 260 -280 {lab=nQ}
N 300 -220 300 -200 {lab=Q}
N 300 -220 400 -220 {lab=Q}
N 300 -250 300 -220 {lab=Q}
N 400 -220 400 60 {lab=Q}
N 220 60 400 60 {lab=Q}
N 220 -20 220 60 {lab=Q}
N 400 60 420 60 {lab=Q}
N -20 -30 -20 30 {lab=VddA18}
N 160 -20 160 40 {lab=VddA18}
N 140 -360 140 -310 {lab=VddA18}
N 300 -360 300 -310 {lab=VddA18}
N 140 -280 190 -280 {lab=VddA18}
N 300 -280 350 -280 {lab=VddA18}
N -20 70 -20 120 {lab=GndA}
N 160 70 160 130 {lab=GndA}
N 140 -140 140 -90 {lab=GndA}
N 300 -140 300 -90 {lab=GndA}
N 140 -170 200 -170 {lab=GndA}
N 300 -170 360 -170 {lab=GndA}
N 400 80 420 80 {lab=nQ}
N -150 50 -80 50 {lab=D}
C {sky130_fd_pr/nfet_01v8.sym} -20 140 1 1 {name=Mnsw1
W=0.42
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
C {sky130_fd_pr/pfet_01v8.sym} -20 -40 3 1 {name=Mpsw1
W=0.42
L=0.15
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
C {ipin.sym} -150 50 0 0 {name=p1 lab=D}
C {ipin.sym} -170 -70 0 0 {name=p2 lab=Latch}
C {ipin.sym} -170 -50 0 0 {name=p3 lab=nLatch}
C {lab_wire.sym} -20 -90 3 0 {name=p4 sig_type=std_logic lab=Latch}
C {lab_wire.sym} -20 190 3 1 {name=p5 sig_type=std_logic lab=nLatch}
C {sky130_fd_pr/nfet_01v8.sym} 160 150 1 1 {name=Mnsw2
W=0.42
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
C {sky130_fd_pr/pfet_01v8.sym} 160 -40 3 1 {name=Mpsw2
W=0.42
L=0.15
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
C {lab_wire.sym} 160 -90 3 0 {name=p6 sig_type=std_logic lab=nLatch}
C {lab_wire.sym} 160 200 3 1 {name=p7 sig_type=std_logic lab=Latch}
C {lab_wire.sym} 80 50 0 0 {name=p8 sig_type=std_logic lab=int}
C {sky130_fd_pr/pfet_01v8.sym} 120 -280 0 0 {name=Mpinv1
W=0.42
L=0.15
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
C {sky130_fd_pr/pfet_01v8.sym} 280 -280 0 0 {name=Mpinv2
W=0.42
L=0.15
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
C {sky130_fd_pr/nfet_01v8.sym} 120 -170 0 0 {name=Mninv1
W=0.42
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
C {sky130_fd_pr/nfet_01v8.sym} 280 -170 0 0 {name=Mninv2
W=0.42
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
C {lab_wire.sym} 200 -220 0 0 {name=p9 sig_type=std_logic lab=nQ}
C {opin.sym} 420 60 0 0 {name=p10 lab=Q}
C {iopin.sym} -170 -90 2 0 {name=p11 lab=GndA}
C {iopin.sym} -170 -110 2 0 {name=p12 lab=VddA18}
C {lab_wire.sym} -20 30 1 0 {name=p13 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 160 40 1 0 {name=p14 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 140 -360 3 0 {name=p15 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 300 -360 3 0 {name=p16 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 190 -280 0 0 {name=p17 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 350 -280 0 0 {name=p18 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} -20 70 1 1 {name=p19 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 160 70 1 1 {name=p20 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 140 -90 1 0 {name=p21 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 300 -90 1 0 {name=p22 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 200 -170 2 1 {name=p23 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 360 -170 2 1 {name=p24 sig_type=std_logic lab=GndA}
C {opin.sym} 420 80 0 0 {name=p25 lab=nQ}
