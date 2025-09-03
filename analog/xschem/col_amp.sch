v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 420 -10 610 -10 {lab=vout_sense}
N 610 -10 610 120 {lab=vout_sense}
N 650 150 680 150 {lab=pix_rst}
N 580 150 610 150 {lab=gnd}
N 610 180 610 270 {lab=feedback}
N 610 270 610 330 {lab=feedback}
N 610 -10 830 -10 {lab=vout_sense}
N 920 30 920 50 {lab=gnd}
N 900 30 900 50 {lab=vdd}
N 880 30 880 90 {lab=bias_comp}
N 980 -30 1100 -30 {lab=vcomp}
N 730 -50 830 -50 {lab=vcm}
N 610 270 730 270 {lab=feedback}
N 760 230 760 275 {lab=gnd}
N 760 310 760 340 {lab=n_pix_rst}
N 790 270 920 270 {lab=fb_idle_lvl}
N 160 -100 160 -70 {lab=bias_amp_cascp}
N 180 -100 180 -70 {lab=bias_amp_cascn}
N 210 90 210 110 {lab=sense}
N 220 -100 220 -70 {lab=vcascn}
N 270 -100 270 -70 {lab=nbias}
N 290 -100 290 -70 {lab=pbias}
N 200 -100 200 -70 {lab=vcascn}
N 360 -100 360 -70 {lab=vdd}
N 380 -100 380 -70 {lab=gnd}
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
C {ipin.sym} 680 150 2 0 {name=p22 lab=pix_rst}
C {amp_comp.sym} 830 40 0 0 {name=xcomp}
C {lab_wire.sym} 920 50 3 0 {name=p23 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 900 50 3 0 {name=p24 sig_type=std_logic lab=vdd}
C {ipin.sym} 880 90 3 0 {name=p25 lab=bias_comp}
C {opin.sym} 1100 -30 0 0 {name=p26 lab=vcomp}
C {ipin.sym} 730 -50 0 0 {name=p27 lab=vcm}
C {lab_wire.sym} 550 -10 0 0 {name=p14 sig_type=std_logic lab=vout_sense}
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
C {sense_amp.sym} 270 50 0 0 {name=xsense_amp}
C {ipin.sym} 160 -100 1 0 {name=p29 lab=bias_amp_cascp}
C {ipin.sym} 180 -100 1 0 {name=p31 lab=bias_amp_cascn}
C {ipin.sym} 290 -100 1 0 {name=p32 lab=pbias}
C {ipin.sym} 220 -100 1 0 {name=p33 lab=vcascn}
C {ipin.sym} 270 -100 1 0 {name=p34 lab=nbias}
C {iopin.sym} 210 110 1 0 {name=p35 lab=sense}
C {ipin.sym} 200 -100 1 0 {name=p36 lab=vcascp}
C {iopin.sym} 360 -100 3 0 {name=p37 lab=vdd}
C {iopin.sym} 380 -100 3 0 {name=p38 lab=gnd}
