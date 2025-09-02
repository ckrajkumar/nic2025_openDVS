v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 420 -50 420 -10 {lab=vout_sense}
N 420 -10 570 -10 {lab=vout_sense}
N 420 -480 420 -450 {lab=vdd}
N 420 -420 450 -420 {lab=vdd}
N 330 -420 380 -420 {lab=pbias}
N 420 -200 450 -200 {lab=vdd}
N 420 -170 420 -130 {lab=vout_sense}
N 420 -390 420 -340 {lab=pbchk}
N 310 -420 330 -420 {lab=pbias}
N 360 -200 380 -200 {lab=#net1}
N 340 -200 360 -200 {lab=#net1}
N 250 -340 420 -340 {lab=pbchk}
N 240 -340 250 -340 {lab=pbchk}
N 420 -340 420 -230 {lab=pbchk}
N 420 -130 420 -60 {lab=vout_sense}
N 420 -60 420 -50 {lab=vout_sense}
N 250 -200 340 -200 {lab=#net1}
N 70 -190 150 -190 {lab=pbchk}
N 70 -340 70 -190 {lab=pbchk}
N 70 -340 230 -340 {lab=pbchk}
N 230 -340 240 -340 {lab=pbchk}
N 200 -160 200 -130 {lab=vdd}
N 220 -160 220 -130 {lab=gnd}
N 140 -210 150 -210 {lab=vcascp}
N 180 -160 180 -130 {lab=bias_amp_cascp}
N 180 -130 180 -100 {lab=bias_amp_cascp}
N 150 80 160 80 {lab=vcascn}
N 420 120 420 250 {lab=sense}
N 360 90 380 90 {lab=#net2}
N 420 90 450 90 {lab=gnd}
N 420 20 420 60 {lab=vout_sense}
N 240 90 360 90 {lab=#net2}
N 230 130 230 180 {lab=gnd}
N 230 180 230 190 {lab=gnd}
N 210 130 210 160 {lab=vdd}
N 190 130 190 160 {lab=bias_amp_cascn}
N 190 160 190 190 {lab=bias_amp_cascn}
N 70 100 160 100 {lab=sense}
N 70 100 70 270 {lab=sense}
N 70 270 420 270 {lab=sense}
N 420 250 420 320 {lab=sense}
N 420 -10 420 20 {lab=vout_sense}
N 310 400 310 420 {lab=gnd}
N 310 370 340 370 {lab=gnd}
N 310 330 310 340 {lab=sense}
N 310 300 310 330 {lab=sense}
N 310 300 420 300 {lab=sense}
N 250 370 270 370 {lab=nbias}
N 610 -10 610 120 {lab=vout_sense}
N 650 150 670 150 {lab=pix_rst}
N 580 150 610 150 {lab=gnd}
N 610 180 610 220 {lab=feedback}
N 610 220 610 330 {lab=feedback}
N 670 150 680 150 {lab=pix_rst}
N 570 -10 610 -10 {lab=vout_sense}
N 610 -10 830 -10 {lab=vout_sense}
N 920 30 920 50 {lab=gnd}
N 900 30 900 50 {lab=vdd}
N 880 30 880 60 {lab=bias_comp}
N 880 60 880 90 {lab=bias_comp}
N 980 -30 1100 -30 {lab=vcomp}
N 730 -50 830 -50 {lab=vcm}
N 610 270 730 270 {lab=feedback}
N 760 230 760 275 {lab=gnd}
N 760 310 760 330 {lab=n_pix_rst}
N 760 330 760 340 {lab=n_pix_rst}
N 790 270 910 270 {lab=vcm}
N 910 270 920 270 {lab=vcm}
C {sky130_fd_pr/pfet_01v8.sym} 400 -420 0 0 {name=Mpb
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
C {sky130_fd_pr/pfet_01v8.sym} 400 -200 0 0 {name=Mpc
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
C {amp_n.sym} 300 -200 0 0 {name=xamp_cascp}
C {ipin.sym} 310 -420 0 0 {name=p1 lab=pbias}
C {iopin.sym} 420 -480 3 0 {name=p2 lab=vdd}
C {lab_wire.sym} 450 -420 0 0 {name=p3 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 450 -200 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 200 -130 3 0 {name=p5 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 220 -130 3 0 {name=p6 sig_type=std_logic lab=gnd}
C {ipin.sym} 140 -210 0 0 {name=p7 lab=vcascp}
C {amp_p.sym} 310 90 0 0 {name=xamp_cascn}
C {ipin.sym} 180 -100 3 0 {name=p9 lab=bias_amp_cascp}
C {ipin.sym} 150 80 0 0 {name=p10 lab=vcascn}
C {sky130_fd_pr/nfet_01v8.sym} 400 90 0 0 {name=Mnc
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
C {lab_wire.sym} 450 90 0 0 {name=p11 sig_type=std_logic lab=gnd}
C {iopin.sym} 230 190 1 0 {name=p12 lab=gnd}
C {lab_wire.sym} 210 160 3 0 {name=p13 sig_type=std_logic lab=vdd}
C {iopin.sym} 420 320 1 0 {name=p15 lab=sense}
C {sky130_fd_pr/nfet_01v8.sym} 290 370 0 0 {name=Mnb
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
C {ipin.sym} 250 370 0 0 {name=p16 lab=nbias}
C {lab_wire.sym} 340 370 0 0 {name=p17 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 310 420 0 0 {name=p18 sig_type=std_logic lab=gnd}
C {sky130_fd_pr/nfet_01v8.sym} 630 150 0 1 {name=Mfb
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
C {iopin.sym} 610 320 1 0 {name=p20 lab=feedback}
C {lab_wire.sym} 580 150 0 0 {name=p19 sig_type=std_logic lab=gnd}
C {ipin.sym} 190 190 3 0 {name=p21 lab=bias_amp_cascn}
C {ipin.sym} 680 150 2 0 {name=p22 lab=pix_rst}
C {amp_comp.sym} 830 40 0 0 {name=xcomp}
C {lab_wire.sym} 920 50 3 0 {name=p23 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 900 50 3 0 {name=p24 sig_type=std_logic lab=vdd}
C {ipin.sym} 880 90 3 0 {name=p25 lab=bias_comp}
C {opin.sym} 1100 -30 0 0 {name=p26 lab=vcomp}
C {ipin.sym} 730 -50 0 0 {name=p27 lab=vcm}
C {lab_wire.sym} 550 -10 0 0 {name=p14 sig_type=std_logic lab=vout_sense}
C {lab_wire.sym} 420 -360 0 0 {name=p8 sig_type=std_logic lab=pbchk}
C {sky130_fd_pr/nfet_01v8.sym} 760 290 3 0 {name=Mrst
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
C {lab_wire.sym} 760 230 3 0 {name=p40 sig_type=std_logic lab=gnd}
C {ipin.sym} 760 340 3 0 {name=p28 lab=n_pix_rst}
C {ipin.sym} 920 270 2 0 {name=p30 lab=fb_idle_lvl}
