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
N -410 110 -410 150 {lab=COL_GND}
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
.lib /home/alienfalcon/.ciel/sky130B/libs.tech/combined/sky130.lib.spice tt_mm

.option trtol=1 abstol=1p chgtol=4e-16 vntol=1e-9 reltol=1e-6
.option temp=27

.param vdd = 1.8
.param tr = 1p
.param tf = 1p
.param pw = 1u
.param col_cap = 300f
.param leakage = 5p

V_VDD VDD COL_GND DC \{vdd\}
V_GND COL_GND 0 DC 0
V_ON ON COL_GND DC \{vdd\}
V_nOFF nOFF COL_GND DC 0
V_READON READON COL_GND pulse(0 \{vdd\} \{3*pw\} \{tr\} \{tf\} \{pw\} \{5*pw\})
V_READOFF READOFF COL_GND DC 0
V_nCHARGE nCHARGE COL_GND pulse(\{vdd\} 0 \{pw\} \{tr\} \{tf\} \{pw\} \{5*pw\})

.control
	option SEED=random	
	let mc_runs = 100
	let run = 1
	let V_diff = 0
	let Vc_10 = 0
	let Vc_90 = 0
	let Vc_set_low = 0
	let Vc_set_high = 0
	let Vc_max = 0
	let Vc_min_rst = 0
	let Vc_max_rst = 0
	let Vc_min = 0
	let start_pulse = 4u
	let tset_col_setlow = 0
	let tset_col_high_trig = 0
	let tset_col_low_trig = 0
	let tf_col_out = 0
	
	save none 
	
	op
	write TRAN_TF_TB.raw 

	set appendwrite
	dowhile run <= mc_runs
		
		save v(COL_OUT) tset_col tf_col_out nosub nointernals
		optran 0 0 0 1p 10n 0 
		tran 0.1n 5u

		set run = "$&run"

		meas tran Vc_max FIND v(COL_OUT) AT=1.3u
		meas tran Vc_max_rst FIND v(COL_OUT) AT=1.1u
		meas tran Vc_min FIND v(COL_OUT) AT=0.3u
		meas tran Vc_min_rst FIND v(COL_OUT) AT=3.1u 
		let V_diff = Vc_max - Vc_min
		let Vc_mid = (Vc_max_rst + Vc_min_rst)/2
		let Vc_10 = V_diff*0.1 + Vc_min
		let Vc_90 = V_diff*0.9 + Vc_min
		let Vc_set_low = Vc_min*0.98
		let Vc_set_high = Vc_min*1.02

		*meas tran tr_col_out TRIG v(COL_OUT) VAL=Vc_10 CROSS=1 TARG v(COL_OUT) VAL=Vc_90 CROSS=1
		meas tran tf_col_out TRIG v(COL_OUT) VAL=Vc_90 FALL=LAST TARG v(COL_OUT) VAL=Vc_10 FALL=LAST
		meas tran tset_col_low WHEN v(COL_OUT)=Vc_set_low RISE=LAST
		meas tran tset_col_high WHEN v(COL_OUT)=Vc_set_high FALL=LAST

		let tset_col_setlow = ((tset_col_low + tset_col_high)/2) - start_pulse

		write TRAN_TF_TB.raw tset_col_setlow tf_col_out 
		write TRAN_TF_TB.raw Vc_max_rst Vc_min_rst
		let run = run + 1
		reset
	end
	unset appendwrite
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
C {isource.sym} -410 80 0 0 {name=I0 value=\{leakage\}}
C {iopin.sym} -410 150 0 0 {name=p11 lab=COL_GND}
