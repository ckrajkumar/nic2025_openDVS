v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -130 50 -130 90 {lab=vout_sense}
N -130 -380 -130 -350 {lab=vdd}
N -130 -320 -100 -320 {lab=vdd}
N -220 -320 -170 -320 {lab=pbias}
N -130 -100 -100 -100 {lab=vdd}
N -130 -70 -130 -30 {lab=vout_sense}
N -130 -290 -130 -240 {lab=pbchk}
N -240 -320 -220 -320 {lab=pbias}
N -190 -100 -170 -100 {lab=vcascp}
N -130 -240 -130 -130 {lab=pbchk}
N -130 -30 -130 40 {lab=vout_sense}
N -130 40 -130 50 {lab=vout_sense}
N -400 180 -390 180 {lab=vcascn}
N -130 220 -130 350 {lab=sense}
N -190 190 -170 190 {lab=amp_p_vg}
N -130 190 -100 190 {lab=gnd}
N -130 120 -130 160 {lab=vout_sense}
N -320 230 -320 280 {lab=gnd}
N -320 280 -320 290 {lab=gnd}
N -340 230 -340 260 {lab=vdd}
N -360 230 -360 260 {lab=bias_amp_cascn}
N -360 260 -360 290 {lab=bias_amp_cascn}
N -480 200 -390 200 {lab=sense}
N -480 200 -480 370 {lab=sense}
N -480 370 -130 370 {lab=sense}
N -130 350 -130 620 {lab=sense}
N -130 90 -130 120 {lab=vout_sense}
N -130 90 0 90 {lab=vout_sense}
N 0 90 70 90 {lab=vout_sense}
N 210 120 240 120 {lab=gnd}
N -290 190 -190 190 {lab=amp_p_vg}
N 70 90 240 90 {lab=vout_sense}
N 280 120 340 120 {lab=pix_rst}
N 240 150 240 290 {lab=feedback}
C {iopin.sym} -130 -380 3 0 {name=p2 lab=vdd}
C {lab_wire.sym} -100 -320 0 0 {name=p3 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -100 -100 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -100 190 0 0 {name=p11 sig_type=std_logic lab=gnd}
C {iopin.sym} -320 290 1 0 {name=p12 lab=gnd}
C {lab_wire.sym} -340 260 3 0 {name=p13 sig_type=std_logic lab=vdd}
C {iopin.sym} -130 620 1 0 {name=p15 lab=sense}
C {lab_wire.sym} -190 190 0 0 {name=p33 sig_type=std_logic lab=amp_p_vg}
C {iopin.sym} 70 90 1 0 {name=p19 lab=vout_sense}
C {iopin.sym} 240 290 1 0 {name=p20 lab=feedback}
C {lab_wire.sym} 210 120 0 0 {name=p14 sig_type=std_logic lab=gnd}
C {iopin.sym} -130 -190 2 1 {name=p25 lab=pbchk}
C {iopin.sym} 340 120 0 0 {name=p8 lab=pix_rst}
C {iopin.sym} -400 180 2 0 {name=p23 lab=vcascn}
C {iopin.sym} -190 -100 2 0 {name=p7 lab=vcascp}
C {iopin.sym} -240 -320 2 0 {name=p1 lab=pbias}
C {sky130_fd_pr/pfet_01v8.sym} -150 -320 0 0 {name=Mpb
W=5
L=1
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
C {sky130_fd_pr/nfet_01v8.sym} -150 190 0 0 {name=Mnc
W=3
L=1
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
C {sky130_fd_pr/nfet_01v8.sym} 260 120 0 1 {name=Mfb
W=0.5
L=0.5
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
C {sky130_fd_pr/pfet_01v8.sym} -150 -100 0 0 {name=Mpc
W=5
L=1
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
C {iopin.sym} -360 290 1 0 {name=p10 lab=bias_amp_cascn}
C {/home/user/projects/open_dvs/analog/amp_p_5T.sym} -240 190 0 0 {name=x1}
