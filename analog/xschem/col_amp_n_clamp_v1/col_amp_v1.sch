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
N 470 120 500 120 {lab=gnd}
N -290 190 -190 190 {lab=amp_p_vg}
N 70 90 240 90 {lab=vout_sense}
N 540 120 600 120 {lab=pix_rst}
N 500 150 500 290 {lab=feedback}
N 160 -380 160 -350 {lab=vdd}
N 160 -320 190 -320 {lab=vdd}
N 70 -320 120 -320 {lab=pbias}
N 160 -100 190 -100 {lab=vdd}
N 160 -290 160 -240 {lab=pbchk}
N 50 -320 70 -320 {lab=pbias}
N 100 -100 120 -100 {lab=vcascp}
N 160 -240 160 -130 {lab=pbchk}
N 160 -70 160 90 {lab=vout_sense}
N 160 -380 190 -380 {lab=vdd}
N 440 -380 440 -350 {lab=vdd}
N 440 -320 470 -320 {lab=vdd}
N 350 -320 400 -320 {lab=pbias}
N 440 -100 470 -100 {lab=vdd}
N 440 -290 440 -240 {lab=pbchk}
N 330 -320 350 -320 {lab=pbias}
N 380 -100 400 -100 {lab=vcascp}
N 440 -240 440 -130 {lab=pbchk}
N 440 -70 440 90 {lab=vout_sense}
N 440 -380 470 -380 {lab=vdd}
N 240 90 440 90 {lab=vout_sense}
N 700 -380 700 -350 {lab=vdd}
N 700 -320 730 -320 {lab=vdd}
N 610 -320 660 -320 {lab=pbias}
N 700 -100 730 -100 {lab=vdd}
N 700 -290 700 -240 {lab=pbchk}
N 590 -320 610 -320 {lab=pbias}
N 640 -100 660 -100 {lab=vcascp}
N 700 -240 700 -130 {lab=pbchk}
N 700 -70 700 90 {lab=vout_sense}
N 700 -380 730 -380 {lab=vdd}
N 440 90 700 90 {lab=vout_sense}
N 40 190 70 190 {lab=gnd}
N 200 190 230 190 {lab=gnd}
N 380 190 410 190 {lab=gnd}
N 380 90 380 160 {lab=vout_sense}
N 200 90 200 160 {lab=vout_sense}
N 40 90 40 160 {lab=vout_sense}
N -40 190 -0 190 {lab=amp_p_vg}
N 120 190 160 190 {lab=amp_p_vg}
N 300 190 340 190 {lab=amp_p_vg}
N -130 220 380 220 {lab=sense}
C {iopin.sym} -130 -380 3 0 {name=p2 lab=vdd}
C {lab_wire.sym} -100 -320 0 0 {name=p3 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -100 -100 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -100 190 0 0 {name=p11 sig_type=std_logic lab=gnd}
C {iopin.sym} -320 290 1 0 {name=p12 lab=gnd}
C {lab_wire.sym} -340 260 3 0 {name=p13 sig_type=std_logic lab=vdd}
C {iopin.sym} -130 620 1 0 {name=p15 lab=sense}
C {lab_wire.sym} -190 190 0 0 {name=p33 sig_type=std_logic lab=amp_p_vg}
C {iopin.sym} 700 90 1 0 {name=p19 lab=vout_sense}
C {iopin.sym} 500 290 1 0 {name=p20 lab=feedback}
C {lab_wire.sym} 470 120 0 0 {name=p14 sig_type=std_logic lab=gnd}
C {iopin.sym} -130 -190 2 1 {name=p25 lab=pbchk}
C {iopin.sym} 600 120 0 0 {name=p8 lab=pix_rst}
C {iopin.sym} -400 180 2 0 {name=p23 lab=vcascn}
C {iopin.sym} -190 -100 2 0 {name=p7 lab=vcascp}
C {iopin.sym} -240 -320 2 0 {name=p1 lab=pbias}
C {sky130_fd_pr/pfet_01v8.sym} -150 -320 0 0 {name=Mpb
W=1.25
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
W=0.75
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
C {sky130_fd_pr/nfet_01v8.sym} 520 120 0 1 {name=Mfb
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
W=1.25
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
C {lab_wire.sym} 190 -320 0 0 {name=p6 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 190 -100 0 0 {name=p9 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/pfet_01v8.sym} 140 -320 0 0 {name=Mpb1
W=1.25
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
C {sky130_fd_pr/pfet_01v8.sym} 140 -100 0 0 {name=Mpc1
W=1.25
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
C {lab_wire.sym} 50 -320 0 0 {name=p17 sig_type=std_logic lab=pbias}
C {lab_wire.sym} 100 -100 0 0 {name=p18 sig_type=std_logic lab=vcascp}
C {lab_wire.sym} 160 -200 0 0 {name=p16 sig_type=std_logic lab=pbchk}
C {lab_wire.sym} 190 -380 0 0 {name=p5 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 470 -320 0 0 {name=p21 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 470 -100 0 0 {name=p22 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/pfet_01v8.sym} 420 -320 0 0 {name=Mpb2
W=1.25
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
C {sky130_fd_pr/pfet_01v8.sym} 420 -100 0 0 {name=Mpc2
W=1.25
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
C {lab_wire.sym} 330 -320 0 0 {name=p24 sig_type=std_logic lab=pbias}
C {lab_wire.sym} 380 -100 0 0 {name=p26 sig_type=std_logic lab=vcascp}
C {lab_wire.sym} 440 -200 0 0 {name=p27 sig_type=std_logic lab=pbchk}
C {lab_wire.sym} 470 -380 0 0 {name=p28 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 730 -320 0 0 {name=p29 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 730 -100 0 0 {name=p30 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/pfet_01v8.sym} 680 -320 0 0 {name=Mpb3
W=1.25
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
C {sky130_fd_pr/pfet_01v8.sym} 680 -100 0 0 {name=Mpc3
W=1.25
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
C {lab_wire.sym} 590 -320 0 0 {name=p31 sig_type=std_logic lab=pbias}
C {lab_wire.sym} 640 -100 0 0 {name=p32 sig_type=std_logic lab=vcascp}
C {lab_wire.sym} 700 -200 0 0 {name=p34 sig_type=std_logic lab=pbchk}
C {lab_wire.sym} 730 -380 0 0 {name=p35 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 70 190 0 0 {name=p36 sig_type=std_logic lab=gnd}
C {sky130_fd_pr/nfet_01v8.sym} 20 190 0 0 {name=Mnc1
W=0.75
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
C {lab_wire.sym} 230 190 0 0 {name=p37 sig_type=std_logic lab=gnd}
C {sky130_fd_pr/nfet_01v8.sym} 180 190 0 0 {name=Mnc2
W=0.75
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
C {lab_wire.sym} 410 190 0 0 {name=p38 sig_type=std_logic lab=gnd}
C {sky130_fd_pr/nfet_01v8.sym} 360 190 0 0 {name=Mnc3
W=0.75
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
C {lab_wire.sym} 0 190 0 0 {name=p39 sig_type=std_logic lab=amp_p_vg}
C {lab_wire.sym} 160 190 0 0 {name=p40 sig_type=std_logic lab=amp_p_vg}
C {lab_wire.sym} 340 190 0 0 {name=p41 sig_type=std_logic lab=amp_p_vg}
C {/home/user/projects/nic2025_v2/nic2025_openDVS/analog/xschem/col_amp_n_clamp_v1/amp_p_5T.sym} -240 190 0 0 {name=x1}
