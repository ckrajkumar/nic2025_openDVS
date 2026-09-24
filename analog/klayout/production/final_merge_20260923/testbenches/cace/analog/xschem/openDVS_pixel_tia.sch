v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 130 180 130 190 {lab=gnd}
N -350 60 -350 70 {lab=vpd}
N -350 -50 -350 -20 {lab=vdd}
N 220 80 240 80 {lab=vph_sf}
N 220 180 240 180 {lab=vref}
N 300 180 320 180 {lab=vd}
N 320 80 320 180 {lab=vd}
N 300 80 320 80 {lab=vd}
N -350 40 -350 60 {lab=vpd}
N 130 170 130 180 {lab=gnd}
N -380 10 -350 10 {lab=gnd}
N 130 -110 130 -80 {lab=vdd}
N 130 -50 160 -50 {lab=gnd}
N 130 150 130 170 {lab=gnd}
N 130 120 160 120 {lab=gnd}
N 130 80 220 80 {lab=vph_sf}
N 200 180 220 180 {lab=vref}
N -80 20 -20 20 {lab=vpr}
N 40 120 90 120 {lab=sf_bias}
N 130 -20 130 60 {lab=vph_sf}
N 130 60 130 90 {lab=vph_sf}
N 320 80 340 80 {lab=vd}
N 380 80 410 80 {lab=gnd}
N 380 -40 380 50 {lab=sense_local}
N 450 120 450 140 {lab=lrst}
N 450 180 450 210 {lab=gnd}
N 320 180 420 180 {lab=vd}
N 680 -190 680 30 {lab=feedback}
N 480 180 530 180 {lab=feedback}
N 450 90 450 120 {lab=lrst}
N 450 0 450 90 {lab=lrst}
N 30 -50 90 -50 {lab=vpr}
N 30 -50 30 20 {lab=vpr}
N -160 -60 -120 -60 {lab=pr_bias}
N 430 -70 430 -40 {lab=gnd}
N 460 -70 510 -70 {lab=sense}
N 580 -60 580 -40 {lab=row_sel}
N 580 0 580 30 {lab=gnd}
N 450 0 550 0 {lab=lrst}
N 630 -170 630 0 {lab=pix_rst}
N 380 -70 400 -70 {lab=sense_local}
N 380 -70 380 -50 {lab=sense_local}
N 380 -50 380 -40 {lab=sense_local}
N -170 -170 -130 -170 {lab=row_sel}
N -130 -170 480 -170 {lab=row_sel}
N 430 -170 430 -110 {lab=row_sel}
N 510 -190 510 -70 {lab=sense}
N 580 -170 580 -60 {lab=row_sel}
N 480 -170 580 -170 {lab=row_sel}
N 610 0 630 0 {lab=pix_rst}
N 530 180 680 180 {lab=feedback}
N 680 30 680 180 {lab=feedback}
N 630 -200 630 -170 {lab=pix_rst}
N 630 -220 630 -200 {lab=pix_rst}
N 680 -220 680 -190 {lab=feedback}
N -350 70 -350 110 {lab=vpd}
N 380 110 380 140 {lab=gnd}
N -350 170 -350 180 {lab=gnd}
N -350 190 -350 200 {lab=gnd}
N -350 180 -350 190 {lab=gnd}
N -480 80 -480 100 {lab=vpd}
N -480 80 -350 80 {lab=vpd}
N -80 20 -80 40 {lab=vpr}
N -20 20 30 20 {lab=vpr}
N -80 130 -80 140 {lab=gnd}
N -80 120 -80 130 {lab=gnd}
N -80 100 -80 120 {lab=gnd}
N -80 -30 -80 20 {lab=vpr}
N -80 -120 -80 -90 {lab=vdd}
N -180 70 -120 70 {lab=vpd}
N -350 70 -180 70 {lab=vpd}
N -310 10 -80 10 {lab=vpr}
N -80 -60 -50 -60 {lab=vdd}
N -80 70 -50 70 {lab=gnd}
C {sky130_fd_pr/cap_mim_m3_1.sym} 270 80 3 0 {name=CSAMPLE model=cap_mim_m3_1 W=1 L=1 MF=16 spiceprefix=X}
C {sky130_fd_pr/cap_mim_m3_1.sym} 270 180 3 0 {name=CREF model=cap_mim_m3_1 W=1 L=1 MF=2 spiceprefix=X}
C {sky130_fd_pr/nfet_01v8.sym} -330 10 0 1 {name=Mpd
W=0.5
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
C {lab_pin.sym} 130 30 2 0 {name=p2 sig_type=std_logic lab=vph_sf}
C {lab_pin.sym} 320 130 2 0 {name=p3 sig_type=std_logic lab=vd}
C {sky130_fd_pr/nfet_01v8.sym} 360 80 0 0 {name=Mch_amp
W=2
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
C {sky130_fd_pr/nfet_01v8.sym} 450 160 1 0 {name=Msw
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
C {sky130_fd_pr/nfet_01v8.sym} 110 120 0 0 {name=Msf_bias
W=0.5
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
C {sky130_fd_pr/nfet_01v8.sym} 110 -50 0 0 {name=Msf
W=0.5
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
C {sky130_fd_pr/nfet_01v8.sym} 430 -90 1 0 {name=Mrow_sel
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
C {sky130_fd_pr/nfet_01v8.sym} 580 -20 1 0 {name=Mfb_row_sel
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
C {ipin.sym} -170 -170 0 0 {name=p4 lab=row_sel}
C {iopin.sym} 510 -190 3 0 {name=p10 lab=sense}
C {iopin.sym} 630 -220 3 0 {name=p6 lab=pix_rst}
C {iopin.sym} 680 -220 3 0 {name=p5 lab=feedback}
C {lab_wire.sym} 580 30 0 0 {name=p12 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 430 -40 0 0 {name=p14 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 450 210 0 0 {name=p15 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 160 -50 0 0 {name=p16 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -380 10 0 1 {name=p17 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 160 120 0 0 {name=p18 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 410 80 0 0 {name=p19 sig_type=std_logic lab=gnd}
C {iopin.sym} -160 -60 2 0 {name=p9 lab=pr_bias}
C {iopin.sym} -350 -50 3 0 {name=p8 lab=vdd}
C {lab_wire.sym} 130 -110 0 0 {name=p20 sig_type=std_logic lab=vdd}
C {iopin.sym} 200 180 2 0 {name=p21 lab=vref}
C {iopin.sym} -480 100 1 0 {name=p22 lab=vpd}
C {iopin.sym} 40 120 2 0 {name=p7 lab=sf_bias}
C {lab_wire.sym} 380 140 0 0 {name=p13 sig_type=std_logic lab=gnd}
C {iopin.sym} -350 200 1 0 {name=p1 lab=gnd}
C {lab_wire.sym} 130 190 0 0 {name=p11 sig_type=std_logic lab=gnd}
C {lab_pin.sym} 450 100 2 0 {name=p23 sig_type=std_logic lab=lrst}
C {lab_pin.sym} 380 0 2 0 {name=p24 sig_type=std_logic lab=sense_local}
C {sky130_fd_pr/nfet_01v8.sym} -100 70 0 0 {name=Mpr_amp
W=0.5
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
C {lab_wire.sym} -80 140 0 0 {name=p25 sig_type=std_logic lab=gnd}
C {sky130_fd_pr/pfet_01v8.sym} -100 -60 0 0 {name=Mpr_bias
W=0.5
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
C {lab_wire.sym} -80 -120 0 0 {name=p26 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -50 -60 0 0 {name=p27 sig_type=std_logic lab=vdd}
C {lab_pin.sym} -30 20 2 0 {name=p28 sig_type=std_logic lab=vpr}
C {lab_wire.sym} -50 70 0 0 {name=p29 sig_type=std_logic lab=gnd}
C {sky130_fd_pr/photodiode.sym} -350 140 0 0 {name=D1
model=photodiode
area=25
perim=20
spiceprefix=X
}
