v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 700 -680 700 -610 {lab=#net1}
N 700 -710 730 -710 {lab=gnd}
N 700 -760 700 -740 {lab=nRst}
N 700 -810 730 -810 {lab=vdd}
N 620 -810 660 -810 {lab=RefrBp}
N 700 -760 880 -760 {lab=nRst}
N 700 -780 700 -760 {lab=nRst}
N 880 -760 880 -740 {lab=nRst}
N 850 -700 850 -660 {lab=vdd}
N 880 -660 910 -660 {lab=vdd}
N 880 -700 880 -660 {lab=vdd}
N 850 -660 880 -660 {lab=vdd}
N 910 -700 910 -660 {lab=vdd}
N 620 -580 660 -580 {lab=rowRst}
N 700 -580 730 -580 {lab=gnd}
N 700 -880 700 -840 {lab=vdd}
N 700 -550 700 -500 {lab=gnd}
N 620 -710 660 -710 {lab=colRst}
N 880 -760 920 -760 {lab=nRst}
C {ipin.sym} 620 -580 0 0 {name=p1 lab=rowRst}
C {ipin.sym} 620 -710 0 0 {name=p49 lab=colRst}
C {sky130_fd_pr/nfet_01v8.sym} 680 -710 0 0 {name=MrefrInv
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
C {lab_wire.sym} 730 -710 0 0 {name=p55 sig_type=std_logic lab=gnd}
C {sky130_fd_pr/pfet_01v8.sym} 680 -810 0 0 {name=MrefrBias
W=2
L=8
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
C {lab_wire.sym} 730 -810 0 0 {name=p57 sig_type=std_logic lab=vdd}
C {iopin.sym} 620 -810 2 0 {name=p58 lab=RefrBp}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 880 -720 1 0 {name=McapRefr
W=8
L=8
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
C {lab_wire.sym} 850 -660 0 0 {name=p48 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/nfet_01v8.sym} 680 -580 0 0 {name=MswON1
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
C {lab_wire.sym} 730 -580 0 0 {name=p52 sig_type=std_logic lab=gnd}
C {iopin.sym} 700 -500 1 0 {name=p61 lab=gnd
}
C {iopin.sym} 700 -880 3 0 {name=p62 lab=vdd
}
C {iopin.sym} 920 -760 0 0 {name=p2 lab=nRst}
