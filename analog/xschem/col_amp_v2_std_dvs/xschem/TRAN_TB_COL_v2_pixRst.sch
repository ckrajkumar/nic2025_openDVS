v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 -360 -10 {}
N 40 340 80 340 {lab=READON}
N 240 340 280 340 {lab=READOFF}
N -160 220 -160 260 {lab=GND}
N 160 60 160 110 {lab=column_out}
N 190 60 260 60 {lab=nCHARGE}
N 170 -70 190 -70 {lab=GND}
N 140 -70 160 -70 {lab=VDD_COL}
N 400 170 400 200 {lab=GND}
N 60 0 110 0 {lab=COL_OUT}
N 680 490 720 490 {lab=GND}
N 480 490 520 490 {lab=GND}
N 560 580 560 620 {lab=GND}
N 680 550 720 550 {lab=ON}
N 480 550 520 550 {lab=ON}
N -380 -70 -330 -70 {lab=COL_OUT}
N -380 -30 -330 -30 {lab=VTHRESH}
N -510 50 -470 50 {lab=GND}
N -470 10 -470 50 {lab=GND}
N -450 50 -430 50 {lab=VDD_COMP}
N -450 10 -450 50 {lab=VDD_COMP}
N -630 -60 -580 -60 {lab=VOUT_P}
N -630 -40 -580 -40 {lab=VOUT_N}
N -580 -40 -520 -40 {lab=VOUT_N}
N -580 -60 -520 -60 {lab=VOUT_P}
N -380 0 -240 0 {lab=DETECT}
N -380 -100 -240 -100 {lab=nDETECT}
N 160 110 400 110 {lab=column_out}
N 20 0 60 0 {lab=COL_OUT}
N -450 110 -450 140 {lab=GND}
N 160 -200 160 -170 {lab=GND}
N 160 -110 160 -70 {lab=VDD_COL}
N 600 280 600 430 {lab=column_out}
N 160 110 160 280 {lab=column_out}
N 160 280 600 280 {lab=column_out}
N -180 220 -180 260 {lab=VDD}
N -20 440 40 440 {lab=bias_on}
N -20 600 40 600 {lab=bias_off}
N -240 600 -240 660 {lab=DiffBn}
N -500 560 -440 560 {lab=pixRst}
N -500 460 -440 460 {lab=RefrBp}
N -30 1100 0 1100 {lab=vdd}
N 0 1020 0 1070 {lab=vdd}
N 40 1100 40 1160 {lab=RefrBp}
N 0 1160 40 1160 {lab=RefrBp}
N 240 1140 240 1180 {lab=gnd}
N 240 1110 270 1110 {lab=gnd}
N 200 1040 200 1110 {lab=DiffBn}
N 200 1040 240 1040 {lab=DiffBn}
N 240 1040 240 1080 {lab=DiffBn}
N 0 1130 0 1160 {lab=RefrBp}
N 440 1140 440 1180 {lab=GND}
N 440 1110 470 1110 {lab=GND}
N 400 1040 400 1110 {lab=bias_on}
N 400 1040 440 1040 {lab=bias_on}
N 440 1040 440 1080 {lab=bias_on}
N 640 1140 640 1180 {lab=GND}
N 640 1110 670 1110 {lab=GND}
N 600 1040 600 1110 {lab=bias_off}
N 600 1040 640 1040 {lab=bias_off}
N 640 1040 640 1080 {lab=bias_off}
N -430 -230 -430 -200 {lab=evt_on}
N -120 -530 -100 -530 {lab=GLOBAL_PIX_RST}
N -660 -240 -560 -240 {lab=CLK}
N -600 320 -300 320 {lab=VSF}
N -790 320 -760 320 {lab=vdd}
N -760 240 -760 290 {lab=VDD}
N -720 320 -720 380 {lab=VSF}
N -760 380 -720 380 {lab=VSF}
N -760 350 -760 380 {lab=VSF}
N -760 380 -760 460 {lab=VSF}
N -720 320 -600 320 {lab=VSF}
N 300 800 300 840 {lab=GND}
N 420 710 460 710 {lab=GND}
N 220 710 260 710 {lab=GND}
N 340 280 340 650 {lab=column_out}
N 220 770 260 770 {lab=GND}
N 420 770 460 770 {lab=GND}
N -400 -230 -400 -170 {lab=EN_OFF}
N -340 -230 -340 -160 {lab=RST_REG}
N -280 -230 -280 -200 {lab=evt_off}
N 20 -430 100 -430 {lab=pixRst}
N -100 -530 -100 -480 {lab=GLOBAL_PIX_RST}
N -300 -480 -200 -480 {lab=READON_RST}
N -620 -390 -620 -40 {lab=VOUT_N}
N -620 -390 -560 -390 {lab=VOUT_N}
N -600 -340 -560 -340 {lab=VOUT_P}
N -580 -310 -580 -200 {lab=EN_ON}
N -580 -310 -560 -310 {lab=EN_ON}
N -600 -340 -600 -60 {lab=VOUT_P}
N 400 -120 400 -90 {lab=GND}
N 400 -220 400 -180 {lab=VDD}
C {col_amp.sym} 110 0 0 0 {name=X_COL_AMP1}
C {capa.sym} 400 140 0 0 {name=C2
m=1
value=\{col_cap\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 290 110 0 1 {name=p18 sig_type=std_logic lab=column_out
}
C {iopin.sym} 260 60 0 0 {name=p24 lab=nCHARGE}
C {iopin.sym} 140 -70 0 1 {name=p31 lab=VDD_COL}
C {iopin.sym} 20 0 0 1 {name=p32 lab=COL_OUT}
C {/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/dvs_2026/pixel/xschem/pix_or_gate.sym} 520 590 0 0 {name=X_or_gate_extra1[62:0]}
C {iopin.sym} 720 550 0 0 {name=p33 lab=ON}
C {iopin.sym} 480 550 0 1 {name=p34 lab=ON}
C {iopin.sym} -240 0 0 0 {name=p35 lab=DETECT}
C {iopin.sym} -330 -30 0 0 {name=p36 lab=VTHRESH}
C {iopin.sym} -430 50 0 0 {name=p37 lab=VDD_COMP}
C {iopin.sym} -630 -60 0 1 {name=p38 lab=VOUT_P}
C {iopin.sym} -630 -40 0 1 {name=p39 lab=VOUT_N}
C {iopin.sym} -240 -100 0 0 {name=p40 lab=nDETECT}
C {iopin.sym} -330 -70 0 0 {name=p41 lab=COL_OUT}
C {lab_wire.sym} 400 200 0 1 {name=p42 sig_type=std_logic lab=GND}
C {lab_wire.sym} -160 220 0 1 {name=p43 sig_type=std_logic lab=GND}
C {lab_wire.sym} 560 620 0 1 {name=p44 sig_type=std_logic lab=GND}
C {lab_wire.sym} 720 490 0 1 {name=p45 sig_type=std_logic lab=GND}
C {lab_wire.sym} 480 490 0 0 {name=p46 sig_type=std_logic lab=GND}
C {lab_wire.sym} -510 50 0 0 {name=p47 sig_type=std_logic lab=GND}
C {lab_wire.sym} 190 -70 0 1 {name=p48 sig_type=std_logic lab=GND}
C {dyn_comp.sym} -380 0 0 1 {name=x1}
C {capa.sym} -450 80 0 0 {name=C1
m=1
value=1p
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} -450 140 0 0 {name=p1 sig_type=std_logic lab=GND}
C {capa.sym} 160 -140 2 0 {name=C3
m=1
value=1p
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 160 -200 2 0 {name=p2 sig_type=std_logic lab=GND}
C {lab_wire.sym} -180 220 0 0 {name=p3 sig_type=std_logic lab=VDD}
C {iopin.sym} 40 440 0 0 {name=p4 lab=bias_on}
C {iopin.sym} 40 600 0 0 {name=p5 lab=bias_off}
C {iopin.sym} -240 660 2 0 {name=p6 lab=DiffBn}
C {iopin.sym} -480 460 3 0 {name=p8 lab=RefrBp}
C {iopin.sym} -760 460 2 0 {name=p9 lab=VSF}
C {iopin.sym} -500 560 0 1 {name=p7 lab=pixRst}
C {code_shown.sym} 940 -120 0 0 {name=TRAN only_toplevel=false value=
"
.lib /home/alienfalcon/.ciel/sky130B/libs.tech/combined/sky130.lib.spice tt
.include "/home/alienfalcon/.ciel/sky130B/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice"

*.include "/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/dvs_2026/dig_col_interface/spice_files/reg_pix_rst.sp"

.option rshunt=1000T
.option trtol=7 abstol=1p chgtol=4e-16 vntol=1e-6 reltol=1e-4
.option temp=27

.GLOBAL VDD_COMP
.GLOBAL VDD_COL
.GLOBAL VDD
.GLOBAL GND

.param vdd = 1.8 	//supply voltage
.param tr = 1n		//rise time of voltage source signals
.param tf = 1n		//fall time of voltage source signals
.param clk_tr = 1p	//rise time for the clk signal
.param clk_tf = 1p	//fall time for the clk signal
.param clk_pw = 10n	//pulse width for the clk signal

.param pw = 80n			//pulse width
.param pw_chrg = pw		//pulse width for ncharge signal
.param pw_rd = \{(500e-9)-4*(pw)\}	//pulse width for read signal
.param pw_det = \{pw\}
.param pw_del = \{pw\}		//setup and hold delays for pulses
.param pw_ld = \{pw\}		//hold delay for latch for async
.param pw_en = \{pw/2\}

.param thresh = 1.05		//threshold voltage for comparator
.param col_cap = 300f		//column line capacitance

.param diff_amp_bias = 10n
.param on_detect_bias = 7n
.param off_detect_bias = 13n
.param rst_bias = 1u

.param cur_offset = 50n
.param cur_amp = 20n
.param pw_cur = 2u
.param cur_delay = 2.04u

.param read_time = \{2*pw_chrg + 2*pw_rd + 6*pw_del\}
.param run_time = 10u

V_VDD VDD GND DC \{vdd\}
V_VDD_COL VDD_COL GND DC \{vdd\}
V_VDD_COMP VDD_COMP GND DC \{vdd\}
V_ON ON GND DC \{vdd-0.2\}
V_nOFF nOFF GND DC 0.2
V_THRESH VTHRESH GND DC \{thresh\}
V_MEAS_CUR VSF VSF_OUT DC 0
I_VSF_HIGH VSF_OUT GND pulse(\{cur_offset\} \{cur_amp + cur_offset\} \{cur_delay\} \{tr\} \{tf\} \{pw_cur\} \{cur_delay + 4*pw_cur\})
I_VSF_LOW VSF_OUT GND pulse(\{cur_offset\} \{-cur_amp + cur_offset\} \{cur_delay + 2*pw_cur\} \{tr\} \{tf\} \{pw_cur\} \{cur_delay + 4*pw_cur\})

I_diffbias VDD DiffBn DC \{diff_amp_bias\}
I_rstbias RefrBp GND DC \{rst_bias\}
I_biason VDD bias_on DC \{on_detect_bias\}
I_biasoff VDD bias_off DC \{off_detect_bias\}

V_CLK CLK GND pulse(0 \{vdd\} 0 \{clk_tr\} \{clk_tf\} \{clk_pw-clk_tr\} \{clk_pw*2 - clk_tr - clk_tf\})

V_EN_ON EN_ON GND pulse(0 \{vdd\} \{pw_chrg + 2*pw_del + pw_en\} \{clk_tr\} \{clk_tf\} \{pw_en\} \{read_time\})
V_EN_OFF EN_OFF GND pulse(0 \{vdd\} \{2*pw_chrg + 6*pw_del + pw_en\} \{clk_tr\} \{clk_tf\} \{pw_en\} \{read_time\})
V_GLOBAL_RST GLOBAL_PIX_RST GND pulse(\{vdd\} 0 \{read_time\} \{tr\} \{tf\} \{run_time-read_time\} \{run_time\})
V_RST RST_REG GND pulse(\{vdd\} 0 \{2*pw_chrg + 6*pw_del + pw_det + 2*pw\} \{clk_tr\} \{clk_tf\} \{pw_en\} \{read_time\})

V_READOFF READOFF GND pulse(0 \{vdd\} \{2*pw_chrg + 5*pw_del\} \{tr\} \{tf\} \{pw_det+pw_del\} \{read_time\})
V_READON READON READON_RST pulse(0 \{vdd\} \{pw_chrg + pw_del\} \{tr\} \{tf\} \{pw_det+pw_del\} \{read_time\})
V_READON_RST READON_RST GND pulse(0 \{vdd\} \{2*pw_chrg + 6*pw_del + pw_det + pw_en\} \{tr\} \{tf\} \{pw\} \{read_time\})

V_CHARGE_ON CHARGE_ON GND pulse(0 \{vdd\} 0 \{tr\} \{tf\} \{pw_chrg\} \{read_time\})
V_CHARGE_OFF CHARGE CHARGE_ON pulse(0 \{vdd\} \{pw_chrg + 3*pw_del + pw_det\} \{tr\} \{tf\} \{pw_chrg\} \{read_time\})
E_nCHARGE nCHARGE VDD CHARGE GND -1

V_DETECT_ON DETECT_ON GND pulse(0 \{vdd\} \{pw_chrg + 2*pw_del\} \{tr\} \{tf\} \{pw_det\} \{read_time\})
V_DETECT_OFF DETECT DETECT_ON pulse(0 \{vdd\} \{2*pw_chrg + 6*pw_del\} \{tr\} \{tf\} \{pw_det\} \{read_time\})
E_nDETECT nDETECT VDD DETECT GND -1

.control
	save v(column_out) v(nCHARGE) v(COL_OUT) v(ON) v(nOFF) v(READON) v(READOFF) v(DETECT) v(nDETECT) 
	save v(VOUT_P) v(VOUT_N) v(VTHRESH)
	save v(EN_ON) v(EN_OFF) v(rst_reg) 
	save v(clk)
	save v(x2.x4.nrst) v(x2.vdiff) v(x2.x4.vd) v(x2.noff) v(x2.on)
	save v(evt_on) v(evt_off) v(pixRst) v(READON_RST) v(GLOBAL_PIX_RST)
	save v(VSF)
	save i(v_meas_cur)
	save i(V_VDD_COL) i(V_VDD_COMP) i(VDD)
	

	tran 1n 10u uic


	write TRAN_TB_COL_v2_pixRst.raw
.endc


"}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 20 1100 0 1 {name=MrefrBias
W=2
L=8
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
C {lab_wire.sym} -30 1100 0 1 {name=p57 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 0 1020 0 1 {name=p10 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/nfet_01v8.sym} 220 1110 0 0 {name=MoffBias
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
C {lab_wire.sym} 240 1180 0 0 {name=p12 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 270 1110 0 0 {name=p13 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 100 -430 0 0 {name=p15 sig_type=std_logic lab=pixRst}
C {lab_wire.sym} -280 -200 0 1 {name=p17 sig_type=std_logic lab=evt_off}
C {lab_wire.sym} -430 -200 0 0 {name=p19 sig_type=std_logic lab=evt_on}
C {lab_wire.sym} 40 1160 0 1 {name=p23 sig_type=std_logic lab=RefrBp}
C {/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/dvs_2026/pixel/xschem/pixamp_to_col.sym} -300 520 0 0 {name=x2}
C {lab_wire.sym} 200 1040 0 0 {name=p11 sig_type=std_logic lab=DiffBn}
C {sky130_fd_pr/nfet_01v8.sym} 420 1110 0 0 {name=MoffBias1
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
C {lab_wire.sym} 470 1110 0 0 {name=p14 sig_type=std_logic lab=GND
}
C {lab_wire.sym} 440 1180 0 0 {name=p26 sig_type=std_logic lab=GND
}
C {sky130_fd_pr/nfet_01v8.sym} 620 1110 0 0 {name=MoffBias2
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
C {lab_wire.sym} 670 1110 0 0 {name=p27 sig_type=std_logic lab=GND
}
C {lab_wire.sym} 640 1180 0 0 {name=p29 sig_type=std_logic lab=GND
}
C {lab_wire.sym} 400 1040 0 0 {name=p49 sig_type=std_logic lab=bias_on}
C {lab_wire.sym} 600 1040 0 0 {name=p50 sig_type=std_logic lab=bias_off}
C {iopin.sym} -120 -530 0 1 {name=p51 lab=GLOBAL_PIX_RST}
C {iopin.sym} -340 -160 0 0 {name=p16 lab=RST_REG}
C {iopin.sym} -400 -170 0 1 {name=p20 lab=EN_OFF}
C {iopin.sym} -580 -200 0 0 {name=p22 lab=EN_ON}
C {iopin.sym} -660 -240 0 1 {name=p21 lab=CLK}
C {sky130_fd_pr/pfet_01v8_hvt.sym} -740 320 0 1 {name=DIODE_VIN
W=2
L=2
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
C {lab_wire.sym} -790 320 0 1 {name=p25 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -760 240 0 1 {name=p52 sig_type=std_logic lab=VDD}
C {/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/dvs_2026/pixel/xschem/pix_or_gate.sym} 260 810 0 0 {name=X_or_gate_extra}
C {lab_wire.sym} 300 840 0 1 {name=p53 sig_type=std_logic lab=GND}
C {lab_wire.sym} 220 770 0 0 {name=p56 sig_type=std_logic lab=GND}
C {lab_wire.sym} 460 770 0 1 {name=p58 sig_type=std_logic lab=GND}
C {iopin.sym} 280 340 0 0 {name=p28 lab=READOFF}
C {iopin.sym} 40 340 0 1 {name=p30 lab=READON}
C {lab_wire.sym} 460 710 0 1 {name=p54 sig_type=std_logic lab=GND}
C {lab_wire.sym} 220 710 0 0 {name=p55 sig_type=std_logic lab=GND}
C {iopin.sym} -300 -480 0 1 {name=p59 lab=READON_RST}
C {/home/alienfalcon/Projects/skywater/open_dvs_py312/open_dvs/dvs_2026/dig_col_interface/symbols/reg_pix_rst.sym} -540 -280 0 0 {name=x3}
C {capa.sym} 400 -150 0 0 {name=C4
m=1
value=1p
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 400 -90 0 0 {name=p60 sig_type=std_logic lab=GND}
C {iopin.sym} 400 -220 0 1 {name=p61 lab=VDD}
