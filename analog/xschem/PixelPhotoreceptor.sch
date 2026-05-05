v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 0 -390 0 -360 {lab=VddA18}
N 0 -300 0 -270 {lab=vpd}
N -30 -330 0 -330 {lab=GndA}
N 190 -400 230 -400 {lab=PrBp}
N 0 -260 0 -230 {lab=vpd}
N -130 -260 -130 -240 {lab=vpd}
N -130 -260 0 -260 {lab=vpd}
N 270 -240 270 -200 {lab=GndA}
N 270 -330 270 -300 {lab=vpr}
N 270 -460 270 -430 {lab=VddA18}
N 0 -270 230 -270 {lab=vpd}
N 40 -330 270 -330 {lab=vpr}
N 270 -400 300 -400 {lab=VddA18}
N 270 -270 300 -270 {lab=GndA}
N 0 -270 0 -260 {lab=vpd}
N 270 -340 270 -330 {lab=vpr}
N 270 -340 310 -340 {lab=vpr}
N 270 -370 270 -340 {lab=vpr}
C {sky130_fd_pr/nfet_01v8.sym} 20 -330 0 1 {name=Mpd
W=0.5
L=0.3
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
C {lab_wire.sym} -30 -330 0 1 {name=p17 sig_type=std_logic lab=GndA}
C {iopin.sym} 190 -400 2 0 {name=p9 lab=PrBp}
C {iopin.sym} 0 -390 3 0 {name=p8 lab=VddA18}
C {iopin.sym} -130 -240 1 0 {name=p22 lab=vpd}
C {sky130_fd_pr/nfet_01v8.sym} 250 -270 0 0 {name=Mpr_amp
W=0.42
L=0.3
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
C {lab_wire.sym} 270 -200 0 0 {name=p25 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 270 -460 0 0 {name=p26 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 300 -400 0 0 {name=p27 sig_type=std_logic lab=VddA18}
C {lab_wire.sym} 300 -270 0 0 {name=p29 sig_type=std_logic lab=GndA}
C {iopin.sym} 90 -60 1 0 {name=p1 lab=GndA
}
C {iopin.sym} 310 -340 0 0 {name=p2 lab=vpr}
C {sky130_fd_pr/pfet_01v8.sym} 250 -400 0 0 {name=MprBias
W=0.5
L=0.15
nf=1
mult=1
ad="150e-3"
pd="1.6"
as="150e-3"
ps="1.6"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
