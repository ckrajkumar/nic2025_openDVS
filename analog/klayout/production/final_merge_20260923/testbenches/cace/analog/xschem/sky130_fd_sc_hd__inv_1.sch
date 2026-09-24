v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 260 -40 280 -40 {lab=A}
N 260 -60 290 -60 {lab=VNB}
N 480 110 520 110 {lab=VNB}
N 420 110 440 110 {lab=A}
N 260 -80 290 -80 {lab=VGND}
N 260 -100 290 -100 {lab=VPB}
N 260 -120 290 -120 {lab=VPWR}
N 480 140 480 180 {lab=VGND}
N 260 -20 280 -20 {lab=Y}
N 420 -50 440 -50 {lab=A}
N 420 30 420 110 {lab=A}
N 480 30 480 80 {lab=Y}
N 480 -50 520 -50 {lab=VPB}
N 480 -130 480 -80 {lab=VPWR}
N 480 30 530 30 {lab=Y}
N 480 -20 480 30 {lab=Y}
N 370 30 420 30 {lab=A}
N 420 -50 420 30 {lab=A}
C {ipin.sym} 260 -40 0 0 {name=p32 lab=A}
C {opin.sym} 280 -20 0 0 {name=p1 lab=Y}
C {iopin.sym} 260 -60 2 0 {name=p3 lab=VNB}
C {iopin.sym} 260 -100 2 0 {name=p4 lab=VPB}
C {iopin.sym} 260 -120 2 0 {name=p5 lab=VPWR}
C {sky130_fd_pr/nfet_01v8.sym} 460 110 0 0 {name=X0
W=0.65	
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
C {iopin.sym} 260 -80 2 0 {name=p15 lab=VGND}
C {lab_wire.sym} 480 180 3 1 {name=p10 sig_type=std_logic lab=VGND}
C {lab_wire.sym} 520 110 2 1 {name=p12 sig_type=std_logic lab=VNB}
C {lab_wire.sym} 370 30 0 1 {name=p27 sig_type=std_logic lab=A}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 460 -50 0 0 {name=X1
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
model=pfet_01v8_hvt
spiceprefix=X
}
C {lab_wire.sym} 520 -50 2 1 {name=p37 sig_type=std_logic lab=VPB}
C {lab_wire.sym} 480 -130 3 0 {name=p38 sig_type=std_logic lab=VPWR}
C {lab_wire.sym} 530 30 2 1 {name=p39 sig_type=std_logic lab=Y}
