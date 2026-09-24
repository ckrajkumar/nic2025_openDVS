v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 170 330 190 330 {lab=vd}
N 190 330 210 330 {lab=vd}
N 250 330 280 330 {lab=gnd}
N 250 210 250 300 {lab=sense_local}
N 300 180 300 210 {lab=gnd}
N 330 180 380 180 {lab=sense}
N 250 180 270 180 {lab=sense_local}
N 250 180 250 200 {lab=sense_local}
N 250 200 250 210 {lab=sense_local}
N 300 80 300 140 {lab=row_sel}
N 250 360 250 390 {lab=gnd}
N 380 -110 380 90 {lab=sense}
N 380 90 380 180 {lab=sense}
N 960 -250 960 -200 {lab=gnd}
N 960 -360 960 -310 {lab=nbias}
N 1050 -250 1050 -200 {lab=gnd}
N 1050 -360 1050 -310 {lab=vcascn}
N 1140 -250 1140 -200 {lab=gnd}
N 1140 -360 1140 -310 {lab=vcascp}
N 1270 100 1270 110 {lab=GND!}
N 1270 100 1350 100 {lab=GND!}
N 1350 90 1350 100 {lab=GND!}
N 1350 10 1350 30 {lab=vdd}
N 1270 10 1270 30 {lab=gnd}
N 1270 90 1270 100 {lab=GND!}
N -550 -160 -550 -100 {lab=pbias}
N -550 -280 -550 -250 {lab=VDD}
N -580 -220 -550 -220 {lab=vdd}
N -470 -220 -470 -160 {lab=pbias}
N -550 -160 -470 -160 {lab=pbias}
N -470 -220 -410 -220 {lab=pbias}
N -540 -520 -540 -490 {lab=bias_amp_cascp}
N -540 -430 -540 -380 {lab=gnd}
N -540 -460 -500 -460 {lab=gnd}
N -630 -460 -580 -460 {lab=bias_amp_cascp}
N -630 -520 -630 -460 {lab=bias_amp_cascp}
N -630 -520 -540 -520 {lab=bias_amp_cascp}
N -540 -550 -540 -520 {lab=bias_amp_cascp}
N -540 -640 -540 -610 {lab=vdd}
N -240 -530 -240 -490 {lab=bias_amp_cascn}
N -240 -430 -240 -380 {lab=gnd}
N -240 -640 -240 -610 {lab=vdd}
N -320 -580 -280 -580 {lab=bias_amp_cascn}
N -320 -580 -320 -530 {lab=bias_amp_cascn}
N -320 -530 -240 -530 {lab=bias_amp_cascn}
N -240 -580 -205 -580 {lab=vdd}
N -550 -40 -550 -10 {lab=gnd}
N -510 -220 -470 -220 {lab=pbias}
N -550 -190 -550 -160 {lab=pbias}
N -240 -550 -240 -530 {lab=bias_amp_cascn}
N 790 70 790 80 {lab=gnd}
N 790 -10 790 10 {lab=row_sel}
N 790 70 790 120 {lab=gnd}
N 30 430 30 440 {lab=gnd}
N 30 350 30 370 {lab=vd}
N 30 430 30 480 {lab=gnd}
N 590 -210 680 -210 {lab=vsense_out}
N 440 -320 440 -270 {lab=nbias}
N 390 -320 390 -270 {lab=vcascn}
N 370 -320 370 -270 {lab=vcascp}
N 460 -320 460 -280 {lab=pbias}
N 530 -320 530 -290 {lab=vdd}
N 460 -280 460 -270 {lab=pbias}
N 530 -290 530 -270 {lab=vdd}
N 550 -320 550 -290 {lab=gnd}
N 550 -290 550 -270 {lab=gnd}
N 330 -320 330 -270 {lab=bias_amp_cascp}
N 350 -320 350 -270 {lab=bias_amp_cascn}
N 30 340 30 350 {lab=vd}
N 30 330 170 330 {lab=vd}
N 30 330 30 350 {lab=vd}
C {sky130_fd_pr/nfet_01v8.sym} 230 330 0 0 {name=Mch_amp
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
C {sky130_fd_pr/nfet_01v8.sym} 300 160 1 0 {name=Mrow_sel
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
C {lab_wire.sym} 300 210 0 0 {name=p20 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 280 330 0 0 {name=p23 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 250 390 0 0 {name=p24 sig_type=std_logic lab=gnd}
C {lab_pin.sym} 250 250 2 0 {name=p26 sig_type=std_logic lab=sense_local}
C {lab_pin.sym} 300 80 2 0 {name=p27 sig_type=std_logic lab=row_sel
}
C {vsource.sym} 960 -280 0 0 {name=vtail value=xvtail savecurrent=false}
C {lab_wire.sym} 960 -200 0 0 {name=Vvref3 sig_type=std_logic lab=gnd
value=vref}
C {lab_wire.sym} 960 -360 0 0 {name=p28 sig_type=std_logic lab=nbias}
C {vsource.sym} 1050 -280 0 0 {name=vcascn value=xvcascn savecurrent=false}
C {lab_wire.sym} 1050 -200 0 0 {name=Vvref6 sig_type=std_logic lab=gnd
value=vref}
C {lab_wire.sym} 1050 -360 0 0 {name=p29 sig_type=std_logic lab=vcascn}
C {vsource.sym} 1140 -280 0 0 {name=vcascp value=xvcascp savecurrent=false}
C {lab_wire.sym} 1140 -200 0 0 {name=vcascp1 sig_type=std_logic lab=gnd
value=xcascp}
C {lab_wire.sym} 1140 -360 0 0 {name=vcascp2 sig_type=std_logic lab=vcascp
value=xcascp}
C {vsource.sym} 1270 60 0 0 {name=Vgnd value=0 savecurrent=false}
C {gnd.sym} 1270 110 0 0 {name=l1 lab=GND!}
C {vsource.sym} 1350 60 0 0 {name=Vvdd value=xvdd savecurrent=false}
C {lab_wire.sym} 1270 10 0 0 {name=p30 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1350 10 0 0 {name=p31 sig_type=std_logic lab=vdd}
C {isource.sym} -550 -70 0 0 {name=Ipb value=xicol_bias}
C {sky130_fd_pr/pfet_01v8.sym} -530 -220 0 1 {name=M14
W=3
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
C {vdd.sym} -550 -280 0 0 {name=l36 lab=VDD}
C {lab_wire.sym} -410 -220 0 0 {name=p32 sig_type=std_logic lab=pbias}
C {sky130_fd_pr/nfet_01v8.sym} -560 -460 0 0 {name=Mbias_cascp
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
C {lab_wire.sym} -500 -460 0 0 {name=p33 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -540 -380 0 0 {name=vcascp3 sig_type=std_logic lab=gnd
value=xcascp}
C {isource.sym} -540 -580 0 0 {name=Ibias_cascp value=xibias_cascp}
C {lab_wire.sym} -540 -640 0 0 {name=p34 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -580 -520 0 0 {name=vcascp4 sig_type=std_logic lab=bias_amp_cascp}
C {sky130_fd_pr/pfet_01v8.sym} -260 -580 0 0 {name=Mbias_cascn
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
C {isource.sym} -240 -460 0 0 {name=Ibias_cascn value=xibias_cascn}
C {lab_wire.sym} -240 -380 0 0 {name=vcascp7 sig_type=std_logic lab=gnd
value=xcascp}
C {lab_wire.sym} -240 -640 0 0 {name=p35 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -290 -530 2 1 {name=vcascp8 sig_type=std_logic lab=bias_amp_cascn}
C {lab_wire.sym} -580 -220 0 0 {name=p36 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -205 -580 0 0 {name=p37 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -550 -10 0 0 {name=p38 sig_type=std_logic lab=gnd}
C {vsource.sym} 790 40 0 0 {name=Vrow_sel value=xvdd savecurrent=false}
C {lab_wire.sym} 790 -10 0 0 {name=p39 sig_type=std_logic lab=row_sel}
C {lab_wire.sym} 790 120 0 0 {name=Vvref1 sig_type=std_logic lab=gnd
value=vref}
C {code_shown.sym} 925 -940 0 0 {name=NGSPICE
only_toplevel=true
value="* sim
*.option reltol=1e-3 abstol=1e-12 vntol=1e-5 gmin=1e-10 
*.option trtol=6 chgtol=1e-12

.param xvcascn = 0.2
.param xvcascp = 1.6
.param xicol_bias = 5e-7
.param xvtail = 0.5
.param xvdd = 1.8
.param xvd = 0.1
.param xibias_cascp = 50n
.param xibias_cascn = 50n
.param xibias_comp = 50n

.control
save all
dc Vvd 0 1.8 10m
*op
write test_sense_amp_dc.raw
.endc
"}
C {vsource.sym} 30 400 0 0 {name=Vvd value=xvd savecurrent=false}
C {lab_wire.sym} 30 350 0 0 {name=p40 sig_type=std_logic lab=vd
}
C {lab_wire.sym} 30 480 0 0 {name=Vvref2 sig_type=std_logic lab=gnd
value=vref}
C {devices/code.sym} 720 -850 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {sense_amp.sym} 440 -150 0 0 {name=x1}
C {lab_wire.sym} 680 -210 0 0 {name=p1 sig_type=std_logic lab=vsense_out}
C {noconn.sym} 680 -210 2 0 {name=l2}
C {lab_wire.sym} 440 -320 3 0 {name=p2 sig_type=std_logic lab=nbias}
C {lab_wire.sym} 390 -320 3 0 {name=p3 sig_type=std_logic lab=vcascn}
C {lab_wire.sym} 370 -320 3 0 {name=vcascp5 sig_type=std_logic lab=vcascp
value=xcascp}
C {lab_wire.sym} 460 -320 3 0 {name=p4 sig_type=std_logic lab=pbias}
C {lab_wire.sym} 530 -320 3 0 {name=p5 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 550 -320 3 0 {name=p6 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 350 -320 3 1 {name=vcascp6 sig_type=std_logic lab=bias_amp_cascn}
C {lab_wire.sym} 330 -320 3 1 {name=vcascp9 sig_type=std_logic lab=bias_amp_cascp}
C {lab_pin.sym} 380 60 2 0 {name=p7 sig_type=std_logic lab=sense
}
