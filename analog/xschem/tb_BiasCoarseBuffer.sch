v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 340 -210 340 -200 {lab=GND!}
N 300 -200 340 -200 {lab=GND!}
N 270 -210 270 -200 {lab=GND!}
N 300 -200 300 -190 {lab=GND!}
N 270 -200 300 -200 {lab=GND!}
N 270 -300 270 -270 {lab=gnd}
N 340 -300 340 -270 {lab=vdd}
N 820 -770 820 -740 {lab=vdd}
N 820 -560 820 -530 {lab=gnd}
N 790 -560 790 -510 {lab=IR}
N 790 -450 790 -400 {lab=gnd}
N 760 -560 760 -430 {lab=BiasCB<0>}
N 700 -560 700 -430 {lab=BiasCB<2>}
N 670 -560 670 -430 {lab=BiasCB<3>}
N 610 -560 610 -430 {lab=BiasCB<5>}
N 550 -560 550 -430 {lab=BiasCB<7>}
N 70 -170 70 -130 {lab=gnd}
N 70 -310 70 -230 {lab=PowerDown}
N 790 -820 790 -740 {lab=PowerDown}
N 760 -830 760 -740 {lab=VmasterN}
N 730 -830 730 -740 {lab=VmasterP}
N 730 -560 730 -430 {lab=BiasCB<1>}
N 640 -560 640 -430 {lab=BiasCB<4>}
N 580 -560 580 -430 {lab=BiasCB<6>}
N 890 -140 890 -90 {lab=gnd}
N 890 -390 890 -360 {lab=vdd}
N 1000 -250 1050 -250 {lab=VGate}
N 1110 -250 1160 -250 {lab=VGate_meas}
N 1310 -290 1360 -290 {lab=gnd}
N 1230 -140 1230 -90 {lab=gnd}
N 1230 -390 1230 -360 {lab=vdd}
N 760 -370 760 -320 {lab=#net1}
N 760 -320 820 -320 {lab=#net1}
N 730 -370 730 -300 {lab=#net2}
N 730 -300 820 -300 {lab=#net2}
N 700 -370 700 -280 {lab=#net3}
N 700 -280 820 -280 {lab=#net3}
N 670 -370 670 -260 {lab=#net4}
N 670 -260 820 -260 {lab=#net4}
N 640 -370 640 -240 {lab=#net5}
N 640 -240 820 -240 {lab=#net5}
N 610 -370 610 -220 {lab=#net6}
N 610 -220 820 -220 {lab=#net6}
N 580 -370 580 -200 {lab=#net7}
N 580 -200 820 -200 {lab=#net7}
N 550 -370 550 -180 {lab=#net8}
N 550 -180 820 -180 {lab=#net8}
N 1140 -490 1140 -440 {lab=gnd}
N 1140 -610 1140 -550 {lab=bit0}
N 1250 -490 1250 -440 {lab=gnd}
N 1250 -610 1250 -550 {lab=bit1}
N 1350 -490 1350 -440 {lab=gnd}
N 1350 -610 1350 -550 {lab=bit2}
N 910 -140 910 -80 {lab=bit0}
N 930 -140 930 -80 {lab=bit1}
N 950 -140 950 -80 {lab=bit2}
N 1250 -140 1250 -80 {lab=bit1}
N 1270 -140 1270 -80 {lab=bit2}
C {vsource.sym} 270 -240 0 0 {name=Vgnd value=0 savecurrent=true}
C {gnd.sym} 300 -190 0 0 {name=l1 lab=GND!}
C {vsource.sym} 340 -240 0 0 {name=Vvdd value='xvdd' savecurrent=true}
C {lab_wire.sym} 270 -300 3 0 {name=p1 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 340 -300 3 0 {name=p4 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 820 -770 1 1 {name=p2 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 820 -530 1 0 {name=p3 sig_type=std_logic lab=gnd}
C {res.sym} 790 -480 0 1 {name=R1
value='xIR'
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 790 -400 1 0 {name=p5 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 760 -520 1 1 {name=p6 sig_type=std_logic lab=BiasCB<0>}
C {vsource.sym} 70 -200 0 0 {name=VpowerDown value='xpowerdown*xvdd' savecurrent=true}
C {lab_wire.sym} 70 -130 3 1 {name=p7 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 70 -310 3 0 {name=p8 sig_type=std_logic lab=PowerDown}
C {lab_wire.sym} 790 -820 1 1 {name=p9 sig_type=std_logic lab=PowerDown}
C {noconn.sym} 760 -830 3 1 {name=l2}
C {noconn.sym} 730 -830 3 1 {name=l3}
C {lab_wire.sym} 760 -820 1 1 {name=p10 sig_type=std_logic lab=VmasterN}
C {lab_wire.sym} 730 -820 1 1 {name=p11 sig_type=std_logic lab=VmasterP}
C {devices/code.sym} 230 -530 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {devices/launcher.sym} 210 -660 2 1 {name=h1
descr="Annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {code_shown.sym} -50 -1210 0 0 {name=NGSPICE
only_toplevel=true
value="

.temp 27

* Flag unsafe operating conditions (exceeds models' specified limits)
.option warn=1

.param xvdd = 1.8
.param xpowerdown = 0
.param xIR = 100k
.param xcoarseCode = 0
.param xbit0 = (xcoarseCode%2 >= 1)?1:0
.param xbit1 = ((xcoarseCode/2)%2 >= 1)?1:0
.param xbit2 = ((xcoarseCode/4)%2 >= 1)?1:0

.save all

.control
op
.endc
"}
C {lab_wire.sym} 790 -530 1 0 {name=p12 sig_type=std_logic lab=IR}
C {lab_wire.sym} 730 -520 1 1 {name=p13 sig_type=std_logic lab=BiasCB<1>}
C {lab_wire.sym} 700 -520 1 1 {name=p14 sig_type=std_logic lab=BiasCB<2>}
C {lab_wire.sym} 670 -520 1 1 {name=p15 sig_type=std_logic lab=BiasCB<3>}
C {lab_wire.sym} 640 -520 1 1 {name=p16 sig_type=std_logic lab=BiasCB<4>}
C {lab_wire.sym} 610 -520 1 1 {name=p17 sig_type=std_logic lab=BiasCB<5>}
C {lab_wire.sym} 580 -520 1 1 {name=p18 sig_type=std_logic lab=BiasCB<6>}
C {lab_wire.sym} 550 -520 1 1 {name=p19 sig_type=std_logic lab=BiasCB<7>}
C {BiasCoarseBuffer.sym} 660 -230 0 0 {name=xCoarseBuf}
C {BiasMasternCoarse.sym} 720 -650 0 1 {name=xBiasMasternCoarse}
C {vsource.sym} 760 -400 0 1 {name=Vmeas_BiasCB0 value=0 savecurrent=true}
C {vsource.sym} 730 -400 0 1 {name=Vmeas_BiasCB1 value=0 savecurrent=true}
C {vsource.sym} 700 -400 0 1 {name=Vmeas_BiasCB2 value=0 savecurrent=true}
C {vsource.sym} 670 -400 0 1 {name=Vmeas_BiasCB3 value=0 savecurrent=true}
C {vsource.sym} 640 -400 0 1 {name=Vmeas_BiasCB4 value=0 savecurrent=true}
C {vsource.sym} 610 -400 0 1 {name=Vmeas_BiasCB5 value=0 savecurrent=true}
C {vsource.sym} 580 -400 0 1 {name=Vmeas_BiasCB6 value=0 savecurrent=true}
C {vsource.sym} 550 -400 0 1 {name=Vmeas_BiasCB7 value=0 savecurrent=true}
C {lab_wire.sym} 890 -90 1 0 {name=p20 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 890 -390 1 1 {name=p21 sig_type=std_logic lab=vdd}
C {BiasCoarseFineInterface.sym} 1000 -230 0 0 {name=xCoarse2Fine}
C {vsource.sym} 1080 -250 1 1 {name=Vmeas_ICoarse value=0 savecurrent=true}
C {lab_wire.sym} 1010 -250 2 0 {name=p22 sig_type=std_logic lab=VGate}
C {lab_wire.sym} 1110 -250 2 0 {name=p23 sig_type=std_logic lab=VGate_meas}
C {lab_wire.sym} 1360 -290 0 0 {name=p24 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1230 -90 3 1 {name=p25 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1230 -390 1 1 {name=p26 sig_type=std_logic lab=vdd}
C {vsource.sym} 1140 -520 0 0 {name=Vbit0 value='xbit0*xvdd' savecurrent=true}
C {lab_wire.sym} 1140 -440 3 1 {name=p27 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1140 -610 1 1 {name=p28 sig_type=std_logic lab=bit0}
C {vsource.sym} 1250 -520 0 0 {name=Vbit1 value='xbit1*xvdd' savecurrent=true}
C {lab_wire.sym} 1250 -440 3 1 {name=p29 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1250 -610 1 1 {name=p30 sig_type=std_logic lab=bit1}
C {vsource.sym} 1350 -520 0 0 {name=Vbit2 value='xbit2*xvdd' savecurrent=true}
C {lab_wire.sym} 1350 -440 3 1 {name=p31 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1350 -610 1 1 {name=p32 sig_type=std_logic lab=bit2}
C {lab_wire.sym} 910 -80 1 0 {name=p33 sig_type=std_logic lab=bit0}
C {lab_wire.sym} 930 -80 1 0 {name=p34 sig_type=std_logic lab=bit1}
C {lab_wire.sym} 950 -80 1 0 {name=p35 sig_type=std_logic lab=bit2}
C {lab_wire.sym} 1250 -80 1 0 {name=p36 sig_type=std_logic lab=bit1}
C {lab_wire.sym} 1270 -80 1 0 {name=p37 sig_type=std_logic lab=bit2}
