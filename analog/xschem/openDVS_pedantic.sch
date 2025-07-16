v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
L 4 120 -480 390 -480 {}
L 4 280 -90 390 -90 {}
L 4 280 -390 280 -90 {}
L 4 120 -390 280 -390 {}
L 4 520 -480 820 -480 {}
L 4 520 -400 820 -400 {}
L 4 820 -480 820 -400 {}
L 4 520 -480 520 -400 {}
L 4 390 -480 390 -90 {}
L 4 120 -480 120 -390 {}
N 340 -560 340 -390 {
lab=VDD}
N 180 -560 340 -560 {
lab=VDD}
N 180 -560 180 -470 {
lab=VDD}
N 360 -130 360 -80 {
lab=GND}
N 180 -440 200 -440 {
lab=GND}
N 80 -560 180 -560 {
lab=VDD}
N 180 -80 200 -80 {
lab=GND}
N 80 -80 180 -80 {
lab=GND}
N 340 -130 360 -130 {
lab=GND}
N 340 -80 360 -80 {
lab=GND}
N 180 -360 300 -360 {
lab=vphoto}
N 80 -130 300 -130 {
lab=sf_bias}
N 710 -440 730 -440 {
lab=row_sel}
N 710 -540 710 -440 {
lab=row_sel}
N 540 -440 560 -440 {
lab=row_sel}
N 540 -540 540 -440 {
lab=row_sel}
N 180 -410 180 -360 {
lab=vphoto}
N 770 -440 790 -440 {
lab=GND}
N 790 -180 790 -80 {
lab=GND}
N 770 -80 790 -80 {
lab=GND}
N 540 -540 710 -540 {
lab=row_sel}
N 670 -360 690 -360 {
lab=GND}
N 770 -150 770 -80 {
lab=GND}
N 770 -180 790 -180 {
lab=GND}
N 620 -80 690 -80 {
lab=GND}
N 340 -100 340 -80 {
lab=GND}
N 670 -180 730 -180 {
lab=vin}
N 600 -360 630 -360 {
lab=#net1}
N 200 -80 340 -80 {
lab=GND}
N 600 -440 620 -440 {
lab=GND}
N 690 -80 770 -80 {
lab=GND}
N 670 -280 670 -180 {
lab=vin}
N 340 -280 340 -160 {
lab=vph_sf}
N 770 -410 770 -210 {
lab=#net2}
N 200 -440 200 -80 {
lab=GND}
N 790 -440 790 -180 {
lab=GND}
N 620 -440 620 -80 {
lab=GND}
N 180 -250 180 -80 {
lab=GND}
N 80 -440 140 -440 {
lab=vph_bias}
N 80 -180 420 -180 {
lab=vref}
N 340 -280 420 -280 {
lab=vph_sf}
N 480 -280 670 -280 {
lab=vin}
N 480 -180 670 -180 {
lab=vin}
N 80 -540 540 -540 {
lab=row_sel}
N 360 -80 620 -80 {
lab=GND}
N 180 -360 180 -310 {
lab=vphoto}
N 340 -360 360 -360 {
lab=GND}
N 360 -360 360 -130 {
lab=GND}
N 600 -580 600 -470 {
lab=pix_rst}
N 770 -580 770 -470 {
lab=sense}
N 600 -410 600 -360 {
lab=#net1}
N 670 -580 670 -390 {
lab=feedback}
N 670 -330 670 -280 {
lab=vin}
N 690 -360 690 -80 {
lab=GND}
N 340 -330 340 -280 {
lab=vph_sf}
C {sky130_fd_pr/cap_mim_m3_1.sym} 450 -280 3 0 {name=CSAMPLE model=cap_mim_m3_1 W=1 L=1 MF=16 spiceprefix=X}
C {sky130_fd_pr/cap_mim_m3_1.sym} 450 -180 3 0 {name=CREF model=cap_mim_m3_1 W=1 L=1 MF=2 spiceprefix=X}
C {sky130_fd_pr/nfet_01v8.sym} 160 -440 0 0 {name=M1
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
C {sky130_fd_pr/nfet_01v8.sym} 750 -180 0 0 {name=M4
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
C {sky130_fd_pr/nfet_01v8.sym} 650 -360 0 0 {name=M7
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
C {sky130_fd_pr/nfet_01v8.sym} 320 -130 0 0 {name=M2
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
C {sky130_fd_pr/nfet_01v8.sym} 320 -360 0 0 {name=M3
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
C {sky130_fd_pr/photodiode.sym} 180 -280 0 0 {name=D1
model=photodiode
area=9e-12
perim=12e-6
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 750 -440 0 0 {name=M5
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
C {sky130_fd_pr/nfet_01v8.sym} 580 -440 0 0 {name=M6
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
C {devices/iopin.sym} 80 -80 2 0 {name=p0 lab=GND}
C {devices/iopin.sym} 80 -560 2 0 {name=p1 lab=VDD}
C {devices/ipin.sym} 80 -540 0 0 {name=p2 lab=row_sel}
C {devices/ipin.sym} 80 -180 0 0 {name=p3 lab=vref}
C {devices/ipin.sym} 80 -440 0 0 {name=p4 lab=vph_bias}
C {devices/ipin.sym} 80 -130 0 0 {name=p5 lab=sf_bias}
C {devices/ipin.sym} 600 -580 1 0 {name=p6 lab=pix_rst}
C {devices/ipin.sym} 670 -580 1 0 {name=p7 lab=feedback}
C {devices/opin.sym} 770 -580 3 0 {name=p8 lab=sense}
C {devices/lab_pin.sym} 180 -360 2 1 {name=p9 lab=vphoto}
C {devices/lab_pin.sym} 340 -280 2 1 {name=p10 lab=vph_sf}
C {devices/lab_pin.sym} 670 -230 2 1 {name=p11 lab=vin}
C {devices/title.sym} 160 0 0 0 {name=l1 author="Raj"}
