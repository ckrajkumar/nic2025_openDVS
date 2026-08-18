v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 0 -200 0 -170 {lab=VDD}
N 0 -110 0 -80 {lab=GND}
N 0 -80 200 -80 {lab=GND}
N -210 170 -210 200 {lab=GND}
N -50 140 -20 140 {lab=IBIAS}
N -60 110 -60 140 {lab=IBIAS}
N -60 -170 -60 -30 {lab=VDD}
N -60 -200 160 -200 {lab=VDD}
N -60 140 -60 170 {lab=IBIAS}
N -60 140 -50 140 {lab=IBIAS}
N -20 200 10 200 {lab=GND}
N -20 170 10 170 {lab=GND}
N -590 110 -590 130 {lab=VIN}
N -60 30 -60 110 {lab=IBIAS}
N -260 110 -210 110 {lab=VOUT}
N -390 180 -390 220 {lab=IBIAS}
N -360 180 -360 220 {lab=GND}
N -520 110 -460 110 {lab=VIN}
N -590 190 -590 230 {lab=GND}
N -360 -10 -360 40 {lab=VDD}
C {infiniamp_xl.sym} -360 110 0 0 {name=x1}
C {vsource.sym} 0 -140 0 0 {name=V_vdd value=\{xVdd\} savecurrent=false}
C {vsource.sym} -590 160 0 0 {name=Vvin value=xVin savecurrent=false}
C {isource.sym} -60 -0 0 0 {name=I_bias value=\{xIbias\}}
C {capa.sym} -210 140 0 0 {name=C1
m=1
value=\{xCap\}
footprint=1206
device="ceramic capacitor"}
C {sky130_fd_pr/nfet_01v8.sym} -40 170 0 0 {
name=MnIBiasOut
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
C {lab_wire.sym} 40 -200 0 0 {name=l1 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 120 -80 0 0 {name=l2 sig_type=std_logic lab=GND}
C {lab_wire.sym} -510 110 0 0 {name=l3 sig_type=std_logic lab=VIN}
C {lab_wire.sym} -220 110 0 0 {name=l4 sig_type=std_logic lab=VOUT}
C {lab_wire.sym} -60 110 0 0 {name=l5 sig_type=std_logic lab=IBIAS}
C {iopin.sym} 80 -200 3 0 {name=p1 lab=VDD}
C {iopin.sym} 200 -80 0 0 {name=p2 lab=GND}
C {iopin.sym} -590 110 3 0 {name=p3 lab=VIN}
C {code_shown.sym} 280 -200 0 0 {name=NGSPICE
only_toplevel=true
value="
.lib $PDK_ROOT/$PDK/libs.tech/combined/sky130.lib.spice tt

.option gmin=1e-16 abstol=1e-15 vntol=1e-9 reltol=1e-4 chgtol=1e-16
.option method=gear maxord=2 trtol=1
.option itl1=500 itl2=200 itl4=50
.option gminsteps=200 srcsteps=200
.option ramptime=100n

.param xVdd = 1.8
.param xVin = \{xVdd/2\}
.param xIbias = 200n
.param xCap = 10p

.save all
.op
.control
DC Vvin 0 1.8 0.01
write tb_infiniamp_x1.raw
.endc
"}
C {lab_wire.sym} -390 210 0 0 {name=l6 sig_type=std_logic lab=IBIAS}
C {lab_wire.sym} -360 200 0 1 {name=l7 sig_type=std_logic lab=GND}
C {lab_wire.sym} -590 210 0 1 {name=l8 sig_type=std_logic lab=GND}
C {iopin.sym} -360 -10 3 0 {name=p4 lab=VDD}
C {lab_wire.sym} 10 170 0 1 {name=l9 sig_type=std_logic lab=GND}
C {lab_wire.sym} 10 200 0 1 {name=l10 sig_type=std_logic lab=GND}
C {lab_wire.sym} -60 -100 0 0 {name=l11 sig_type=std_logic lab=VDD}
C {lab_wire.sym} -210 200 0 0 {name=l12 sig_type=std_logic lab=GND}
