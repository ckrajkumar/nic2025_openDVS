v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 840 -340 880 -340 {lab=rowReadON}
N 920 -310 920 -280 {lab=readLineONpd}
N 920 -220 920 -180 {lab=GndD}
N 1140 -340 1180 -340 {lab=rowReadOFF}
N 1220 -310 1220 -280 {lab=readLineOFFpd}
N 1220 -220 1220 -180 {lab=GndD}
N 920 -410 920 -370 {lab=readLine}
N 1070 -410 1220 -410 {lab=readLine}
N 1220 -410 1220 -370 {lab=readLine}
N 1070 -520 1070 -410 {lab=readLine}
N 920 -410 1070 -410 {lab=readLine}
N 920 -250 950 -250 {lab=GndA}
N 1220 -250 1250 -250 {lab=GndA}
N 1220 -340 1250 -340 {lab=GndA}
N 920 -340 950 -340 {lab=GndA}
N 790 -250 880 -250 {lab=ON}
N 1100 -250 1180 -250 {lab=nOFF}
C {ipin.sym} 840 -340 0 0 {name=p1 lab=rowReadON}
C {sky130_fd_pr/nfet_01v8.sym} 900 -340 0 0 {name=MswON
W=0.42
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
C {sky130_fd_pr/nfet_01v8.sym} 900 -250 0 0 {name=MoutON
W=0.42
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
C {ipin.sym} 1140 -340 0 0 {name=p39 lab=rowReadOFF}
C {sky130_fd_pr/nfet_01v8.sym} 1200 -340 0 0 {name=MswOFF
W=0.42
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
C {sky130_fd_pr/nfet_01v8.sym} 1200 -250 0 0 {name=MoutOFF
W=0.42
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
C {lab_wire.sym} 1220 -180 0 0 {name=p40 sig_type=std_logic lab=GndD}
C {iopin.sym} 1070 -520 3 0 {name=p42 lab=readLine}
C {lab_wire.sym} 1250 -250 0 0 {name=p44 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 920 -290 0 0 {name=p71 sig_type=std_logic lab=readLineONpd}
C {lab_wire.sym} 1220 -290 0 0 {name=p72 sig_type=std_logic lab=readLineOFFpd}
C {iopin.sym} 790 -250 2 0 {name=p2 lab=ON}
C {iopin.sym} 1100 -250 2 0 {name=p9 lab=nOFF}
C {iopin.sym} 920 -180 1 0 {name=p10 lab=GndD
}
C {lab_wire.sym} 1250 -340 0 0 {name=p3 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 950 -340 0 0 {name=p4 sig_type=std_logic lab=GndA}
C {lab_wire.sym} 950 -250 0 0 {name=p5 sig_type=std_logic lab=GndA}
C {iopin.sym} 990 -200 1 0 {name=p6 lab=GndA
}
