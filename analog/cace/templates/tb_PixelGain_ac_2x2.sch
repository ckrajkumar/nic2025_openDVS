v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 300 -190 300 -170 {lab=GND!}
N 300 -190 380 -190 {lab=GND!}
N 380 -270 380 -250 {lab=vdd}
N 300 -260 300 -250 {lab=gnd}
N 400 -760 400 -730 {lab=gnd}
N 400 -840 400 -820 {lab=vpd0}
N 400 -870 460 -870 {lab=vpd0}
N 400 -870 400 -840 {lab=vpd0}
N 520 -870 590 -870 {lab=vpd0_in}
N 540 -850 590 -850 {lab=PrBp}
N 740 -270 740 -250 {lab=DiffBn}
N 650 -220 700 -220 {lab=DiffBn}
N 650 -270 650 -220 {lab=DiffBn}
N 740 -290 740 -270 {lab=DiffBn}
N 740 -190 740 -150 {lab=gnd}
N 740 -420 740 -350 {lab=vdd}
N 650 -270 740 -270 {lab=DiffBn}
N 740 -220 780 -220 {lab=gnd}
N 950 -290 950 -270 {lab=PrBp}
N 950 -210 950 -170 {lab=gnd}
N 880 -340 910 -340 {lab=PrBp}
N 880 -340 880 -290 {lab=PrBp}
N 880 -290 950 -290 {lab=PrBp}
N 950 -310 950 -290 {lab=PrBp}
N 950 -340 1000 -340 {lab=vdd}
N 950 -410 950 -370 {lab=vdd}
N 1100 -290 1100 -270 {lab=PrSFBp}
N 1100 -210 1100 -170 {lab=gnd}
N 1030 -340 1060 -340 {lab=PrSFBp}
N 1030 -340 1030 -290 {lab=PrSFBp}
N 1030 -290 1100 -290 {lab=PrSFBp}
N 1100 -310 1100 -290 {lab=PrSFBp}
N 1100 -340 1150 -340 {lab=vdd}
N 1100 -410 1100 -370 {lab=vdd}
N 790 -1120 980 -1120 {lab=vpd3,vpd2,vpd1,vpd0_in}
N 930 -1240 980 -1240 {lab=PrBp}
N 930 -1220 980 -1220 {lab=vdd}
N 930 -1200 980 -1200 {lab=PrSFBp}
N 930 -1180 980 -1180 {lab=DiffBn}
N 930 -1160 980 -1160 {lab=vdd}
N 930 -1140 980 -1140 {lab=vdd}
N 1280 -1310 1320 -1310 {lab=gnd}
N 930 -1290 980 -1290 {lab=gnd}
N 930 -1270 980 -1270 {lab=gnd}
N 930 -1310 980 -1310 {lab=gnd}
N 1110 -1080 1110 -1030 {lab=gnd}
N 1130 -1080 1130 -1030 {lab=gnd}
N 1150 -1080 1150 -1030 {lab=vdd}
C {devices/code.sym} -360 -240 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice CACE\{corner\}
"
spice_ignore=false}
C {devices/launcher.sym} -110 -330 2 1 {name=h1
descr="Annotate OP"
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {code_shown.sym} -1240 -1340 0 0 {name=NGSPICE
only_toplevel=true
value="
.include CACE\{root\}/xschem/openDVS_pixel2x2_pex_CACE\{xPexType\}.spice

.temp CACE\{temperature\}

.option gmin=1e-16 abstol=1e-15 vntol=1e-9 reltol=1e-4 chgtol=1e-16
.option itl1=500 itl2=200
.option gminsteps=200 srcsteps=200

.param xvdd = CACE\{vdd\}
.param xipd = CACE\{xipd\}
.param xPrBp = CACE\{xPrBp\}
.param xPrSFBp = CACE\{xPrSFBp\}
.param xDiffBn = CACE\{xDiffBn\}
.param xCloadPD = CACE\{xCloadPD\}

** nRst at vdd for normal operation (Mrst OFF)
VnRst nRst gnd \{xvdd\}

** DC current sources for neighbor pixels (no AC stimulus)
Iipd1 vpd1 gnd dc \{xipd\}
Iipd2 vpd2 gnd dc \{xipd\}
Iipd3 vpd3 gnd dc \{xipd\}

** Large inductor: DC short (sets OP) but AC open (no effect on freq response)
** Provides DC path for floating cap node through vdiff
Lbias xpix2x2.pix[0].vdiff xpix2x2.pix[0].vd 1000T

** Bsource probes: mirror bracket-containing internal nodes to top-level names
Bprobe_vpd vpd_mon 0 V = v(vpd0_in)
Bprobe_vpr vpr_mon 0 V = v(xpix2x2.pix[0].vpr)
Bprobe_vsf vsf_mon 0 V = v(xpix2x2.pix[0].vsf)
Bprobe_vdiff vdiff_mon 0 V = v(xpix2x2.pix[0].vdiff)
Bprobe_vd vd_mon 0 V = v(xpix2x2.pix[0].vd)

.save all

.control
** OP with nRst=vdd, inductor provides DC path for floating nodes
op
write CACE\{filename\}_CACE\{N\}_op.raw

** AC sweep from this operating point
ac dec 50 1m 1G
write CACE\{filename\}_CACE\{N\}.raw

echo
echo '=== AC analysis complete, running post-processing ==='
shell python3 CACE\{root\}/cace/scripts/tb_PixelGain_ac_2x2.py CACE\{simpath\} CACE\{filename\} CACE\{N\}
.endc
"}
C {vsource.sym} 300 -220 0 0 {name=Vgnd value=0 savecurrent=false}
C {gnd.sym} 300 -170 0 0 {name=l1 lab=GND!}
C {vsource.sym} 380 -220 0 0 {name=Vvdd value=\{xvdd\} savecurrent=false}
C {lab_wire.sym} 300 -260 0 0 {name=p3 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 380 -260 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 400 -730 0 0 {name=p45 sig_type=std_logic lab=gnd}
C {isource.sym} 400 -790 0 0 {name=Iipd value="dc \{xipd\} ac \{xipd\}"}
C {lab_wire.sym} 400 -850 0 0 {name=p46 sig_type=std_logic lab=vpd0}
C {vsource.sym} 490 -870 1 0 {name=Vmeas_ipd1 value=0 savecurrent=false}
C {lab_wire.sym} 550 -870 0 0 {name=p47 sig_type=std_logic lab=vpd0_in}
C {lab_wire.sym} 540 -850 2 0 {name=p48 sig_type=std_logic lab=PrBp}
C {sky130_fd_pr/nfet_01v8.sym} 720 -220 0 0 {name=MDiffBn
W=1.5
L=1.5
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
C {lab_wire.sym} 650 -270 3 0 {name=p25 sig_type=std_logic lab=DiffBn}
C {isource.sym} 740 -320 0 0 {name=IDiffBn value=\{xDiffBn\}}
C {lab_wire.sym} 740 -150 3 1 {name=p26 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 740 -420 3 0 {name=p28 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 780 -220 2 1 {name=p9 sig_type=std_logic lab=gnd}
C {isource.sym} 950 -240 0 0 {name=IPrBp value=\{xPrBp\}}
C {sky130_fd_pr/pfet_01v8.sym} 930 -340 0 0 {name=MPrBp
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
model=pfet_01v8
spiceprefix=X
}
C {lab_wire.sym} 1000 -340 0 0 {name=p8 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 950 -410 3 0 {name=p10 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 950 -170 3 1 {name=p13 sig_type=std_logic lab=gnd}
C {isource.sym} 1100 -240 0 0 {name=IPrSFBp value=\{xPrSFBp\}}
C {lab_wire.sym} 1150 -340 0 0 {name=p15 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1100 -410 3 0 {name=p20 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1100 -170 3 1 {name=p21 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 880 -340 3 0 {name=p22 sig_type=std_logic lab=PrBp}
C {lab_wire.sym} 1030 -340 3 0 {name=p23 sig_type=std_logic lab=PrSFBp}
C {sky130_fd_pr/pfet_01v8.sym} 1080 -340 0 0 {name=MPrSFBp
W=0.42
L=1.5
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
C {openDVS_pixel2x2.sym} 1130 -1210 0 0 {name=xpix2x2}
C {lab_wire.sym} 950 -1120 0 0 {name=p18 sig_type=std_logic lab=vpd3,vpd2,vpd1,vpd0_in}
C {lab_wire.sym} 930 -1240 0 1 {name=p19 sig_type=std_logic lab=PrBp}
C {lab_wire.sym} 930 -1220 0 1 {name=p24 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 930 -1200 0 1 {name=p11 sig_type=std_logic lab=PrSFBp}
C {lab_wire.sym} 930 -1160 0 1 {name=p27 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 930 -1140 0 1 {name=p14 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1290 -1310 0 1 {name=p29 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 930 -1290 0 1 {name=p30 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 930 -1270 0 1 {name=p31 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 930 -1310 0 1 {name=p32 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1110 -1030 3 1 {name=p33 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1130 -1030 3 1 {name=p34 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1150 -1030 3 1 {name=p35 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 930 -1180 0 1 {name=p12 sig_type=std_logic lab=DiffBn}
