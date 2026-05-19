v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 190 150 190 170 {lab=RefrBp}
N 190 230 190 270 {lab=gnd}
N 120 100 150 100 {lab=RefrBp}
N 120 100 120 150 {lab=RefrBp}
N 120 150 190 150 {lab=RefrBp}
N 190 130 190 150 {lab=RefrBp}
N 190 100 240 100 {lab=vdd}
N 190 30 190 70 {lab=vdd}
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
N 630 390 630 420 {lab=gnd}
N 630 260 630 330 {lab=pixRst}
N 800 40 990 40 {lab=vpd3,vpd2,vpd1,vpd0}
N 940 -80 990 -80 {lab=PrBp}
N 940 -60 990 -60 {lab=RefrBp}
N 940 -40 990 -40 {lab=PrSFBp}
N 940 -20 990 -20 {lab=DiffBn}
N 940 0 990 0 {lab=OffBn}
N 940 20 990 20 {lab=OnBn}
N 940 -130 990 -130 {lab=gnd,pixRst}
N 940 -110 990 -110 {lab=gnd}
N 940 -150 990 -150 {lab=gnd,pixRst}
N 1120 80 1120 130 {lab=gnd}
N 1140 80 1140 130 {lab=gnd}
N 1160 80 1160 130 {lab=vdd}
N 1290 -150 1340 -150 {lab=gnd}
N 290 -170 290 -140 {lab=gnd}
N 290 -270 290 -230 {lab=vpd1}
N 410 -170 410 -140 {lab=gnd}
N 410 -270 410 -230 {lab=vpd2}
N 530 -170 530 -140 {lab=gnd}
N 530 -270 530 -230 {lab=vpd3}
N 150 -170 150 -140 {lab=gnd}
N 150 -270 150 -230 {lab=vpd0}
N 350 150 350 170 {lab=PrBp}
N 350 230 350 270 {lab=gnd}
N 280 100 310 100 {lab=PrBp}
N 280 100 280 150 {lab=PrBp}
N 280 150 350 150 {lab=PrBp}
N 350 130 350 150 {lab=PrBp}
N 350 100 400 100 {lab=vdd}
N 350 30 350 70 {lab=vdd}
N 510 150 510 170 {lab=PrSFBp}
N 510 230 510 270 {lab=gnd}
N 440 100 470 100 {lab=PrSFBp}
N 440 150 510 150 {lab=PrSFBp}
N 510 130 510 150 {lab=PrSFBp}
N 510 100 560 100 {lab=vdd}
N 510 30 510 70 {lab=vdd}
N 350 450 350 470 {lab=DiffBn}
N 260 500 310 500 {lab=DiffBn}
N 260 450 260 500 {lab=DiffBn}
N 260 450 350 450 {lab=DiffBn}
N 350 430 350 450 {lab=DiffBn}
N 350 530 350 570 {lab=gnd}
N 350 500 390 500 {lab=gnd}
N 350 330 350 370 {lab=vdd}
N 440 100 440 150 {lab=PrSFBp}
N 310 -460 310 -440 {lab=GND!}
N 310 -460 390 -460 {lab=GND!}
N 390 -540 390 -520 {lab=vdd}
N 310 -530 310 -520 {lab=gnd}
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

.option gmin=1e-17 abstol=1e-15 vntol=1e-9 reltol=1e-4 chgtol=1e-16
.option method=gear maxord=2 trtol=1
.option itl1=500 itl2=200 itl4=50
.option gminsteps=200 srcsteps=200
.option ramptime=100n

.param xvdd = CACE\{vdd\}
.param xPrBp = CACE\{xPrBp\}
.param xPrSFBp = CACE\{xPrSFBp\}
.param xDiffBn = CACE\{xDiffBn\}
.param xRefrBp = CACE\{xRefrBp\}
.param xOnBn = CACE\{xOnBn\}
.param xOffBn = CACE\{xOffBn\}

.param xipd0 = CACE\{xipd0\}
.param xipd1 = CACE\{xipd1\}
.param xipd2 = CACE\{xipd2\}
.param xipd3 = CACE\{xipd3\}

.save all

** Bsource probes: mirror bracket-containing internal nodes to top-level names
Bprobe_on on_mon 0 V = v(xpix2x2.pix[0].on)
Bprobe_nrst nrst_mon 0 V = v(xpix2x2.pix[0].nrst)
Bprobe_vdiff vdiff_mon 0 V = v(xpix2x2.pix[0].vdiff)

.control
** Phase 1: initial reset (VpixRst = xvdd, DC source)
stop when time > 1m
tran 100u 51 uic
let vdd_val = v(vdd)[length(v(vdd))-1]
echo
echo '=== Phase 1: initial reset complete (t=1ms) ==='

** Phase 2: release reset, run until ON fires
alter vpixrst = 0
delete all
let on_thresh = 0.9 * vdd_val
stop when v(on_mon) > $&on_thresh
stop when time > 45
resume

let t_on_event = time[length(time)-1]
echo
echo '=== Phase 2: ON event detected ==='
print t_on_event

** Phase 3: trigger second reset for 1ms
alter vpixrst = $&vdd_val
delete all
let t3 = time[length(time)-1]
let t_rst2_end = t3 + 1m
stop when time > $&t_rst2_end
resume

** Phase 4: release second reset, run settling time
alter vpixrst = 0
delete all
let t_final = t_on_event + 0.5
if t_final > 50.9
  let t_final = 50.9
end
stop when time > $&t_final
resume

write CACE\{filename\}_CACE\{N\}.raw
shell python3 CACE\{root\}/cace/scripts/tb_PixelResetTran_2x2.py CACE\{simpath\} CACE\{filename\} CACE\{N\}
.endc
"}
C {isource.sym} 190 200 0 0 {name=IRefrBp value=\{xRefrBp\}}
C {sky130_fd_pr/pfet_01v8.sym} 170 100 0 0 {name=MRefrBp
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
C {lab_wire.sym} 240 100 0 0 {name=p12 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 190 270 3 1 {name=p23 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 120 100 3 0 {name=p24 sig_type=std_logic lab=RefrBp}
C {sky130_fd_pr/nfet_01v8.sym} 10 500 0 0 {name=MOnBn
W=1.5
L=1.5
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
W=1.5
L=1.5
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
C {vsource.sym} 630 360 0 0 {name=VpixRst value=\{xvdd\} savecurrent=false}
C {lab_wire.sym} 630 420 3 1 {name=p27 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 630 260 3 1 {name=p37 sig_type=std_logic lab=pixRst}
C {openDVS_pixel2x2.sym} 1140 -50 0 0 {name=xpix2x2}
C {lab_wire.sym} 960 40 0 0 {name=p40 sig_type=std_logic lab=vpd3,vpd2,vpd1,vpd0}
C {lab_wire.sym} 940 -80 0 1 {name=p41 sig_type=std_logic lab=PrBp}
C {lab_wire.sym} 940 -60 0 1 {name=p42 sig_type=std_logic lab=RefrBp}
C {lab_wire.sym} 940 -40 0 1 {name=p43 sig_type=std_logic lab=PrSFBp}
C {lab_wire.sym} 940 -20 0 1 {name=p44 sig_type=std_logic lab=DiffBn}
C {lab_wire.sym} 940 0 0 1 {name=p45 sig_type=std_logic lab=OffBn}
C {lab_wire.sym} 940 20 0 1 {name=p46 sig_type=std_logic lab=OnBn}
C {lab_wire.sym} 940 -130 0 1 {name=p48 sig_type=std_logic lab=gnd,pixRst}
C {lab_wire.sym} 940 -110 0 1 {name=p49 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 940 -150 0 1 {name=p50 sig_type=std_logic lab=gnd,pixRst}
C {lab_wire.sym} 1120 130 3 1 {name=p51 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1140 130 3 1 {name=p52 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1160 130 3 1 {name=p53 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1340 -150 0 0 {name=p8 sig_type=std_logic lab=gnd}
C {isource.sym} 290 -200 0 0 {name=I0 value='xipd1'}
C {lab_wire.sym} 290 -140 0 0 {name=p26 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 290 -270 0 0 {name=p1 sig_type=std_logic lab=vpd1}
C {isource.sym} 410 -200 0 0 {name=I1 value='xipd2'}
C {lab_wire.sym} 410 -140 0 0 {name=p28 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 410 -270 0 0 {name=p2 sig_type=std_logic lab=vpd2}
C {isource.sym} 530 -200 0 0 {name=I2 value='xipd3'}
C {lab_wire.sym} 530 -140 0 0 {name=p38 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 530 -270 0 0 {name=p39 sig_type=std_logic lab=vpd3}
C {isource.sym} 150 -200 0 0 {name=I3 value='xipd0'}
C {lab_wire.sym} 150 -140 0 0 {name=p19 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 150 -270 0 0 {name=p5 sig_type=std_logic lab=vpd0}
C {sky130_fd_pr/pfet_01v8.sym} 330 100 0 0 {name=MPrBp
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
C {isource.sym} 350 200 0 0 {name=IPrBp value=\{xPrBp\}}
C {lab_wire.sym} 400 100 0 0 {name=p54 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 350 270 3 1 {name=p55 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 280 100 3 0 {name=p56 sig_type=std_logic lab=PrBp}
C {sky130_fd_pr/pfet_01v8.sym} 490 100 0 0 {name=MPrSFBp
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
C {isource.sym} 510 200 0 0 {name=IPrSFBp value=\{xPrSFBp\}}
C {lab_wire.sym} 560 100 0 0 {name=p57 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 510 270 3 1 {name=p58 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 440 100 3 0 {name=p59 sig_type=std_logic lab=PrSFBp}
C {sky130_fd_pr/nfet_01v8.sym} 330 500 0 0 {name=MDiffBn
W=1.5
L=1.5
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
C {lab_wire.sym} 260 450 3 0 {name=p60 sig_type=std_logic lab=DiffBn}
C {isource.sym} 350 400 0 0 {name=IDiffBn value=\{xDiffBn\}}
C {lab_wire.sym} 350 570 3 1 {name=p61 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 390 500 2 1 {name=p62 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 350 330 3 0 {name=p63 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 190 30 3 0 {name=p3 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 350 30 3 0 {name=p4 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 510 30 3 0 {name=p6 sig_type=std_logic lab=vdd}
C {vsource.sym} 310 -490 0 0 {name=Vgnd value=0 savecurrent=false}
C {gnd.sym} 310 -440 0 0 {name=l1 lab=GND!}
C {vsource.sym} 390 -490 0 0 {name=Vvdd value=\{xvdd\} savecurrent=false}
C {lab_wire.sym} 310 -530 0 0 {name=p7 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 390 -530 0 0 {name=p9 sig_type=std_logic lab=vdd}
