v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 750 30 840 30 {lab=clamp_leakp}
N 750 50 840 50 {lab=pix_rst}
N 750 70 840 70 {lab=vgn}
N 750 90 840 90 {lab=vout}
N 750 110 840 110 {lab=vout_sense}
N 750 130 840 130 {lab=vcm}
N 750 150 840 150 {lab=vgp}
N 750 170 840 170 {lab=_pix_rst}
N 750 190 840 190 {lab=clamp_leakn}
N 750 210 840 210 {lab=gnd}
N 280 30 370 30 {lab=pbias}
N 280 50 370 50 {lab=pbchk}
N 280 70 370 70 {lab=vcascp}
N 280 90 370 90 {lab=vout_sense}
N 280 110 370 110 {lab=pix_rst}
N 280 130 370 130 {lab=vcascn}
N 280 170 370 170 {lab=bias_amp_cascn}
N 280 150 370 150 {lab=gnd}
N 280 190 370 190 {lab=feedback}
N 280 210 370 210 {lab=#net1}
N 280 10 840 10 {lab=vdd}
C {/home/user/projects/nic2025_v2/nic2025_openDVS/analog/xschem/col_amp_n_clamp_v1/col_amp_v1.sym} 130 110 0 0 {name=x1}
C {/home/user/projects/nic2025_v2/nic2025_openDVS/analog/xschem/col_amp_n_clamp_v1/clamp_qdvs_v2.sym} 990 110 0 1 {name=x2}
C {lab_wire.sym} 770 110 0 0 {name=p9 sig_type=std_logic lab=vout_sense}
C {lab_wire.sym} 370 90 0 0 {name=p11 sig_type=std_logic lab=vout_sense}
C {lab_wire.sym} 370 110 0 0 {name=p15 sig_type=std_logic lab=pix_rst}
C {lab_wire.sym} 370 150 0 0 {name=p17 sig_type=std_logic lab=gnd}
C {iopin.sym} 750 190 0 1 {name=p2 lab=clamp_leakn}
C {iopin.sym} 750 210 0 1 {name=p3 lab=gnd}
C {iopin.sym} 450 10 3 0 {name=p4 lab=vdd}
C {opin.sym} 750 70 0 1 {name=p20 lab=vgn}
C {iopin.sym} 750 30 2 0 {name=p16 lab=clamp_leakp}
C {opin.sym} 750 150 0 1 {name=p21 lab=vgp}
C {iopin.sym} 750 130 0 1 {name=p8 lab=vcm}
C {iopin.sym} 750 90 2 0 {name=p18 lab=vout}
C {iopin.sym} 750 50 0 1 {name=p14 lab=pix_rst}
C {iopin.sym} 750 170 0 1 {name=p23 lab=_pix_rst}
C {iopin.sym} 370 210 2 1 {name=p10 lab=sense}
C {iopin.sym} 370 50 2 1 {name=p25 lab=pbchk}
C {iopin.sym} 370 70 2 1 {name=p24 lab=vcascp}
C {iopin.sym} 370 30 2 1 {name=p27 lab=pbias}
C {iopin.sym} 370 190 2 1 {name=p28 lab=feedback}
C {iopin.sym} 370 130 2 1 {name=p29 lab=vcascn}
C {iopin.sym} 370 170 2 1 {name=p33 lab=bias_amp_cascn}
