v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -70 -290 -70 -260 {lab=vdd}
N -70 -230 -40 -230 {lab=vdd}
N -70 -30 -70 10 {lab=gnd}
N -70 -60 -40 -60 {lab=vdd}
N -160 -230 -110 -230 {lab=PrSFBp}
N -70 -130 -70 -90 {lab=vsf}
N -70 -200 -70 -190 {lab=#net1}
N -230 -180 -230 -160 {lab=PrSFBp}
N -230 -100 -230 -60 {lab=gnd}
N -190 -230 -160 -230 {lab=PrSFBp}
N -160 -230 -160 -180 {lab=PrSFBp}
N -230 -180 -160 -180 {lab=PrSFBp}
N -230 -200 -230 -180 {lab=PrSFBp}
N -280 -230 -230 -230 {lab=vdd}
N -230 -300 -230 -260 {lab=vdd}
N -180 50 -180 90 {lab=gnd}
N -180 -60 -110 -60 {lab=vin}
N -180 -60 -180 -10 {lab=vin}
N -340 230 -340 240 {lab=GND!}
N -380 240 -340 240 {lab=GND!}
N -410 230 -410 240 {lab=GND!}
N -380 240 -380 250 {lab=GND!}
N -410 240 -380 240 {lab=GND!}
N -410 140 -410 170 {lab=gnd}
N -340 140 -340 170 {lab=vdd}
C {lab_pin.sym} -70 -100 2 0 {name=p2 sig_type=std_logic lab=vsf}
C {lab_wire.sym} -70 -290 0 0 {name=p20 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -70 10 0 0 {name=p11 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -40 -230 0 0 {name=p3 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -40 -60 0 0 {name=p5 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/pfet_01v8.sym} -90 -230 0 0 {name=MsfBias
W=1
L=8
nf=2
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
C {sky130_fd_pr/pfet_01v8.sym} -90 -60 0 0 {name=Msf
W=1
L=2
nf=2
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
C {vsource.sym} -70 -160 0 0 {name=Vmeas_sf value=0 savecurrent=false}
C {isource.sym} -230 -130 0 1 {name=IPrSFBp value=\{xPrSFBp\}}
C {lab_wire.sym} -280 -230 0 1 {name=p15 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -230 -300 1 1 {name=p4 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -230 -60 1 0 {name=p21 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -160 -230 1 1 {name=p23 sig_type=std_logic lab=PrSFBp}
C {sky130_fd_pr/pfet_01v8.sym} -210 -230 0 1 {name=MPrSFBp
W=1
L=8
nf=2
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
C {lab_wire.sym} -160 -60 2 0 {name=p1 sig_type=std_logic lab=vin
}
C {code_shown.sym} -1120 -600 0 0 {name=NGSPICE
only_toplevel=true
value="
.option gmin=1e-17

.param xvdd = 1.8
.param xPrSFBp = 20p
.param xvin = 1

.option gmin=1e-18 abstol=1e-15 vntol=1e-9 reltol=1e-6 chgtol=1e-16 trtol=6

.save all
.dc vin 0 1.8 0.1
"}
C {vsource.sym} -180 20 0 0 {name=vin value=\{xvin\} savecurrent=true}
C {lab_wire.sym} -180 90 0 0 {name=p6 sig_type=std_logic lab=gnd}
C {devices/code.sym} -590 -250 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {devices/launcher.sym} -690 40 2 1 {name=h2
descr="Annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {vsource.sym} -410 200 0 0 {name=Vgnd value=0 savecurrent=true}
C {gnd.sym} -380 250 0 0 {name=l1 lab=GND!}
C {vsource.sym} -340 200 0 0 {name=Vvdd value='xvdd' savecurrent=true}
C {lab_wire.sym} -410 140 3 0 {name=p7 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -340 140 3 0 {name=p8 sig_type=std_logic lab=vdd}
