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
N 500 -470 560 -470 {lab=vpr}
N 180 -360 180 -330 {lab=gnd}
N 180 -440 180 -420 {lab=vpd}
N 180 -470 240 -470 {lab=vpd}
N 120 -440 120 -430 {lab=vpd}
N 120 -440 180 -440 {lab=vpd}
N 120 -370 120 -360 {lab=gnd}
N 120 -360 180 -360 {lab=gnd}
N 180 -470 180 -440 {lab=vpd}
N 300 -470 370 -470 {lab=vpd_in}
N 320 -450 370 -450 {lab=PrBp}
N 370 -370 370 -320 {lab=PrSFBp}
N 510 -450 560 -450 {lab=PrSFBp}
N 690 -470 750 -470 {lab=vsf}
N 620 -400 620 -350 {lab=gnd}
N 650 -400 650 -350 {lab=vdd}
N 430 -400 430 -350 {lab=gnd}
N 460 -400 460 -350 {lab=vdd}
N -70 270 -70 310 {lab=gnd}
N -70 170 -70 210 {lab=exp}
N 370 100 370 120 {lab=gnd}
N 370 180 370 200 {lab=GND!}
N 370 180 450 180 {lab=GND!}
N 450 100 450 120 {lab=vdd}
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
.include /home/rpgraca/research/projects/telluride/2025/nic_eventcam/nic2025_openDVS/analog/xschem/dvs_readout_ctrl.spice

** Convergence options for nA-range weak-inversion pixel circuit
** gmin=1e-15: at 1V node this is 1fA shunt, negligible vs nA signals
** method=gear: damps numerical ringing on stiff circuits (fast digital + slow analog)
** trtol=1: conservative timestep control prevents overshoot at edges
.option gmin=1e-16 abstol=1e-15 vntol=1e-9 reltol=1e-4 chgtol=1e-16
.option method=gear maxord=2 trtol=1
.option itl1=500 itl2=200 itl4=50
.option gminsteps=200 srcsteps=200
.option ramptime=100n

.dc Vexp -14 -7 0.2


.param xvdd = 1.8
*.param xipd = 1e-9
.param xPrBp = 10n
.param xPrSFBp = 100p
.param xCloadPD = 30f

** xipd swept via Vexp: Iipd uses behavioral expression

*Small Iphoto testing

.save all

"}
C {isource.sym} -560 430 0 0 {name=IPrBp value=\{xPrBp\}}
C {sky130_fd_pr/pfet_01v8_hvt.sym} -580 330 0 0 {name=MPrBp
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
C {PixelPhotoreceptor.sym} 520 -480 0 0 {name=xpr}
C {PixelSourceFollower.sym} 710 -480 0 0 {name=xsf}
C {lab_wire.sym} 180 -330 0 0 {name=p45 sig_type=std_logic lab=gnd}
C {bsource.sym} 180 -390 0 0 {name=Bipd1 VAR=I FUNC="pow(10, v(exp))"}
C {lab_wire.sym} 180 -450 0 0 {name=p46 sig_type=std_logic lab=vpd}
C {capa.sym} 120 -400 0 1 {name=CloadPD1
m=1
value='xCloadPD'
footprint=1206
device="ceramic capacitor"}
C {vsource.sym} 270 -470 1 0 {name=Vmeas_ipd1 value=0 savecurrent=false}
C {lab_wire.sym} 330 -470 0 0 {name=p47 sig_type=std_logic lab=vpd_in}
C {lab_wire.sym} 320 -450 2 0 {name=p48 sig_type=std_logic lab=PrBp}
C {lab_wire.sym} 370 -370 3 0 {name=p49 sig_type=std_logic lab=PrSFBp}
C {lab_wire.sym} 510 -450 2 0 {name=p50 sig_type=std_logic lab=PrSFBp}
C {lab_wire.sym} 510 -470 0 1 {name=p51 sig_type=std_logic lab=vpr}
C {lab_wire.sym} 740 -470 0 0 {name=p52 sig_type=std_logic lab=vsf}
C {noconn.sym} 750 -470 2 0 {name=l4}
C {lab_wire.sym} 620 -350 1 1 {name=p53 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 650 -350 1 1 {name=p54 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 430 -350 1 1 {name=p55 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 460 -350 1 1 {name=p56 sig_type=std_logic lab=vdd}
C {vsource.sym} -70 240 0 0 {name=Vexp value=0 savecurrent=false}
C {lab_wire.sym} -70 310 3 1 {name=p1 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -70 170 1 1 {name=p2 sig_type=std_logic lab=exp}
C {vsource.sym} 370 150 0 0 {name=Vgnd value=0 savecurrent=false}
C {gnd.sym} 370 200 0 0 {name=l1 lab=GND!}
C {vsource.sym} 450 150 0 0 {name=Vvdd value=\{xvdd\} savecurrent=false}
C {lab_wire.sym} 370 110 0 0 {name=p3 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 450 110 0 0 {name=p4 sig_type=std_logic lab=vdd}
