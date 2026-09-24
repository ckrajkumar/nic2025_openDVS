* RESET_ROW_BEGIN
* RESET_ROW_ID row-c236f273d4f51f98a45b56ba7fff7bbb0a28ecc2907cca952e37581542642560
* CONDITION_JSON {"analysis":"reset_transient","analysis_conditions":{"chgtol_c":1e-16,"coarse_settling_max_step_s":0.0001,"gmin_s":1e-17,"gminsteps":500,"iabstol_a":1e-12,"integration_method":"gear2only","itl1":1000,"itl2":500,"itl4":100,"ramptime_s":1e-07,"reltol":0.0005,"srcsteps":500,"trtol":1,"vabstol_v":1e-06},"biases_a":{"DiffBn":1e-08,"OffBn":1e-09,"OnBn":7e-08,"PrBp":1e-08,"PrSFBp":1e-10,"RefrBp":4e-09},"corner":"tt","initial_state":{"pixRst[0]":"high","pixRst[1]":"low","readLine[0]":"low","readLine[1]":"low","rowReadOFF[0]":"low","rowReadOFF[1]":"low","rowReadON[0]":"high","rowReadON[1]":"low","vpd[0]":"optical_source_defined","vpd[1]":"optical_source_defined","vpd[2]":"optical_source_defined","vpd[3]":"optical_source_defined"},"optical":{"mode":"photocurrent_dc","photocurrent_a":{"vpd[0]":1e-09,"vpd[1]":1e-09,"vpd[2]":1e-09,"vpd[3]":1e-09}},"path":"magic_rcc_ngspice","pin_forcing":{"DiffBn":"current_mirror_driven","GndA":"rail_tied_to_ground","GndD":"rail_tied_to_ground","OffBn":"current_mirror_driven","OnBn":"current_mirror_driven","PrBp":"current_mirror_driven","PrSFBp":"current_mirror_driven","RefrBp":"current_mirror_driven","VddA18":"rail_tied_to_vdd","pixRst[0]":"fixed_timeline_driven","pixRst[1]":"inactive_low","readLine[0]":"inactive_low","readLine[1]":"inactive_low","rowReadOFF[0]":"inactive_low","rowReadOFF[1]":"inactive_low","rowReadON[0]":"fixed_timeline_driven","rowReadON[1]":"inactive_low"},"simulator":"ngspice","stimulus":{"adaptation":"The CACE event-triggered second reset is replaced by its registered 45 s timeout path so every matched path and PVT row receives the same absolute waveform. All three simulators use the same 10 ns edge duration.","cace_reference":{"configuration_sha256":"68f501f65eea943f0a85300669a6b066c735b4da228ab1ebe3ff4dd4aeea2338","postprocessor_sha256":"2ce2f3d1e94facbf69213d10ec68b15f19c418b32c6b549ea79e19ff42a92e6f","testbench_sha256":"91f7ab29b4d7fd108bd733c7b9a4ad962d748d50cda7a00593542401686e8ab5"},"event_trigger":"none","kind":"reset_release_transient","protocol_mode":"fixed_common_timeline_v1","reset_drive":"explicit_piecewise_linear_voltage_source","reset_phase":"fixed_two_pulse_timeline","stop_s":45.5,"timeline":[{"level_fraction_vdd":1.0,"time_s":0.0},{"level_fraction_vdd":1.0,"time_s":0.001},{"level_fraction_vdd":0.0,"time_s":0.00100001},{"level_fraction_vdd":0.0,"time_s":45.0},{"level_fraction_vdd":1.0,"time_s":45.00000001},{"level_fraction_vdd":1.0,"time_s":45.001},{"level_fraction_vdd":0.0,"time_s":45.00100001},{"level_fraction_vdd":0.0,"time_s":45.5}]},"temperature_c":27,"vdd_v":1.8,"view":"magic_rcc"}
* SOURCE_CLAIM {"identity":"accepted_magic_composed_21_port_rcc","sha256":"e016ed5834155460c0a743b450d398080a850f3221c3a631583ae30a56452775"}
* FIXED_RESET_TIMELINE [{"level_fraction_vdd":1.0,"time_s":0.0},{"level_fraction_vdd":1.0,"time_s":0.001},{"level_fraction_vdd":0.0,"time_s":0.00100001},{"level_fraction_vdd":0.0,"time_s":45.0},{"level_fraction_vdd":1.0,"time_s":45.00000001},{"level_fraction_vdd":1.0,"time_s":45.001},{"level_fraction_vdd":0.0,"time_s":45.00100001},{"level_fraction_vdd":0.0,"time_s":45.5}]
* geometry_convention=ngspice_SCALE_micrometre
* RESET_BASE_SOURCE_CLAIM /home/rpgraca/git/opendvs-pex-cadence-production-v1/pex_campaign_native/full_pvt_three_path_v1/sources/production_gds_v1/openDVS_pixel2x2_magic_rcc_ngspice.spice
* RESET_ADAPTED_SOURCE_CLAIM source/openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.spice
.lib /home/rpgraca/.ciel/ciel/sky130/versions/40cee970d8a9b7eaea35a34fe7d6068f05721f0a/sky130A/libs.tech/combined/sky130.lib.spice tt
.include /home/rpgraca/.ciel/ciel/sky130/versions/40cee970d8a9b7eaea35a34fe7d6068f05721f0a/sky130A/libs.tech/ngspice/corners/tt/nonfet.spice
.include /home/rpgraca/.ciel/ciel/sky130/versions/40cee970d8a9b7eaea35a34fe7d6068f05721f0a/sky130A/libs.tech/ngspice/parasitics/sky130_fd_pr__model__parasitic__diode_ps2dn.model.spice
.include source/openDVS_pixel2x2_magic_rcc_ngspice.reset_physical_pd.edit20260922m.spice
.temp 27
.option gmin=1e-17 abstol=1p vntol=1u reltol=0.5m chgtol=1e-16
.option method=gear maxord=2 trtol=1
.option itl1=1000 itl2=500 itl4=100
.option gminsteps=500 srcsteps=500
.option ramptime=100n
Vvdd VddA18 0 dc 1.8
VresetController pixrst 0 PWL(0 1.8 0.000 1.8 0.00000001 0 45 0 45.00000001 1.8 45.001 1.8 45.00100001 0 45.5 0)
IPrBp PrBp 0 dc 10n
XMPrBp PrBp PrBp VddA18 VddA18 sky130_fd_pr__pfet_01v8 l=0.15 w=0.5 nf=1 ad=0.145 as=0.145 pd=1.58 ps=1.58 nrd=0.58 nrs=0.58 mult=1
IPrSFBp PrSFBp 0 dc 100p
XMPrSFBp PrSFBp PrSFBp VddA18 VddA18 sky130_fd_pr__pfet_01v8 l=1.5 w=0.42 nf=1 ad=0.1218 as=0.1218 pd=1.42 ps=1.42 nrd=0.69047619047619 nrs=0.69047619047619 mult=1
IDiffBn VddA18 DiffBn dc 10n
XMDiffBn DiffBn DiffBn 0 0 sky130_fd_pr__nfet_01v8 l=1.5 w=1.5 nf=1 ad=0.435 as=0.435 pd=3.58 ps=3.58 nrd=0.193333333333333 nrs=0.193333333333333 mult=1
IOnBn VddA18 OnBn dc 100n
XMOnBn OnBn OnBn 0 0 sky130_fd_pr__nfet_01v8 l=1.5 w=1.5 nf=1 ad=0.435 as=0.435 pd=3.58 ps=3.58 nrd=0.193333333333333 nrs=0.193333333333333 mult=1
IOffBn VddA18 OffBn dc 1n
XMOffBn OffBn OffBn 0 0 sky130_fd_pr__nfet_01v8 l=1.5 w=1.5 nf=1 ad=0.435 as=0.435 pd=3.58 ps=3.58 nrd=0.193333333333333 nrs=0.193333333333333 mult=1
IRefrBp RefrBp 0 dc 4n
XMRefrBp RefrBp RefrBp VddA18 VddA18 sky130_fd_pr__pfet_01v8 l=1.5 w=0.42 nf=1 ad=0.1218 as=0.1218 pd=1.42 ps=1.42 nrd=0.69047619047619 nrs=0.69047619047619 mult=1
Iipd0 vpd0 0 dc 1n
Iipd1 vpd1 0 dc 1n
Iipd2 vpd2 0 dc 1n
Iipd3 vpd3 0 dc 1n
EonSense onSense 0 xpix2x2.xdiffbn_physical_core.openDVS_pixel_0.ON 0 1
EnrstSense nrstSense 0 xpix2x2.xdiffbn_physical_core.openDVS_pixel_0.nRst 0 1
EvdiffSense vdiffSense 0 xpix2x2.xdiffbn_physical_core.openDVS_pixel_0.vdiff 0 1
EvdSense vdSense 0 xpix2x2.xdiffbn_physical_core.openDVS_pixel_0.vd 0 1
EvsfSense vsfSense 0 xpix2x2.xdiffbn_physical_core.openDVS_pixel_0.vsf 0 1
EvprSense vprSense 0 xpix2x2.xdiffbn_physical_core.openDVS_pixel_0.vpr 0 1
EnoffSense noffSense 0 xpix2x2.xdiffbn_physical_core.openDVS_pixel_0.nOFF 0 1
xpix2x2 0 pixrst 0 pixrst 0 0 0 0 vpd3 vpd2 vpd1 vpd0 VddA18 0 0 OnBn OffBn DiffBn PrSFBp RefrBp PrBp openDVS_pixel2x2
.save v(VddA18) v(pixrst) v(onSense) v(nrstSense) v(vdiffSense) v(vdSense) v(vsfSense) v(vprSense) v(vpd0) v(noffSense)
.save all
.tran 20n 0.110m 0m 20n
.control
set filetype=ascii
run
write outputs/reset_rise.raw
*plot v(pixrst) v(nrstSense) v(onSense)
*plot v(vdiffSense) v(vdSense) v(vsfSense)
.endc
.end
* RESET_ROW_END
