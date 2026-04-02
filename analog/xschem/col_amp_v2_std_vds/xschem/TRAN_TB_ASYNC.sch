v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 -410 -60 {}
N -120 110 -80 110 {lab=READON}
N -120 170 -80 170 {lab=ON}
N 80 170 120 170 {lab=nOFF}
N 80 110 120 110 {lab=READOFF}
N -40 200 -40 240 {lab=GND}
N -0 0 -0 50 {lab=column_out}
N 30 0 100 0 {lab=nCHARGE}
N 10 -130 30 -130 {lab=GND}
N -20 -130 -0 -130 {lab=VDD}
N 240 110 240 140 {lab=GND}
N -100 -60 -50 -60 {lab=COL_OUT}
N -410 50 -0 50 {lab=column_out}
N -330 110 -290 110 {lab=GND}
N -530 110 -490 110 {lab=GND}
N -450 200 -450 240 {lab=GND}
N -330 170 -290 170 {lab=ON}
N -530 170 -490 170 {lab=ON}
N -220 -240 -130 -240 {lab=GND}
N -430 -120 -380 -120 {lab=COL_OUT}
N -430 -80 -380 -80 {lab=VTHRESH}
N -560 0 -520 0 {lab=GND}
N -520 -40 -520 0 {lab=GND}
N -500 0 -480 0 {lab=VDD}
N -500 -40 -500 0 {lab=VDD}
N -680 -110 -630 -110 {lab=EVT_HIGH}
N -680 -70 -630 -70 {lab=EVT_LOW}
N -630 -90 -630 -70 {lab=EVT_LOW}
N -630 -90 -570 -90 {lab=EVT_LOW}
N -630 -110 -570 -110 {lab=EVT_HIGH}
N -280 -280 -230 -280 {lab=EVT_HIGH}
N -430 -50 -290 -50 {lab=DETECT}
N -290 -140 -290 -50 {lab=DETECT}
N -430 -140 -290 -140 {lab=DETECT}
N -430 -160 -290 -160 {lab=nDETECT}
N -430 -160 -430 -150 {lab=nDETECT}
N 0 50 240 50 {lab=column_out}
N -370 -350 -280 -350 {lab=L_r}
N -390 -510 -390 -420 {lab=R_a}
N -430 -510 -430 -420 {lab=R_r}
N -430 -620 -390 -620 {lab=#net1}
N -330 -330 -280 -330 {lab=L_a}
N -430 -400 -250 -400 {lab=R_r}
N -430 -420 -430 -400 {lab=R_r}
N -230 -420 -230 -400 {lab=R_a}
N -390 -420 -230 -420 {lab=R_a}
N -210 -800 -210 -580 {lab=R_d[0]}
N -200 -760 -200 -580 {lab=R_d[1]}
N -190 -720 -190 -580 {lab=R_d[2]}
N -180 -680 -180 -580 {lab=R_d[3]}
N -170 -640 -170 -580 {lab=R_d[4]}
N -210 -580 -210 -400 {lab=R_d[0]}
N -200 -580 -200 -400 {lab=R_d[1]}
N -190 -580 -190 -400 {lab=R_d[2]}
N -180 -580 -180 -400 {lab=R_d[3]}
N -170 -580 -170 -400 {lab=R_d[4]}
N -160 -600 -160 -400 {lab=R_d[5]}
N -150 -560 -150 -400 {lab=R_d[6]}
N -140 -520 -140 -400 {lab=R_d[7]}
N -130 -480 -130 -400 {lab=R_d[8]}
N -170 -280 -170 -240 {lab=GND}
N -180 -280 -180 -240 {lab=GND}
N -220 -280 -220 -240 {lab=GND}
N -210 -280 -210 -260 {lab=EVT_HIGH}
N -230 -260 -210 -260 {lab=EVT_HIGH}
N -230 -280 -230 -260 {lab=EVT_HIGH}
N -210 -260 -190 -260 {lab=EVT_HIGH}
N -190 -280 -190 -260 {lab=EVT_HIGH}
N -200 -280 -200 -260 {lab=EVT_HIGH}
N -160 -280 -160 -260 {lab=EVT_HIGH}
N -190 -260 -160 -260 {lab=EVT_HIGH}
C {col_amp.sym} -50 -60 0 0 {name=X_COL_AMP}
C {capa.sym} 240 80 0 0 {name=C1
m=1
value=\{col_cap\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 130 50 0 1 {name=p10 sig_type=std_logic lab=column_out
}
C {iopin.sym} 100 0 0 0 {name=p1 lab=nCHARGE}
C {iopin.sym} 120 170 0 0 {name=p4 lab=nOFF}
C {iopin.sym} 120 110 0 0 {name=p3 lab=READOFF}
C {iopin.sym} -120 170 0 1 {name=p6 lab=ON}
C {iopin.sym} -120 110 0 1 {name=p2 lab=READON}
C {iopin.sym} -20 -130 0 1 {name=p8 lab=VDD}
C {/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/dvs_2026/pixel/xschem/pix_or_gate.sym} -80 210 0 0 {name=X_or_gate}
C {iopin.sym} -100 -60 0 1 {name=p9 lab=COL_OUT}
C {/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/dvs_2026/pixel/xschem/pix_or_gate.sym} -490 210 0 0 {name=X_or_gate_extra[62:0]}
C {iopin.sym} -290 170 0 0 {name=p15 lab=ON}
C {iopin.sym} -530 170 0 1 {name=p16 lab=ON}
C {iopin.sym} -290 -140 0 0 {name=p17 lab=DETECT}
C {iopin.sym} -380 -80 0 0 {name=p19 lab=VTHRESH}
C {iopin.sym} -480 0 0 0 {name=p21 lab=VDD}
C {iopin.sym} -680 -110 0 1 {name=p22 lab=EVT_HIGH}
C {iopin.sym} -680 -70 0 1 {name=p23 lab=EVT_LOW}
C {iopin.sym} -280 -280 0 1 {name=p24 lab=EVT_HIGH}
C {iopin.sym} -290 -160 0 0 {name=p25 lab=nDETECT}
C {code_shown.sym} 390 -230 0 0 {name=TRAN only_toplevel=false value=
"
.lib /home/alienfalcon/.ciel/sky130B/libs.tech/combined/sky130.lib.spice tt
.include "/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/dvs_2026/col_amp/xschem/read_row8.sp"

.option rshunt=1000T
.option trtol=7 abstol=1p chgtol=4e-16 vntol=1e-6 reltol=1e-4
.option temp=27

.GLOBAL VDD
.GLOBAL GND
.GLOBAL Reset

.param vdd = 1.8 	//supply voltage
.param tr = 1p		//rise time of voltage source signals
.param tf = 1p		//fall time of voltage source signals
.param pw = 30n		//pulse width
.param pw_chrg = 30n	//pulse width for ncharge signal
.param pw_rd = 380n	//pulse width for read signal
.param pw_det = 60n
.param pw_del = 30n	//setup and hold delays for pulses
.param pw_ld = 20n	//hold delay for latch for async
.param thresh = 1.05	//threshold voltage for comparator
.param col_cap = 300f	//column line capacitance

.param read_time = \{2*pw_chrg + 2*pw_rd + 6*pw_del\}

V_VDD VDD GND DC \{vdd\}
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

	write TRAN_TB_ASYNC.raw
.endc


"}
C {iopin.sym} -370 -350 0 1 {name=p27 lab=L_r}
C {iopin.sym} -330 -330 0 1 {name=p28 lab=L_a}
C {iopin.sym} -210 -800 1 1 {name=p29 lab=R_d[0]}
C {iopin.sym} -200 -760 1 1 {name=p30 lab=R_d[1]}
C {iopin.sym} -190 -720 1 1 {name=p31 lab=R_d[2]}
C {iopin.sym} -180 -680 1 1 {name=p32 lab=R_d[3]}
C {iopin.sym} -170 -640 1 1 {name=p33 lab=R_d[4]}
C {iopin.sym} -160 -600 1 1 {name=p34 lab=R_d[5]}
C {iopin.sym} -150 -560 1 1 {name=p35 lab=R_d[6]}
C {iopin.sym} -140 -520 1 1 {name=p36 lab=R_d[7]}
C {iopin.sym} -130 -480 1 1 {name=p37 lab=R_d[8]}
C {iopin.sym} -430 -450 0 1 {name=p38 lab=R_r}
C {iopin.sym} -390 -450 0 0 {name=p39 lab=R_a}
C {_0_0cell_0_0ginvx1.sym} -390 -590 1 0 {name=x3}
C {_0_0cell_0_0ginvx1.sym} -430 -540 3 0 {name=x4}
C {ring_decomp_rowread.sym} -190 -340 0 0 {name=x2}
C {iopin.sym} -380 -120 0 0 {name=p26 lab=COL_OUT}
C {lab_wire.sym} 240 140 0 1 {name=p5 sig_type=std_logic lab=GND}
C {lab_wire.sym} -40 240 0 1 {name=p12 sig_type=std_logic lab=GND}
C {lab_wire.sym} -450 240 0 1 {name=p14 sig_type=std_logic lab=GND}
C {lab_wire.sym} -290 110 0 1 {name=p11 sig_type=std_logic lab=GND}
C {lab_wire.sym} -530 110 0 0 {name=p13 sig_type=std_logic lab=GND}
C {lab_wire.sym} -560 0 0 0 {name=p40 sig_type=std_logic lab=GND}
C {lab_wire.sym} 30 -130 0 1 {name=p7 sig_type=std_logic lab=GND}
C {lab_wire.sym} -130 -240 0 1 {name=p18 sig_type=std_logic lab=GND}
