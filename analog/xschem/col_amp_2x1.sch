v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 140 -120 220 -120 {lab=#net1}
N 140 -80 220 -80 {lab=VTHRESH}
N 70 -40 70 20 {lab=VDD}
N 50 -40 50 20 {lab=GND}
N -60 -90 0 -90 {lab=voutn[0]}
N 140 -50 140 10 {lab=DETECT}
N 270 -250 270 -190 {lab=VDD}
N 280 -250 280 -190 {lab=GND}
N 300 -60 300 0 {lab=nCHARGE}
N 270 -60 270 0 {lab=readLine[0]}
N 140 -210 140 -150 {lab=nDETECT}
N 140 150 220 150 {lab=#net2}
N 140 190 220 190 {lab=VTHRESH}
N 70 230 70 290 {lab=VDD}
N 50 230 50 290 {lab=GND}
N -60 180 0 180 {lab=voutn[1]}
N 140 220 140 280 {lab=DETECT}
N 270 20 270 80 {lab=VDD}
N 280 20 280 80 {lab=GND}
N 300 210 300 270 {lab=nCHARGE}
N 270 210 270 270 {lab=readLine[1]}
N 140 60 140 120 {lab=nDETECT}
C {iopin.sym} 380 -160 0 0 {name=p1 lab=nCHARGE}
C {iopin.sym} 380 -140 0 0 {name=p2 lab=VDD}
C {iopin.sym} 380 -120 0 0 {name=p3 lab=GND}
C {iopin.sym} 380 -100 0 0 {name=p4 lab=readLine[0]}
C {iopin.sym} 380 -80 0 0 {name=p5 lab=readLine[1]}
C {col_amp_v2_std_dvs/xschem/dyn_comp.sym} 140 -50 0 1 {name=x1}
C {col_amp_v2_std_dvs/xschem/col_amp.sym} 220 -120 0 0 {name=x2}
C {iopin.sym} 380 -180 0 0 {name=p6 lab=VTHRESH}
C {lab_wire.sym} 200 -80 0 0 {name=p8 sig_type=std_logic lab=VTHRESH}
C {lab_wire.sym} 270 -240 3 0 {name=p9 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 280 -240 1 1 {name=p10 sig_type=std_logic lab=GND}
C {lab_wire.sym} 140 -200 1 1 {name=p11 sig_type=std_logic lab=nDETECT}
C {lab_wire.sym} 140 0 1 0 {name=p12 sig_type=std_logic lab=DETECT}
C {lab_wire.sym} 70 0 1 0 {name=p13 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 50 0 3 1 {name=p14 sig_type=std_logic lab=GND}
C {lab_wire.sym} -40 -90 0 0 {name=p15 sig_type=std_logic lab=voutn[0]}
C {lab_wire.sym} 270 -20 0 0 {name=p16 sig_type=std_logic lab=readLine[0]}
C {lab_wire.sym} 300 -20 0 1 {name=p17 sig_type=std_logic lab=nCHARGE}
C {iopin.sym} 380 -60 0 0 {name=p18 lab=voutn[0]}
C {iopin.sym} 380 -40 0 0 {name=p19 lab=voutn[1]}
C {iopin.sym} 380 -200 0 0 {name=p20 lab=nDETECT}
C {iopin.sym} 380 -220 0 0 {name=p21 lab=DETECT}
C {col_amp_v2_std_dvs/xschem/dyn_comp.sym} 140 220 0 1 {name=x3}
C {col_amp_v2_std_dvs/xschem/col_amp.sym} 220 150 0 0 {name=x4}
C {lab_wire.sym} 200 190 0 0 {name=p7 sig_type=std_logic lab=VTHRESH}
C {lab_wire.sym} 270 30 3 0 {name=p22 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 280 30 1 1 {name=p23 sig_type=std_logic lab=GND}
C {lab_wire.sym} 140 70 1 1 {name=p24 sig_type=std_logic lab=nDETECT}
C {lab_wire.sym} 140 270 1 0 {name=p25 sig_type=std_logic lab=DETECT}
C {lab_wire.sym} 70 270 1 0 {name=p26 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 50 270 3 1 {name=p27 sig_type=std_logic lab=GND}
C {lab_wire.sym} -40 180 0 0 {name=p28 sig_type=std_logic lab=voutn[1]}
C {lab_wire.sym} 270 250 0 0 {name=p29 sig_type=std_logic lab=readLine[1]}
C {lab_wire.sym} 300 250 0 1 {name=p30 sig_type=std_logic lab=nCHARGE}
C {iopin.sym} 380 20 0 0 {name=p31 lab=pixRst[0]}
C {iopin.sym} 380 40 0 0 {name=p32 lab=pixRst[1]}
