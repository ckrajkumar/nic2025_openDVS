v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -280 -270 -280 -190 {lab=IR}
N -60 -380 20 -380 {lab=Coarse1}
N -60 -340 20 -340 {lab=Coarse2}
N -520 -530 -520 -520 {lab=GND!}
N -560 -520 -520 -520 {lab=GND!}
N -590 -530 -590 -520 {lab=GND!}
N -560 -520 -560 -510 {lab=GND!}
N -590 -520 -560 -520 {lab=GND!}
N -590 -620 -590 -590 {lab=gnd}
N -520 -620 -520 -590 {lab=vdd}
N -210 -510 -210 -450 {lab=vdd}
N -210 -270 -210 -210 {lab=gnd}
N -140 -270 -140 -130 {lab=VMasterBiasN}
N -140 -610 -140 -450 {lab=VMasterBiasP}
N -280 -130 -280 -50 {lab=gnd}
N -470 -270 -470 -190 {lab=gnd}
N -470 -360 -470 -330 {lab=PowerDown}
N -470 -360 -360 -360 {lab=PowerDown}
C {lab_wire.sym} -420 -360 0 1 {name=p15 sig_type=std_logic lab=PowerDown}
C {lab_wire.sym} -280 -210 3 1 {name=p23 sig_type=std_logic lab=IR}
C {lab_wire.sym} -140 -150 3 1 {name=p24 sig_type=std_logic lab=VMasterBiasN}
C {lab_wire.sym} -140 -570 3 0 {name=p25 sig_type=std_logic lab=VMasterBiasP}
C {lab_wire.sym} -50 -380 0 1 {name=p26 sig_type=std_logic lab=Coarse1}
C {lab_wire.sym} -50 -340 0 1 {name=p27 sig_type=std_logic lab=Coarse2}
C {BiasMasterBias.sym} -210 -360 0 0 {name=xBiasMasterBias}
C {vsource.sym} -590 -560 0 0 {name=Vgnd value=0 savecurrent=true}
C {gnd.sym} -560 -510 0 0 {name=l1 lab=GND!}
C {vsource.sym} -520 -560 0 0 {name=Vvdd value="pwl(0 0 'xtramp' 'xvdd')" savecurrent=true}
C {lab_wire.sym} -590 -620 3 0 {name=p1 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -520 -620 3 0 {name=p4 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -210 -510 3 0 {name=p2 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -210 -210 3 1 {name=p3 sig_type=std_logic lab=gnd}
C {noconn.sym} -140 -610 1 0 {name=l5}
C {noconn.sym} 20 -380 2 0 {name=l2}
C {noconn.sym} 20 -340 2 0 {name=l3}
C {noconn.sym} -140 -130 3 0 {name=l4}
C {res.sym} -280 -160 0 0 {name=R1
value='xIR'
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} -280 -50 3 1 {name=p43 sig_type=std_logic lab=gnd}
C {devices/code.sym} -450 -840 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice CACE\{corner\}
"
spice_ignore=false}
C {devices/launcher.sym} -470 -970 2 1 {name=h1
descr="Annotate OP"
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {code_shown.sym} -1490 -950 0 0 {name=NGSPICE
only_toplevel=true
value="
.include CACE\{DUT_path\}

.temp CACE\{temperature\}

.option SEED=CACE[CACE\{seed=12345\} + CACE\{iterations=0\}]

* Flag unsafe operating conditions (exceeds models' specified limits)
.option warn=1

.param xvdd = CACE\{vdd\}
.param xtramp = 1m
.param xtpd_fall = 2m
.param xtpd_tf = 10u

.param xIR = 100k

.save all

.control
tran 1u 10m
write CACE\{filename\}_CACE\{N\}.raw
shell python CACE\{root\}/cace/scripts/tb_BiasMasterBias_bootstrap.py CACE\{simpath\} CACE\{filename\} CACE\{N\}
.endc
"}
C {vsource.sym} -470 -300 0 0 {name=Vpd value="pwl(0 0 'xtramp' 'xvdd' 'xtpd_fall' 'xvdd' 'xtpd_fall+xtpd_tf' 0)" savecurrent=true}
C {lab_wire.sym} -470 -190 3 1 {name=p5 sig_type=std_logic lab=gnd}
