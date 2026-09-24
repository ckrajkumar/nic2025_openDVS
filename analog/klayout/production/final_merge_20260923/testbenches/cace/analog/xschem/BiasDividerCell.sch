v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 250 -140 300 -140 {lab=IPrev}
N 130 -140 190 -140 {lab=IPrev}
N 130 -140 130 -110 {lab=IPrev}
N 80 -80 130 -80 {lab=IPrev}
N 80 -140 130 -140 {lab=IPrev}
N 80 -140 80 -80 {lab=IPrev}
N 220 -100 220 -80 {lab=VGate}
N 170 -80 220 -80 {lab=VGate}
N 130 -50 130 -20 {lab=IOut}
N 220 -160 220 -140 {lab=IPrev}
N 160 -160 220 -160 {lab=IPrev}
N 160 -160 160 -140 {lab=IPrev}
N 50 -140 80 -140 {lab=IPrev}
C {sky130_fd_pr/pfet_01v8.sym} 220 -120 3 0 {name=M1
W=4
L=8
nf=1
mult=2
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 150 -80 0 1 {name=M2
W=4
L=8
nf=1
mult=13
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {iopin.sym} 300 -140 2 1 {name=p1 lab=INext}
C {iopin.sym} 130 -20 3 1 {name=p2 lab=IOut}
C {iopin.sym} 50 -140 0 1 {name=p3 lab=IPrev}
C {ipin.sym} 220 -80 0 1 {name=p4 lab=VGate}
