v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 180 280 180 300 {lab=gnd}
N 40 0 40 30 {lab=gnd}
N 40 -80 40 -60 {lab=vpd}
N 40 -110 100 -110 {lab=vpd}
N 260 -20 260 30 {lab=gnd}
N 180 360 180 380 {lab=GND!}
N 290 -20 290 30 {lab=vdd}
N 180 360 260 360 {lab=GND!}
N 260 280 260 300 {lab=vdd}
N 320 -280 320 -230 {lab=PrBp}
N 340 -280 340 -230 {lab=PrSFBp}
N 360 -280 360 -230 {lab=RefrBp}
N 380 -280 380 -230 {lab=DiffBn}
N 400 -280 400 -230 {lab=OnBn}
N 420 -280 420 -230 {lab=OffBn}
N -250 380 -250 400 {lab=RefrBp}
N -250 460 -250 500 {lab=gnd}
N -320 330 -290 330 {lab=RefrBp}
N -320 330 -320 380 {lab=RefrBp}
N -320 380 -250 380 {lab=RefrBp}
N -250 360 -250 380 {lab=RefrBp}
N -250 330 -200 330 {lab=vdd}
N -250 260 -250 300 {lab=vdd}
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
N -570 680 -570 700 {lab=DiffBn}
N -660 730 -610 730 {lab=DiffBn}
N -660 680 -660 730 {lab=DiffBn}
N -660 680 -570 680 {lab=DiffBn}
N -570 660 -570 680 {lab=DiffBn}
N -570 760 -570 800 {lab=gnd}
N -570 730 -530 730 {lab=gnd}
N -570 560 -570 600 {lab=vdd}
N -410 680 -410 700 {lab=OnBn}
N -500 730 -450 730 {lab=OnBn}
N -500 680 -500 730 {lab=OnBn}
N -500 680 -410 680 {lab=OnBn}
N -410 660 -410 680 {lab=OnBn}
N -410 760 -410 800 {lab=gnd}
N -410 730 -370 730 {lab=gnd}
N -410 560 -410 600 {lab=vdd}
N -250 680 -250 700 {lab=OffBn}
N -340 730 -290 730 {lab=OffBn}
N -340 680 -340 730 {lab=OffBn}
N -340 680 -250 680 {lab=OffBn}
N -250 660 -250 680 {lab=OffBn}
N -250 760 -250 800 {lab=gnd}
N -250 730 -210 730 {lab=gnd}
N -250 560 -250 600 {lab=vdd}
N 500 -130 570 -130 {lab=readLine}
N 570 -130 570 -110 {lab=readLine}
N 570 -50 570 0 {lab=gnd}
N 110 -170 200 -170 {lab=rowReadON}
N 110 -150 200 -150 {lab=rowReadOFF}
N 110 -190 200 -190 {lab=pixRst}
N -20 -80 -20 -70 {lab=vpd}
N -20 -80 40 -80 {lab=vpd}
N -20 -10 -20 0 {lab=gnd}
N -20 0 40 0 {lab=gnd}
N 40 -110 40 -80 {lab=vpd}
N 160 -110 200 -110 {lab=vpd_in}
N 570 -140 570 -130 {lab=readLine}
N 570 -270 570 -230 {lab=vdd}
N 570 -140 790 -140 {lab=readLine}
N 570 -170 570 -140 {lab=readLine}
N 860 -280 860 -240 {lab=vdd}
N 860 40 860 90 {lab=gnd}
N 1110 -180 1200 -180 {lab=rowReadON}
N 1110 -140 1200 -140 {lab=rowReadOFF}
N 1110 -100 1200 -100 {lab=pixRst}
N 1110 -60 1210 -60 {lab=onEventCount}
N 1110 -20 1210 -20 {lab=offEventCount}
C {openDVS_pixel.sym} 350 -100 0 0 {name=xpix}
C {vsource.sym} 180 330 0 0 {name=Vgnd value=0 savecurrent=false}
C {gnd.sym} 180 380 0 0 {name=l1 lab=GND!}
C {vsource.sym} 260 330 0 0 {name=Vvdd value=\{xvdd\} savecurrent=false}
C {lab_wire.sym} 180 290 0 0 {name=p1 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 40 30 0 0 {name=p2 sig_type=std_logic lab=gnd}
C {isource.sym} 40 -30 0 0 {name=Iipd value=\{xipd\}}
C {lab_wire.sym} 260 290 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 260 30 1 1 {name=p14 sig_type=std_logic lab=gnd}
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

.param xvdd = 1.8
.param xipd = 1e-9
.param xPrBp = 10n
.param xPrSFBp = 100p
.param xRefrBp = 4n
.param xDiffBn = 10n
.param xOnBn = 100n
.param xOffBn = 1n

.param xtr = 1n
.param xtperRead = 3u
.param xtdReadON = 100n
.param xtlenReadON = 950n
.param xtlenReadOFF = 950n
.param xtlenRstPhase = 950n
.param xtdReadOFF = 'xtdReadON+xtlenReadON+10n'
.param xtdRstPhase = 'xtdReadOFF+xtlenReadOFF+10n'
.param xtdRowSel = 50n
.param xtperRowSel = '2*xtperRead'

.param xCloadPD = 30f
.param xCloadReadLine = 300f
.param xCloadRowReadON = 300f
.param xCloadRowReadOFF = 300f
.param xCloadPixRst = 300f

*Small Iphoto testing
Iphoto1 vpd gnd pulse(50n 100n 120m 50m 50m 59.9m 300m)
Iphoto2 vpd gnd pulse(50n 25n 240m 50m 50m 59.9m 300m)

.control

	save all
	op
	tran 100n 390m
        write pixel_tb.raw
.endc
"}
C {lab_wire.sym} 40 -90 0 0 {name=p8 sig_type=std_logic lab=vpd}
C {lab_wire.sym} 290 30 1 1 {name=p9 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 320 -280 3 0 {name=p11 sig_type=std_logic lab=PrBp}
C {lab_wire.sym} 340 -280 3 0 {name=p12 sig_type=std_logic lab=PrSFBp}
C {lab_wire.sym} 360 -280 3 0 {name=p16 sig_type=std_logic lab=RefrBp}
C {lab_wire.sym} 380 -280 3 0 {name=p17 sig_type=std_logic lab=DiffBn}
C {lab_wire.sym} 400 -280 3 0 {name=p18 sig_type=std_logic lab=OnBn}
C {lab_wire.sym} 420 -280 3 0 {name=p19 sig_type=std_logic lab=OffBn}
C {isource.sym} -250 430 0 0 {name=IRefrBp value=\{xRefrBp\}}
C {sky130_fd_pr/pfet_01v8.sym} -270 330 0 0 {name=MRefrBp
W=2
L=8
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
C {lab_wire.sym} -200 330 0 0 {name=p3 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -250 260 3 0 {name=p5 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -250 500 3 1 {name=p6 sig_type=std_logic lab=gnd}
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
C {lab_wire.sym} -320 330 3 0 {name=p24 sig_type=std_logic lab=RefrBp}
C {sky130_fd_pr/nfet_01v8.sym} -590 730 0 0 {name=MDiffBn
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
C {lab_wire.sym} -660 680 3 0 {name=p25 sig_type=std_logic lab=DiffBn}
C {isource.sym} -570 630 0 0 {name=IDiffBn value=\{xDiffBn\}}
C {lab_wire.sym} -570 800 3 1 {name=p26 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -530 730 2 1 {name=p27 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -570 560 3 0 {name=p28 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/nfet_01v8.sym} -430 730 0 0 {name=MOnBn
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
C {lab_wire.sym} -500 680 3 0 {name=p29 sig_type=std_logic lab=OnBn}
C {isource.sym} -410 630 0 0 {name=IOnBn value=\{xOnBn\}}
C {lab_wire.sym} -410 800 3 1 {name=p30 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -370 730 2 1 {name=p31 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -410 560 3 0 {name=p32 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/nfet_01v8.sym} -270 730 0 0 {name=MOffBn
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
C {lab_wire.sym} -340 680 3 0 {name=p33 sig_type=std_logic lab=OffBn}
C {isource.sym} -250 630 0 0 {name=IOffBn value=\{xOffBn\}}
C {lab_wire.sym} -250 800 3 1 {name=p34 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -210 730 2 1 {name=p35 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -250 560 3 0 {name=p36 sig_type=std_logic lab=vdd}
C {capa.sym} 570 -80 0 0 {name=CloadReadLine
m=1
value='xCloadReadLine'
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 570 0 1 1 {name=p99 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 560 -130 0 0 {name=p43 sig_type=std_logic lab=readLine}
C {lab_wire.sym} 110 -170 0 1 {name=p91 sig_type=std_logic lab=rowReadON}
C {lab_wire.sym} 110 -150 0 1 {name=p92 sig_type=std_logic lab=rowReadOFF}
C {lab_wire.sym} 110 -190 0 1 {name=p102 sig_type=std_logic lab=pixRst}
C {capa.sym} -20 -40 0 1 {name=CloadPD
m=1
value='xCloadPD'
footprint=1206
device="ceramic capacitor"}
C {vsource.sym} 130 -110 1 0 {name=Vmeas_ipd value=0 savecurrent=false}
C {lab_wire.sym} 190 -110 0 0 {name=p104 sig_type=std_logic lab=vpd_in}
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
C {res.sym} 570 -200 0 0 {name=RreadLinePU
value=10k
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 570 -270 0 0 {name=p105 sig_type=std_logic lab=vdd}
C {dvs_readout_ctrl.sym} 630 -110 0 0 {name=xVAReadout}
C {lab_wire.sym} 860 -280 0 0 {name=p37 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 860 90 1 1 {name=p38 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1200 -180 0 0 {name=p39 sig_type=std_logic lab=rowReadON}
C {lab_wire.sym} 1200 -140 0 0 {name=p40 sig_type=std_logic lab=rowReadOFF}
C {lab_wire.sym} 1200 -100 0 0 {name=p41 sig_type=std_logic lab=pixRst}
C {lab_wire.sym} 1200 -60 0 0 {name=p42 sig_type=std_logic lab=onEventCount}
C {lab_wire.sym} 1200 -20 0 0 {name=p44 sig_type=std_logic lab=offEventCount}
C {noconn.sym} 1210 -60 2 0 {name=l2}
C {noconn.sym} 1210 -20 2 0 {name=l3}
