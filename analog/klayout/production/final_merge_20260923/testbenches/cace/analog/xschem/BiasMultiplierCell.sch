v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 0 -140 50 -140 {lab=IPrev}
N 110 -140 170 -140 {lab=INext}
N 170 -140 170 -110 {lab=INext}
N 170 -80 220 -80 {lab=INext}
N 170 -140 220 -140 {lab=INext}
N 220 -140 220 -80 {lab=INext}
N 80 -100 80 -80 {lab=VGate}
N 80 -80 130 -80 {lab=VGate}
N 170 -50 170 -20 {lab=IOut}
N 80 -160 80 -140 {lab=INext}
N 80 -160 140 -160 {lab=INext}
N 140 -160 140 -140 {lab=INext}
N 220 -140 250 -140 {lab=INext}
C {sky130_fd_pr/pfet_01v8.sym} 80 -120 1 1 {name=M1
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
C {sky130_fd_pr/pfet_01v8.sym} 150 -80 0 0 {name=M2
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
C {iopin.sym} 0 -140 2 0 {name=p1 lab=IPrev}
C {iopin.sym} 170 -20 1 0 {name=p2 lab=IOut}
C {iopin.sym} 250 -140 0 0 {name=p3 lab=INext}
C {ipin.sym} 80 -80 0 0 {name=p4 lab=VGate}
