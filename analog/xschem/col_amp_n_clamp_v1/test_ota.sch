v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -260 170 -220 170 {lab=vdd}
N -260 80 -260 140 {lab=vdd}
N 270 130 310 130 {lab=gnd}
N 270 80 270 100 {lab=vdd}
N 190 130 230 130 {lab=vout_p}
N 270 160 270 220 {lab=Iload_p}
N 100 130 190 130 {lab=vout_p}
N 850 130 890 130 {lab=vdd}
N 850 80 850 100 {lab=Iload_nmir}
N 850 80 910 80 {lab=Iload_nmir}
N 770 130 810 130 {lab=vout_nmir}
N 850 220 890 220 {lab=gnd}
N 850 160 850 220 {lab=gnd}
N 680 130 770 130 {lab=vout_nmir}
N 270 370 310 370 {lab=gnd}
N 270 320 270 340 {lab=vdd}
N 190 370 230 370 {lab=vout_pmir}
N 270 400 270 460 {lab=Iload_pmir}
N 100 370 190 370 {lab=vout_pmir}
N 850 370 890 370 {lab=vdd}
N 850 320 850 340 {lab=Iload_n}
N 850 320 910 320 {lab=Iload_n}
N 770 370 810 370 {lab=vout_n}
N 850 460 890 460 {lab=gnd}
N 850 400 850 460 {lab=gnd}
N 680 370 770 370 {lab=vout_n}
N 70 170 70 200 {lab=gnd}
N 30 170 30 220 {lab=vbias_p}
N 630 170 630 220 {lab=vdd}
N 650 170 650 200 {lab=gnd}
N 610 170 610 220 {lab=vbias_nmir}
N 630 410 630 460 {lab=vdd}
N 650 410 650 440 {lab=gnd}
N 610 410 610 460 {lab=vbias_n}
N 50 410 50 460 {lab=vdd}
N 70 410 70 440 {lab=gnd}
N 30 410 30 460 {lab=vbias_pmir}
N -40 380 -0 380 {lab=Iload_pmir}
N -40 140 0 140 {lab=Iload_p}
N 540 140 580 140 {lab=Iload_nmir}
N 540 380 580 380 {lab=Vconst_n}
N -120 360 -0 360 {lab=Vp_p}
N -120 120 0 120 {lab=Vp_p}
N 460 120 580 120 {lab=Vp_n}
N 460 360 580 360 {lab=Vp_n}
N 50 170 50 250 {lab=vdd}
N 1120 150 1160 150 {lab=gnd}
N 1120 240 1160 240 {lab=gnd}
N 1120 180 1120 240 {lab=gnd}
N 1120 60 1120 120 {lab=vbias_nmir}
N 1080 100 1080 150 {lab=vbias_nmir}
N 1080 100 1120 100 {lab=vbias_nmir}
N 1120 370 1160 370 {lab=gnd}
N 1120 460 1160 460 {lab=gnd}
N 1120 400 1120 460 {lab=gnd}
N 1120 280 1120 340 {lab=vbias_n}
N 1080 320 1080 370 {lab=vbias_n}
N 1080 320 1120 320 {lab=vbias_n}
N -260 390 -220 390 {lab=vdd}
N -260 300 -260 360 {lab=vdd}
N -260 200 -260 240 {lab=vbias_pmir}
N -300 240 -260 240 {lab=vbias_pmir}
N -300 170 -300 240 {lab=vbias_pmir}
N -260 420 -260 460 {lab=vbias_p}
N -300 460 -260 460 {lab=vbias_p}
N -300 390 -300 460 {lab=vbias_p}
N 200 270 200 300 {lab=gnd}
N 200 210 270 210 {lab=Iload_p}
C {code.sym} 420 -220 0 0 {name=s1 only_toplevel=false value=
"
Vvdd vdd gnd set_vdd
Vvpp Vp_p gnd set_vp AC 1 0
Vvpn Vp_n gnd set_vn AC 1 0
Vvnp Vconst_p gnd set_vp
Vvnn Vconst_n gnd set_vn

*Vvdd vdd gnd set_vdd
*Vvp Vp gnd set_vp AC 1 0
*Vvn Vconst gnd set_vn

*bias for ota
Iibias_p vbias_p gnd DC set_bias_p
Iibias_pmir vbias_pmir gnd DC set_bias_p
Iibias_nmir vdd vbias_nmir DC set_bias
Iibias_n vdd vbias_n DC set_bias

*load for the ota

Iiload_pmir Iload_pmir gnd DC set_load
Iiload_p Iload_p gnd DC set_load
Iiload_nmir vdd Iload_nmir DC set_load
Iiload_n vdd Iload_n DC set_load

*set parameters
.param set_vdd = 1.8
.param set_vn = 1.5
.param set_vp = 0.3
.param set_bias_p = 100n
.param set_bias = 5n
.param set_load = 200n

*set options
.options reltol=1e-6 abstol=1e-15 vntol=1e-9 gmin=1e-15 
.option trtol=4 chgtol=1e-18
.option temp=30
.option tnom=30

.control
	save all
	op

	dc Vvpp 0 1.8 0.001
	
	plot v(vout_pmir) v(vout_p)
	
	ac dec 10 1 10T
 	
	plot vdb(vout_pmir) vdb(vout_p) 
	plot vp(vout_pmir) vp(vout_p) 

	dc Vvpn 0 1.8 0.001
	
	plot v(vout_nmir) v(vout_n)

	ac dec 10 1 10T
 	
	*plot vdb(vout_nmir) vdb(vout_n) 
	*plot vp(vout_nmir) vp(vout_n)
	*plot vdb(vout_nmir) vdb(vout_p)
	*plot vp(vout_nmir) vp(vout_p)
	*plot vdb(vout_nmir)
	plot vdb(vout_p)
	*plot vp(vout_nmir)
	plot vp(vout_p)

	*print all

	meas ac vout_pmir_gain find vdb(vout_pmir) AT=10
	let v_gain_bw = vout_pmir_gain - 3
	meas ac v_pmir_bw when vdb(vout_pmir)=v_gain_bw CROSS=1
	meas ac v_pmir_ft when vdb(vout_pmir)=0 CROSS=1
	meas ac vout_pmir_ph find vp(vout_pmir) AT=v_pmir_ft
	let vout_pmir_pm = 180*(pi - abs(vout_pmir_ph))/pi
	print vout_pmir_pm
	*print vout_pmir_gain
	*print v_pmir_bw

	meas ac vout_p_gain find vdb(vout_p) AT=10
	let v_gain_bw = vout_p_gain - 3
	meas ac v_p_bw when vdb(vout_p)=v_gain_bw CROSS=1
	meas ac v_p_ft when vdb(vout_p)=0 CROSS=1
	meas ac vout_p_ph find vp(vout_p) AT=v_p_ft
	let vout_p_pm = 180*(pi - abs(vout_p_ph))/pi
	print vout_p_pm
	*print vout_p_gain
	*print v_p_bw

	meas ac vout_nmir_gain find vdb(vout_nmir) AT=10
	let v_gain_bw = vout_nmir_gain - 3
	meas ac v_nmir_bw when vdb(vout_nmir)=v_gain_bw CROSS=1
	meas ac v_nmir_ft when vdb(vout_nmir)=0 CROSS=1
	meas ac vout_nmir_ph find vp(vout_nmir) AT=v_nmir_ft
	let vout_nmir_pm = 180*(pi - abs(vout_nmir_ph))/pi
	print vout_nmir_pm
	*print vout_nmir_gain
	*print v_nmir_bw

	meas ac vout_n_gain find vdb(vout_n) AT=10
	let v_gain_bw = vout_n_gain - 3
	meas ac v_n_bw when vdb(vout_n)=v_gain_bw CROSS=1
	meas ac v_n_ft when vdb(vout_n)=0 CROSS=1
	meas ac vout_n_ph find vp(vout_n) AT=v_n_ft
	let vout_n_pm = 180*(pi - abs(vout_n_ph))/pi
	print vout_n_pm
	*print vout_n_gain
	*print v_n_bw
	
	
	write test_ota.raw
.endc
"


 
}
C {devices/code.sym} 250 -220 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {lab_wire.sym} -220 170 0 0 {name=p13 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -260 80 0 0 {name=p14 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -300 240 0 0 {name=p15 sig_type=std_logic lab=vbias_pmir}
C {lab_wire.sym} 310 130 0 0 {name=p16 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 270 80 0 0 {name=p17 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 200 370 0 0 {name=p18 sig_type=std_logic lab=vout_pmir}
C {iopin.sym} 270 440 0 0 {name=p20 lab=Iload_pmir}
C {/home/user/projects/open_dvs/analog/amp_n_mir.sym} 600 130 0 0 {name=x1}
C {/home/user/projects/open_dvs/analog/amp_p_mir.sym} 20 370 0 0 {name=x2}
C {lab_wire.sym} 890 130 0 0 {name=p1 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 890 220 0 0 {name=p2 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 770 130 0 0 {name=p3 sig_type=std_logic lab=vout_nmir}
C {iopin.sym} 910 80 0 0 {name=p4 lab=Iload_nmir}
C {sky130_fd_pr/nfet_01v8.sym} 250 370 0 0 {name=Mnc2
W=0.75
L=1
nf=1 
mult=4
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {lab_wire.sym} 310 370 0 0 {name=p5 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 270 320 0 0 {name=p6 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 190 130 0 0 {name=p7 sig_type=std_logic lab=vout_p}
C {iopin.sym} 270 220 0 0 {name=p8 lab=Iload_p}
C {lab_wire.sym} 890 370 0 0 {name=p9 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 890 460 0 0 {name=p10 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 770 370 0 0 {name=p11 sig_type=std_logic lab=vout_n}
C {iopin.sym} 910 320 0 0 {name=p12 lab=Iload_n}
C {lab_wire.sym} 630 220 3 0 {name=p23 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 650 200 3 0 {name=p24 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 630 460 3 0 {name=p26 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 650 440 3 0 {name=p27 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 50 460 3 0 {name=p29 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 70 440 3 0 {name=p30 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -120 360 0 0 {name=p36 sig_type=std_logic lab=Vp_p}
C {lab_wire.sym} 460 360 0 0 {name=p39 sig_type=std_logic lab=Vp_n}
C {iopin.sym} -120 120 0 1 {name=p40 lab=Vp_p}
C {iopin.sym} -40 140 0 1 {name=p41 lab=Iload_p}
C {iopin.sym} 30 460 0 1 {name=p42 lab=vbias_pmir}
C {iopin.sym} 610 220 0 1 {name=p43 lab=vbias_nmir}
C {iopin.sym} 30 220 0 1 {name=p44 lab=vbias_p}
C {iopin.sym} 610 460 0 1 {name=p45 lab=vbias_n}
C {iopin.sym} 50 250 0 1 {name=p19 lab=vdd}
C {iopin.sym} 70 200 0 0 {name=p21 lab=gnd}
C {sky130_fd_pr/nfet_01v8.sym} 1100 150 0 0 {name=Mbias2
W=1.65
L=0.6
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
C {lab_wire.sym} 1160 150 0 0 {name=p22 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1160 240 0 0 {name=p25 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1110 100 0 0 {name=p28 sig_type=std_logic lab=vbias_nmir}
C {sky130_fd_pr/nfet_01v8.sym} 1100 370 0 0 {name=Mbias3
W=1
L=1
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
C {lab_wire.sym} 1160 370 0 0 {name=p31 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1160 460 0 0 {name=p33 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 1110 320 0 0 {name=p37 sig_type=std_logic lab=vbias_n}
C {lab_wire.sym} -220 390 0 0 {name=p46 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -260 300 0 0 {name=p47 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -300 460 0 0 {name=p48 sig_type=std_logic lab=vbias_p}
C {sky130_fd_pr/nfet_01v8.sym} 250 130 0 0 {name=Mnc1
W=0.75
L=1
nf=1 
mult=4
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 830 130 0 0 {name=M1
W=1.25
L=1
nf=1
mult=4
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 830 370 0 0 {name=M2
W=1.25
L=1
nf=1
mult=4
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} -280 170 0 0 {name=M3
W=2.7
L=0.6
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
C {sky130_fd_pr/pfet_01v8.sym} -280 390 0 0 {name=M4
W=0.5
L=1
nf=1
mult=4
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {iopin.sym} 460 120 0 1 {name=p38 lab=Vp_n}
C {iopin.sym} 540 380 0 1 {name=p34 lab=Vconst_n}
C {capa.sym} 200 240 0 0 {name=C1
m=1
value=300f
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 200 290 3 0 {name=p49 sig_type=std_logic lab=gnd}
C {iopin.sym} -40 380 0 1 {name=p32 lab=Iload_pmir}
C {iopin.sym} 540 140 0 1 {name=p35 lab=Iload_nmir}
C {/home/user/projects/nic2025_v2/nic2025_openDVS/analog/xschem/col_amp_n_clamp_v1/amp_p_5T.sym} 150 130 0 0 {name=x3}
C {/home/user/projects/open_dvs/analog/amp_n_5T.sym} 730 370 0 0 {name=x4}
