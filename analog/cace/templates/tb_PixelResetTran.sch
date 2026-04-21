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
.include CACE\{DUT_path\}
.include CACE\{root\}/netlist/schematic/PixelComparators.spice
.include CACE\{root\}/netlist/schematic/PixelResetGen.spice

** Manual instantiation (syms not found in CACE run dir)
xcomp vdd OnBn gnd vdiff ON OffBn nOFF PixelComparators
xrst pixRst gnd pixRst nRst RefrBp vdd PixelResetGen

.temp CACE\{temperature\}

.option gmin=1e-16 abstol=1e-15 vntol=1e-9 reltol=1e-4 chgtol=1e-16
.option method=gear maxord=2 trtol=1
.option itl1=500 itl2=200 itl4=50
.option gminsteps=200 srcsteps=200

.param xvdd = CACE\{vdd\}
.param xRefrBp = CACE\{xRefrBp\}
.param xDiffBn = CACE\{xDiffBn\}
.param xOnBn = CACE\{xOnBn\}
.param xOffBn = CACE\{xOffBn\}
.param xvsf = CACE\{xvsf\}

.save all
.save @m.xchamp.xmrst.msky130_fd_pr__pfet_01v8_hvt[id]
.save @m.xchamp.xmrst.msky130_fd_pr__pfet_01v8_hvt[ibd]
.save @m.xchamp.xmrst.msky130_fd_pr__pfet_01v8_hvt[ibs]
.save @m.xchamp.xmrst.msky130_fd_pr__pfet_01v8_hvt[igidl]
.save @m.xchamp.xmrst.msky130_fd_pr__pfet_01v8_hvt[igisl]

.control
** Phase 1: initial reset (VpixRst = xvdd from schematic)
stop when time > 1m
tran 100u 51 uic
let vdd_val = v(vdd)[length(v(vdd))-1]

** Phase 2: release reset with 10ns edge, run until ON fires or 45s timeout
let t1 = time[length(time)-1]
let t_ramp_end = t1 + 10n
alter @vpixrst[pwl] = [ $&t1 $&vdd_val $&t_ramp_end 0 ]
delete all
let on_thresh = 0.9 * vdd_val
stop when v(on) > $&on_thresh
stop when time > 45
resume

let t_on_event = time[length(time)-1]

** Phase 3: trigger second reset for 10us with 10ns edge (always, even without ON event)
let t3 = time[length(time)-1]
let t3_ramp = t3 + 10n
alter @vpixrst[pwl] = [ $&t3 0 $&t3_ramp $&vdd_val ]
delete all
let t_rst2_end = t3 + 10u
stop when time > $&t_rst2_end
resume

** Phase 4: release second reset with 10ns edge, run settling time
let t4 = time[length(time)-1]
let t4_ramp = t4 + 10n
alter @vpixrst[pwl] = [ $&t4 $&vdd_val $&t4_ramp 0 ]
delete all
let t_final = t_on_event + 0.5
if t_final > 50.9
  let t_final = 50.9
end
stop when time > $&t_final
resume

write CACE\{filename\}_CACE\{N\}.raw
shell python3 CACE\{root\}/cace/scripts/tb_PixelResetTran.py CACE\{simpath\} CACE\{filename\} CACE\{N\}
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
C {vsource.sym} 630 360 0 0 {name=VpixRst value=\{xvdd\} savecurrent=false}
C {lab_wire.sym} 630 420 3 1 {name=p27 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 630 260 3 1 {name=p37 sig_type=std_logic lab=pixRst}
