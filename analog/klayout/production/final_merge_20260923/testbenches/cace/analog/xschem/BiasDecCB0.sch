v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 310 -30 310 0 {lab=abar}
N 390 0 390 50 {lab=VddA18}
N 390 80 440 80 {lab=VddA18}
N 310 -130 310 -70 {lab=GndA}
N 390 110 390 150 {lab=orline}
N 390 150 460 150 {lab=orline}
N 340 -70 430 -70 {lab=andlower}
N 320 80 350 80 {lab=abar}
N 310 -0 310 80 {lab=abar}
N 310 80 320 80 {lab=abar}
N 190 -70 280 -70 {lab=andupper}
N 230 -140 230 90 {lab=abar}
N 230 80 310 80 {lab=abar}
N 230 90 230 110 {lab=abar}
N 190 100 190 110 {lab=a}
C {sky130_fd_pr/pfet_01v8.sym} 370 80 0 0 {name=Mp
W=0.45
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
C {sky130_fd_pr/nfet_01v8.sym} 310 -50 1 1 {name=Mn
W=0.45
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
C {iopin.sym} 100 -150 2 0 {name=p11 lab=GndA}
C {iopin.sym} 100 -170 2 0 {name=p12 lab=VddA18}
C {lab_wire.sym} 390 0 3 0 {name=p15 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 440 80 0 0 {name=p17 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 310 -130 3 0 {name=p23 sig_type=std_logic lab=GndA}
C {iopin.sym} 460 150 0 0 {name=p2 lab=orline}
C {iopin.sym} 430 -70 0 0 {name=p3 lab=andlower}
C {iopin.sym} 190 -70 2 0 {name=p4 lab=andupper}
C {iopin.sym} 230 110 1 0 {name=p5 lab=abar}
C {iopin.sym} 190 110 1 0 {name=p1 lab=a}
C {noconn.sym} 190 100 1 0 {name=l1}
