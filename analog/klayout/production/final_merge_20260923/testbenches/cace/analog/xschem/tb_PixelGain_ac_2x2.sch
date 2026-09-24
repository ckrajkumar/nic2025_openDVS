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
N 710 -680 710 -650 {lab=gnd}
N 710 -780 710 -740 {lab=vpd1}
N 830 -680 830 -650 {lab=gnd}
N 830 -780 830 -740 {lab=vpd2}
N 950 -680 950 -650 {lab=gnd}
N 950 -780 950 -740 {lab=vpd3}
C {devices/code.sym} -360 -240 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {devices/launcher.sym} -110 -330 2 1 {name=h1
descr="Annotate OP"
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {code_shown.sym} -1240 -1340 0 0 {name=NGSPICE
only_toplevel=true
value="
.temp 27

.include /home/rpgraca/research/projects/telluride/2025/nic_eventcam/nic2025_openDVS/analog/xschem/openDVS_pixel2x2_pex_simple.spice
*.include /home/rpgraca/research/projects/telluride/2025/nic_eventcam/nic2025_openDVS/analog/xschem/openDVS_pixel2x2_pex_r.spice
*.include /home/rpgraca/research/projects/telluride/2025/nic_eventcam/nic2025_openDVS/analog/xschem/openDVS_pixel2x2_pex_cc.spice
*.include /home/rpgraca/research/projects/telluride/2025/nic_eventcam/nic2025_openDVS/analog/xschem/openDVS_pixel2x2_pex_c.spice
*.include /home/rpgraca/research/projects/telluride/2025/nic_eventcam/nic2025_openDVS/analog/xschem/openDVS_pixel2x2_pex_rcc.spice
*.include /home/rpgraca/research/projects/telluride/2025/nic_eventcam/nic2025_openDVS/analog/xschem/openDVS_pixel2x2_pex_rc.spice



.option gmin=1e-19 abstol=1e-15 vntol=1e-9 reltol=1e-4 chgtol=1e-16
.option itl1=500 itl2=200
.option gminsteps=200 srcsteps=200

.param xipd1 = 1n
.param xipd2 = 1n
.param xipd3 = 1n

.param xvdd = 1.8
.param xipd = 10n
.param xPrBp = 10n
.param xPrSFBp = 10p
.param xDiffBn = 20n
.param xCloadPD = 30f

** nRst at vdd for normal operation (Mrst OFF)
VnRst nRst gnd \{xvdd\}

** Large inductor: DC short (sets OP) but AC open (no effect on freq response)
** Provides DC path for floating cap node xchamp.vd through vdiff
Lbias xpix2x2.pix[0].vdiff xpix2x2.pix[0].vd 1000T

.save all

.control
** OP with nRst=vdd, .nodeset guides floating nodes
op
write tb_PixelGain_ac_op_2x2.raw

** AC sweep from this operating point
ac dec 50 1m 1G
write tb_PixelGain_ac_2x2.raw

echo
echo '=== AC analysis complete, running post-processing ==='
shell python3 /home/rpgraca/research/projects/telluride/2025/nic_eventcam/nic2025_openDVS/analog/xschem/process_PixelGain_ac.py tb_PixelGain_ac_2x2.raw
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
C {isource.sym} 710 -710 0 0 {name=I0 value='xipd1'}
C {lab_wire.sym} 710 -650 0 0 {name=p1 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 710 -780 0 0 {name=p2 sig_type=std_logic lab=vpd1}
C {isource.sym} 830 -710 0 0 {name=I1 value='xipd2'}
C {lab_wire.sym} 830 -650 0 0 {name=p5 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 830 -780 0 0 {name=p6 sig_type=std_logic lab=vpd2}
C {isource.sym} 950 -710 0 0 {name=I2 value='xipd3'}
C {lab_wire.sym} 950 -650 0 0 {name=p16 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 950 -780 0 0 {name=p17 sig_type=std_logic lab=vpd3}
