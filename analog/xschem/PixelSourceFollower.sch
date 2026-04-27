v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 150 -410 150 -380 {lab=vdd}
N 150 -350 180 -350 {lab=vdd}
N 150 -120 150 -70 {lab=gnd}
N 150 -150 180 -150 {lab=vdd}
N 150 -260 250 -260 {lab=vsf}
N 60 -350 110 -350 {lab=PrSFBp}
N 90 -150 110 -150 {lab=vpr}
N 150 -260 150 -180 {lab=vsf}
N 150 -320 150 -260 {lab=vsf}
C {iopin.sym} 150 -70 1 0 {name=p1 lab=gnd
}
C {iopin.sym} 60 -350 2 0 {name=p7 lab=PrSFBp}
C {lab_wire.sym} 150 -80 0 0 {name=p11 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 180 -350 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 180 -150 0 0 {name=p5 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/pfet_01v8.sym} 130 -350 0 0 {name=MsfBias
W=0.42
L=1.6
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
C {iopin.sym} 90 -150 2 0 {name=p2 lab=vpr}
C {iopin.sym} 250 -260 0 0 {name=p3 lab=vsf}
C {iopin.sym} 150 -410 3 0 {name=p6 lab=vdd}
C {sky130_fd_pr/pfet_01v8.sym} 130 -150 0 0 {name=Msf
W=0.5
L=0.25
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
