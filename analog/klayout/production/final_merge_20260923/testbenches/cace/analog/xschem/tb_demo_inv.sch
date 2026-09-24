v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -380 50 -380 70 {lab=0}
N -380 70 -330 70 {lab=0}
N -380 -50 -380 -10 {lab=gd}
N -330 70 -280 70 {lab=0}
N -280 50 -280 70 {lab=0}
N -280 -50 -280 -10 {lab=vdd}
N -60 50 -60 90 {lab=gd}
N -60 -90 -60 -50 {lab=vdd}
N -10 0 40 -0 {lab=out}
N -170 -0 -120 0 {lab=in}
N -190 -0 -190 30 {lab=in}
N -190 -0 -170 -0 {lab=in}
N -190 90 -190 130 {lab=gd}
C {demo_inv.sym} 30 0 0 0 {name=xinv}
C {gnd.sym} -330 70 0 0 {name=l1 lab=0}
C {vsource.sym} -380 20 0 0 {name=Vgd value=0 savecurrent=false}
C {lab_wire.sym} -380 -50 3 0 {name=p1 sig_type=std_logic lab=gd}
C {vsource.sym} -280 20 0 0 {name=Vvdd value='xvdd' savecurrent=false}
C {lab_wire.sym} -280 -50 3 0 {name=p2 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -60 90 1 0 {name=p3 sig_type=std_logic lab=gd}
C {lab_wire.sym} -60 -90 3 0 {name=p4 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 40 0 0 0 {name=p5 sig_type=std_logic lab=out}
C {lab_wire.sym} -170 0 2 0 {name=p6 sig_type=std_logic lab=in}
C {vsource.sym} -190 60 0 0 {name=Vin value='xin' savecurrent=false}
C {lab_wire.sym} -190 130 1 0 {name=p7 sig_type=std_logic lab=gd}
