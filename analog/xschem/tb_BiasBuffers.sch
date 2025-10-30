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
N 70 -170 70 -130 {lab=gnd}
N 70 -310 70 -230 {lab=PowerDown}
N 1000 -240 1000 -190 {lab=gnd}
N 1000 -360 1000 -300 {lab=bit0}
N 1110 -240 1110 -190 {lab=gnd}
N 1110 -360 1110 -300 {lab=bit1}
N 1210 -240 1210 -190 {lab=gnd}
N 1210 -360 1210 -300 {lab=bit2}
N 790 -650 790 -590 {lab=bit0}
N 810 -650 810 -590 {lab=bit1}
N 830 -650 830 -590 {lab=bit2}
N 490 -810 490 -760 {lab=iin}
N 490 -760 660 -760 {lab=iin}
N 490 -900 490 -870 {lab=vdd}
N 1340 -490 1380 -490 {lab=gnd}
N 1340 -460 1340 -380 {lab=gnd}
N 980 -760 1180 -760 {lab=vout}
N 1180 -760 1180 -490 {lab=vout}
N 1180 -490 1300 -490 {lab=vout}
N 1340 -570 1340 -520 {lab=drain_nMeasOut}
N 1340 -660 1340 -630 {lab=vdd}
N 1180 -960 1180 -760 {lab=vout}
N 1180 -960 1310 -960 {lab=vout}
N 1350 -830 1350 -800 {lab=gnd}
N 1350 -930 1350 -890 {lab=drain_pMeasOut}
N 1350 -1020 1350 -990 {lab=vdd}
N 1350 -960 1380 -960 {lab=vdd}
N 530 -300 570 -300 {lab=gnd}
N 450 -300 490 -300 {lab=BufferNBias}
N 450 -360 450 -300 {lab=BufferNBias}
N 450 -360 530 -360 {lab=BufferNBias}
N 530 -360 530 -330 {lab=BufferNBias}
N 530 -390 530 -360 {lab=BufferNBias}
N 530 -270 530 -230 {lab=gnd}
N 530 -480 530 -450 {lab=vdd}
N 750 -650 750 -570 {lab=BufferNBias}
N 760 -470 760 -440 {lab=vdd}
N 760 -410 790 -410 {lab=vdd}
N 680 -410 720 -410 {lab=BufferPBias}
N 680 -410 680 -340 {lab=BufferPBias}
N 760 -340 760 -300 {lab=BufferPBias}
N 760 -240 760 -200 {lab=gnd}
N 680 -340 760 -340 {lab=BufferPBias}
N 760 -380 760 -340 {lab=BufferPBias}
N 750 -950 750 -870 {lab=BufferPBias}
N 730 -900 730 -870 {lab=vdd}
N 810 -900 810 -870 {lab=gnd}
N 790 -960 790 -870 {lab=PowerDown}
N 850 -650 850 -560 {lab=BiasDisabled}
N 870 -650 870 -560 {lab=BiasEnabled}
N 890 -650 890 -560 {lab=NBiasEnabled}
N 910 -650 910 -560 {lab=PBiasEnabled}
N 730 -650 730 -610 {lab=gnd}
N -220 -170 -220 -130 {lab=gnd}
N -220 -310 -220 -230 {lab=BiasEnabled}
N -80 -170 -80 -130 {lab=gnd}
N -80 -310 -80 -230 {lab=BiasDisabled}
N -220 -390 -220 -350 {lab=gnd}
N -220 -530 -220 -450 {lab=NBiasEnabled}
N -80 -390 -80 -350 {lab=gnd}
N -80 -530 -80 -450 {lab=PBiasEnabled}
C {vsource.sym} 270 -240 0 0 {name=Vgnd value=0 savecurrent=true}
C {gnd.sym} 300 -190 0 0 {name=l1 lab=GND!}
C {vsource.sym} 340 -240 0 0 {name=Vvdd value='xvdd' savecurrent=true}
C {lab_wire.sym} 270 -300 3 0 {name=p1 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 340 -300 3 0 {name=p4 sig_type=std_logic lab=vdd}
C {vsource.sym} 70 -200 0 0 {name=VpowerDown value='xpowerdown*xvdd' savecurrent=true}
C {lab_wire.sym} 70 -130 3 1 {name=p7 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 70 -310 3 0 {name=p8 sig_type=std_logic lab=PowerDown}
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
C {code_shown.sym} -240 -1200 0 0 {name=NGSPICE
only_toplevel=true
value="

.temp 27

* Flag unsafe operating conditions (exceeds models' specified limits)
.option warn=1

.param xvdd = 1.8
.param xpowerdown = 0
.param xIR = 100k
.param xcoarseCode = 0
.param xBiasEnabled = 1
.param xNBias = 0
.param xIin = 100n
.param xIBufferN = 400n
.param xIBufferP = 400n
.param xbit0 = (xcoarseCode%2 >= 1)?1:0
.param xbit1 = ((xcoarseCode/2)%2 >= 1)?1:0
.param xbit2 = ((xcoarseCode/4)%2 >= 1)?1:0


.save v(@m.xbuf.xMnMirrBuffBias.msky130_fd_pr__nfet_01v8_lvt[vdsat])
.save v(@m.xbuf.xMnMirrBuffBias.msky130_fd_pr__nfet_01v8_lvt[vth])
.save @m.xbuf.xMnMirrBuffBias.msky130_fd_pr__nfet_01v8_lvt[id]
.save v(@m.xbuf.xMnMirrBuffBias.msky130_fd_pr__nfet_01v8_lvt[vgs])
.save i(@x.xbuf[SplitterOutput])

.save all

*.dc Iin 1p 10u 1000p
.op
"}
C {vsource.sym} 1000 -270 0 0 {name=Vbit0 value='xbit0*xvdd' savecurrent=true}
C {lab_wire.sym} 1000 -190 3 1 {name=p27 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1000 -360 1 1 {name=p28 sig_type=std_logic lab=bit0}
C {vsource.sym} 1110 -270 0 0 {name=Vbit1 value='xbit1*xvdd' savecurrent=true}
C {lab_wire.sym} 1110 -190 3 1 {name=p29 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1110 -360 1 1 {name=p30 sig_type=std_logic lab=bit1}
C {vsource.sym} 1210 -270 0 0 {name=Vbit2 value='xbit2*xvdd' savecurrent=true}
C {lab_wire.sym} 1210 -190 3 1 {name=p31 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1210 -360 1 1 {name=p32 sig_type=std_logic lab=bit2}
C {BiasBuffers.sym} 500 -740 0 0 {name=xBuf}
C {lab_wire.sym} 790 -590 3 1 {name=p38 sig_type=std_logic lab=bit0}
C {lab_wire.sym} 810 -590 3 1 {name=p39 sig_type=std_logic lab=bit1}
C {lab_wire.sym} 830 -590 3 1 {name=p40 sig_type=std_logic lab=bit2}
C {isource.sym} 490 -840 0 0 {name=Iin value='xIin'}
C {lab_wire.sym} 490 -900 1 1 {name=p41 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/nfet_01v8.sym} 1320 -490 0 0 {name=MnMeasOut
W=6
L=6
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
C {lab_wire.sym} 1380 -490 2 1 {name=p42 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1340 -380 3 1 {name=p43 sig_type=std_logic lab=gnd}
C {vsource.sym} 1340 -600 0 1 {name=Vmeas_Iout_nmos value=0 savecurrent=true}
C {lab_wire.sym} 1340 -660 1 1 {name=p44 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/pfet_01v8.sym} 1330 -960 0 0 {name=MpMeasOut
W=6
L=3
nf=1
mult=2
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {vsource.sym} 1350 -860 0 1 {name=Vmeas_Iout_pmos value=0 savecurrent=true}
C {lab_wire.sym} 1350 -800 3 1 {name=p45 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1350 -1020 1 1 {name=p46 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1380 -960 2 1 {name=p47 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1350 -900 3 1 {name=p48 sig_type=std_logic lab=drain_pMeasOut}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 510 -300 0 0 {name=MnMirrBuffBias
W=6
L=6
nf=1 
mult=16
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {lab_wire.sym} 530 -230 3 1 {name=p49 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 570 -300 2 1 {name=p50 sig_type=std_logic lab=gnd}
C {isource.sym} 530 -420 0 0 {name=Ibias_BufferN value='xIBufferN'}
C {lab_wire.sym} 530 -480 1 1 {name=p51 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 450 -360 0 1 {name=p52 sig_type=std_logic lab=BufferNBias}
C {lab_wire.sym} 750 -570 3 1 {name=p53 sig_type=std_logic lab=BufferNBias}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 740 -410 0 0 {name=MpMirrBuffBias
W=6
L=3
nf=1
mult=2
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {lab_wire.sym} 760 -470 1 1 {name=p54 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 790 -410 2 1 {name=p55 sig_type=std_logic lab=vdd}
C {isource.sym} 760 -270 0 0 {name=Ibias_bufferP value='xIBufferP'}
C {lab_wire.sym} 760 -200 3 1 {name=p56 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 680 -340 0 1 {name=p57 sig_type=std_logic lab=BufferPBias}
C {lab_wire.sym} 750 -950 3 0 {name=p58 sig_type=std_logic lab=BufferPBias}
C {lab_wire.sym} 730 -900 3 0 {name=p59 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 790 -960 3 0 {name=p60 sig_type=std_logic lab=PowerDown}
C {lab_wire.sym} 810 -900 3 0 {name=p61 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 850 -560 3 1 {name=p62 sig_type=std_logic lab=BiasDisabled}
C {lab_wire.sym} 870 -560 3 1 {name=p63 sig_type=std_logic lab=BiasEnabled}
C {lab_wire.sym} 890 -560 3 1 {name=p64 sig_type=std_logic lab=NBiasEnabled}
C {lab_wire.sym} 910 -560 3 1 {name=p65 sig_type=std_logic lab=PBiasEnabled}
C {lab_wire.sym} 730 -610 3 1 {name=p66 sig_type=std_logic lab=gnd}
C {vsource.sym} -220 -200 0 0 {name=VbiasEnabled value='xbiasEnabled*xvdd' savecurrent=false}
C {lab_wire.sym} -220 -130 3 1 {name=VbiasEnabled1 sig_type=std_logic lab=gnd
value='(1-xbiasEnabled)*xvdd'
savecurrent=false}
C {vsource.sym} -80 -200 0 0 {name=VbiasEnabled3 value='(1-xbiasEnabled)*xvdd' savecurrent=false}
C {lab_wire.sym} -80 -130 3 1 {name=VbiasEnabled4 sig_type=std_logic lab=gnd
value='(1-xbiasEnabled)*xvdd'
savecurrent=false}
C {lab_wire.sym} -220 -310 3 0 {name=p2 sig_type=std_logic lab=BiasEnabled}
C {lab_wire.sym} -80 -310 3 0 {name=p3 sig_type=std_logic lab=BiasDisabled}
C {vsource.sym} -220 -420 0 0 {name=VbiasEnabled2 value='xNBias*xvdd' savecurrent=false}
C {lab_wire.sym} -220 -350 3 1 {name=VbiasEnabled5 sig_type=std_logic lab=gnd
value='(1-xbiasEnabled)*xvdd'
savecurrent=false}
C {vsource.sym} -80 -420 0 0 {name=VbiasEnabled6 value='(1-xNBias)*xvdd' savecurrent=false}
C {lab_wire.sym} -80 -350 3 1 {name=VbiasEnabled7 sig_type=std_logic lab=gnd
value='(1-xbiasEnabled)*xvdd'
savecurrent=false}
C {lab_wire.sym} -220 -530 3 0 {name=p5 sig_type=std_logic lab=NBiasEnabled}
C {lab_wire.sym} -80 -530 3 0 {name=p6 sig_type=std_logic lab=PBiasEnabled}
C {lab_wire.sym} 570 -760 2 1 {name=p9 sig_type=std_logic lab=iin}
C {lab_wire.sym} 1070 -760 2 1 {name=p10 sig_type=std_logic lab=vout}
C {lab_wire.sym} 1340 -540 3 1 {name=p11 sig_type=std_logic lab=drain_nMeasOut}
