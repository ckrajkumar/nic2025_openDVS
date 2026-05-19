v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -560 380 -560 400 {lab=PrBp}
N -560 460 -560 500 {lab=gnd}
N -630 330 -600 330 {lab=PrBp}
N -630 330 -630 380 {lab=PrBp}
N -630 380 -560 380 {lab=PrBp}
N -560 360 -560 380 {lab=PrBp}
N -560 330 -510 330 {lab=vdd}
N -560 260 -560 300 {lab=vdd}
N -410 380 -410 400 {lab=PrSFBp}
N -410 460 -410 500 {lab=gnd}
N -480 330 -450 330 {lab=PrSFBp}
N -480 330 -480 380 {lab=PrSFBp}
N -480 380 -410 380 {lab=PrSFBp}
N -410 360 -410 380 {lab=PrSFBp}
N -410 330 -360 330 {lab=vdd}
N -410 260 -410 300 {lab=vdd}
N -70 270 -70 310 {lab=gnd}
N -70 170 -70 210 {lab=exp}
N 370 100 370 120 {lab=gnd}
N 370 180 370 200 {lab=GND!}
N 370 180 450 180 {lab=GND!}
N 450 100 450 120 {lab=vdd}
N 160 -230 160 -200 {lab=gnd}
N 160 -310 160 -290 {lab=vpd0}
N 160 -340 220 -340 {lab=vpd0}
N 100 -310 100 -300 {lab=vpd0}
N 100 -310 160 -310 {lab=vpd0}
N 100 -240 100 -230 {lab=gnd}
N 100 -230 160 -230 {lab=gnd}
N 160 -340 160 -310 {lab=vpd0}
N 280 -340 350 -340 {lab=vpd0_in}
N 450 -250 450 -220 {lab=gnd}
N 450 -350 450 -310 {lab=vpd1}
N 570 -250 570 -220 {lab=gnd}
N 570 -350 570 -310 {lab=vpd2}
N 690 -250 690 -220 {lab=gnd}
N 690 -350 690 -310 {lab=vpd3}
N 760 220 950 220 {lab=vpd3,vpd2,vpd1,vpd0_in}
N 900 100 950 100 {lab=PrBp}
N 900 120 950 120 {lab=vdd}
N 900 140 950 140 {lab=PrSFBp}
N 900 160 950 160 {lab=gnd}
N 900 180 950 180 {lab=vdd}
N 900 200 950 200 {lab=vdd}
N 1250 30 1290 30 {lab=gnd}
N 900 50 950 50 {lab=gnd}
N 900 70 950 70 {lab=gnd}
N 900 30 950 30 {lab=gnd}
N 1080 260 1080 310 {lab=gnd}
N 1100 260 1100 310 {lab=gnd}
N 1120 260 1120 310 {lab=vdd}
C {devices/code.sym} -420 -210 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice CACE\{corner\}
"
spice_ignore=false}
C {devices/launcher.sym} -170 -300 2 1 {name=h1
descr="Annotate OP"
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {code_shown.sym} -1280 -550 0 0 {name=NGSPICE
only_toplevel=true
value="
.include CACE\{root\}/xschem/openDVS_pixel2x2_pex_CACE\{xPexType\}.spice

.temp CACE\{temperature\}

** Convergence options for nA-range weak-inversion pixel circuit
.option gmin=1e-16 abstol=1e-15 vntol=1e-9 reltol=1e-4 chgtol=1e-16
.option method=gear maxord=2 trtol=1
.option itl1=500 itl2=200 itl4=50
.option gminsteps=200 srcsteps=200
.option ramptime=100n

.param xvdd = CACE\{vdd\}
.param xPrBp = CACE\{xPrBp\}
.param xPrSFBp = CACE\{xPrSFBp\}
.param xCloadPD = 30f
.param xipd1 = 1n
.param xipd2 = 1n
.param xipd3 = 1n

.save all
.save v(xpix2x2.xpix[0].vpr) v(xpix2x2.xpix[0].vsf)
.save v(vpd0) v(vpd0_in) v(exp)

.control
dc Vexp -14 -7 0.2
write CACE\{filename\}_CACE\{N\}.raw
shell python CACE\{root\}/cace/scripts/tb_PixelPhotoreceptor_dc_2x2.py CACE\{simpath\} CACE\{filename\} CACE\{N\}
.endc
"}
C {isource.sym} -560 430 0 0 {name=IPrBp value=\{xPrBp\}}
C {sky130_fd_pr/pfet_01v8.sym} -580 330 0 0 {name=MPrBp
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
model=pfet_01v8
spiceprefix=X
}
C {lab_wire.sym} -510 330 0 0 {name=p7 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -560 260 3 0 {name=p10 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -560 500 3 1 {name=p13 sig_type=std_logic lab=gnd}
C {isource.sym} -410 430 0 0 {name=IPrSFBp value=\{xPrSFBp\}}
C {lab_wire.sym} -360 330 0 0 {name=p15 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -410 260 3 0 {name=p20 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -410 500 3 1 {name=p21 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -630 330 3 0 {name=p22 sig_type=std_logic lab=PrBp}
C {lab_wire.sym} -480 330 3 0 {name=p23 sig_type=std_logic lab=PrSFBp}
C {sky130_fd_pr/pfet_01v8.sym} -430 330 0 0 {name=MPrSFBp
W=0.42
L=1.5
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
C {vsource.sym} -70 240 0 0 {name=Vexp value=0 savecurrent=false}
C {lab_wire.sym} -70 310 3 1 {name=p1 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -70 170 1 1 {name=p2 sig_type=std_logic lab=exp}
C {vsource.sym} 370 150 0 0 {name=Vgnd value=0 savecurrent=false}
C {gnd.sym} 370 200 0 0 {name=l1 lab=GND!}
C {vsource.sym} 450 150 0 0 {name=Vvdd value=\{xvdd\} savecurrent=false}
C {lab_wire.sym} 370 110 0 0 {name=p3 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 450 110 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {openDVS_pixel2x2.sym} 1100 130 0 0 {name=xpix2x2}
C {lab_wire.sym} 160 -200 0 0 {name=p5 sig_type=std_logic lab=gnd}
C {bsource.sym} 160 -260 0 0 {name=Bipd2 VAR=I FUNC="pow(10, v(exp))"}
C {lab_wire.sym} 160 -320 0 0 {name=p6 sig_type=std_logic lab=vpd0}
C {capa.sym} 100 -270 0 1 {name=CloadPD2
m=1
value='xCloadPD'
footprint=1206
device="ceramic capacitor"}
C {vsource.sym} 250 -340 1 0 {name=Vmeas_ipd2 value=0 savecurrent=false}
C {lab_wire.sym} 330 -340 0 0 {name=p8 sig_type=std_logic lab=vpd0_in}
C {isource.sym} 450 -280 0 0 {name=I0 value='xipd1'}
C {lab_wire.sym} 450 -220 0 0 {name=p9 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 450 -350 0 0 {name=p11 sig_type=std_logic lab=vpd1}
C {isource.sym} 570 -280 0 0 {name=I1 value='xipd2'}
C {lab_wire.sym} 570 -220 0 0 {name=p12 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 570 -350 0 0 {name=p14 sig_type=std_logic lab=vpd2}
C {isource.sym} 690 -280 0 0 {name=I2 value='xipd3'}
C {lab_wire.sym} 690 -220 0 0 {name=p16 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 690 -350 0 0 {name=p17 sig_type=std_logic lab=vpd3}
C {lab_wire.sym} 920 220 0 0 {name=p18 sig_type=std_logic lab=vpd3,vpd2,vpd1,vpd0_in}
C {lab_wire.sym} 900 100 0 1 {name=p19 sig_type=std_logic lab=PrBp}
C {lab_wire.sym} 900 120 0 1 {name=p24 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 900 140 0 1 {name=p25 sig_type=std_logic lab=PrSFBp}
C {lab_wire.sym} 900 160 0 1 {name=p26 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 900 180 0 1 {name=p27 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 900 200 0 1 {name=p28 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1260 30 0 1 {name=p29 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 900 50 0 1 {name=p30 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 900 70 0 1 {name=p31 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 900 30 0 1 {name=p32 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1080 310 3 1 {name=p33 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1100 310 3 1 {name=p34 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1120 310 3 1 {name=p35 sig_type=std_logic lab=vdd}
