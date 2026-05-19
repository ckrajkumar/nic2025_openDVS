v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 850 110 850 130 {lab=OnBn}
N 760 160 810 160 {lab=OnBn}
N 760 110 760 160 {lab=OnBn}
N 760 110 850 110 {lab=OnBn}
N 850 90 850 110 {lab=OnBn}
N 850 190 850 230 {lab=gnd}
N 850 160 890 160 {lab=gnd}
N 850 -10 850 30 {lab=vdd}
N 1010 110 1010 130 {lab=OffBn}
N 920 160 970 160 {lab=OffBn}
N 920 110 920 160 {lab=OffBn}
N 920 110 1010 110 {lab=OffBn}
N 1010 90 1010 110 {lab=OffBn}
N 1010 190 1010 230 {lab=gnd}
N 1010 160 1050 160 {lab=gnd}
N 1010 -10 1010 30 {lab=vdd}
N 220 -450 220 -430 {lab=gnd}
N 220 -370 220 -350 {lab=GND!}
N 220 -370 300 -370 {lab=GND!}
N 300 -450 300 -430 {lab=vdd}
N 300 -800 300 -770 {lab=gnd}
N 300 -900 300 -860 {lab=vpd1}
N 420 -800 420 -770 {lab=gnd}
N 420 -900 420 -860 {lab=vpd2}
N 540 -800 540 -770 {lab=gnd}
N 540 -900 540 -860 {lab=vpd3}
N 610 -330 800 -330 {lab=vpd3,vpd2,vpd1,vpd0}
N 750 -450 800 -450 {lab=gnd}
N 750 -430 800 -430 {lab=gnd}
N 750 -410 800 -410 {lab=vdd}
N 750 -390 800 -390 {lab=gnd}
N 750 -370 800 -370 {lab=OffBn}
N 750 -350 800 -350 {lab=OnBn}
N 1100 -520 1140 -520 {lab=gnd}
N 750 -500 800 -500 {lab=gnd}
N 750 -480 800 -480 {lab=gnd}
N 750 -520 800 -520 {lab=gnd}
N 930 -290 930 -240 {lab=gnd}
N 950 -290 950 -240 {lab=gnd}
N 970 -290 970 -240 {lab=vdd}
N 160 -800 160 -770 {lab=gnd}
N 160 -900 160 -860 {lab=vpd0}
C {devices/code.sym} -420 -210 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice CACE\{corner\}
"
spice_ignore=false}
C {devices/launcher.sym} -170 -300 2 1 {name=h1
descr="Annotate OP"
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {code_shown.sym} -1280 -550 0 0 {name=NGSPICE
only_toplevel=true
value="
.include CACE\{root\}/xschem/openDVS_pixel2x2_pex_CACE\{xPexType\}.spice

.temp CACE\{temperature\}

.option gmin=1e-16 abstol=1e-15 vntol=1e-9 reltol=1e-4 chgtol=1e-16
.option itl1=500 itl2=200
.option gminsteps=200 srcsteps=200

.param xvdd = CACE\{vdd\}
** Bias set: 1 = OnBn=200nA / OffBn=0.5nA, 2 = OnBn=100nA / OffBn=1nA
.param xBiasSet = CACE\{xBiasSet\}
.param xOnBn = '(xBiasSet < 1.5) ? 200e-9 : 100e-9'
.param xOffBn = '(xBiasSet < 1.5) ? 0.5e-9 : 1e-9'

.param xipd0 = CACE\{xipd0\}
.param xipd1 = CACE\{xipd1\}
.param xipd2 = CACE\{xipd2\}
.param xipd3 = CACE\{xipd3\}

** Force vdiff on Pix[0] — must be in SPICE code, not as schematic wire
** (xschem mangles dots in net labels during netlisting)
Vvdiff_pex xpix2x2.Pix[0].vdiff gnd \{xvdiff\}

** Bsource probes: mirror bracket-containing internal nodes to top-level names
Bprobe_on on_mon 0 V = v(xpix2x2.pix[0].on)
Bprobe_noff noff_mon 0 V = v(xpix2x2.pix[0].noff)

.param xvdiff = 0

.save all

.control
dc vvdiff_pex 0 CACE\{vdd\} 0.1m
write CACE\{filename\}_CACE\{N\}.raw

shell python3 CACE\{root\}/cace/scripts/tb_PixelComparators_dc_2x2.py CACE\{simpath\} CACE\{filename\} CACE\{N\}
.endc
"}
C {sky130_fd_pr/nfet_01v8.sym} 830 160 0 0 {name=MOnBn
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
C {lab_wire.sym} 760 110 3 0 {name=p29 sig_type=std_logic lab=OnBn}
C {isource.sym} 850 60 0 0 {name=IOnBn value=\{xOnBn\}}
C {lab_wire.sym} 850 230 3 1 {name=p30 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 890 160 2 1 {name=p31 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 850 -10 3 0 {name=p32 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/nfet_01v8.sym} 990 160 0 0 {name=MOffBn
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
C {lab_wire.sym} 920 110 3 0 {name=p33 sig_type=std_logic lab=OffBn}
C {isource.sym} 1010 60 0 0 {name=IOffBn value=\{xOffBn\}}
C {lab_wire.sym} 1010 230 3 1 {name=p34 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1050 160 2 1 {name=p35 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1010 -10 3 0 {name=p36 sig_type=std_logic lab=vdd}
C {vsource.sym} 220 -400 0 0 {name=Vgnd1 value=0 savecurrent=false}
C {gnd.sym} 220 -350 0 0 {name=l5 lab=GND!}
C {vsource.sym} 300 -400 0 0 {name=Vvdd1 value=\{xvdd\} savecurrent=false}
C {lab_wire.sym} 220 -440 0 0 {name=p11 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 300 -440 0 0 {name=p12 sig_type=std_logic lab=vdd}
C {openDVS_pixel2x2.sym} 950 -420 0 0 {name=xpix2x2}
C {isource.sym} 300 -830 0 0 {name=I0 value='xipd1'}
C {lab_wire.sym} 300 -770 0 0 {name=p26 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 300 -900 0 0 {name=p27 sig_type=std_logic lab=vpd1}
C {isource.sym} 420 -830 0 0 {name=I1 value='xipd2'}
C {lab_wire.sym} 420 -770 0 0 {name=p28 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 420 -900 0 0 {name=p37 sig_type=std_logic lab=vpd2}
C {isource.sym} 540 -830 0 0 {name=I2 value='xipd3'}
C {lab_wire.sym} 540 -770 0 0 {name=p38 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 540 -900 0 0 {name=p39 sig_type=std_logic lab=vpd3}
C {lab_wire.sym} 770 -330 0 0 {name=p40 sig_type=std_logic lab=vpd3,vpd2,vpd1,vpd0}
C {lab_wire.sym} 750 -450 0 1 {name=p41 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 750 -430 0 1 {name=p42 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 750 -410 0 1 {name=p43 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 750 -390 0 1 {name=p44 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 750 -370 0 1 {name=p45 sig_type=std_logic lab=OffBn}
C {lab_wire.sym} 750 -350 0 1 {name=p46 sig_type=std_logic lab=OnBn}
C {lab_wire.sym} 1110 -520 0 1 {name=p47 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 750 -500 0 1 {name=p48 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 750 -480 0 1 {name=p49 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 750 -520 0 1 {name=p50 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 930 -240 3 1 {name=p51 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 950 -240 3 1 {name=p52 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 970 -240 3 1 {name=p53 sig_type=std_logic lab=vdd}
C {isource.sym} 160 -830 0 0 {name=I3 value='xipd0'}
C {lab_wire.sym} 160 -770 0 0 {name=p19 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 160 -900 0 0 {name=p24 sig_type=std_logic lab=vpd0}
