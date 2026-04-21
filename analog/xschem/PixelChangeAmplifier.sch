v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 500 -480 500 -440 {lab=vdiff}
N 500 -260 500 -170 {lab=gnd}
N 420 -290 460 -290 {lab=DiffBn}
N 500 -620 530 -620 {lab=vdd}
N 500 -590 500 -560 {lab=vdiff}
N 500 -290 530 -290 {lab=gnd}
N 350 -440 390 -440 {lab=vd}
N 450 -440 500 -440 {lab=vdiff}
N 500 -440 500 -320 {lab=vdiff}
N 420 -470 420 -440 {lab=vdd}
N 420 -400 420 -360 {lab=nRst}
N 350 -620 460 -620 {lab=vd}
N 350 -560 430 -560 {lab=vd}
N 490 -560 500 -560 {lab=vdiff}
N 190 -620 290 -620 {lab=vsf}
N 500 -710 500 -650 {lab=vdd}
N 500 -480 560 -480 {lab=vdiff}
N 500 -560 500 -480 {lab=vdiff}
N 350 -560 350 -440 {lab=vd}
N 350 -620 350 -560 {lab=vd}
N 410 -360 420 -360 {lab=nRst}
C {sky130_fd_pr/cap_mim_m3_1.sym} 320 -620 3 0 {name=C1 model=cap_mim_m3_1 W=1 L=1 MF=40 spiceprefix=X}
C {sky130_fd_pr/cap_mim_m3_1.sym} 460 -560 3 0 {name=C2 model=cap_mim_m3_1 W=1 L=1 MF=2 spiceprefix=X}
C {sky130_fd_pr/nfet_01v8.sym} 480 -290 0 0 {name=MchAmpBias
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
C {iopin.sym} 420 -290 2 0 {name=p10 lab=DiffBn}
C {lab_wire.sym} 530 -620 0 0 {name=p13 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 530 -290 0 0 {name=p12 sig_type=std_logic lab=gnd}
C {lab_pin.sym} 430 -620 2 0 {name=p23 sig_type=std_logic lab=vd}
C {lab_wire.sym} 420 -470 3 0 {name=p46 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 420 -420 3 0 {name=Mrst
W=1
L=0.3
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
C {sky130_fd_pr/pfet_01v8_hvt.sym} 480 -620 0 0 {name=MchAmp
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
C {iopin.sym} 190 -620 2 0 {name=p9 lab=vsf}
C {iopin.sym} 500 -710 3 0 {name=p15 lab=vdd}
C {iopin.sym} 500 -170 1 0 {name=p16 lab=gnd
}
C {iopin.sym} 560 -480 0 0 {name=p1 lab=vdiff}
C {iopin.sym} 410 -360 2 0 {name=p2 lab=nRst}
