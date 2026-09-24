v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -140 50 -140 60 {lab=GND!}
N -180 60 -140 60 {lab=GND!}
N -210 50 -210 60 {lab=GND!}
N -180 60 -180 70 {lab=GND!}
N -210 60 -180 60 {lab=GND!}
N -210 -40 -210 -10 {lab=gnd}
N -140 -40 -140 -10 {lab=vdd}
N 90 -280 90 -250 {lab=vdd}
N 90 -70 90 -40 {lab=gnd}
N 120 -70 120 -20 {lab=IR}
N 120 40 120 90 {lab=gnd}
N 150 -70 150 -20 {lab=BiasCB<0>}
N 180 -70 180 -20 {lab=BiasCB<1>}
N 210 -70 210 -20 {lab=BiasCB<2>}
N 240 -70 240 -20 {lab=BiasCB<3>}
N 270 -70 270 -20 {lab=BiasCB<4>}
N 300 -70 300 -20 {lab=BiasCB<5>}
N 330 -70 330 -20 {lab=BiasCB<6>}
N 360 -70 360 -20 {lab=BiasCB<7>}
N -210 -150 -210 -110 {lab=gnd}
N -210 -290 -210 -210 {lab=PowerDown}
N 120 -330 120 -250 {lab=PowerDown}
N 150 -340 150 -250 {lab=VmasterN}
N 180 -340 180 -250 {lab=VmasterP}
C {BiasMasternCoarse.sym} 190 -160 0 0 {name=xBiasMasternCoarse}
C {vsource.sym} -210 20 0 0 {name=Vgnd value=0 savecurrent=true}
C {gnd.sym} -180 70 0 0 {name=l1 lab=GND!}
C {vsource.sym} -140 20 0 0 {name=Vvdd value=xvdd savecurrent=true}
C {lab_wire.sym} -210 -40 3 0 {name=p1 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -140 -40 3 0 {name=p4 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 90 -280 3 0 {name=p2 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 90 -40 3 1 {name=p3 sig_type=std_logic lab=gnd}
C {res.sym} 120 10 0 0 {name=R1
value='xIR'
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 120 90 3 1 {name=p5 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 150 -30 3 0 {name=p6 sig_type=std_logic lab=BiasCB<0>}
C {vsource.sym} -210 -180 0 0 {name=VpowerDown value='xpowerdown*xvdd' savecurrent=true}
C {lab_wire.sym} -210 -110 3 1 {name=p7 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -210 -290 3 0 {name=p8 sig_type=std_logic lab=PowerDown}
C {lab_wire.sym} 120 -330 3 0 {name=p9 sig_type=std_logic lab=PowerDown}
C {noconn.sym} 150 -340 1 0 {name=l2}
C {noconn.sym} 180 -340 1 0 {name=l3}
C {lab_wire.sym} 150 -330 3 0 {name=p10 sig_type=std_logic lab=VmasterN}
C {lab_wire.sym} 180 -330 3 0 {name=p11 sig_type=std_logic lab=VmasterP}
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
.param xpowerdown = 0
.param xIR = 100k
.save all
.probe alli
.op
"}
C {lab_wire.sym} 120 -40 3 1 {name=p12 sig_type=std_logic lab=IR}
C {lab_wire.sym} 180 -30 3 0 {name=p13 sig_type=std_logic lab=BiasCB<1>}
C {lab_wire.sym} 210 -30 3 0 {name=p14 sig_type=std_logic lab=BiasCB<2>}
C {lab_wire.sym} 240 -30 3 0 {name=p15 sig_type=std_logic lab=BiasCB<3>}
C {lab_wire.sym} 270 -30 3 0 {name=p16 sig_type=std_logic lab=BiasCB<4>}
C {lab_wire.sym} 300 -30 3 0 {name=p17 sig_type=std_logic lab=BiasCB<5>}
C {lab_wire.sym} 330 -30 3 0 {name=p18 sig_type=std_logic lab=BiasCB<6>}
C {lab_wire.sym} 360 -30 3 0 {name=p19 sig_type=std_logic lab=BiasCB<7>}
C {noconn.sym} 360 -20 3 0 {name=l5}
C {noconn.sym} 330 -20 3 0 {name=l6}
C {noconn.sym} 300 -20 3 0 {name=l7}
C {noconn.sym} 270 -20 3 0 {name=l8}
C {noconn.sym} 240 -20 3 0 {name=l9}
C {noconn.sym} 210 -20 3 0 {name=l10}
C {noconn.sym} 180 -20 3 0 {name=l11}
C {noconn.sym} 150 -20 3 0 {name=l12}
