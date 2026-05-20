v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 20 -200 20 -180 {lab=PrBp}
N -40 40 -40 60 {lab=GndA}
N -10 40 -10 60 {lab=VddA18}
N 40 -200 40 -180 {lab=PrSFBp}
N 80 -200 80 -190 {lab=DiffBn}
N 100 -200 100 -170 {lab=OnBn}
N 120 -200 120 -170 {lab=OffBn}
N 60 -200 60 -160 {lab=RefrBp}
N -140 -130 -100 -130 {lab=pixRst[1],pixRst[1],pixRst[0],pixRst[0]}
N -140 -110 -100 -110 {lab=rowReadON[1],rowReadON[0],rowReadON[1],rowReadON[0]}
N -140 -90 -100 -90 {lab=rowReadOFF[1],rowReadOFF[0],rowReadOFF[1],rowReadOFF[0]}
N 200 -70 230 -70 {lab=readLine[1],readLine[1],readLine[0],readLine[0]}
N 20 40 20 70 {lab=GndD}
N 80 -190 80 -170 {lab=DiffBn}
N 40 -180 40 -170 {lab=PrSFBp}
N -120 -50 -100 -50 {lab=vpd[3:0]}
N 20 -180 20 -170 {lab=PrBp}
N 60 -170 60 -160 {lab=RefrBp}
C {openDVS_pixel.sym} 50 -40 0 0 {name=xPix[3:0]}
C {iopin.sym} 20 -200 3 0 {name=p60 lab=PrBp}
C {iopin.sym} -40 60 1 0 {name=p61 lab=GndA
}
C {iopin.sym} -10 60 1 0 {name=p62 lab=VddA18
}
C {iopin.sym} 40 -200 3 0 {name=p2 lab=PrSFBp}
C {iopin.sym} 80 -200 3 0 {name=p8 lab=DiffBn}
C {iopin.sym} 100 -200 3 0 {name=p13 lab=OnBn}
C {iopin.sym} 120 -200 3 0 {name=p17 lab=OffBn}
C {iopin.sym} 60 -200 3 0 {name=p7 lab=RefrBp}
C {iopin.sym} 20 70 1 0 {name=p28 lab=GndD
}
C {iopin.sym} -120 -50 2 0 {name=p1 lab=vpd[3],vpd[2],vpd[1],vpd[0]}
C {lab_wire.sym} -140 -130 0 0 {name=p6 sig_type=std_logic lab=pixRst[1],pixRst[1],pixRst[0],pixRst[0]}
C {lab_wire.sym} -140 -110 0 0 {name=p3 sig_type=std_logic lab=rowReadON[1],rowReadON[0],rowReadON[1],rowReadON[0]}
C {lab_wire.sym} -140 -90 0 0 {name=p4 sig_type=std_logic lab=rowReadOFF[1],rowReadOFF[0],rowReadOFF[1],rowReadOFF[0]}
C {lab_wire.sym} 230 -70 0 1 {name=p9 sig_type=std_logic lab=readLine[1],readLine[1],readLine[0],readLine[0]}
C {ipin.sym} -210 -460 0 0 {name=p10 lab=pixRst[1:0]}
C {ipin.sym} -210 -440 0 0 {name=p22 lab=rowReadON[1:0]}
C {ipin.sym} -210 -420 0 0 {name=p23 lab=rowReadOFF[1:0]}
C {iopin.sym} -230 -400 0 0 {name=p26 lab=readLine[1:0]}
