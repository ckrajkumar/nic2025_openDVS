v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 10 180 10 190 {lab=GND}
N 10 100 10 110 {lab=vphoto}
N 10 -10 10 20 {lab=VDD}
N 70 100 70 110 {lab=vphoto}
N -100 120 -30 120 {lab=#net1}
N 10 100 70 100 {lab=vphoto}
N 70 170 70 180 {lab=GND}
N 10 180 70 180 {lab=GND}
N -30 160 -30 180 {lab=GND}
N -100 180 -30 180 {lab=GND}
N 320 160 340 160 {lab=vph_sf}
N 320 260 340 260 {lab=#net2}
N 400 260 420 260 {lab=vin}
N 420 160 420 260 {lab=vin}
N 400 160 420 160 {lab=vin}
N 10 80 10 100 {lab=vphoto}
N 10 170 10 180 {lab=GND}
N 10 50 40 50 {lab=GND}
N -30 180 10 180 {lab=GND}
N -150 50 -30 50 {lab=#net3}
N 230 40 230 70 {lab=VDD}
N 230 100 260 100 {lab=GND}
N 70 100 190 100 {lab=vphoto}
N 230 230 230 250 {lab=GND}
N 230 200 260 200 {lab=GND}
N 130 200 190 200 {lab=#net4}
N 230 130 230 170 {lab=vph_sf}
N 230 160 320 160 {lab=vph_sf}
N 300 260 320 260 {lab=#net2}
C {vdd.sym} 10 -10 0 0 {name=l1 lab=VDD}
C {gnd.sym} 10 190 0 0 {name=l2 lab=GND}
C {vsource.sym} -230 70 0 0 {name=vdd value=1.8 savecurrent=true}
C {vdd.sym} -230 40 0 0 {name=l3 lab=VDD}
C {gnd.sym} -230 100 0 0 {name=l4 lab=GND}
C {devices/code.sym} -380 0 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {code_shown.sym} -370 160 0 0 {name=NGSPICE
only_toplevel=true
value="
.control
.param I_PH = 0.1
save all
# dc vph 0 1.8 10m
.IC v(vin)=0.5
tran 1n 10u UIC
plot v(vphoto) v(vph_sf) v(vin)
save @m.xm1.msky130_fd_pr__nfet_01v8[gm]
save @m.xm1.msky130_fd_pr__nfet_01v8[id]
save @m.xm1.msky130_fd_pr__nfet_01v8[vgs]
save @m.xm1.msky130_fd_pr__nfet_01v8[vds]
save @m.xm1.msky130_fd_pr__nfet_01v8[vth]
save @m.xm1.msky130_fd_pr__nfet_01v8[vdsat]
save @m.xm2.msky130_fd_pr__nfet_01v8[gm]
save @m.xm2.msky130_fd_pr__nfet_01v8[id]
save @m.xm3.msky130_fd_pr__nfet_01v8[gm]
save @m.xm3.msky130_fd_pr__nfet_01v8[id]
op
write test_pixel_tia.raw
.endc
"}
C {devices/launcher.sym} -150 -50 2 1 {name=h1
descr="Annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {sky130_fd_pr/annotate_fet_params.sym} 10 240 0 0 {name=annot1 ref=M1}
C {sky130_fd_pr/cap_mim_m3_1.sym} 370 160 3 0 {name=CSAMPLE model=cap_mim_m3_1 W=1 L=1 MF=16 spiceprefix=X}
C {sky130_fd_pr/cap_mim_m3_1.sym} 370 260 3 0 {name=CREF model=cap_mim_m3_1 W=1 L=1 MF=2 spiceprefix=X}
C {capa.sym} 70 140 0 0 {name=C1
m=1
value=30f
footprint=1206
device="ceramic capacitor"}
C {vsource.sym} -100 150 0 0 {name=vph value=I_PH savecurrent=false}
C {gnd.sym} 40 50 0 0 {name=l6 lab=GND}
C {sky130_fd_pr/nfet_01v8.sym} -10 50 0 0 {name=M1
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
model=nfet_01v8
spiceprefix=X
}
C {vccs.sym} 10 140 0 0 {name=G1 value=1e-9}
C {vsource.sym} -150 80 0 0 {name=vnb value=0.6 savecurrent=false}
C {gnd.sym} -150 110 0 0 {name=l5 lab=GND}
C {lab_pin.sym} 70 100 2 0 {name=p1 sig_type=std_logic lab=vphoto}
C {vdd.sym} 230 40 0 0 {name=l7 lab=VDD}
C {gnd.sym} 260 100 0 0 {name=l8 lab=GND}
C {sky130_fd_pr/nfet_01v8.sym} 210 100 0 0 {name=M2
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
model=nfet_01v8
spiceprefix=X
}
C {gnd.sym} 260 200 0 0 {name=l9 lab=GND}
C {sky130_fd_pr/nfet_01v8.sym} 210 200 0 0 {name=M3
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
model=nfet_01v8
spiceprefix=X
}
C {gnd.sym} 230 250 0 0 {name=l10 lab=GND}
C {vsource.sym} 130 230 0 0 {name=vsf value=0.6 savecurrent=false}
C {gnd.sym} 130 260 0 0 {name=l11 lab=GND}
C {lab_pin.sym} 230 150 2 0 {name=p2 sig_type=std_logic lab=vph_sf}
C {vsource.sym} 300 290 0 0 {name=vref value="pulse(0.8 1.2 0 1n 1n 1u 2u)" savecurrent=false}
C {gnd.sym} 300 320 0 0 {name=l12 lab=GND}
C {lab_pin.sym} 420 210 2 0 {name=p3 sig_type=std_logic lab=vin}
