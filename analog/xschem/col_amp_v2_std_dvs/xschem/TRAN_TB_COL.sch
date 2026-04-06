v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 -230 90 {}
N 70 270 110 270 {lab=READON}
N 70 330 110 330 {lab=ON}
N 270 330 310 330 {lab=nOFF}
N 270 270 310 270 {lab=READOFF}
N 150 360 150 400 {lab=GND}
N 190 160 190 210 {lab=column_out}
N 220 160 290 160 {lab=nCHARGE}
N 200 30 220 30 {lab=GND}
N 170 30 190 30 {lab=VDD_COL}
N 430 270 430 300 {lab=GND}
N 90 100 140 100 {lab=COL_OUT}
N -220 210 190 210 {lab=column_out}
N -140 270 -100 270 {lab=GND}
N -340 270 -300 270 {lab=GND}
N -260 360 -260 400 {lab=GND}
N -140 330 -100 330 {lab=ON}
N -340 330 -300 330 {lab=ON}
N -250 30 -200 30 {lab=COL_OUT}
N -250 70 -200 70 {lab=VTHRESH}
N -380 150 -340 150 {lab=GND}
N -340 110 -340 150 {lab=GND}
N -320 150 -300 150 {lab=VDD_COMP}
N -320 110 -320 150 {lab=VDD_COMP}
N -500 40 -450 40 {lab=EVT_HIGH}
N -500 60 -450 60 {lab=EVT_LOW}
N -450 60 -390 60 {lab=EVT_LOW}
N -450 40 -390 40 {lab=EVT_HIGH}
N -250 100 -110 100 {lab=DETECT}
N -250 0 -110 0 {lab=nDETECT}
N 190 210 430 210 {lab=column_out}
N 50 100 90 100 {lab=COL_OUT}
N -320 210 -320 240 {lab=GND}
N 190 -100 190 -70 {lab=GND}
N 190 -10 190 30 {lab=VDD_COL}
C {code_shown.sym} 690 10 0 0 {name=TRAN only_toplevel=false value=
"
.lib /home/alienfalcon/.ciel/sky130B/libs.tech/combined/sky130.lib.spice tt
.include "/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/dvs_2026/col_amp/xschem/read_row8.sp"

.option rshunt=1000T
.option trtol=7 abstol=1p chgtol=4e-16 vntol=1e-6 reltol=1e-4
.option temp=27

.GLOBAL VDD_COMP
.GLOBAL VDD_COL
.GLOBAL GND
.GLOBAL Reset

.param vdd = 1.8 	//supply voltage
.param tr = 1n		//rise time of voltage source signals
.param tf = 1n		//fall time of voltage source signals
.param pw = 70n		//pulse width
.param pw_chrg = 70n	//pulse width for ncharge signal
.param pw_rd = 220n	//pulse width for read signal
.param pw_det = 70n
.param pw_del = 70n	//setup and hold delays for pulses
.param pw_ld = 70n	//hold delay for latch for async
.param thresh = 1.05	//threshold voltage for comparator
.param col_cap = 300f	//column line capacitance

.param read_time = \{2*pw_chrg + 2*pw_rd + 6*pw_del\}

V_VDD VDD GND DC \{vdd\}
V_VDD_COL VDD_COL GND DC \{vdd\}
V_VDD_COMP VDD_COMP GND DC \{vdd\}
V_ON ON GND DC \{vdd-0.2\}
V_nOFF nOFF GND DC 0.2
V_THRESH VTHRESH GND DC \{thresh\}
E_nDETECT nDETECT VDD DETECT GND -1
E_RESET Reset VDD nCHARGE GND -1

V_READON READOFF GND pulse(0 \{vdd\} \{2*pw_chrg + 4*pw_del + pw_rd\} \{tr\} \{tf\} \{pw_det+pw_del\} \{read_time\})
V_READOFF READON GND pulse(0 \{vdd\} \{pw_chrg + pw_del\} \{tr\} \{tf\} \{pw_det+pw_del\} \{read_time\})

V_nCHARGE nCHARGE GND pulse(\{vdd\} 0 0 \{tr\} \{tf\} \{pw_chrg\} \{read_time/2\})
V_DETECT DETECT GND pulse(0 \{vdd\} \{pw_chrg + 2*pw_del\} \{tr\} \{tf\} \{pw_det\} \{read_time/2\})
V_LATCH L_r GND pulse(0 \{vdd\} \{pw_chrg+ 2*pw_del + pw_ld\} \{tr\} \{tf\} \{pw_det-pw_ld\} \{read_time/2\})


.control
	save v(column_out) v(nCHARGE) v(COL_OUT) v(ON) v(nOFF) v(READON) v(READOFF) v(DETECT) 
	save v(EVT_HIGH) v(EVT_LOW) v(VTHRESH)
	save v(L_a) v(L_r) v(R_r) v(R_a) v(Reset)
	save v(R_d[0]) v(R_d[1]) v(R_d[2]) v(R_d[3]) v(R_d[4]) v(R_d[5]) v(R_d[6]) v(R_d[7]) v(R_d[8])
	save i(V_VDD_COL) i(V_VDD_COMP)
	save nosub nointernals

	tran 1n 2u uic
	let Vc_max = 0
	let Vc_min = 0
	let tr_col_out = 0
	let tf_col_out = 0
	let tset_col_low = 0
	let tset_col_high = 0

	*meas tran Vc_max FIND v(COL_OUT) AT=1.3u
	*meas tran Vc_min FIND v(COL_OUT) AT=0.3u 

	*let V_diff = Vc_max - Vc_min
	*let Vc_10 = V_diff*0.1 + Vc_min
	*let Vc_90 = V_diff*0.9 + Vc_min
	*let Vc_set_low = Vc_max*0.98
	*let Vc_set_high = Vc_max*1.02

	*meas tran tr_col_out TRIG v(COL_OUT) VAL=Vc_10 CROSS=1 TARG v(COL_OUT) VAL=Vc_90 CROSS=1
	*meas tran tf_col_out TRIG v(COL_OUT) VAL=Vc_90 CROSS=2 TARG v(COL_OUT) VAL=Vc_10 CROSS=2
	*meas tran tset_col_low WHEN v(COL_OUT)=Vc_set_low RISE=LAST
	*meas tran tset_col_high WHEN v(COL_OUT)=Vc_set_high FALL=LAST

	*print Vc_max Vc_min
	*print tr_col_out tf_col_out tset_col_low tset_col_high

	*save tr_col_out tf_col_out tset_col_low tset_col_high

	write TRAN_TB_COL.raw
.endc


"}
C {col_amp.sym} 140 100 0 0 {name=X_COL_AMP1}
C {capa.sym} 430 240 0 0 {name=C2
m=1
value=\{col_cap\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 320 210 0 1 {name=p18 sig_type=std_logic lab=column_out
}
C {iopin.sym} 290 160 0 0 {name=p24 lab=nCHARGE}
C {iopin.sym} 310 330 0 0 {name=p27 lab=nOFF}
C {iopin.sym} 310 270 0 0 {name=p28 lab=READOFF}
C {iopin.sym} 70 330 0 1 {name=p29 lab=ON}
C {iopin.sym} 70 270 0 1 {name=p30 lab=READON}
C {iopin.sym} 170 30 0 1 {name=p31 lab=VDD_COL}
C {/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/dvs_2026/pixel/xschem/pix_or_gate.sym} 110 370 0 0 {name=X_or_gate1}
C {iopin.sym} 50 100 0 1 {name=p32 lab=COL_OUT}
C {/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/dvs_2026/pixel/xschem/pix_or_gate.sym} -300 370 0 0 {name=X_or_gate_extra1[62:0]}
C {iopin.sym} -100 330 0 0 {name=p33 lab=ON}
C {iopin.sym} -340 330 0 1 {name=p34 lab=ON}
C {iopin.sym} -110 100 0 0 {name=p35 lab=DETECT}
C {iopin.sym} -200 70 0 0 {name=p36 lab=VTHRESH}
C {iopin.sym} -300 150 0 0 {name=p37 lab=VDD_COMP}
C {iopin.sym} -500 40 0 1 {name=p38 lab=EVT_HIGH}
C {iopin.sym} -500 60 0 1 {name=p39 lab=EVT_LOW}
C {iopin.sym} -110 0 0 0 {name=p40 lab=nDETECT}
C {iopin.sym} -200 30 0 0 {name=p41 lab=COL_OUT}
C {lab_wire.sym} 430 300 0 1 {name=p42 sig_type=std_logic lab=GND}
C {lab_wire.sym} 150 400 0 1 {name=p43 sig_type=std_logic lab=GND}
C {lab_wire.sym} -260 400 0 1 {name=p44 sig_type=std_logic lab=GND}
C {lab_wire.sym} -100 270 0 1 {name=p45 sig_type=std_logic lab=GND}
C {lab_wire.sym} -340 270 0 0 {name=p46 sig_type=std_logic lab=GND}
C {lab_wire.sym} -380 150 0 0 {name=p47 sig_type=std_logic lab=GND}
C {lab_wire.sym} 220 30 0 1 {name=p48 sig_type=std_logic lab=GND}
C {dyn_comp.sym} -250 100 0 1 {name=x1}
C {capa.sym} -320 180 0 0 {name=C1
m=1
value=300f
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} -320 240 0 0 {name=p1 sig_type=std_logic lab=GND}
C {capa.sym} 190 -40 2 0 {name=C3
m=1
value=1p
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 190 -100 2 0 {name=p2 sig_type=std_logic lab=GND}
