v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -100 -280 -100 -250 {lab=vdd}
N -100 -220 -70 -220 {lab=vdd}
N -190 -220 -140 -220 {lab=int_outp}
N -100 -190 -100 -140 {lab=int_outn}
N -270 -280 -270 -250 {lab=vdd}
N -300 -220 -270 -220 {lab=vdd}
N -270 -190 -270 -160 {lab=int_outp
}
N -230 -220 -190 -220 {lab=int_outp}
N -330 -110 -310 -110 {lab=vp}
N -270 -110 -240 -110 {lab=gnd}
N -60 -110 -40 -110 {lab=vm}
N -130 -110 -100 -110 {lab=gnd}
N -270 -160 -270 -140 {lab=int_outp}
N -270 -80 -270 -50 {lab=vsource}
N -100 -80 -100 -50 {lab=vsource}
N -270 -50 -100 -50 {lab=vsource}
N -180 -50 -180 -20 {lab=vsource}
N -180 40 -180 70 {lab=gnd}
N -270 10 -220 10 {lab=vbias_n}
N -180 10 -150 10 {lab=gnd}
N 340 -320 340 -290 {lab=vdd}
N 250 -260 300 -260 {lab=vbias_p}
N 430 -170 460 -170 {lab=vdd}
N 230 -170 260 -170 {lab=vdd}
N 260 -140 260 -110 {lab=voutp
}
N 430 -140 430 -110 {lab=voutn}
N 430 -110 520 -110 {lab=voutn}
N 190 -110 260 -110 {lab=voutp}
N 300 -170 320 -170 {lab=voutn}
N 300 -20 320 -20 {lab=voutn}
N 230 -20 260 -20 {lab=gnd}
N 370 -20 390 -20 {lab=voutp}
N 430 -20 460 -20 {lab=gnd}
N 260 -110 260 -50 {lab=voutp}
N 430 -110 430 -50 {lab=voutn}
N 320 -170 320 -20 {lab=voutn}
N 320 -90 430 -90 {lab=voutn}
N 370 -170 370 -20 {lab=voutp}
N 370 -170 390 -170 {lab=voutp}
N 260 -70 370 -70 {lab=voutp}
N 110 -20 230 -20 {lab=gnd}
N 110 -80 110 -50 {lab=voutp}
N 110 -80 260 -80 {lab=voutp}
N 40 -20 70 -20 {lab=int_outn}
N 110 10 110 60 {lab=gnd}
N 110 60 260 60 {lab=gnd}
N 260 10 260 60 {lab=gnd}
N 180 -20 180 60 {lab=gnd}
N 430 10 430 60 {lab=gnd}
N 260 60 430 60 {lab=gnd}
N 460 -20 580 -20 {lab=gnd}
N 510 -20 510 60 {lab=gnd}
N 430 60 510 60 {lab=gnd}
N 620 -20 650 -20 {lab=int_outp}
N 580 10 580 60 {lab=gnd}
N 510 60 580 60 {lab=gnd}
N 580 -70 580 -50 {lab=voutn}
N 430 -70 580 -70 {lab=voutn}
N 260 -220 260 -200 {lab=#net1}
N 260 -220 340 -220 {lab=#net1}
N 340 -230 340 -220 {lab=#net1}
N 340 -220 430 -220 {lab=#net1}
N 430 -220 430 -200 {lab=#net1}
N 340 -260 390 -260 {lab=vdd}
N 390 -320 390 -260 {lab=vdd}
N 340 -320 390 -320 {lab=vdd}
C {sky130_fd_pr/pfet_01v8.sym} -120 -220 0 0 {name=Mmirr3
W=1
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
C {sky130_fd_pr/pfet_01v8.sym} -250 -220 0 1 {name=Mdio2
W=1
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
C {sky130_fd_pr/nfet_01v8.sym} -290 -110 0 0 {name=Minm3
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
C {sky130_fd_pr/nfet_01v8.sym} -80 -110 0 1 {name=Minp3
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
C {iopin.sym} -270 -280 3 0 {name=p25 lab=vdd}
C {lab_wire.sym} -70 -220 0 0 {name=p26 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -100 -280 0 0 {name=p27 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -300 -220 0 0 {name=p28 sig_type=std_logic lab=vdd}
C {iopin.sym} -180 70 1 0 {name=p29 lab=gnd}
C {lab_wire.sym} -240 -110 0 0 {name=p30 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -130 -110 0 0 {name=p31 sig_type=std_logic lab=gnd}
C {sky130_fd_pr/nfet_01v8.sym} -200 10 0 0 {name=Mbias1
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
C {lab_wire.sym} -150 10 0 0 {name=p32 sig_type=std_logic lab=gnd}
C {ipin.sym} -270 10 0 0 {name=p33 lab=vbias_n
}
C {ipin.sym} -330 -110 0 0 {name=p34 lab=vp
}
C {ipin.sym} -40 -110 2 0 {name=p35 lab=vm
}
C {lab_wire.sym} -190 -50 0 0 {name=p36 sig_type=std_logic lab=vsource}
C {lab_wire.sym} -100 -160 0 0 {name=p38 sig_type=std_logic lab=int_outn}
C {sky130_fd_pr/pfet_01v8.sym} 320 -260 0 0 {name=Mmirr4
W=1
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
C {lab_wire.sym} 340 -320 0 0 {name=p39 sig_type=std_logic lab=vdd}
C {ipin.sym} 250 -260 0 0 {name=p40 lab=vbias_p

}
C {sky130_fd_pr/pfet_01v8.sym} 410 -170 0 0 {name=Mmirr5
W=1
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
C {sky130_fd_pr/pfet_01v8.sym} 280 -170 0 1 {name=Mdio3
W=1
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
C {lab_wire.sym} 460 -170 0 0 {name=p41 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 230 -170 0 0 {name=p42 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/nfet_01v8.sym} 280 -20 0 1 {name=Minp4
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
C {lab_wire.sym} 350 60 0 0 {name=p43 sig_type=std_logic lab=gnd}
C {sky130_fd_pr/nfet_01v8.sym} 410 -20 0 0 {name=Minm4
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
C {sky130_fd_pr/nfet_01v8.sym} 90 -20 0 0 {name=Minm5
W=1
L=0.15
nf=1 
mult=4
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {lab_wire.sym} 50 -20 0 0 {name=p44 sig_type=std_logic lab=int_outn}
C {sky130_fd_pr/nfet_01v8.sym} 600 -20 0 1 {name=Minp5
W=1
L=0.15
nf=1 
mult=4
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {opin.sym} 520 -110 0 0 {name=p45 lab=voutn}
C {opin.sym} 190 -110 2 0 {name=p46 lab=voutp}
C {lab_pin.sym} 640 -20 2 0 {name=p47 sig_type=std_logic lab=int_outp
}
C {lab_wire.sym} -270 -160 0 0 {name=p1 sig_type=std_logic lab=int_outp}
C {lab_wire.sym} -160 -220 0 0 {name=p2 sig_type=std_logic lab=vbias_n}
