v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 180 280 180 300 {lab=gnd}
N 40 0 40 30 {lab=gnd}
N 40 -80 40 -60 {lab=vpd}
N 40 -110 100 -110 {lab=vpd}
N 260 -20 260 30 {lab=gnd}
N 180 360 180 380 {lab=GND!}
N 290 -20 290 30 {lab=vdd}
N 180 360 260 360 {lab=GND!}
N 260 280 260 300 {lab=vdd}
N 320 -280 320 -230 {lab=PrBp}
N 340 -280 340 -230 {lab=PrSFBp}
N 360 -280 360 -230 {lab=RefrBp}
N 380 -280 380 -230 {lab=DiffBn}
N 400 -280 400 -230 {lab=OnBn}
N 420 -280 420 -230 {lab=OffBn}
N -250 380 -250 400 {lab=RefrBp}
N -250 460 -250 500 {lab=gnd}
N -320 330 -290 330 {lab=RefrBp}
N -320 330 -320 380 {lab=RefrBp}
N -320 380 -250 380 {lab=RefrBp}
N -250 360 -250 380 {lab=RefrBp}
N -250 330 -200 330 {lab=vdd}
N -250 260 -250 300 {lab=vdd}
N -560 380 -560 400 {lab=PrBp}
N -560 460 -560 500 {lab=gnd}
N -630 330 -600 330 {lab=PrBp}
N -630 330 -630 380 {lab=PrBp}
N -630 380 -560 380 {lab=PrBp}
N -560 360 -560 380 {lab=PrBp}
N -560 330 -510 330 {lab=vdd}
N -560 260 -560 300 {lab=vdd}
N -410 380 -410 400 {lab=PrSFBp}
N -410 460 -410 500 {lab=gnd}
N -480 330 -450 330 {lab=PrSFBp}
N -480 330 -480 380 {lab=PrSFBp}
N -480 380 -410 380 {lab=PrSFBp}
N -410 360 -410 380 {lab=PrSFBp}
N -410 330 -360 330 {lab=vdd}
N -410 260 -410 300 {lab=vdd}
N -570 680 -570 700 {lab=DiffBn}
N -660 730 -610 730 {lab=DiffBn}
N -660 680 -660 730 {lab=DiffBn}
N -660 680 -570 680 {lab=DiffBn}
N -570 660 -570 680 {lab=DiffBn}
N -570 760 -570 800 {lab=gnd}
N -570 730 -530 730 {lab=gnd}
N -570 560 -570 600 {lab=vdd}
N -410 680 -410 700 {lab=OnBn}
N -500 730 -450 730 {lab=OnBn}
N -500 680 -500 730 {lab=OnBn}
N -500 680 -410 680 {lab=OnBn}
N -410 660 -410 680 {lab=OnBn}
N -410 760 -410 800 {lab=gnd}
N -410 730 -370 730 {lab=gnd}
N -410 560 -410 600 {lab=vdd}
N -250 680 -250 700 {lab=OffBn}
N -340 730 -290 730 {lab=OffBn}
N -340 680 -340 730 {lab=OffBn}
N -340 680 -250 680 {lab=OffBn}
N -250 660 -250 680 {lab=OffBn}
N -250 760 -250 800 {lab=gnd}
N -250 730 -210 730 {lab=gnd}
N -250 560 -250 600 {lab=vdd}
N 500 -130 570 -130 {lab=readLine}
N 570 -130 570 -110 {lab=readLine}
N 570 -50 570 0 {lab=gnd}
N 110 -170 200 -170 {lab=rowReadON}
N 110 -150 200 -150 {lab=rowReadOFF}
N 110 -190 200 -190 {lab=pixRst}
N -20 -80 -20 -70 {lab=vpd}
N -20 -80 40 -80 {lab=vpd}
N -20 -10 -20 0 {lab=gnd}
N -20 0 40 0 {lab=gnd}
N 40 -110 40 -80 {lab=vpd}
N 160 -110 200 -110 {lab=vpd_in}
N 570 -270 570 -230 {lab=vdd}
N 570 -170 570 -130 {lab=readLine}
N -100 -250 -100 -220 {lab=pixRst}
N -100 -160 -100 -130 {lab=gnd}
N -100 -120 -100 -90 {lab=rowReadON}
N -100 -30 -100 0 {lab=gnd}
N -100 10 -100 40 {lab=rowReadOFF}
N -100 100 -100 130 {lab=gnd}
C {openDVS_pixel.sym} 350 -100 0 0 {name=xpix}
C {vsource.sym} 180 330 0 0 {name=Vgnd value=0 savecurrent=false}
C {gnd.sym} 180 380 0 0 {name=l1 lab=GND!}
C {vsource.sym} 260 330 0 0 {name=Vvdd value=\{xvdd\} savecurrent=false}
C {lab_wire.sym} 180 290 0 0 {name=p1 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 40 30 0 0 {name=p2 sig_type=std_logic lab=gnd}
C {isource.sym} 40 -30 0 0 {name=Iipd value=\{xipd\}}
C {lab_wire.sym} 260 290 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 260 30 1 1 {name=p14 sig_type=std_logic lab=gnd}
C {devices/code.sym} -420 -210 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {devices/launcher.sym} -170 -300 2 1 {name=h1
descr="Annotate OP"
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {code_shown.sym} -1280 -550 0 0 {name=NGSPICE
only_toplevel=true
value="
** Convergence options for nA-range weak-inversion pixel circuit
.option gmin=1e-16 abstol=1e-15 vntol=1e-9 reltol=1e-4 chgtol=1e-16
.option method=gear maxord=2 trtol=1
.option itl1=500 itl2=200 itl4=50
.option gminsteps=200 srcsteps=200
.option ramptime=100n

.param xvdd = 1.8
.param xipd = 1e-9
.param xPrBp = 10n
.param xPrSFBp = 100p
.param xRefrBp = 4n
.param xDiffBn = 10n
.param xOnBn = 100n
.param xOffBn = 1n

.param xCloadPD = 30f
.param xCloadReadLine = 300f

*Small Iphoto testing
Iphoto1 vpd gnd pulse(50n 100n 120m 50m 50m 59.9m 300m)
Iphoto2 vpd gnd pulse(50n 25n 240m 50m 50m 59.9m 300m)

.save all
.save v(xpix.on) v(xpix.noff)

.control

** ============================================================
** Event-driven auto-read testbench
** Detects xpix.ON rising or xpix.nOFF falling, then generates
** the read sequence: rowReadON, rowReadOFF, rowReadON (reset)
** ============================================================

** Read sequence timing (parameterizable)
let xevent_delay = 1e-6
let xread_on_len = 950e-9
let xgap = 50e-9
let xread_off_len = 950e-9
let xrst_phase_len = 950e-9
let xsettle = 100e-6

let sim_end = 0.39
let tran_end = sim_end + 1

** Phase 0: let circuit initialize (10ms settling)
** tran end time must exceed sim_end to avoid resume-after-finished crash
stop when time > 10e-3
tran 1u $&tran_end uic
let vdd_val = v(vdd)[length(v(vdd))-1]
let on_thresh = 0.9 * vdd_val
let noff_thresh = 0.1 * vdd_val

echo
echo '=== Auto-read TB initialized ==='
echo '    VDD =' $&vdd_val 'V'
echo '    ON thresh =' $&on_thresh 'V'
echo '    nOFF thresh =' $&noff_thresh 'V'

** Event-driven readout loop (runs until sim_end)
let event_count = 0
let t_now = time[length(time)-1]

while t_now < $&sim_end - 1e-9
  ** Arm event breakpoints
  delete all
  stop when v(xpix.on) > $&on_thresh
  stop when v(xpix.noff) < $&noff_thresh
  stop when time > $&sim_end
  resume

  let t_now = time[length(time)-1]
  if t_now >= $&sim_end - 1e-9
    break
  end

  let event_count = event_count + 1
  let t_event = t_now
  echo
  echo '=== Event #' $&event_count 'at t =' $&t_event 's ==='

  ** Skip read sequence if not enough time left
  let t_seq_end = t_event + xevent_delay + xread_on_len + xgap + xread_off_len + xgap + xrst_phase_len + xsettle
  if t_seq_end > $&sim_end
    echo '    Skipping read sequence - too close to sim_end'
    break
  end

  ** Wait parameterized delay before read sequence
  delete all
  let t1 = t_event + xevent_delay
  stop when time > $&t1
  resume

  ** Phase 1: rowReadON (read ON phase)
  alter vrowreadon = $&vdd_val
  delete all
  let t2 = t1 + xread_on_len
  stop when time > $&t2
  resume
  alter vrowreadon = 0

  ** Gap
  delete all
  let t3 = t2 + xgap
  stop when time > $&t3
  resume

  ** Phase 2: rowReadOFF
  alter vrowreadoff = $&vdd_val
  delete all
  let t4 = t3 + xread_off_len
  stop when time > $&t4
  resume
  alter vrowreadoff = 0

  ** Gap
  delete all
  let t5 = t4 + xgap
  stop when time > $&t5
  resume

  ** Phase 3: rowReadON (reset phase) + pixRst
  alter vrowreadon = $&vdd_val
  alter vpixrstctrl = $&vdd_val
  delete all
  let t6 = t5 + xrst_phase_len
  stop when time > $&t6
  resume
  alter vrowreadon = 0
  alter vpixrstctrl = 0

  ** Post-reset settle before re-arming event detection
  delete all
  let t7 = t6 + xsettle
  stop when time > $&t7
  resume
  let t_now = time[length(time)-1]
end

** Run to sim_end to ensure complete waveform
delete all
stop when time > $&sim_end
resume

echo
echo '=== Simulation complete:' $&event_count 'events detected ==='
setplot tran1
write tb_Pixel_autoreadLine_tran.raw
.endc
"}
C {lab_wire.sym} 40 -90 0 0 {name=p8 sig_type=std_logic lab=vpd}
C {lab_wire.sym} 290 30 1 1 {name=p9 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 320 -280 3 0 {name=p11 sig_type=std_logic lab=PrBp}
C {lab_wire.sym} 340 -280 3 0 {name=p12 sig_type=std_logic lab=PrSFBp}
C {lab_wire.sym} 360 -280 3 0 {name=p16 sig_type=std_logic lab=RefrBp}
C {lab_wire.sym} 380 -280 3 0 {name=p17 sig_type=std_logic lab=DiffBn}
C {lab_wire.sym} 400 -280 3 0 {name=p18 sig_type=std_logic lab=OnBn}
C {lab_wire.sym} 420 -280 3 0 {name=p19 sig_type=std_logic lab=OffBn}
C {isource.sym} -250 430 0 0 {name=IRefrBp value=\{xRefrBp\}}
C {sky130_fd_pr/pfet_01v8.sym} -270 330 0 0 {name=MRefrBp
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
model=pfet_01v8
spiceprefix=X
}
C {lab_wire.sym} -200 330 0 0 {name=p3 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -250 260 3 0 {name=p5 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -250 500 3 1 {name=p6 sig_type=std_logic lab=gnd}
C {isource.sym} -560 430 0 0 {name=IPrBp value=\{xPrBp\}}
C {sky130_fd_pr/pfet_01v8_hvt.sym} -580 330 0 0 {name=MPrBp
W=1
L=0.15
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
C {lab_wire.sym} -510 330 0 0 {name=p7 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -560 260 3 0 {name=p10 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -560 500 3 1 {name=p13 sig_type=std_logic lab=gnd}
C {isource.sym} -410 430 0 0 {name=IPrSFBp value=\{xPrSFBp\}}
C {lab_wire.sym} -360 330 0 0 {name=p15 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -410 260 3 0 {name=p20 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -410 500 3 1 {name=p21 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -630 330 3 0 {name=p22 sig_type=std_logic lab=PrBp}
C {lab_wire.sym} -480 330 3 0 {name=p23 sig_type=std_logic lab=PrSFBp}
C {lab_wire.sym} -320 330 3 0 {name=p24 sig_type=std_logic lab=RefrBp}
C {sky130_fd_pr/nfet_01v8.sym} -590 730 0 0 {name=MDiffBn
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
C {lab_wire.sym} -660 680 3 0 {name=p25 sig_type=std_logic lab=DiffBn}
C {isource.sym} -570 630 0 0 {name=IDiffBn value=\{xDiffBn\}}
C {lab_wire.sym} -570 800 3 1 {name=p26 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -530 730 2 1 {name=p27 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -570 560 3 0 {name=p28 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/nfet_01v8.sym} -430 730 0 0 {name=MOnBn
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
C {lab_wire.sym} -500 680 3 0 {name=p29 sig_type=std_logic lab=OnBn}
C {isource.sym} -410 630 0 0 {name=IOnBn value=\{xOnBn\}}
C {lab_wire.sym} -410 800 3 1 {name=p30 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -370 730 2 1 {name=p31 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -410 560 3 0 {name=p32 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/nfet_01v8.sym} -270 730 0 0 {name=MOffBn
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
C {lab_wire.sym} -340 680 3 0 {name=p33 sig_type=std_logic lab=OffBn}
C {isource.sym} -250 630 0 0 {name=IOffBn value=\{xOffBn\}}
C {lab_wire.sym} -250 800 3 1 {name=p34 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -210 730 2 1 {name=p35 sig_type=std_logic lab=gnd}
C {lab_wire.sym} -250 560 3 0 {name=p36 sig_type=std_logic lab=vdd}
C {capa.sym} 570 -80 0 0 {name=CloadReadLine
m=1
value='xCloadReadLine'
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 570 0 1 1 {name=p99 sig_type=std_logic lab=gnd}
C {lab_wire.sym} 560 -130 0 0 {name=p43 sig_type=std_logic lab=readLine}
C {lab_wire.sym} 110 -170 0 1 {name=p91 sig_type=std_logic lab=rowReadON}
C {lab_wire.sym} 110 -150 0 1 {name=p92 sig_type=std_logic lab=rowReadOFF}
C {lab_wire.sym} 110 -190 0 1 {name=p102 sig_type=std_logic lab=pixRst}
C {capa.sym} -20 -40 0 1 {name=CloadPD
m=1
value='xCloadPD'
footprint=1206
device="ceramic capacitor"}
C {vsource.sym} 130 -110 1 0 {name=Vmeas_ipd value=0 savecurrent=false}
C {lab_wire.sym} 190 -110 0 0 {name=p104 sig_type=std_logic lab=vpd_in}
C {sky130_fd_pr/pfet_01v8.sym} -430 330 0 0 {name=MPrSFBp
W=1
L=8
nf=2
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
C {res.sym} 570 -200 0 0 {name=RreadLinePU
value=10k
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 570 -270 0 0 {name=p105 sig_type=std_logic lab=vdd}
C {vsource.sym} -100 -190 0 0 {name=VpixRstCtrl value=0 savecurrent=false}
C {lab_wire.sym} -100 -250 3 0 {name=p201 sig_type=std_logic lab=pixRst}
C {lab_wire.sym} -100 -130 3 1 {name=p202 sig_type=std_logic lab=gnd}
C {vsource.sym} -100 -60 0 0 {name=VrowReadON value=0 savecurrent=false}
C {lab_wire.sym} -100 -120 3 0 {name=p203 sig_type=std_logic lab=rowReadON}
C {lab_wire.sym} -100 0 3 1 {name=p204 sig_type=std_logic lab=gnd}
C {vsource.sym} -100 70 0 0 {name=VrowReadOFF value=0 savecurrent=false}
C {lab_wire.sym} -100 10 3 0 {name=p205 sig_type=std_logic lab=rowReadOFF}
C {lab_wire.sym} -100 130 3 1 {name=p206 sig_type=std_logic lab=gnd}
