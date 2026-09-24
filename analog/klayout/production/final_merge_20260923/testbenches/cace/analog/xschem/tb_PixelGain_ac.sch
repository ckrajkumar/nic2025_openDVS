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
N 720 -870 780 -870 {lab=vpr}
N 400 -760 400 -730 {lab=gnd}
N 400 -840 400 -820 {lab=vpd}
N 400 -870 460 -870 {lab=vpd}
N 340 -840 340 -830 {lab=vpd}
N 340 -840 400 -840 {lab=vpd}
N 340 -770 340 -760 {lab=gnd}
N 340 -760 400 -760 {lab=gnd}
N 400 -870 400 -840 {lab=vpd}
N 520 -870 590 -870 {lab=vpd_in}
N 540 -850 590 -850 {lab=PrBp}
N 730 -850 780 -850 {lab=PrSFBp}
N 910 -870 1040 -870 {lab=vsf}
N 840 -800 840 -750 {lab=gnd}
N 870 -800 870 -750 {lab=vdd}
N 650 -800 650 -750 {lab=gnd}
N 680 -800 680 -750 {lab=vdd}
N 970 -830 1040 -830 {lab=nRst}
N 1100 -800 1100 -730 {lab=gnd}
N 1130 -800 1130 -730 {lab=vdd}
N 740 -270 740 -250 {lab=DiffBn}
N 650 -220 700 -220 {lab=DiffBn}
N 650 -270 650 -220 {lab=DiffBn}
N 740 -290 740 -270 {lab=DiffBn}
N 740 -190 740 -150 {lab=gnd}
N 740 -420 740 -350 {lab=vdd}
N 650 -270 740 -270 {lab=DiffBn}
N 740 -220 780 -220 {lab=gnd}
N 970 -850 1040 -850 {lab=DiffBn}
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
N 1170 -870 1180 -870 {lab=vdiff}
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

.option gmin=1e-16 abstol=1e-15 vntol=1e-9 reltol=1e-4 chgtol=1e-16
.option itl1=500 itl2=200
.option gminsteps=200 srcsteps=200

.param xvdd = 1.8
.param xipd = 1p
.param xPrBp = 10n
.param xPrSFBp = 100p
.param xDiffBn = 5n
.param xCloadPD = 30f

** nRst at vdd for normal operation (Mrst OFF)
VnRst nRst gnd \{xvdd\}

** Large inductor: DC short (sets OP) but AC open (no effect on freq response)
** Provides DC path for floating cap node xchamp.vd through vdiff
Lbias vdiff xchamp.vd 1000T

.save all

.control
** OP with nRst=vdd, .nodeset guides floating nodes
op
let vd_op = v(xchamp.vd)
let vdiff_op = v(vdiff)
echo
echo '=== OP (nRst=vdd) ==='
echo '    vd    =' $&vd_op 'V'
echo '    vdiff =' $&vdiff_op 'V'
write tb_PixelGain_ac_op.raw

** AC sweep from this operating point
ac dec 50 1m 1G
write tb_PixelGain_ac.raw

echo
echo '=== AC analysis complete, running post-processing ==='
shell python3 /home/rpgraca/research/projects/telluride/2025/nic_eventcam/nic2025_openDVS/analog/xschem/process_PixelGain_ac.py tb_PixelGain_ac.raw
.endc
"}
C {vsource.sym} 300 -220 0 0 {name=Vgnd value=0 savecurrent=false}
C {gnd.sym} 300 -170 0 0 {name=l1 lab=GND!}
C {vsource.sym} 380 -220 0 0 {name=Vvdd value=\{xvdd\} savecurrent=false}
C {lab_wire.sym} 300 -260 0 0 {name=p3 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 380 -260 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {PixelPhotoreceptor.sym} 740 -880 0 0 {name=xpr}
C {PixelSourceFollower.sym} 930 -880 0 0 {name=xsf}
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
C {lab_wire.sym} 540 -850 2 0 {name=p48 sig_type=std_logic lab=PrBp}
C {lab_wire.sym} 730 -850 2 0 {name=p50 sig_type=std_logic lab=PrSFBp}
C {lab_wire.sym} 730 -870 0 1 {name=p51 sig_type=std_logic lab=vpr}
C {lab_wire.sym} 960 -870 0 0 {name=p52 sig_type=std_logic lab=vsf}
C {lab_wire.sym} 840 -750 1 1 {name=p53 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 870 -750 1 1 {name=p54 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 650 -750 1 1 {name=p55 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 680 -750 1 1 {name=p56 sig_type=std_logic lab=vdd}
C {PixelChangeAmplifier.sym} 1190 -880 0 0 {name=xChAmp}
C {lab_wire.sym} 970 -830 0 1 {name=p1 sig_type=std_logic lab=nRst}
C {lab_wire.sym} 1100 -730 3 1 {name=p2 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1130 -730 3 1 {name=p6 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1180 -870 0 1 {name=p7 sig_type=std_logic lab=vdiff}
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
C {lab_wire.sym} 970 -850 0 1 {name=p5 sig_type=std_logic lab=DiffBn}
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
C {noconn.sym} 1180 -870 2 0 {name=l2}
