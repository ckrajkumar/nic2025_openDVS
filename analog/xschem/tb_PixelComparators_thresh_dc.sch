v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 440 140 440 160 {lab=GND!}
N 440 140 520 140 {lab=GND!}
N 520 60 520 80 {lab=vdd}
N 440 70 440 80 {lab=gnd}
N 740 -130 740 -100 {lab=gnd}
N 770 -130 770 -100 {lab=vdd}
N 650 -180 680 -180 {lab=OnBn}
N 650 -160 680 -160 {lab=OffBn}
N 810 -210 850 -210 {lab=ON}
N 810 -190 850 -190 {lab=nOFF}
N 30 450 30 470 {lab=OnBn}
N -60 500 -10 500 {lab=OnBn}
N -60 450 -60 500 {lab=OnBn}
N -60 450 30 450 {lab=OnBn}
N 30 430 30 450 {lab=OnBn}
N 30 530 30 570 {lab=gnd}
N 30 500 70 500 {lab=gnd}
N 30 330 30 370 {lab=vdd}
N 190 450 190 470 {lab=OffBn}
N 100 500 150 500 {lab=OffBn}
N 100 450 100 500 {lab=OffBn}
N 100 450 190 450 {lab=OffBn}
N 190 430 190 450 {lab=OffBn}
N 190 530 190 570 {lab=gnd}
N 190 500 230 500 {lab=gnd}
N 190 330 190 370 {lab=vdd}
N 470 -200 680 -200 {lab=vdiff}
N 470 -200 470 -190 {lab=vdiff}
N 470 -130 470 -90 {lab=gnd}
C {devices/code.sym} -420 -210 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {devices/launcher.sym} -170 -300 2 1 {name=h1
descr="Annotate OP"
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {code_shown.sym} -1280 -550 0 0 {name=NGSPICE
only_toplevel=true
value="
.temp 27

.option gmin=1e-16 abstol=1e-15 vntol=1e-9 reltol=1e-4 chgtol=1e-16
.option itl1=500 itl2=200
.option gminsteps=200 srcsteps=200

.param xvdd = 1.8
.param xOnBn = 200n
.param xOffBn = 0.25n
.param xvdiff = 0

.save all

.control
dc vvdiff 0 1.8 0.1m
write tb_PixelComparators_dc.raw
.endc
"}
C {vsource.sym} 440 110 0 0 {name=Vgnd value=0 savecurrent=false}
C {gnd.sym} 440 160 0 0 {name=l1 lab=GND!}
C {vsource.sym} 520 110 0 0 {name=Vvdd value=\{xvdd\} savecurrent=false}
C {lab_wire.sym} 440 70 0 0 {name=p3 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 520 70 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {noconn.sym} 620 -200 2 0 {name=l4}
C {lab_wire.sym} 600 -200 0 1 {name=p7 sig_type=std_logic lab=vdiff}
C {iopin.sym} 650 -180 2 0 {name=p13 lab=OnBn}
C {PixelComparators.sym} 830 -210 0 0 {name=xcomp}
C {iopin.sym} 650 -160 2 0 {name=p17 lab=OffBn}
C {lab_wire.sym} 740 -100 3 1 {name=p15 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 770 -100 3 1 {name=p16 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 850 -210 0 0 {name=p14 sig_type=std_logic lab=ON}
C {lab_wire.sym} 850 -190 0 0 {name=p18 sig_type=std_logic lab=nOFF}
C {sky130_fd_pr/nfet_01v8.sym} 10 500 0 0 {name=MOnBn
W=1
L=2
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
C {lab_wire.sym} -60 450 3 0 {name=p29 sig_type=std_logic lab=OnBn}
C {isource.sym} 30 400 0 0 {name=IOnBn value=\{xOnBn\}}
C {lab_wire.sym} 30 570 3 1 {name=p30 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 70 500 2 1 {name=p31 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 30 330 3 0 {name=p32 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/nfet_01v8.sym} 170 500 0 0 {name=MOffBn
W=1
L=2
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
C {lab_wire.sym} 100 450 3 0 {name=p33 sig_type=std_logic lab=OffBn}
C {isource.sym} 190 400 0 0 {name=IOffBn value=\{xOffBn\}}
C {lab_wire.sym} 190 570 3 1 {name=p34 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 230 500 2 1 {name=p35 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 190 330 3 0 {name=p36 sig_type=std_logic lab=vdd}
C {noconn.sym} 850 -210 2 0 {name=l2}
C {noconn.sym} 850 -190 2 0 {name=l3}
C {vsource.sym} 470 -160 0 0 {name=Vvdiff value=\{xvdiff\} savecurrent=false}
C {lab_wire.sym} 470 -90 3 1 {name=p1 sig_type=std_logic lab=gnd}
