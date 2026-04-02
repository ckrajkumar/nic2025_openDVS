
******************************************************************
*****SUB CIRCUIT BLOCKS
******************************************************************
.lib /usr/local/share/pdk/sky130B/libs.tech/combined/continuous/sky130.lib.spice tt
.include read_row8.sp

.GLOBAL VDD
.GLOBAL GND
.GLOBAL Reset
.PREPROCESS REPLACEGROUND TRUE
.OPTIONS PARSER model_binning=true

******************************************************************
**** Define DC bias voltages and currents
******************************************************************

vdd VDD 0 1.8v
vrst Reset 0 pulse(0.0 1.8 50n 100p 100p 50n 50u)

Vi00 b0 0 dc 0.0v
Vi01 b1 0 dc 1.8v
ViLr L.r 0 PULSE(0 1.8 150n 100p 100p 100n 50u)


******************************************************************
**** Connecting all sub blocks
******************************************************************

x1 b1 b1 b0 b0 b0 b0 b0 b0 L.r L.a R.d[0] R.d[1] R.d[2] R.d[3] R.d[4] R.d[5] R.d[6] R.d[7] R.d[8] R.r R.a ring_decomp_rowread

x2 R.r Rr1 _0_0cell_0_0ginvx1
x3 Rr1 R.a _0_0cell_0_0ginvx1

******************************************************************
***** NGSPICE Simualation Setup
******************************************************************

.tran 10n 1u
.print tran format=noindex v(R.d[0]) v(R.d[1]) v(R.d[2]) v(R.d[3]) v(R.d[4]) v(R.d[5]) v(R.d[6]) v(R.d[7]) v(R.d[8])
.print tran format=noindex v(Reset) v(L.r) v(L.a) v(R.r) v(R.a)

.end
