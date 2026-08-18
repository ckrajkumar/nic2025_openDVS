v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -210 -30 -190 -30 {lab=PrBp}
N -210 -10 -190 -10 {lab=PrSFBp}
N -210 30 -200 30 {lab=DiffBn}
N -210 50 -180 50 {lab=OnBn}
N -210 70 -180 70 {lab=OffBn}
N -200 30 -180 30 {lab=DiffBn}
N -190 -10 -180 -10 {lab=PrSFBp}
N -190 -30 -180 -30 {lab=PrBp}
N -210 10 -180 10 {lab=RefrBp}
N -30 130 -30 150 {lab=GndA}
N -10 130 -10 150 {lab=VddA18}
N -50 130 -50 160 {lab=GndD}
N -220 -100 -180 -100 {lab=pixRst[1],pixRst[0]}
N -220 -80 -180 -80 {lab=rowReadON[1],rowReadON[0]}
N -220 -60 -180 -60 {lab=rowReadOFF[1],rowReadOFF[0]}
N 120 -100 150 -100 {lab=readLine[1],readLine[0]}
N -210 90 -180 90 {lab=#net1}
C {openDVS_pixel2x2.sym} -30 0 0 0 {name=x1}
C {iopin.sym} -210 -30 0 1 {name=p60 lab=PrBp}
C {iopin.sym} -210 -10 0 1 {name=p2 lab=PrSFBp}
C {iopin.sym} -210 30 0 1 {name=p8 lab=DiffBn}
C {iopin.sym} -210 50 0 1 {name=p13 lab=OnBn}
C {iopin.sym} -210 70 0 1 {name=p17 lab=OffBn}
C {iopin.sym} -210 10 0 1 {name=p7 lab=RefrBp}
C {iopin.sym} -30 150 1 0 {name=p61 lab=GndA
}
C {iopin.sym} -10 150 1 0 {name=p62 lab=VddA18
}
C {iopin.sym} -50 160 1 0 {name=p28 lab=GndD
}
C {lab_wire.sym} -220 -100 0 0 {name=p6 sig_type=std_logic lab=pixRst[1],pixRst[0]}
C {lab_wire.sym} -220 -80 0 0 {name=p3 sig_type=std_logic lab=rowReadON[1],rowReadON[0]}
C {lab_wire.sym} -220 -60 0 0 {name=p4 sig_type=std_logic lab=rowReadOFF[1],rowReadOFF[0]}
C {lab_wire.sym} 150 -100 0 1 {name=p9 sig_type=std_logic lab=readLine[1],readLine[0]}
C {iopin.sym} 320 70 0 0 {name=p26 lab=readLine[1:0]}
C {noconn.sym} -210 90 0 0 {name=l1[3:0]}
C {iopin.sym} 320 -10 0 0 {name=p1 lab=pixRst[1:0]}
C {iopin.sym} 340 10 0 1 {name=p5 lab=rowReadON[1:0]}
C {iopin.sym} 340 30 0 1 {name=p10 lab=rowReadOFF[1:0]}
