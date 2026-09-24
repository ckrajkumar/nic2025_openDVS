v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -150 -190 -150 -180 {lab=GND!}
N -190 -180 -150 -180 {lab=GND!}
N -220 -190 -220 -180 {lab=GND!}
N -190 -180 -190 -170 {lab=GND!}
N -220 -180 -190 -180 {lab=GND!}
N -220 -280 -220 -250 {lab=gnd}
N -150 -280 -150 -250 {lab=vdd}
N 40 -380 40 -350 {lab=vdd}
N 40 -230 40 -200 {lab=gnd}
N 70 -200 70 -190 {lab=#net1}
N 70 -230 70 -190 {lab=#net1}
N 70 -130 70 -100 {lab=gnd}
N 130 -60 130 -20 {lab=gnd}
N 90 -140 130 -140 {lab=#net2}
N 130 -140 130 -120 {lab=#net2}
N 90 -140 90 -90 {lab=#net2}
N 130 -90 140 -90 {lab=gnd}
N 200 -60 200 -20 {lab=gnd}
N 160 -140 200 -140 {lab=#net3}
N 200 -140 200 -120 {lab=#net3}
N 160 -140 160 -90 {lab=#net3}
N 200 -90 210 -90 {lab=gnd}
N 100 -230 100 -210 {lab=#net4}
N 100 -150 100 -140 {lab=#net2}
N 170 -230 170 -210 {lab=#net5}
N 170 -150 170 -140 {lab=#net3}
C {vsource.sym} -220 -220 0 0 {name=Vgnd value=0 savecurrent=true}
C {gnd.sym} -190 -170 0 0 {name=l1 lab=GND!}
C {vsource.sym} -150 -220 0 0 {name=Vvdd value=xvdd savecurrent=true}
C {lab_wire.sym} -220 -280 3 0 {name=p1 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -150 -280 3 0 {name=p4 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 40 -380 3 0 {name=p2 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 40 -200 3 1 {name=p3 sig_type=std_logic lab=gnd}
C {devices/code.sym} 110 -520 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {devices/launcher.sym} 160 -610 2 1 {name=h1
descr="Annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {code_shown.sym} -230 -560 0 0 {name=NGSPICE
only_toplevel=true
value="
.param xvdd = 1.8
.param xIin = 400n
.save all
.op
"}
C {isource.sym} 70 -160 0 0 {name=I0 value=xIin}
C {BiasMultiplier.sym} -20 -230 0 0 {name=xMult}
C {lab_wire.sym} 70 -100 3 1 {name=p20 sig_type=std_logic lab=gnd}
C {sky130_fd_pr/nfet_01v8.sym} 110 -90 0 0 {name=M1
W=1.98
L=5
nf=1 
mult=8
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 180 -90 0 0 {name=M2
W=1	
L=10
nf=1 
mult=8
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {vsource.sym} 100 -180 0 0 {name=Vmeas_Iout1 value=0 savecurrent=true}
C {vsource.sym} 170 -180 0 0 {name=Vmeas_Iout0 value=0 savecurrent=true}
C {lab_wire.sym} 130 -20 3 1 {name=p5 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 200 -20 3 1 {name=p6 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 140 -90 0 0 {name=p7 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 210 -90 0 0 {name=p8 sig_type=std_logic lab=gnd}
