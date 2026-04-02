v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 120 -250 {}
N -120 110 -80 110 {lab=READON}
N -120 170 -80 170 {lab=ON}
N 80 170 120 170 {lab=nOFF}
N 80 110 120 110 {lab=READOFF}
N -40 200 -40 240 {lab=COL_GND}
N -0 0 -0 50 {lab=column_out}
N 30 0 100 0 {lab=nCHARGE}
N 10 -130 30 -130 {lab=COL_GND}
N -20 -130 -0 -130 {lab=VDD}
N 0 50 200 50 {lab=column_out}
N 200 110 200 140 {lab=COL_GND}
N -100 -60 -50 -60 {lab=COL_OUT}
N -410 50 -0 50 {lab=column_out}
N -330 110 -290 110 {lab=COL_GND}
N -530 110 -490 110 {lab=COL_GND}
N -450 200 -450 240 {lab=COL_GND}
N -330 170 -290 170 {lab=ON}
N -530 170 -490 170 {lab=ON}
C {col_amp.sym} -50 -60 0 0 {name=X_COL_AMP}
C {capa.sym} 200 80 0 0 {name=C1
m=1
value=\{col_cap\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 130 50 0 1 {name=p10 sig_type=std_logic lab=column_out
}
C {code_shown.sym} 420 -110 0 0 {name=TRAN only_toplevel=false value=
"
.lib /home/alienfalcon/.ciel/sky130B/libs.tech/combined/sky130.lib.spice tt

.param vdd = 1.8
.param tr = 1p
.param tf = 1p
.param pw = 1u
.param col_cap = 300f

V_VDD VDD COL_GND DC \{vdd\}
V_GND COL_GND 0 DC 0
V_ON ON COL_GND DC \{vdd\}
V_nOFF nOFF COL_GND DC 0
V_READON READON COL_GND pulse(0 \{vdd\} \{3*pw\} \{tr\} \{tf\} \{pw\} \{5*pw\})
V_READOFF READOFF COL_GND DC 0
V_nCHARGE nCHARGE COL_GND pulse(\{vdd\} 0 \{pw\} \{tr\} \{tf\} \{pw\} \{5*pw\})

.control
	save v(column_out) v(nCHARGE) v(COL_OUT) v(ON) v(nOFF) v(READON) v(READOFF)

	tran 10p 5u
	let Vc_max = 0
	let Vc_min = 0
	let tr_col_out = 0
	let tf_col_out = 0
	let tset_col_low = 0
	let tset_col_high = 0

	meas tran Vc_max FIND v(COL_OUT) AT=1.3u
	meas tran Vc_min FIND v(COL_OUT) AT=0.3u 

	let V_diff = Vc_max - Vc_min
	let Vc_10 = V_diff*0.1 + Vc_min
	let Vc_90 = V_diff*0.9 + Vc_min
	let Vc_set_low = Vc_max*0.98
	let Vc_set_high = Vc_max*1.02

	meas tran tr_col_out TRIG v(COL_OUT) VAL=Vc_10 CROSS=1 TARG v(COL_OUT) VAL=Vc_90 CROSS=1
	meas tran tf_col_out TRIG v(COL_OUT) VAL=Vc_90 CROSS=2 TARG v(COL_OUT) VAL=Vc_10 CROSS=2
	meas tran tset_col_low WHEN v(COL_OUT)=Vc_set_low RISE=LAST
	meas tran tset_col_high WHEN v(COL_OUT)=Vc_set_high FALL=LAST

	print Vc_max Vc_min
	print tr_col_out tf_col_out tset_col_low tset_col_high

	save tr_col_out tf_col_out tset_col_low tset_col_high

	write TRAN_TB.raw
.endc


"}
C {iopin.sym} 100 0 0 0 {name=p1 lab=nCHARGE}
C {iopin.sym} 120 170 0 0 {name=p4 lab=nOFF}
C {iopin.sym} 120 110 0 0 {name=p3 lab=READOFF}
C {iopin.sym} -120 170 0 1 {name=p6 lab=ON}
C {iopin.sym} -120 110 0 1 {name=p2 lab=READON}
C {iopin.sym} -40 240 0 0 {name=p5 lab=COL_GND}
C {iopin.sym} 200 140 0 0 {name=p12 lab=COL_GND}
C {iopin.sym} 30 -130 0 0 {name=p7 lab=COL_GND}
C {iopin.sym} -20 -130 0 1 {name=p8 lab=VDD}
C {/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/dvs_2026/pixel/xschem/pix_or_gate.sym} -80 210 0 0 {name=X_or_gate}
C {iopin.sym} -100 -60 0 1 {name=p9 lab=COL_OUT}
C {/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/dvs_2026/pixel/xschem/pix_or_gate.sym} -490 210 0 0 {name=X_or_gate_extra[62:0]}
C {iopin.sym} -290 110 0 0 {name=p11 lab=COL_GND}
C {iopin.sym} -530 110 0 1 {name=p13 lab=COL_GND}
C {iopin.sym} -450 240 0 0 {name=p14 lab=COL_GND}
C {iopin.sym} -290 170 0 0 {name=p15 lab=ON}
C {iopin.sym} -530 170 0 1 {name=p16 lab=ON}
