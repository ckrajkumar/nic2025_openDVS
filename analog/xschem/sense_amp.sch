v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 350 -900 350 -870 {lab=vdd}
N 350 -840 380 -840 {lab=vdd}
N 350 -620 380 -620 {lab=vdd}
N 350 -590 350 -430 {lab=vout_sense}
N 350 -810 350 -760 {lab=pbchk}
N 240 -840 310 -840 {lab=pbias}
N 350 -760 350 -650 {lab=pbchk}
N 180 -620 310 -620 {lab=#net1}
N 0 -610 80 -610 {lab=pbchk}
N 0 -760 0 -610 {lab=pbchk}
N 0 -760 350 -760 {lab=pbchk}
N 130 -580 130 -550 {lab=vdd}
N 150 -580 150 -550 {lab=gnd}
N 70 -630 80 -630 {lab=vcascp}
N 110 -580 110 -520 {lab=bias_amp_cascp}
N 80 -340 90 -340 {lab=vcascn}
N 350 -300 350 -150 {lab=sense}
N 350 -330 380 -330 {lab=gnd}
N 170 -330 310 -330 {lab=#net2}
N 160 -290 160 -230 {lab=gnd}
N 140 -290 140 -260 {lab=vdd}
N 120 -290 120 -230 {lab=bias_amp_cascn}
N 0 -320 90 -320 {lab=sense}
N 0 -320 0 -150 {lab=sense}
N 0 -150 350 -150 {lab=sense}
N 350 -120 350 -100 {lab=sense}
N 350 -430 350 -360 {lab=vout_sense}
N 240 -20 240 0 {lab=gnd}
N 240 -50 270 -50 {lab=gnd}
N 240 -120 240 -80 {lab=sense}
N 240 -120 350 -120 {lab=sense}
N 180 -50 200 -50 {lab=nbias}
N 350 -150 350 -120 {lab=sense}
N 350 -580 350 -470 {lab=vsense_out}
N 350 -470 350 -350 {lab=vsense_out}
N 350 -470 470 -470 {lab=vsense_out}
C {sky130_fd_pr/pfet_01v8.sym} 330 -840 0 0 {name=Mpb1
W=3
L=0.5
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
C {sky130_fd_pr/pfet_01v8.sym} 330 -620 0 0 {name=Mpc1
W=3
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
C {amp_n.sym} 230 -620 0 0 {name=xamp_cascp1}
C {ipin.sym} 240 -840 0 0 {name=p20 lab=pbias}
C {iopin.sym} 350 -900 3 0 {name=p22 lab=vdd}
C {lab_wire.sym} 380 -840 0 0 {name=p23 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 380 -620 0 0 {name=p24 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 130 -550 3 0 {name=p25 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 150 -550 3 0 {name=p27 sig_type=std_logic lab=gnd}
C {ipin.sym} 70 -630 0 0 {name=p28 lab=vcascp}
C {amp_p.sym} 240 -330 0 0 {name=xamp_cascn1}
C {ipin.sym} 110 -520 3 0 {name=p29 lab=bias_amp_cascp}
C {ipin.sym} 80 -340 0 0 {name=p30 lab=vcascn}
C {sky130_fd_pr/nfet_01v8.sym} 330 -330 0 0 {name=Mnc1
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
C {lab_wire.sym} 380 -330 0 0 {name=p31 sig_type=std_logic lab=gnd}
C {iopin.sym} 160 -230 1 0 {name=p32 lab=gnd}
C {lab_wire.sym} 140 -260 3 0 {name=p33 sig_type=std_logic lab=vdd}
C {iopin.sym} 350 -100 1 0 {name=p34 lab=sense}
C {sky130_fd_pr/nfet_01v8.sym} 220 -50 0 0 {name=Mnb1
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
C {ipin.sym} 180 -50 0 0 {name=p35 lab=nbias}
C {lab_wire.sym} 270 -50 0 0 {name=p36 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 240 0 0 0 {name=p37 sig_type=std_logic lab=gnd}
C {ipin.sym} 120 -230 3 0 {name=p38 lab=bias_amp_cascn}
C {lab_wire.sym} 350 -780 0 0 {name=p39 sig_type=std_logic lab=pbchk}
C {opin.sym} 470 -470 0 0 {name=p40 lab=vsense_out}
