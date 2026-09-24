v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -230 -130 -210 -130 {lab=PrBp}
N -230 -110 -210 -110 {lab=PrSFBp}
N -230 -70 -220 -70 {lab=DiffBn}
N -230 -50 -200 -50 {lab=OnBn}
N -230 -30 -200 -30 {lab=OffBn}
N -220 -70 -200 -70 {lab=DiffBn}
N -210 -110 -200 -110 {lab=PrSFBp}
N -210 -130 -200 -130 {lab=PrBp}
N -230 -90 -200 -90 {lab=RefrBp}
N -50 30 -50 50 {lab=GndA}
N -30 30 -30 50 {lab=VddA18}
N -70 30 -70 60 {lab=GndD}
N -240 -200 -200 -200 {lab=pixRst[1],pixRst[0]}
N -240 -180 -200 -180 {lab=rowReadON[1],rowReadON[0]}
N -240 -160 -200 -160 {lab=rowReadOFF[1],rowReadOFF[0]}
N 100 -200 130 -200 {lab=readLine[1],readLine[0]}
N -230 -10 -200 -10 {lab=#net1}
C {openDVS_pixel2x2.sym} -50 -100 0 0 {name=x1}
C {iopin.sym} -230 -130 0 1 {name=p60 lab=PrBp}
C {iopin.sym} -230 -110 0 1 {name=p2 lab=PrSFBp}
C {iopin.sym} -230 -70 0 1 {name=p8 lab=DiffBn}
C {iopin.sym} -230 -50 0 1 {name=p13 lab=OnBn}
C {iopin.sym} -230 -30 0 1 {name=p17 lab=OffBn}
C {iopin.sym} -230 -90 0 1 {name=p7 lab=RefrBp}
C {iopin.sym} -50 50 1 0 {name=p61 lab=GndA
}
C {iopin.sym} -30 50 1 0 {name=p62 lab=VddA18
}
C {iopin.sym} -70 60 1 0 {name=p28 lab=GndD
}
C {lab_wire.sym} -240 -200 0 0 {name=p6 sig_type=std_logic lab=pixRst[1],pixRst[0]}
C {lab_wire.sym} -240 -180 0 0 {name=p3 sig_type=std_logic lab=rowReadON[1],rowReadON[0]}
C {lab_wire.sym} -240 -160 0 0 {name=p4 sig_type=std_logic lab=rowReadOFF[1],rowReadOFF[0]}
C {lab_wire.sym} 130 -200 0 1 {name=p9 sig_type=std_logic lab=readLine[1],readLine[0]}
C {iopin.sym} 300 -30 0 0 {name=p26 lab=readLine[1:0]}
C {noconn.sym} -230 -10 0 0 {name=l1[3:0]}
C {iopin.sym} 300 -110 0 0 {name=p1 lab=pixRst[1:0]}
C {iopin.sym} 320 -90 0 1 {name=p5 lab=rowReadON[1:0]}
C {iopin.sym} 320 -70 0 1 {name=p10 lab=rowReadOFF[1:0]}
