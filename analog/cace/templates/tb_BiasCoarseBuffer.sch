v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 170 -110 170 -100 {lab=GND!}
N 130 -100 170 -100 {lab=GND!}
N 100 -110 100 -100 {lab=GND!}
N 130 -100 130 -90 {lab=GND!}
N 100 -100 130 -100 {lab=GND!}
N 100 -200 100 -170 {lab=gnd}
N 170 -200 170 -170 {lab=vdd}
N 650 -670 650 -640 {lab=vdd}
N 650 -460 650 -430 {lab=gnd}
N 620 -460 620 -410 {lab=IR}
N 620 -350 620 -300 {lab=gnd}
N 440 -460 440 -120 {lab=BiasCB<5>}
N -100 -70 -100 -30 {lab=gnd}
N -100 -210 -100 -130 {lab=PowerDown}
N 620 -720 620 -640 {lab=PowerDown}
N 590 -730 590 -640 {lab=VmasterN}
N 560 -730 560 -640 {lab=VmasterP}
N 560 -460 560 -200 {lab=BiasCB<1>}
N 410 -460 410 -100 {lab=BiasCB<6>}
N 720 -40 720 10 {lab=gnd}
N 720 -290 720 -260 {lab=vdd}
N 830 -150 880 -150 {lab=VGate}
N 940 -150 990 -150 {lab=VGate_meas}
N 1140 -190 1190 -190 {lab=gnd}
N 1060 -40 1060 10 {lab=gnd}
N 1060 -290 1060 -260 {lab=vdd}
N 590 -220 650 -220 {lab=BiasCB<0>}
N 560 -200 650 -200 {lab=BiasCB<1>}
N 530 -180 650 -180 {lab=BiasCB<2>}
N 500 -160 650 -160 {lab=BiasCB<3>}
N 470 -140 650 -140 {lab=BiasCB<4>}
N 440 -120 650 -120 {lab=BiasCB<5>}
N 410 -100 650 -100 {lab=BiasCB<6>}
N 380 -80 650 -80 {lab=BiasCB<7>}
N 970 -390 970 -340 {lab=gnd}
N 970 -510 970 -450 {lab=bit0}
N 1080 -390 1080 -340 {lab=gnd}
N 1080 -510 1080 -450 {lab=bit1}
N 1180 -390 1180 -340 {lab=gnd}
N 1180 -510 1180 -450 {lab=bit2}
N 740 -40 740 20 {lab=bit0}
N 760 -40 760 20 {lab=bit1}
N 780 -40 780 20 {lab=bit2}
N 1080 -40 1080 20 {lab=bit1}
N 1100 -40 1100 20 {lab=bit2}
N 590 -460 590 -220 {lab=BiasCB<0>}
N 380 -460 380 -80 {lab=BiasCB<7>}
N 530 -460 530 -180 {lab=BiasCB<2>}
N 500 -460 500 -160 {lab=BiasCB<3>}
N 470 -460 470 -140 {lab=BiasCB<4>}
C {BiasMasternCoarse.sym} 550 -550 0 1 {name=xBiasMasternCoarse}
C {vsource.sym} 100 -140 0 0 {name=Vgnd value=0 savecurrent=true}
C {gnd.sym} 130 -90 0 0 {name=l1 lab=GND!}
C {vsource.sym} 170 -140 0 0 {name=Vvdd value='xvdd' savecurrent=true}
C {lab_wire.sym} 100 -200 3 0 {name=p1 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 170 -200 3 0 {name=p4 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 650 -670 1 1 {name=p2 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 650 -430 1 0 {name=p3 sig_type=std_logic lab=gnd}
C {res.sym} 620 -380 0 1 {name=R1
value='xIR'
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 620 -300 1 0 {name=p5 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 590 -420 1 1 {name=p6 sig_type=std_logic lab=BiasCB<0>}
C {vsource.sym} -100 -100 0 0 {name=VpowerDown value='xpowerdown*xvdd' savecurrent=true}
C {lab_wire.sym} -100 -30 3 1 {name=p7 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -100 -210 3 0 {name=p8 sig_type=std_logic lab=PowerDown}
C {lab_wire.sym} 620 -720 1 1 {name=p9 sig_type=std_logic lab=PowerDown}
C {noconn.sym} 590 -730 3 1 {name=l2}
C {noconn.sym} 560 -730 3 1 {name=l3}
C {lab_wire.sym} 590 -720 1 1 {name=p10 sig_type=std_logic lab=VmasterN}
C {lab_wire.sym} 560 -720 1 1 {name=p11 sig_type=std_logic lab=VmasterP}
C {devices/code.sym} 60 -430 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {devices/launcher.sym} 40 -560 2 1 {name=h1
descr="Annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {code_shown.sym} -210 -1260 0 0 {name=NGSPICE
only_toplevel=true
value="
.include CACE\{DUT_path\}
.include CACE\{root\}/netlist/schematic/BiasCoarseFineInterface.spice
.include CACE\{root\}/netlist/schematic/BiasMasternCoarse.spice

xBiasMasternCoarse vdd gnd BiasCB<0> BiasCB<1> BiasCB<3> BiasCB<4> BiasCB<5> BiasCB<6> BiasCB<7> BiasCB<2> PowerDown VmasterN
+ VmasterP IR BiasMasternCoarse
xCoarse2Fine vdd gnd bit1 bit2 VGate_meas gnd BiasCoarseFineInterface


.temp CACE\{temperature\}

.option SEED=CACE[CACE\{seed=12345\} + CACE\{iterations=0\}]

* Flag unsafe operating conditions (exceeds models' specified limits)
.option warn=1

.param xvdd = CACE\{vdd\}
.param xpowerdown = 0
.param xIR = 100k
.param xcoarseCode = CACE\{coarseCode\}
.param xbit0 = (xcoarseCode%2 >= 1)?1:0
.param xbit1 = ((xcoarseCode/2)%2 >= 1)?1:0
.param xbit2 = ((xcoarseCode/4)%2 >= 1)?1:0

.save all

.control
op
write CACE\{filename\}_CACE\{N\}.raw
shell python CACE\{root\}/cace/scripts/tb_BiasCoarseBuffer_op.py CACE\{simpath\} CACE\{filename\} CACE\{N\}
.endc
"}
C {lab_wire.sym} 620 -430 1 0 {name=p12 sig_type=std_logic lab=IR}
C {lab_wire.sym} 560 -420 1 1 {name=p13 sig_type=std_logic lab=BiasCB<1>}
C {lab_wire.sym} 530 -420 1 1 {name=p14 sig_type=std_logic lab=BiasCB<2>}
C {lab_wire.sym} 500 -420 1 1 {name=p15 sig_type=std_logic lab=BiasCB<3>}
C {lab_wire.sym} 470 -420 1 1 {name=p16 sig_type=std_logic lab=BiasCB<4>}
C {lab_wire.sym} 440 -420 1 1 {name=p17 sig_type=std_logic lab=BiasCB<5>}
C {lab_wire.sym} 410 -420 1 1 {name=p18 sig_type=std_logic lab=BiasCB<6>}
C {lab_wire.sym} 380 -420 1 1 {name=p19 sig_type=std_logic lab=BiasCB<7>}
C {BiasCoarseBuffer.sym} 490 -130 0 0 {name=xCoarseBuf}
C {lab_wire.sym} 720 10 1 0 {name=p20 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 720 -290 1 1 {name=p21 sig_type=std_logic lab=vdd}
C {BiasCoarseFineInterface.sym} 830 -130 0 0 {name=xCoarse2Fine}
C {vsource.sym} 910 -150 1 1 {name=Vmeas_ICoarse value=0 savecurrent=true}
C {lab_wire.sym} 840 -150 2 0 {name=p22 sig_type=std_logic lab=VGate}
C {lab_wire.sym} 940 -150 2 0 {name=p23 sig_type=std_logic lab=VGate_meas}
C {lab_wire.sym} 1190 -190 0 0 {name=p24 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1060 10 3 1 {name=p25 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1060 -290 1 1 {name=p26 sig_type=std_logic lab=vdd}
C {vsource.sym} 970 -420 0 0 {name=Vbit0 value='xbit0*xvdd' savecurrent=true}
C {lab_wire.sym} 970 -340 3 1 {name=p27 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 970 -510 1 1 {name=p28 sig_type=std_logic lab=bit0}
C {vsource.sym} 1080 -420 0 0 {name=Vbit1 value='xbit1*xvdd' savecurrent=true}
C {lab_wire.sym} 1080 -340 3 1 {name=p29 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1080 -510 1 1 {name=p30 sig_type=std_logic lab=bit1}
C {vsource.sym} 1180 -420 0 0 {name=Vbit2 value='xbit2*xvdd' savecurrent=true}
C {lab_wire.sym} 1180 -340 3 1 {name=p31 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1180 -510 1 1 {name=p32 sig_type=std_logic lab=bit2}
C {lab_wire.sym} 740 20 1 0 {name=p33 sig_type=std_logic lab=bit0}
C {lab_wire.sym} 760 20 1 0 {name=p34 sig_type=std_logic lab=bit1}
C {lab_wire.sym} 780 20 1 0 {name=p35 sig_type=std_logic lab=bit2}
C {lab_wire.sym} 1080 20 1 0 {name=p36 sig_type=std_logic lab=bit1}
C {lab_wire.sym} 1100 20 1 0 {name=p37 sig_type=std_logic lab=bit2}
