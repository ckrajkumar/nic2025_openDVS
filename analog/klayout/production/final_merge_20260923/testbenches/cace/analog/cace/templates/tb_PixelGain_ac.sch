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
N 400 -840 400 -820 {lab=vpd}
N 400 -870 460 -870 {lab=vpd}
N 340 -840 340 -830 {lab=vpd}
N 340 -840 400 -840 {lab=vpd}
N 340 -770 340 -760 {lab=gnd}
N 340 -760 400 -760 {lab=gnd}
N 400 -870 400 -840 {lab=vpd}
N 520 -870 550 -870 {lab=vpd_in}
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
C {devices/code.sym} -360 -240 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice CACE\{corner\}
.include CACE\{DUT_path\}
.include CACE\{root\}/netlist/schematic/PixelPhotoreceptor.spice
.include CACE\{root\}/netlist/schematic/PixelSourceFollower.spice
.include CACE\{root\}/netlist/schematic/PixelChangeAmplifier.spice

** Manual instantiation (symbols not available in CACE run directory)
xpr vdd PrBp gnd vpd_in vpr PixelPhotoreceptor
xsf vdd PrSFBp gnd vpr vsf PixelSourceFollower
xchamp vdd DiffBn gnd vsf vdiff nRst PixelChangeAmplifier
"
spice_ignore=false}
C {devices/launcher.sym} -110 -330 2 1 {name=h1
descr="Annotate OP"
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {code_shown.sym} -1240 -1340 0 0 {name=NGSPICE
only_toplevel=true
value="
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

** Large inductor: DC short (sets OP) but AC open (no effect on freq response)
** Provides DC path for floating cap node xchamp.vd through vdiff
Lbias vdiff xchamp.vd 1000T

.save all

.control
** OP with nRst=vdd, inductor provides DC path for floating nodes
op
let vd_op = v(xchamp.vd)
let vdiff_op = v(vdiff)
echo
echo '=== OP (nRst=vdd) ==='
echo '    vd    =' $&vd_op 'V'
echo '    vdiff =' $&vdiff_op 'V'

** AC sweep from this operating point
ac dec 50 1m 1G
write CACE\{filename\}_CACE\{N\}.raw

echo
echo '=== AC analysis complete, running post-processing ==='
shell python3 CACE\{root\}/cace/scripts/tb_PixelGain_ac.py CACE\{simpath\} CACE\{filename\} CACE\{N\}
.endc
"}
C {vsource.sym} 300 -220 0 0 {name=Vgnd value=0 savecurrent=false}
C {gnd.sym} 300 -170 0 0 {name=l1 lab=GND!}
C {vsource.sym} 380 -220 0 0 {name=Vvdd value=\{xvdd\} savecurrent=false}
C {lab_wire.sym} 300 -260 0 0 {name=p3 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 380 -260 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 400 -730 0 0 {name=p45 sig_type=std_logic lab=gnd}
C {isource.sym} 400 -790 0 0 {name=Iipd value="dc \{xipd\} ac \{xipd\}"}
C {lab_wire.sym} 400 -850 0 0 {name=p46 sig_type=std_logic lab=vpd}
C {capa.sym} 340 -800 0 1 {name=CloadPD1
m=1
value='xCloadPD'
footprint=1206
device="ceramic capacitor"}
C {vsource.sym} 490 -870 1 0 {name=Vmeas_ipd1 value=0 savecurrent=false}
C {lab_wire.sym} 550 -870 0 0 {name=p47 sig_type=std_logic lab=vpd_in}
C {sky130_fd_pr/nfet_01v8.sym} 720 -220 0 0 {name=MDiffBn
W=1
L=2
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
C {sky130_fd_pr/pfet_01v8_hvt.sym} 930 -340 0 0 {name=MPrBp
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
model=pfet_01v8_hvt
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
W=1
L=4
nf=2
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
