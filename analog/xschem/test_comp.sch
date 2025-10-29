v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -340 280 -340 290 {lab=GND!}
N -340 280 -260 280 {lab=GND!}
N -260 270 -260 280 {lab=GND!}
N -260 190 -260 210 {lab=vdd}
N -340 190 -340 210 {lab=gnd}
N 690 -250 690 -190 {lab=vcm}
N 1100 120 1100 150 {lab=bias_comp}
N 1100 210 1100 260 {lab=gnd}
N 1100 180 1140 180 {lab=gnd}
N 1010 180 1060 180 {lab=bias_comp}
N 1010 120 1010 180 {lab=bias_comp}
N 1010 120 1100 120 {lab=bias_comp}
N 1100 90 1100 120 {lab=bias_comp}
N -340 270 -340 280 {lab=GND!}
N 1380 110 1380 140 {lab=bias_comp_p}
N 1380 0 1380 30 {lab=vdd}
N 1300 60 1340 60 {lab=bias_comp_p}
N 1300 60 1300 110 {lab=bias_comp_p}
N 1300 110 1380 110 {lab=bias_comp_p}
N 1380 60 1415 60 {lab=vdd}
N 1380 90 1380 110 {lab=bias_comp_p}
N 1380 200 1380 250 {lab=gnd}
N 1100 0 1100 30 {lab=vdd}
N 810 -250 810 -190 {lab=clk}
N 810 -130 810 -80 {lab=gnd}
N 900 -280 900 -220 {lab=clk_not}
N 900 -160 900 -110 {lab=gnd}
N 810 -190 810 -180 {lab=clk}
N 900 -170 900 -160 {lab=gnd}
N 10 665 10 695 {lab=gnd}
N 10 -325 10 -255 {lab=vout_sense}
N 10 520 10 550 {lab=Vr}
N 10 600 10 610 {lab=#net1}
N 690 -130 690 -80 {lab=gnd}
N -130 -640 60 -640 {lab=vout_sense}
N 380 -510 380 -490 {lab=gnd}
N 340 -510 340 -490 {lab=vdd}
N 180 -680 280 -680 {lab=vcm}
N 240 -610 280 -610 {lab=clk}
N 240 -710 280 -710 {lab=clk_not}
N 420 -670 540 -670 {lab=vcompp_dyn}
N 60 -640 280 -640 {lab=vout_sense}
N 420 -650 540 -650 {lab=vcompn_dyn}
N 340 -580 340 -570 {lab=#net2}
N 340 -580 350 -580 {lab=#net2}
N 350 -600 350 -580 {lab=#net2}
N 370 -600 370 -580 {lab=#net3}
N 370 -580 380 -580 {lab=#net3}
N 380 -580 380 -570 {lab=#net3}
N 240 -700 280 -700 {lab=clk}
C {devices/code.sym} 890 -660 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {code_shown.sym} -1015 -480 0 0 {name=NGSPICE
only_toplevel=true
value="* sim
*.option reltol=1e-3 abstol=1e-12 vntol=1e-5 gmin=1e-10 
*.option trtol=6 chgtol=1e-12

.param big = 0.08
.param medium = 0.01
.param small = 0.002
.param xvcm = 0.6
.param xvcm_low = \{xvcm - 0.001\}
.param xvcm_high = \{xvcm + 0.001\}
.param xipd = 1e-9
.param xvph_bias = 1.5
.param xisf_bias = 9.2n
.param xvcascn = 0.2
.param xvcascp = 1.6
.param xicol_bias = 5e-7
.param xvtail = 0.5
.param xvdd = 1.8
.param xibias_cascp = 50n
.param xibias_cascn = 50n
.param xibias_comp = 50n
.param xibias_comp_p = 50n


.control
* plot v(vout_sense)
save v(vout_sense)
save v(vcomp)
save all
tran .1n 30u
*ac dec 20 1 1e10

* save v(vphoto) v(vph_sf) v(vin) v(sense) v(feedback) v(vcomp)
* save v(pix_rst) v(vout) v(pbchk) v(vref) v(row_sel) v(lrst)
* save v(vcompp_dyn) v(vcompn_dyn)
*plot db20(v(vcompp_dyn_v2)/v(Vr))
*ic v(vin)=0.6
*ic v(vout)=1
* dc vph 0 1.8 10m
*save all
* op
write test_comp.raw
.endc

*plot db(v(vcompp_dyn_v2) 180*cph(v(vcompp_dyn_2))/pi

"}
C {devices/launcher.sym} 960 -740 2 1 {name=h1
descr="Annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {vsource.sym} -340 240 0 0 {name=Vgnd value=0 savecurrent=false}
C {gnd.sym} -340 290 0 0 {name=l1 lab=GND!}
C {vsource.sym} -260 240 0 0 {name=Vvdd value=xvdd savecurrent=false}
C {lab_wire.sym} -340 190 0 0 {name=p1 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -260 190 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {vsource.sym} 690 -160 0 0 {name=vrst_dc value=xvcm savecurrent=false}
C {lab_wire.sym} 690 -250 0 1 {name=p32 sig_type=std_logic lab=vcm}
C {lab_wire.sym} 1140 180 0 0 {name=p33 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1100 260 0 0 {name=vcascp11 sig_type=std_logic lab=gnd
value=xcascp}
C {isource.sym} 1100 60 0 0 {name=Ibias_cascp1 value=xibias_comp}
C {lab_wire.sym} 1060 120 0 0 {name=vcascp12 sig_type=std_logic lab=bias_comp}
C {sky130_fd_pr/nfet_01v8.sym} 1080 180 0 0 {name=Mbias_comp
W=1
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
C {isource.sym} 1380 170 0 0 {name=Ibias_cascp2 value=xibias_comp_p}
C {sky130_fd_pr/pfet_01v8.sym} 1360 60 0 0 {name=Mbias_cascn2
W=1
L=0.5
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
C {lab_wire.sym} 1380 0 0 0 {name=p43 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1330 110 2 1 {name=vcascp14 sig_type=std_logic lab=bias_comp_p
}
C {lab_wire.sym} 1415 60 0 0 {name=p45 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1380 250 0 0 {name=vcascp15 sig_type=std_logic lab=gnd
value=xcascp}
C {lab_wire.sym} 1100 0 0 0 {name=p25 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 810 -80 0 0 {name=vcascp7 sig_type=std_logic lab=gnd
value=xcascp}
C {lab_wire.sym} 810 -250 0 1 {name=p15 sig_type=std_logic lab=clk}
C {lab_wire.sym} 900 -110 0 0 {name=vcascp8 sig_type=std_logic lab=gnd
value=xcascp}
C {lab_wire.sym} 900 -280 0 1 {name=p16 sig_type=std_logic lab=clk_not}
C {vsource.sym} 810 -155 0 0 {name=Vclock value="pulse(0 \{xvdd\} 0.1u 10n 10n 0.25u 0.5u)" savecurrent=false}
C {vsource.sym} 900 -195 0 0 {name=Vclock_not value="pulse(\{xvdd\} 0 0.1u 10n 10n 0.25u 0.5u)" savecurrent=false}
C {lab_wire.sym} 10 -325 3 0 {name=p17 sig_type=std_logic lab=vout_sense}
C {vsource.sym} 10 315 2 0 {name=Vsmall_high1 value="pulse(0 \{small\} 12u 1n 1n 1u 400u)" savecurrent=false}
C {vsource.sym} 10 495 0 0 {name=Vbig_high1 value="pulse(0 \{big\} 2u 1n 1n 1u 400u)" savecurrent=false}
C {vsource.sym} 10 375 0 0 {name=Vbig_gradual_high1 value="pulse(0 \{big\} 6u 1.4u 1.4u 2u 400u)" savecurrent=false}
C {lab_wire.sym} 10 690 0 1 {name=p18 sig_type=std_logic lab=gnd}
C {vsource.sym} 10 195 2 0 {name=Vbig_gradual_low1 value="pulse(0 \{big\} 15u 1.4u 1.4u 2u 400u)" savecurrent=false}
C {vsource.sym} 10 135 0 0 {name=Vsmall_low2 value="pulse(0 \{small\} 20u 1n 1n 1u 400u)" savecurrent=false}
C {vsource.sym} 10 575 0 0 {name=Vgrd1 value="pulse(\{xvcm_high\} \{xvcm_low\} 0 1n 1n 16u 400u)" savecurrent=false}
C {vsource.sym} 10 15 2 0 {name=Vbig_low1 value="pulse(0 \{big\} 24u 1n 1n 1u 400u)" savecurrent=false}
C {lab_pin.sym} 10 540 0 0 {name=p19 sig_type=std_logic lab=Vr}
C {vsource.sym} 10 435 2 0 {name=Vmedium_high1 value="pulse(0 \{medium\} 4u 1n 1n 1u 400u)" savecurrent=false}
C {vsource.sym} 10 -225 0 0 {name=Vmedium_low1 value="pulse(0 \{medium\} 29u 1n 1n 1u 400u)" savecurrent=false}
C {vsource.sym} 10 640 0 0 {name=Vac1 
value="dc 0 Ac 0.1"
savecurrent=false}
C {vsource.sym} 10 255 0 0 {name=Vsmall_high2 value="pulse(0 \{small\} 13u 1n 1n 1u 400u)" savecurrent=false}
C {vsource.sym} 10 75 2 0 {name=Vsmall_low3 value="pulse(0 \{small\} 21u 1n 1n 1u 400u)" savecurrent=false}
C {vsource.sym} 10 -165 2 0 {name=Vmedium_low2 value="pulse(0 \{medium\} 28u 1n 1n 1u 400u)" savecurrent=false}
C {vsource.sym} 10 -105 0 0 {name=Vmedium_low3 value="pulse(0 \{medium\} 27u 1n 1n 1u 400u)" savecurrent=false}
C {vsource.sym} 10 -45 2 0 {name=Vmedium_low4 value="pulse(0 \{medium\} 26u 1n 1n 1u 400u)" savecurrent=false}
C {lab_wire.sym} 690 -80 0 0 {name=vcascp10 sig_type=std_logic lab=gnd
value=xcascp}
C {lab_wire.sym} 380 -490 3 0 {name=p3 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 340 -490 3 0 {name=p5 sig_type=std_logic lab=vdd}
C {ipin.sym} 180 -680 0 0 {name=p6 lab=vcm}
C {lab_wire.sym} 0 -640 0 0 {name=p7 sig_type=std_logic lab=vout_sense
}
C {lab_wire.sym} 240 -610 0 0 {name=vcascp1 sig_type=std_logic lab=clk}
C {lab_wire.sym} 240 -710 0 0 {name=vcascp5 sig_type=std_logic lab=clk_not
}
C {opin.sym} 540 -670 0 0 {name=p14 lab=vcompp_dyn
}
C {opin.sym} 540 -650 0 0 {name=p20 lab=vcompn_dyn}
C {vsource.sym} 340 -540 0 1 {name=Vgnd1 value=0 savecurrent=false}
C {vsource.sym} 380 -540 0 0 {name=Vgnd2 value=0 savecurrent=false}
C {dyn_comp.sym} 290 -550 0 0 {name=x1}
C {lab_wire.sym} 240 -700 0 0 {name=vcascp6 sig_type=std_logic lab=clk
}
