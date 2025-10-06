v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 80 -200 80 -180 {lab=VMasterBiasP}
N 80 0 80 20 {lab=VMasterBiasN}
N 160 -110 200 -110 {lab=ICoarse1}
N 160 -70 200 -70 {lab=ICoarse2}
N 260 -110 310 -110 {lab=VddA18}
N 260 -70 310 -70 {lab=VddA18}
N 230 210 230 230 {lab=GND}
N 230 100 230 140 {lab=GndA}
N 350 200 350 210 {lab=GND}
N 230 210 350 210 {lab=GND}
N 230 200 230 210 {lab=GND}
N 350 100 350 140 {lab=VddA18}
N 10 0 10 40 {lab=GndA}
N 10 -220 10 -180 {lab=VddA18}
N -60 -0 -60 20 {lab=IR}
N -60 80 -60 120 {lab=GndA}
N -210 -90 -140 -90 {lab=BiasPowerDown}
N -210 -90 -210 -80 {lab=BiasPowerDown}
N -210 -20 -210 20 {lab=GndA}
C {BiasMasterBias.sym} 10 -90 0 0 {name=xMasterBias}
C {noconn.sym} 80 -200 1 0 {name=l1}
C {lab_wire.sym} 80 -190 3 1 {name=p1 sig_type=std_logic lab=VMasterBiasP
}
C {noconn.sym} 80 20 3 0 {name=l2}
C {lab_wire.sym} 80 10 1 1 {name=p2 sig_type=std_logic lab=VMasterBiasN
}
C {vsource.sym} 230 -110 1 0 {name=VMeasIC1 value=0 savecurrent=true}
C {vsource.sym} 230 -70 1 0 {name=VMeasIC2 value=0 savecurrent=true}
C {lab_wire.sym} 310 -110 0 1 {name=p3 sig_type=std_logic lab=VddA18

}
C {lab_wire.sym} 310 -70 0 1 {name=p4 sig_type=std_logic lab=VddA18

}
C {vsource.sym} 230 170 0 0 {name=Vgnd value=0 savecurrent=true
}
C {gnd.sym} 230 230 0 0 {name=l3 lab=GND}
C {lab_wire.sym} 230 100 1 1 {name=p5 sig_type=std_logic lab=GndA

}
C {vsource.sym} 350 170 0 0 {name=Vvdd value=xvdd18 savecurrent=true}
C {lab_wire.sym} 350 100 1 1 {name=p6 sig_type=std_logic lab=VddA18

}
C {lab_wire.sym} 10 40 3 1 {name=p7 sig_type=std_logic lab=GndA

}
C {lab_wire.sym} 10 -220 1 1 {name=p8 sig_type=std_logic lab=VddA18

}
C {res.sym} -60 50 0 0 {name=RIR
value="r=xir"
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} -60 120 3 1 {name=p9 sig_type=std_logic lab=GndA

}
C {lab_wire.sym} -60 10 3 1 {name=p10 sig_type=std_logic lab=IR

}
C {lab_wire.sym} 170 -110 0 1 {name=p11 sig_type=std_logic lab=ICoarse1

}
C {lab_wire.sym} 170 -70 0 1 {name=p12 sig_type=std_logic lab=ICoarse2

}
C {lab_wire.sym} -210 20 3 1 {name=p13 sig_type=std_logic lab=GndA

}
C {vsource.sym} -210 -50 0 0 {name=VPD value="pulse(1.8 0 xtPowerup xtRise xtRise 0.5 1000 1)" savecurrent=false }
C {devices/code.sym} -470 -270 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {devices/launcher.sym} -400 -350 2 1 {name=h1
descr="Annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {code_shown.sym} -950 -50 0 0 {name=NGSPICE
only_toplevel=true
value="
#.option reltol=1e-3 abstol=1e-12 vntol=1e-5 gmin=1e-10 
#.option trtol=6 chgtol=1e-12
.control
.param xvdd18 = 1.8
.param xir = 100k
.param xtPowerup = 10u
.param xtRise = 10n

save v(BiasPowerDown)
save v(VMasterBiasN)
save v(VMasterBiasP)
save v(GndA)
save v(VddA18)
save v(IR)
save v(xMasterBias.bootstrap)
save v(xMasterBias.VCasc)
save i(VMeasIC1)
save i(VMeasIC2)

tran .1n 100u

write test_BiasMasterBias_startup.raw
.endc
"}
C {lab_wire.sym} -210 -90 0 1 {name=p14 sig_type=std_logic lab=BiasPowerDown

}
