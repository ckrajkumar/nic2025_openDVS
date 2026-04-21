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
N 390 -200 460 -200 {lab=gnd}
N 220 -180 220 -160 {lab=DiffBn}
N 260 -130 310 -130 {lab=DiffBn}
N 310 -180 310 -130 {lab=DiffBn}
N 220 -200 220 -180 {lab=DiffBn}
N 220 -100 220 -60 {lab=gnd}
N 310 -180 460 -180 {lab=DiffBn}
N 220 -330 220 -260 {lab=vdd}
N 220 -180 310 -180 {lab=DiffBn}
N 390 -160 460 -160 {lab=nRst}
N 520 -130 520 -60 {lab=gnd}
N 550 -130 550 -60 {lab=vdd}
N 590 -200 680 -200 {lab=vdiff}
N 440 70 440 80 {lab=gnd}
N 180 -130 220 -130 {lab=gnd}
N 740 -130 740 -100 {lab=gnd}
N 770 -130 770 -100 {lab=vdd}
N 650 -180 680 -180 {lab=OnBn}
N 650 -160 680 -160 {lab=OffBn}
N 810 -210 850 -210 {lab=ON}
N 810 -190 850 -190 {lab=nOFF}
N 890 120 930 120 {lab=RefrBp}
N 890 80 930 80 {lab=pixRst}
N 890 100 930 100 {lab=pixRst}
N 1060 100 1100 100 {lab=nRst}
N 1000 160 1000 190 {lab=gnd}
N 1030 160 1030 190 {lab=vdd}
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
.option method=gear maxord=2 trtol=1
.option itl1=500 itl2=200 itl4=50
.option gminsteps=200 srcsteps=200

.param xvdd = 1.8
.param xRefrBp = 4n
.param xDiffBn = 10n
.param xOnBn = 100n
.param xOffBn = 1n

.param xvsf = 0.7

.save all
.save @m.xchamp.xmrst.msky130_fd_pr__pfet_01v8_hvt[id]
.save @m.xchamp.xmrst.msky130_fd_pr__pfet_01v8_hvt[ibd]
.save @m.xchamp.xmrst.msky130_fd_pr__pfet_01v8_hvt[ibs]
.save @m.xchamp.xmrst.msky130_fd_pr__pfet_01v8_hvt[igidl]
.save @m.xchamp.xmrst.msky130_fd_pr__pfet_01v8_hvt[igisl]

.control
** Phase 1: initial reset (VpixRst = xvdd from schematic)
stop when time > 1m
tran 100u 50 uic
let vdd_val = v(vdd)[length(v(vdd))-1]
echo
echo '=== Phase 1: initial reset complete (t=1ms) ==='

** Phase 2: release reset, run until ON fires
alter vpixrst = 0
delete all
let on_thresh = 0.9 * vdd_val
stop when v(on) > $&on_thresh
resume

let t_on_event = time[length(time)-1]
echo
echo '=== Phase 2: ON event detected ==='
print t_on_event

** Phase 3: trigger second reset for 10us
alter vpixrst = $&vdd_val
delete all
let t_rst2_end = t_on_event + 10u
stop when time > $&t_rst2_end
resume
echo
echo '=== Phase 3: second reset complete (10us pulse) ==='

** Phase 4: release second reset, run 0.5s more
alter vpixrst = 0
delete all
let t_final = t_on_event + 0.5
stop when time > $&t_final
resume
echo
echo '=== Phase 4: post-reset observation complete ==='

write tb_PixelReset_tran.raw
echo 'Raw file written. Running Python analysis...'
shell python3 /home/rpgraca/research/projects/telluride/2025/nic_eventcam/nic2025_openDVS/analog/xschem/tb_PixelReset_tran.py tb_PixelReset_tran.raw
.endc
"}
C {vsource.sym} 440 110 0 0 {name=Vgnd value=0 savecurrent=false}
C {gnd.sym} 440 160 0 0 {name=l1 lab=GND!}
C {vsource.sym} 520 110 0 0 {name=Vvdd value=\{xvdd\} savecurrent=false}
C {lab_wire.sym} 440 70 0 0 {name=p3 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 520 70 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {PixelChangeAmplifier.sym} 610 -210 0 0 {name=xChAmp}
C {lab_wire.sym} 390 -200 0 1 {name=p5 sig_type=std_logic lab=gnd}
C {sky130_fd_pr/nfet_01v8.sym} 240 -130 0 1 {name=MDiffBn
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
C {lab_wire.sym} 310 -180 1 1 {name=p25 sig_type=std_logic lab=DiffBn}
C {isource.sym} 220 -230 0 1 {name=IDiffBn value=\{xDiffBn\}}
C {lab_wire.sym} 220 -60 1 0 {name=p26 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 220 -330 1 1 {name=p28 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 390 -160 0 1 {name=p1 sig_type=std_logic lab=nRst}
C {lab_wire.sym} 520 -60 3 1 {name=p2 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 550 -60 3 1 {name=p6 sig_type=std_logic lab=vdd}
C {noconn.sym} 620 -200 2 0 {name=l4}
C {lab_wire.sym} 600 -200 0 1 {name=p7 sig_type=std_logic lab=vdiff}
C {lab_wire.sym} 180 -130 2 0 {name=p9 sig_type=std_logic lab=gnd}
C {iopin.sym} 650 -180 2 0 {name=p13 lab=OnBn}
C {PixelComparators.sym} 830 -210 0 0 {name=xcomp}
C {iopin.sym} 650 -160 2 0 {name=p17 lab=OffBn}
C {lab_wire.sym} 740 -100 3 1 {name=p15 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 770 -100 3 1 {name=p16 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 850 -210 0 0 {name=p14 sig_type=std_logic lab=ON}
C {lab_wire.sym} 850 -190 0 0 {name=p18 sig_type=std_logic lab=nOFF}
C {lab_wire.sym} 1100 100 0 0 {name=p59 sig_type=std_logic lab=nRst}
C {PixelResetGen.sym} 1080 80 0 0 {name=xrst}
C {lab_wire.sym} 890 100 2 1 {name=p19 sig_type=std_logic lab=pixRst}
C {lab_wire.sym} 1000 190 3 1 {name=p20 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1030 190 3 1 {name=p21 sig_type=std_logic lab=vdd}
C {isource.sym} 190 200 0 0 {name=IRefrBp value=\{xRefrBp\}}
C {sky130_fd_pr/pfet_01v8.sym} 170 100 0 0 {name=MRefrBp
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
C {lab_wire.sym} 240 100 0 0 {name=p12 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 190 30 3 0 {name=p22 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 190 270 3 1 {name=p23 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 120 100 3 0 {name=p24 sig_type=std_logic lab=RefrBp}
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
C {lab_wire.sym} 890 80 2 1 {name=p11 sig_type=std_logic lab=pixRst}
C {lab_wire.sym} 890 120 2 1 {name=p10 sig_type=std_logic lab=RefrBp}
C {vsource.sym} 630 360 0 0 {name=VpixRst value=\{xvdd\} savecurrent=false}
C {lab_wire.sym} 630 420 3 1 {name=p27 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 630 260 3 1 {name=p37 sig_type=std_logic lab=pixRst}
C {noconn.sym} 850 -210 2 0 {name=l2}
C {noconn.sym} 850 -190 2 0 {name=l3}
