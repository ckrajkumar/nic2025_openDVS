v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 1550 -260 1550 -200 {lab=pbias}
N 1550 -380 1550 -350 {lab=VDD}
N 1520 -320 1550 -320 {lab=vdd}
N 1630 -320 1630 -260 {lab=pbias}
N 1550 -260 1630 -260 {lab=pbias}
N 1630 -320 1690 -320 {lab=pbias}
N 570 -670 570 -610 {lab=sense}
N 590 -670 590 -610 {lab=feedback}
N 610 -670 610 -610 {lab=pix_rst}
N 1840 -280 1840 -250 {lab=sf_bias}
N 1890 -280 1890 -220 {lab=sf_bias}
N 1840 -190 1840 -140 {lab=gnd}
N 1880 -220 1890 -220 {lab=sf_bias}
N 1840 -280 1890 -280 {lab=sf_bias}
N 1890 -220 1940 -220 {lab=sf_bias}
N 1840 -380 1840 -350 {lab=vdd}
N 710 -125 710 -95 {lab=gnd}
N 1030 -220 1030 -170 {lab=gnd}
N 1030 -310 1030 -280 {lab=vph_bias}
N 450 -340 450 -310 {lab=gnd}
N 450 -450 450 -400 {lab=vpd}
N 450 -450 480 -450 {lab=vpd}
N 430 -510 480 -510 {lab=sf_bias}
N 430 -490 480 -490 {lab=vref}
N 430 -530 480 -530 {lab=vph_bias}
N 460 -130 460 -120 {lab=GND!}
N 460 -130 540 -130 {lab=GND!}
N 540 -140 540 -130 {lab=GND!}
N 540 -220 540 -200 {lab=vdd}
N 460 -220 460 -200 {lab=gnd}
N 540 -400 540 -380 {lab=gnd}
N 570 -400 570 -380 {lab=vdd}
N 740 -850 740 -830 {lab=gnd}
N 720 -850 720 -830 {lab=vdd}
N 780 -770 830 -770 {lab=vcomp}
N 650 -850 650 -830 {lab=pbias}
N 630 -850 630 -830 {lab=nbias}
N 1070 -490 1070 -440 {lab=gnd}
N 1070 -600 1070 -550 {lab=nbias}
N 1160 -490 1160 -440 {lab=gnd}
N 1160 -600 1160 -550 {lab=vcascn}
N 1250 -490 1250 -440 {lab=gnd}
N 1250 -600 1250 -550 {lab=vcascp}
N 600 -850 600 -830 {lab=bias_comp}
N 580 -850 580 -830 {lab=vcascn}
N 560 -850 560 -830 {lab=vcascp}
N 540 -850 540 -830 {lab=bias_amp_cascn}
N 520 -850 520 -830 {lab=bias_amp_cascp}
N 1560 -620 1560 -590 {lab=bias_amp_cascp}
N 1560 -530 1560 -480 {lab=gnd}
N 1560 -560 1600 -560 {lab=gnd}
N 1470 -560 1520 -560 {lab=bias_amp_cascp}
N 1470 -620 1470 -560 {lab=bias_amp_cascp}
N 1470 -620 1560 -620 {lab=bias_amp_cascp}
N 1560 -650 1560 -620 {lab=bias_amp_cascp}
N 1560 -740 1560 -710 {lab=vdd}
N 1860 -630 1860 -590 {lab=bias_amp_cascn}
N 1860 -530 1860 -480 {lab=gnd}
N 1860 -740 1860 -710 {lab=vdd}
N 1780 -680 1820 -680 {lab=bias_amp_cascn}
N 1780 -680 1780 -630 {lab=bias_amp_cascn}
N 1780 -630 1860 -630 {lab=bias_amp_cascn}
N 940 -590 940 -530 {lab=vcm}
N 940 -470 940 -420 {lab=gnd}
N 670 -850 670 -830 {lab=vcm}
N 2150 -620 2150 -590 {lab=bias_comp}
N 2150 -530 2150 -480 {lab=gnd}
N 2150 -560 2190 -560 {lab=gnd}
N 2060 -560 2110 -560 {lab=bias_comp}
N 2060 -620 2060 -560 {lab=bias_comp}
N 2060 -620 2150 -620 {lab=bias_comp}
N 2150 -650 2150 -620 {lab=bias_comp}
N 2150 -740 2150 -710 {lab=vdd}
N 1860 -680 1895 -680 {lab=vdd}
N 1800 -220 1840 -220 {lab=gnd}
N 1550 -140 1550 -110 {lab=gnd}
N 710 -195 710 -185 {lab=#net1}
N 710 -325 710 -255 {lab=vref}
N 1590 -320 1630 -320 {lab=pbias}
N 1550 -290 1550 -260 {lab=pbias}
N 1840 -290 1840 -280 {lab=sf_bias}
N 460 -140 460 -130 {lab=GND!}
N 1860 -650 1860 -630 {lab=bias_amp_cascn}
N 270 -550 480 -550 {lab=row_sel}
N 270 -550 270 -540 {lab=row_sel}
N 270 -480 270 -450 {lab=gnd}
N 1170 -205 1170 -175 {lab=gnd}
N 1170 -320 1170 -260 {lab=pix_rst}
N 690 -850 690 -830 {lab=vcm}
N 1400 -280 1400 -260 {lab=n_pix_rst}
N 1400 -200 1400 -150 {lab=gnd}
N 1400 -340 1400 -280 {lab=n_pix_rst}
N 630 -670 630 -610 {lab=n_pix_rst}
C {devices/code.sym} 970 -830 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {code_shown.sym} 415 -1680 0 0 {name=NGSPICE
only_toplevel=true
value="* sim
*.option reltol=1e-3 abstol=1e-12 vntol=1e-5 gmin=1e-10 
*.option trtol=6 chgtol=1e-12

.control
.param xipd = 1e-9
.param xvph_bias = 1.5
.param xisf_bias = 9.2n
.param xvcascn = 0.2
.param xvcascp = 1.6
.param xicol_bias = 5e-7
.param xvtail = 0.5
.param xvcm = 0.6
.param xvdd = 1.8
.param xibias_cascp = 50n
.param xibias_cascn = 50n
.param xibias_comp = 50n
tran .1n 29u
* plot v(vref) v(sense) v(feedback) v(pix_rst)
save v(vref) v(sense) v(feedback) v(pix_rst)
save v(vcomp) v(xcol_amp.vout_sense)
*save i(xpix:vpd)

* save v(vphoto) v(vph_sf) v(vin) v(sense) v(feedback) v(vcomp)
* save v(pix_rst) v(vout) v(pbchk) v(vref) v(row_sel) v(lrst)
*ic v(vin)=0.6
*ic v(vout)=1
* dc vph 0 1.8 10m
*save all
* op
write 1x1array_tb.raw
.endc
"}
C {devices/launcher.sym} 1040 -910 2 1 {name=h1
descr="Annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {isource.sym} 1550 -170 0 0 {name=Ipb value=xicol_bias}
C {sky130_fd_pr/pfet_01v8.sym} 1570 -320 0 1 {name=M14
W=3
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
C {vdd.sym} 1550 -380 0 0 {name=l36 lab=VDD}
C {col_amp.sym} 630 -710 0 0 {name=xcol_amp}
C {openDVS_pixel.sym} 630 -480 0 0 {name=xpix}
C {sky130_fd_pr/nfet_01v8.sym} 1860 -220 0 1 {name=M1
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
C {isource.sym} 1840 -320 0 0 {name=Iipd1 value=xisf_bias}
C {lab_wire.sym} 1840 -140 0 0 {name=p3 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1940 -220 0 0 {name=p5 sig_type=std_logic lab=sf_bias}
C {lab_wire.sym} 1840 -380 0 0 {name=p6 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 710 -95 0 0 {name=Vvref1 sig_type=std_logic lab=gnd
value=vref}
C {vsource.sym} 1030 -250 0 0 {name=Vvph_bias value=xvph_bias savecurrent=false}
C {lab_wire.sym} 1030 -170 0 0 {name=Vvref4 sig_type=std_logic lab=gnd
value=vref}
C {lab_wire.sym} 1030 -310 0 0 {name=Vvref5 sig_type=std_logic lab=vph_bias
value=vph_bias}
C {lab_wire.sym} 450 -310 0 0 {name=p2 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 430 -510 0 0 {name=p7 sig_type=std_logic lab=sf_bias}
C {lab_wire.sym} 430 -490 0 0 {name=p10 sig_type=std_logic lab=vref}
C {lab_wire.sym} 430 -530 0 0 {name=p15 sig_type=std_logic lab=vph_bias}
C {lab_wire.sym} 450 -430 0 0 {name=p8 sig_type=std_logic lab=vpd}
C {vsource.sym} 460 -170 0 0 {name=Vgnd value=0 savecurrent=false}
C {gnd.sym} 460 -120 0 0 {name=l1 lab=GND!}
C {vsource.sym} 540 -170 0 0 {name=Vvdd value=xvdd savecurrent=false}
C {lab_wire.sym} 460 -220 0 0 {name=p1 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 540 -220 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 540 -380 3 0 {name=p9 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 570 -380 3 0 {name=p11 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 740 -850 3 1 {name=p12 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 720 -850 3 1 {name=p14 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 570 -650 3 0 {name=p16 sig_type=std_logic lab=sense}
C {lab_wire.sym} 610 -650 3 0 {name=p17 sig_type=std_logic lab=pix_rst}
C {lab_wire.sym} 590 -650 3 0 {name=p18 sig_type=std_logic lab=feedback}
C {lab_wire.sym} 1690 -320 0 0 {name=p19 sig_type=std_logic lab=pbias}
C {lab_wire.sym} 830 -770 2 0 {name=p20 sig_type=std_logic lab=vcomp}
C {lab_wire.sym} 650 -850 3 1 {name=p21 sig_type=std_logic lab=pbias}
C {lab_wire.sym} 630 -850 3 1 {name=p22 sig_type=std_logic lab=nbias
}
C {vsource.sym} 1070 -520 0 0 {name=vtail value=xvtail savecurrent=false}
C {lab_wire.sym} 1070 -440 0 0 {name=Vvref3 sig_type=std_logic lab=gnd
value=vref}
C {lab_wire.sym} 1070 -600 0 0 {name=p23 sig_type=std_logic lab=nbias}
C {vsource.sym} 1160 -520 0 0 {name=vcascn value=xvcascn savecurrent=false}
C {lab_wire.sym} 1160 -440 0 0 {name=Vvref6 sig_type=std_logic lab=gnd
value=vref}
C {lab_wire.sym} 1160 -600 0 0 {name=p24 sig_type=std_logic lab=vcascn}
C {vsource.sym} 1250 -520 0 0 {name=vcascp value=xvcascp savecurrent=false}
C {lab_wire.sym} 1250 -440 0 0 {name=vcascp1 sig_type=std_logic lab=gnd
value=xcascp}
C {lab_wire.sym} 1250 -600 0 0 {name=vcascp2 sig_type=std_logic lab=vcascp
value=xcascp}
C {lab_wire.sym} 580 -850 3 1 {name=p25 sig_type=std_logic lab=vcascn
}
C {lab_wire.sym} 560 -850 3 1 {name=p26 sig_type=std_logic lab=vcascp}
C {sky130_fd_pr/nfet_01v8.sym} 1540 -560 0 0 {name=Mbias_cascp
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
C {lab_wire.sym} 1600 -560 0 0 {name=p28 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1560 -480 0 0 {name=vcascp3 sig_type=std_logic lab=gnd
value=xcascp}
C {isource.sym} 1560 -680 0 0 {name=Ibias_cascp value=xibias_cascp}
C {lab_wire.sym} 1560 -740 0 0 {name=p27 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1520 -620 0 0 {name=vcascp4 sig_type=std_logic lab=bias_amp_cascp}
C {lab_wire.sym} 520 -850 3 1 {name=vcascp5 sig_type=std_logic lab=bias_amp_cascp}
C {lab_wire.sym} 540 -850 3 1 {name=vcascp6 sig_type=std_logic lab=bias_amp_cascn}
C {sky130_fd_pr/pfet_01v8.sym} 1840 -680 0 0 {name=Mbias_cascn
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
C {isource.sym} 1860 -560 0 0 {name=Ibias_cascn value=xibias_cascn}
C {lab_wire.sym} 1860 -480 0 0 {name=vcascp7 sig_type=std_logic lab=gnd
value=xcascp}
C {lab_wire.sym} 1860 -740 0 0 {name=p29 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1810 -630 2 1 {name=vcascp8 sig_type=std_logic lab=bias_amp_cascn}
C {vsource.sym} 940 -500 0 0 {name=vrst_dc value=xvcm savecurrent=false}
C {lab_wire.sym} 940 -420 0 0 {name=vcascp10 sig_type=std_logic lab=gnd
value=xcascp}
C {lab_wire.sym} 670 -850 3 1 {name=p31 sig_type=std_logic lab=vcm}
C {lab_wire.sym} 940 -590 0 1 {name=p32 sig_type=std_logic lab=vcm}
C {lab_wire.sym} 2190 -560 0 0 {name=p33 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 2150 -480 0 0 {name=vcascp11 sig_type=std_logic lab=gnd
value=xcascp}
C {isource.sym} 2150 -680 0 0 {name=Ibias_cascp1 value=xibias_comp}
C {lab_wire.sym} 2150 -740 0 0 {name=p34 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 2110 -620 0 0 {name=vcascp12 sig_type=std_logic lab=bias_comp}
C {sky130_fd_pr/nfet_01v8.sym} 2130 -560 0 0 {name=Mbias_comp
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
C {lab_wire.sym} 600 -850 3 1 {name=vcascp13 sig_type=std_logic lab=bias_comp}
C {lab_wire.sym} 1520 -320 0 0 {name=p35 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1895 -680 0 0 {name=p36 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1800 -220 0 0 {name=p37 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1550 -110 0 0 {name=p38 sig_type=std_logic lab=gnd}
C {vsource.sym} 710 -225 0 0 {name=vref_on value="pulse(0.5 0.6 2u 100n 100n 0.7u 3u)" savecurrent=false}
C {vsource.sym} 710 -155 0 0 {name=vref_off value="pulse(0.5 0.4 3u 100n 100n 0.7u 3u)" savecurrent=false}
C {lab_wire.sym} 710 -325 3 0 {name=p39 sig_type=std_logic lab=vref}
C {noconn.sym} 830 -770 2 0 {name=l2}
C {isource.sym} 450 -370 0 0 {name=Iphoto value="pulse(1e-9 1e-8 10u 1n 1n 12u 24u)"}
C {vsource.sym} 270 -510 0 0 {name=vrowsel value="pulse(1.8 0 1.8u 100n 100n 3u 6u)" savecurrent=false}
C {lab_wire.sym} 270 -450 0 0 {name=p13 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 430 -550 0 0 {name=p41 sig_type=std_logic lab=row_sel}
C {vsource.sym} 1170 -230 0 0 {name=vrst value="pulse(1.8 0 1.7u 100n 100n 2.3u 3u)" savecurrent=false}
C {lab_wire.sym} 1170 -175 0 0 {name=Vvref2 sig_type=std_logic lab=gnd
value=vref}
C {lab_wire.sym} 1170 -300 3 0 {name=p42 sig_type=std_logic lab=pix_rst}
C {lab_wire.sym} 690 -850 3 1 {name=p43 sig_type=std_logic lab=vcm}
C {vsource.sym} 1400 -230 0 0 {name=vrstb1 value="pulse(0 1.8 1.7u 100n 100n 2.3u 3u)" savecurrent=false}
C {lab_wire.sym} 1400 -150 0 0 {name=vrstb2 sig_type=std_logic lab=gnd
value=xcascp}
C {lab_wire.sym} 1400 -340 3 0 {name=p44 sig_type=std_logic lab=n_pix_rst}
C {lab_wire.sym} 630 -660 3 0 {name=p45 sig_type=std_logic lab=n_pix_rst}
