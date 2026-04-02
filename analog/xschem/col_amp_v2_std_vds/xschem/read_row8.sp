*
*---- act defproc: syn::ring::connect_exprblk_assign<1> -----
* raw ports: 
*
* empty subckt
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
* end empty subckt
*---- end of process: connect_exprblk_assign<1> -----
*
*---- act defproc: std::cells::BUFX2<> -----
* raw ports:  A Y
*
.subckt _0_0std_0_0cells_0_0BUFX2 A Y
*.PININFO A:I Y:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* __Y (combinational)
* Y (combinational)
*
* --- end node flags ---
*
xM0_ Vdd A __Y Vdd sky130_fd_pr__pfet_01v8  W=0.6 L=0.15 nrs=1 nrd=1 nf=1
xM1_ Vdd __Y Y Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM2_ GND A __Y GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM3_ GND __Y Y GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: BUFX2<> -----
*
*---- act defproc: std::cells::INVX1<> -----
* raw ports:  A Y
*
.subckt _0_0std_0_0cells_0_0INVX1 A Y
*.PININFO A:I Y:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* Y (combinational)
*
* --- end node flags ---
*
xM0_ Vdd A Y Vdd sky130_fd_pr__pfet_01v8  W=0.6 L=0.15 nrs=1 nrd=1 nf=1
xM1_ GND A Y GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: INVX1<> -----
*
*---- act defproc: std::cells::TIELOX1<> -----
* raw ports:  Y
*
.subckt _0_0std_0_0cells_0_0TIELOX1 Y
*.PININFO Y:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* Y (combinational)
* x (combinational)
*
* --- end node flags ---
*
xM0_ Vdd x x Vdd sky130_fd_pr__pfet_01v8  W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM1_ GND x Y GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: TIELOX1<> -----
*
*---- act defproc: syn::expr::blk_0ti012c_1_6_1_9tmp<> -----
* raw ports:  in__2_50_6 in__1_50_6 in__1_51_6 in__1_52_6 in__1_53_6 in__1_54_6 in__1_55_6 in__0_50_6 out_50_6 out_51_6 out_52_6 out_53_6 out_54_6 out_55_6 out_56_6 out_57_6 out_58_6
*
.subckt _0_0syn_0_0expr_0_0blk_0ti012c_1_6_1_9tmp in____2__50__6 in____1__50__6 in____1__51__6 in____1__52__6 in____1__53__6 in____1__54__6 in____1__55__6 in____0__50__6 out__50__6 out__51__6 out__52__6 out__53__6 out__54__6 out__55__6 out__56__6 out__57__6 out__58__6
*.PININFO in____2__50__6:I in____1__50__6:I in____1__51__6:I in____1__52__6:I in____1__53__6:I in____1__54__6:I in____1__55__6:I in____0__50__6:I out__50__6:O out__51__6:O out__52__6:O out__53__6:O out__54__6:O out__55__6:O out__56__6:O out__57__6:O out__58__6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xg1 in____2__50__6 out__50__6 _0_0std_0_0cells_0_0BUFX2
xg5 in____1__53__6 out__54__6 _0_0std_0_0cells_0_0BUFX2
xg3 in____1__51__6 out__52__6 _0_0std_0_0cells_0_0BUFX2
xg0 in____0__50__6 out__58__6 _0_0std_0_0cells_0_0INVX1
x__nref__0 out__57__6 _0_0std_0_0cells_0_0TIELOX1
xg4 in____1__52__6 out__53__6 _0_0std_0_0cells_0_0BUFX2
xg6 in____1__54__6 out__55__6 _0_0std_0_0cells_0_0BUFX2
xg2 in____1__50__6 out__51__6 _0_0std_0_0cells_0_0BUFX2
xg7 in____1__55__6 out__56__6 _0_0std_0_0cells_0_0BUFX2
.ends
*---- end of process: blk_0ti012c_1_6_1_9tmp<> -----
*
*---- act defproc: syn::expr::blk_0ti012c_1_6_1_9<> -----
* raw ports:  in_2[0] in_1[0] in_1[1] in_1[2] in_1[3] in_1[4] in_1[5] in_0[0] out[0] out[1] out[2] out[3] out[4] out[5] out[6] out[7] out[8]
*
.subckt _0_0syn_0_0expr_0_0blk_0ti012c_1_6_1_9 in__2_50_6 in__1_50_6 in__1_51_6 in__1_52_6 in__1_53_6 in__1_54_6 in__1_55_6 in__0_50_6 out_50_6 out_51_6 out_52_6 out_53_6 out_54_6 out_55_6 out_56_6 out_57_6 out_58_6
*.PININFO in__2_50_6:I in__1_50_6:I in__1_51_6:I in__1_52_6:I in__1_53_6:I in__1_54_6:I in__1_55_6:I in__0_50_6:I out_50_6:O out_51_6:O out_52_6:O out_53_6:O out_54_6:O out_55_6:O out_56_6:O out_57_6:O out_58_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
x__passthru__ in__2_50_6 in__1_50_6 in__1_51_6 in__1_52_6 in__1_53_6 in__1_54_6 in__1_55_6 in__0_50_6 out_50_6 out_51_6 out_52_6 out_53_6 out_54_6 out_55_6 out_56_6 out_57_6 out_58_6 _0_0syn_0_0expr_0_0blk_0ti012c_1_6_1_9tmp
.ends
*---- end of process: blk_0ti012c_1_6_1_9<> -----
*
*---- act defproc: syn::ring::var_access<9> -----
* raw ports: 
*
* empty subckt
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
* end empty subckt
*---- end of process: var_access<9> -----
*
*---- act defproc: syn::ring::var_access<2> -----
* raw ports: 
*
* empty subckt
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
* end empty subckt
*---- end of process: var_access<2> -----
*
*---- act defproc: syn::ring::elem_c_skip<> -----
* raw ports: 
*
* empty subckt
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
* end empty subckt
*---- end of process: elem_c_skip<> -----
*
*---- act defproc: syn::ring::gp_connect<> -----
* raw ports: 
*
* empty subckt
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
* end empty subckt
*---- end of process: gp_connect<> -----
*
*---- act defproc: cell::g0n1n2naa_012aox0<> -----
* raw ports:  in[0] in[1] in[2] out
*
.subckt _0_0cell_0_0g0n1n2naa_012aox0 in_50_6 in_51_6 in_52_6 out
*.PININFO in_50_6:I in_51_6:I in_52_6:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* out (state-holding): pup_reff=0.6; pdn_reff=0.666667
*
* --- end node flags ---
*
xM0_ Vdd in_50_6 #8 Vdd sky130_fd_pr__pfet_01v8  W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM1_ Vdd out #fb9# Vdd sky130_fd_pr__pfet_01v8  W=0.75 L=0.3 nrs=1 nrd=1 nf=1
xM2_keeper Vdd GND #10 Vdd sky130_fd_pr__pfet_01v8  W=0.45 L=1.8 nrs=1 nrd=1 nf=1
xM3_ GND in_50_6 out GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM4_ GND in_51_6 #4 GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM5_ GND out #fb9# GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.3 nrs=1 nrd=1 nf=1
xM6_keeper GND Vdd #11 GND sky130_fd_pr__nfet_01v8 W=0.45 L=3.9 nrs=1 nrd=1 nf=1
xM7_ #4 in_52_6 out GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM8_ #7 in_52_6 out Vdd sky130_fd_pr__pfet_01v8  W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM9_keeper #10 #fb9# out Vdd sky130_fd_pr__pfet_01v8  W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM10_keeper #11 #fb9# out GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM11_ #8 in_51_6 #7 Vdd sky130_fd_pr__pfet_01v8  W=0.75 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: g0n1n2naa_012aox0<> -----
*
*---- act defproc: cell::ginvx0<> -----
* raw ports:  in[0] out
*
.subckt _0_0cell_0_0ginvx0 in_50_6 out
*.PININFO in_50_6:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* out (combinational)
*
* --- end node flags ---
*
xM0_ Vdd in_50_6 out Vdd sky130_fd_pr__pfet_01v8  W=0.6 L=0.15 nrs=1 nrd=1 nf=1
xM1_ GND in_50_6 out GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: ginvx0<> -----
*
*---- act defproc: syn::ring::inverter<> -----
* raw ports:  in out
*
.subckt _0_0syn_0_0ring_0_0inverter in out
*.PININFO in:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xcx0 in out _0_0cell_0_0ginvx0
.ends
*---- end of process: inverter<> -----
*
*---- act defproc: syn::ring::elem_c_itb<> -----
* raw ports:  m1.d.d[0] m1.a p1.d.d[0] p1.a
*
.subckt _0_0syn_0_0ring_0_0elem_c_itb m1_ad_ad_50_6 m1_aa p1_ad_ad_50_6 p1_aa
*.PININFO m1_ad_ad_50_6:I m1_aa:O p1_ad_ad_50_6:O p1_aa:I
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xcx0 Reset m1_ad_ad_50_6 p1_aa p1_ad_ad_50_6 _0_0cell_0_0g0n1n2naa_012aox0
xm1__inv p1_ad_ad_50_6 m1_aa _0_0syn_0_0ring_0_0inverter
.ends
*---- end of process: elem_c_itb<> -----
*
*---- act defproc: syn::ring::delay_line_0<1> -----
* raw ports:  in out
*
.subckt _0_0syn_0_0ring_0_0delay__line__0_31_4 in out
*.PININFO in:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xinvs_50_6 in invs_50_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_51_6 invs_50_6_aY out _0_0std_0_0cells_0_0INVX1
.ends
*---- end of process: delay_line_0<1> -----
*
*---- act defproc: syn::ring::delay_selector<0,1> -----
* raw ports:  in out
*
.subckt _0_0syn_0_0ring_0_0delay__selector_30_71_4 in out
*.PININFO in:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xd0 in out _0_0syn_0_0ring_0_0delay__line__0_31_4
.ends
*---- end of process: delay_selector<0,1> -----
*
*---- act defproc: syn::ring::delay_line<1> -----
* raw ports:  in out
*
.subckt _0_0syn_0_0ring_0_0delay__line_31_4 in out
*.PININFO in:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xdl in out _0_0syn_0_0ring_0_0delay__selector_30_71_4
.ends
*---- end of process: delay_line<1> -----
*
*---- act defproc: syn::ring::delay_line_chan<1> -----
* raw ports:  m1.d.d[0] p1.d.d[0]
*
.subckt _0_0syn_0_0ring_0_0delay__line__chan_31_4 m1_ad_ad_50_6 p1_ad_ad_50_6
*.PININFO m1_ad_ad_50_6:I p1_ad_ad_50_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xd m1_ad_ad_50_6 p1_ad_ad_50_6 _0_0syn_0_0ring_0_0delay__line_31_4
.ends
*---- end of process: delay_line_chan<1> -----
*
*---- act defproc: std::cells::AOI22X1<> -----
* raw ports:  A B C D Y
*
.subckt _0_0std_0_0cells_0_0AOI22X1 A B C D Y
*.PININFO A:I B:I C:I D:I Y:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* Y (combinational)
*
* --- end node flags ---
*
xM0_ Vdd A #9 Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM1_ Vdd B #9 Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM2_ GND A #3 GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM3_ GND C #6 GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM4_ #3 B Y GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM5_ #6 D Y GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM6_ #9 C Y Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM7_ #9 D Y Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: AOI22X1<> -----
*
*---- act defproc: cell::ginvx1<> -----
* raw ports:  in[0] out
*
.subckt _0_0cell_0_0ginvx1 in_50_6 out
*.PININFO in_50_6:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* out (combinational)
*
* --- end node flags ---
*
xM0_ Vdd in_50_6 out Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM1_ GND in_50_6 out GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: ginvx1<> -----
*
*---- act defproc: cell::ginvx2<> -----
* raw ports:  in[0] out
*
.subckt _0_0cell_0_0ginvx2 in_50_6 out
*.PININFO in_50_6:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* out (combinational)
*
* --- end node flags ---
*
xM0_0_ Vdd in_50_6 out Vdd sky130_fd_pr__pfet_01v8  W=2.25 L=0.15 nrs=1 nrd=1 nf=1
xM0_1_ Vdd in_50_6 out Vdd sky130_fd_pr__pfet_01v8  W=2.25 L=0.15 nrs=1 nrd=1 nf=1
xM1_0_ GND in_50_6 out GND sky130_fd_pr__nfet_01v8 W=1.5 L=0.15 nrs=1 nrd=1 nf=1
xM1_1_ GND in_50_6 out GND sky130_fd_pr__nfet_01v8 W=1.5 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: ginvx2<> -----
*
*---- act defproc: std::gates::sigbuf<9> -----
* raw ports:  in out[0]
*
.subckt _0_0std_0_0gates_0_0sigbuf_39_4 in out_50_6
*.PININFO in:I out_50_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xcx0 in __out _0_0cell_0_0ginvx1
xcx1 __out out_50_6 _0_0cell_0_0ginvx2
.ends
*---- end of process: sigbuf<9> -----
*
*---- act defproc: cell::ginvx3<> -----
* raw ports:  in[0] out
*
.subckt _0_0cell_0_0ginvx3 in_50_6 out
*.PININFO in_50_6:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* out (combinational)
*
* --- end node flags ---
*
xM0_ Vdd in_50_6 out Vdd sky130_fd_pr__pfet_01v8  W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM1_ GND in_50_6 out GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: ginvx3<> -----
*
*---- act defproc: std::gates::andtree<1,t> -----
* raw ports:  in[0] out
*
.subckt _0_0std_0_0gates_0_0andtree_31_7t_4 in_50_6 out
*.PININFO in_50_6:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xcx0 in_50_6 out _0_0cell_0_0ginvx3
.ends
*---- end of process: andtree<1,t> -----
*
*---- act defproc: syn::ring::merge_mux_ohc_opt<2,9> -----
* raw ports:  c[0] c[1] din[0][0] din[0][1] din[0][2] din[0][3] din[0][4] din[0][5] din[0][6] din[0][7] din[0][8] din[1][0] din[1][1] din[1][2] din[1][3] din[1][4] din[1][5] din[1][6] din[1][7] din[1][8] dout[0] dout[1] dout[2] dout[3] dout[4] dout[5] dout[6] dout[7] dout[8]
*
.subckt _0_0syn_0_0ring_0_0merge__mux__ohc__opt_32_79_4 c_50_6 c_51_6 din_50_6_50_6 din_50_6_51_6 din_50_6_52_6 din_50_6_53_6 din_50_6_54_6 din_50_6_55_6 din_50_6_56_6 din_50_6_57_6 din_50_6_58_6 din_51_6_50_6 din_51_6_51_6 din_51_6_52_6 din_51_6_53_6 din_51_6_54_6 din_51_6_55_6 din_51_6_56_6 din_51_6_57_6 din_51_6_58_6 dout_50_6 dout_51_6 dout_52_6 dout_53_6 dout_54_6 dout_55_6 dout_56_6 dout_57_6 dout_58_6
*.PININFO c_50_6:I c_51_6:I din_50_6_50_6:I din_50_6_51_6:I din_50_6_52_6:I din_50_6_53_6:I din_50_6_54_6:I din_50_6_55_6:I din_50_6_56_6:I din_50_6_57_6:I din_50_6_58_6:I din_51_6_50_6:I din_51_6_51_6:I din_51_6_52_6:I din_51_6_53_6:I din_51_6_54_6:I din_51_6_55_6:I din_51_6_56_6:I din_51_6_57_6:I din_51_6_58_6:I dout_50_6:O dout_51_6:O dout_52_6:O dout_53_6:O dout_54_6:O dout_55_6:O dout_56_6:O dout_57_6:O dout_58_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xstage__1_50_6_50_6 din_50_6_50_6 stage__1_50_6_58_6_aB din_51_6_50_6 stage__1_50_6_58_6_aD stage__1_50_6_50_6_aY _0_0std_0_0cells_0_0AOI22X1
xstage__1_50_6_51_6 din_50_6_51_6 stage__1_50_6_58_6_aB din_51_6_51_6 stage__1_50_6_58_6_aD stage__1_50_6_51_6_aY _0_0std_0_0cells_0_0AOI22X1
xstage__1_50_6_52_6 din_50_6_52_6 stage__1_50_6_58_6_aB din_51_6_52_6 stage__1_50_6_58_6_aD stage__1_50_6_52_6_aY _0_0std_0_0cells_0_0AOI22X1
xstage__1_50_6_53_6 din_50_6_53_6 stage__1_50_6_58_6_aB din_51_6_53_6 stage__1_50_6_58_6_aD stage__1_50_6_53_6_aY _0_0std_0_0cells_0_0AOI22X1
xstage__1_50_6_54_6 din_50_6_54_6 stage__1_50_6_58_6_aB din_51_6_54_6 stage__1_50_6_58_6_aD stage__1_50_6_54_6_aY _0_0std_0_0cells_0_0AOI22X1
xstage__1_50_6_55_6 din_50_6_55_6 stage__1_50_6_58_6_aB din_51_6_55_6 stage__1_50_6_58_6_aD stage__1_50_6_55_6_aY _0_0std_0_0cells_0_0AOI22X1
xstage__1_50_6_56_6 din_50_6_56_6 stage__1_50_6_58_6_aB din_51_6_56_6 stage__1_50_6_58_6_aD stage__1_50_6_56_6_aY _0_0std_0_0cells_0_0AOI22X1
xstage__1_50_6_57_6 din_50_6_57_6 stage__1_50_6_58_6_aB din_51_6_57_6 stage__1_50_6_58_6_aD stage__1_50_6_57_6_aY _0_0std_0_0cells_0_0AOI22X1
xstage__1_50_6_58_6 din_50_6_58_6 stage__1_50_6_58_6_aB din_51_6_58_6 stage__1_50_6_58_6_aD stage__1_50_6_58_6_aY _0_0std_0_0cells_0_0AOI22X1
xfanout__tree_50_6 c_50_6 stage__1_50_6_58_6_aB _0_0std_0_0gates_0_0sigbuf_39_4
xfanout__tree_51_6 c_51_6 stage__1_50_6_58_6_aD _0_0std_0_0gates_0_0sigbuf_39_4
xstage__2_50_6 stage__1_50_6_50_6_aY dout_50_6 _0_0std_0_0gates_0_0andtree_31_7t_4
xstage__2_51_6 stage__1_50_6_51_6_aY dout_51_6 _0_0std_0_0gates_0_0andtree_31_7t_4
xstage__2_52_6 stage__1_50_6_52_6_aY dout_52_6 _0_0std_0_0gates_0_0andtree_31_7t_4
xstage__2_53_6 stage__1_50_6_53_6_aY dout_53_6 _0_0std_0_0gates_0_0andtree_31_7t_4
xstage__2_54_6 stage__1_50_6_54_6_aY dout_54_6 _0_0std_0_0gates_0_0andtree_31_7t_4
xstage__2_55_6 stage__1_50_6_55_6_aY dout_55_6 _0_0std_0_0gates_0_0andtree_31_7t_4
xstage__2_56_6 stage__1_50_6_56_6_aY dout_56_6 _0_0std_0_0gates_0_0andtree_31_7t_4
xstage__2_57_6 stage__1_50_6_57_6_aY dout_57_6 _0_0std_0_0gates_0_0andtree_31_7t_4
xstage__2_58_6 stage__1_50_6_58_6_aY dout_58_6 _0_0std_0_0gates_0_0andtree_31_7t_4
.ends
*---- end of process: merge_mux_ohc_opt<2,9> -----
*
*---- act defproc: std::cells::LATCH<> -----
* raw ports:  CLK D Q
*
.subckt _0_0std_0_0cells_0_0LATCH CLK D Q
*.PININFO CLK:I D:I Q:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* __clk (combinational)
* __q (combinational)
* Q (combinational)
*
* --- end node flags ---
*
xM0_ Vdd CLK __clk Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM1_ Vdd D #7 Vdd sky130_fd_pr__pfet_01v8  W=1.5 L=0.15 nrs=1 nrd=1 nf=1
xM2_ Vdd Q #8 Vdd sky130_fd_pr__pfet_01v8  W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM3_ Vdd __q Q Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM4_ GND CLK __clk GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM5_ GND D #5 GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM6_ GND Q #10 GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM7_ GND __q Q GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM8_ #5 CLK __q GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM9_ #7 __clk __q Vdd sky130_fd_pr__pfet_01v8  W=1.5 L=0.15 nrs=1 nrd=1 nf=1
xM10_ #8 CLK __q Vdd sky130_fd_pr__pfet_01v8  W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM11_ #10 __clk __q GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: LATCH<> -----
*
*---- act defproc: std::cells::OR2X1<> -----
* raw ports:  A B Y
*
.subckt _0_0std_0_0cells_0_0OR2X1 A B Y
*.PININFO A:I B:I Y:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* __Y (combinational)
* Y (combinational)
*
* --- end node flags ---
*
xM0_ Vdd A #5 Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM1_ Vdd __Y Y Vdd sky130_fd_pr__pfet_01v8  W=0.6 L=0.15 nrs=1 nrd=1 nf=1
xM2_ GND A __Y GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM3_ GND B __Y GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM4_ GND __Y Y GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM5_ #5 B __Y Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: OR2X1<> -----
*
*---- act defproc: syn::ring::delay_line_1<7> -----
* raw ports:  in out
*
.subckt _0_0syn_0_0ring_0_0delay__line__1_37_4 in out
*.PININFO in:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xinvs_50_6 in invs_50_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_51_6 invs_50_6_aY invs_51_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_52_6 invs_51_6_aY invs_52_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_53_6 invs_52_6_aY invs_53_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_54_6 invs_53_6_aY invs_54_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_55_6 invs_54_6_aY invs_55_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_56_6 invs_55_6_aY invs_56_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_57_6 invs_56_6_aY invs_57_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_58_6 invs_57_6_aY invs_58_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_59_6 invs_58_6_aY invs_59_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_510_6 invs_59_6_aY invs_510_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_511_6 invs_510_6_aY invs_511_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_512_6 invs_511_6_aY invs_512_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_513_6 invs_512_6_aY out _0_0std_0_0cells_0_0INVX1
.ends
*---- end of process: delay_line_1<7> -----
*
*---- act defproc: syn::ring::delay_selector<1,7> -----
* raw ports:  in out
*
.subckt _0_0syn_0_0ring_0_0delay__selector_31_77_4 in out
*.PININFO in:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xd1 in out _0_0syn_0_0ring_0_0delay__line__1_37_4
.ends
*---- end of process: delay_selector<1,7> -----
*
*---- act defproc: syn::ring::delay_line<7> -----
* raw ports:  in out
*
.subckt _0_0syn_0_0ring_0_0delay__line_37_4 in out
*.PININFO in:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xdl in out _0_0syn_0_0ring_0_0delay__selector_31_77_4
.ends
*---- end of process: delay_line<7> -----
*
*---- act defproc: cell::gcelem2x0<> -----
* raw ports:  in[0] in[1] out
*
.subckt _0_0cell_0_0gcelem2x0 in_50_6 in_51_6 out
*.PININFO in_50_6:I in_51_6:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* out (state-holding): pup_reff=0.333333; pdn_reff=0.4
*
* --- end node flags ---
*
xM0_ Vdd in_50_6 #6 Vdd sky130_fd_pr__pfet_01v8  W=0.9 L=0.15 nrs=1 nrd=1 nf=1
xM1_ Vdd out #fb7# Vdd sky130_fd_pr__pfet_01v8  W=0.75 L=0.3 nrs=1 nrd=1 nf=1
xM2_keeper Vdd GND #8 Vdd sky130_fd_pr__pfet_01v8  W=0.45 L=1.05 nrs=1 nrd=1 nf=1
xM3_ GND in_50_6 #3 GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM4_ GND out #fb7# GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.3 nrs=1 nrd=1 nf=1
xM5_keeper GND Vdd #9 GND sky130_fd_pr__nfet_01v8 W=0.45 L=2.1 nrs=1 nrd=1 nf=1
xM6_ #3 in_51_6 out GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM7_ #6 in_51_6 out Vdd sky130_fd_pr__pfet_01v8  W=0.9 L=0.15 nrs=1 nrd=1 nf=1
xM8_keeper #8 #fb7# out Vdd sky130_fd_pr__pfet_01v8  W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM9_keeper #9 #fb7# out GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: gcelem2x0<> -----
*
*---- act defproc: std::gates::ctree<2,f> -----
* raw ports:  in[0] in[1] out
*
.subckt _0_0std_0_0gates_0_0ctree_32_7f_4 in_50_6 in_51_6 out
*.PININFO in_50_6:I in_51_6:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xcx0 in_50_6 in_51_6 cx0_aout _0_0cell_0_0gcelem2x0
xcx1 cx0_aout out _0_0cell_0_0ginvx3
.ends
*---- end of process: ctree<2,f> -----
*
*---- act defproc: syn::ring::delay_line_1<6> -----
* raw ports:  in out
*
.subckt _0_0syn_0_0ring_0_0delay__line__1_36_4 in out
*.PININFO in:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xinvs_50_6 in invs_50_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_51_6 invs_50_6_aY invs_51_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_52_6 invs_51_6_aY invs_52_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_53_6 invs_52_6_aY invs_53_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_54_6 invs_53_6_aY invs_54_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_55_6 invs_54_6_aY invs_55_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_56_6 invs_55_6_aY invs_56_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_57_6 invs_56_6_aY invs_57_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_58_6 invs_57_6_aY invs_58_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_59_6 invs_58_6_aY invs_59_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_510_6 invs_59_6_aY invs_510_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_511_6 invs_510_6_aY out _0_0std_0_0cells_0_0INVX1
.ends
*---- end of process: delay_line_1<6> -----
*
*---- act defproc: syn::ring::delay_selector<1,6> -----
* raw ports:  in out
*
.subckt _0_0syn_0_0ring_0_0delay__selector_31_76_4 in out
*.PININFO in:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xd1 in out _0_0syn_0_0ring_0_0delay__line__1_36_4
.ends
*---- end of process: delay_selector<1,6> -----
*
*---- act defproc: syn::ring::delay_line<6> -----
* raw ports:  in out
*
.subckt _0_0syn_0_0ring_0_0delay__line_36_4 in out
*.PININFO in:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xdl in out _0_0syn_0_0ring_0_0delay__selector_31_76_4
.ends
*---- end of process: delay_line<6> -----
*
*---- act defproc: std::cells::AND2X1<> -----
* raw ports:  A B Y
*
.subckt _0_0std_0_0cells_0_0AND2X1 A B Y
*.PININFO A:I B:I Y:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* __Y (combinational)
* Y (combinational)
*
* --- end node flags ---
*
xM0_ Vdd A __Y Vdd sky130_fd_pr__pfet_01v8  W=0.6 L=0.15 nrs=1 nrd=1 nf=1
xM1_ Vdd B __Y Vdd sky130_fd_pr__pfet_01v8  W=0.6 L=0.15 nrs=1 nrd=1 nf=1
xM2_ Vdd __Y Y Vdd sky130_fd_pr__pfet_01v8  W=0.6 L=0.15 nrs=1 nrd=1 nf=1
xM3_ GND A #3 GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM4_ GND __Y Y GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM5_ #3 B __Y GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: AND2X1<> -----
*
*---- act defproc: syn::ring::ff_control<6> -----
* raw ports:  go.d.d[0] go.a clk1 clk2
*
.subckt _0_0syn_0_0ring_0_0ff__control_36_4 go_ad_ad_50_6 go_aa clk1 clk2
*.PININFO go_ad_ad_50_6:I go_aa:O clk1:O clk2:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xor1 go_ad_ad_50_6 or1_aB or1_aY _0_0std_0_0cells_0_0OR2X1
xinv__clk or1_aY clk1 _0_0std_0_0cells_0_0INVX1
xcapture__delay__1 or1_aY and1_aB _0_0syn_0_0ring_0_0delay__line_37_4
xc2 or1_aB and1_aB go_aa _0_0std_0_0gates_0_0ctree_32_7f_4
xcapture__delay__2 clk2 or1_aB _0_0syn_0_0ring_0_0delay__line_36_4
xand1 go_ad_ad_50_6 and1_aB clk2 _0_0std_0_0cells_0_0AND2X1
.ends
*---- end of process: ff_control<6> -----
*
*---- act defproc: syn::ring::capture<6,6,9> -----
* raw ports:  go.d.d[0] go.a din[0] din[1] din[2] din[3] din[4] din[5] din[6] din[7] din[8] dout[0] dout[1] dout[2] dout[3] dout[4] dout[5] dout[6] dout[7] dout[8]
*
.subckt _0_0syn_0_0ring_0_0capture_36_76_79_4 go_ad_ad_50_6 go_aa din_50_6 din_51_6 din_52_6 din_53_6 din_54_6 din_55_6 din_56_6 din_57_6 din_58_6 dout_50_6 dout_51_6 dout_52_6 dout_53_6 dout_54_6 dout_55_6 dout_56_6 dout_57_6 dout_58_6
*.PININFO go_ad_ad_50_6:I go_aa:O din_50_6:I din_51_6:I din_52_6:I din_53_6:I din_54_6:I din_55_6:I din_56_6:I din_57_6:I din_58_6:I dout_50_6:O dout_51_6:O dout_52_6:O dout_53_6:O dout_54_6:O dout_55_6:O dout_56_6:O dout_57_6:O dout_58_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xfanout__tree__2 ff__ctrl_aclk2 x2_58_6_aCLK _0_0std_0_0gates_0_0sigbuf_39_4
xx2_50_6 x2_58_6_aCLK dmid_50_6 dout_50_6 _0_0std_0_0cells_0_0LATCH
xx2_51_6 x2_58_6_aCLK dmid_51_6 dout_51_6 _0_0std_0_0cells_0_0LATCH
xx2_52_6 x2_58_6_aCLK dmid_52_6 dout_52_6 _0_0std_0_0cells_0_0LATCH
xx2_53_6 x2_58_6_aCLK dmid_53_6 dout_53_6 _0_0std_0_0cells_0_0LATCH
xx2_54_6 x2_58_6_aCLK dmid_54_6 dout_54_6 _0_0std_0_0cells_0_0LATCH
xx2_55_6 x2_58_6_aCLK dmid_55_6 dout_55_6 _0_0std_0_0cells_0_0LATCH
xx2_56_6 x2_58_6_aCLK dmid_56_6 dout_56_6 _0_0std_0_0cells_0_0LATCH
xx2_57_6 x2_58_6_aCLK dmid_57_6 dout_57_6 _0_0std_0_0cells_0_0LATCH
xx2_58_6 x2_58_6_aCLK dmid_58_6 dout_58_6 _0_0std_0_0cells_0_0LATCH
xx1_50_6 x1_58_6_aCLK din_50_6 dmid_50_6 _0_0std_0_0cells_0_0LATCH
xx1_51_6 x1_58_6_aCLK din_51_6 dmid_51_6 _0_0std_0_0cells_0_0LATCH
xx1_52_6 x1_58_6_aCLK din_52_6 dmid_52_6 _0_0std_0_0cells_0_0LATCH
xx1_53_6 x1_58_6_aCLK din_53_6 dmid_53_6 _0_0std_0_0cells_0_0LATCH
xx1_54_6 x1_58_6_aCLK din_54_6 dmid_54_6 _0_0std_0_0cells_0_0LATCH
xx1_55_6 x1_58_6_aCLK din_55_6 dmid_55_6 _0_0std_0_0cells_0_0LATCH
xx1_56_6 x1_58_6_aCLK din_56_6 dmid_56_6 _0_0std_0_0cells_0_0LATCH
xx1_57_6 x1_58_6_aCLK din_57_6 dmid_57_6 _0_0std_0_0cells_0_0LATCH
xx1_58_6 x1_58_6_aCLK din_58_6 dmid_58_6 _0_0std_0_0cells_0_0LATCH
xfanout__tree__1 ff__ctrl_aclk1 x1_58_6_aCLK _0_0std_0_0gates_0_0sigbuf_39_4
xff__ctrl go_ad_ad_50_6 go_aa ff__ctrl_aclk1 ff__ctrl_aclk2 _0_0syn_0_0ring_0_0ff__control_36_4
.ends
*---- end of process: capture<6,6,9> -----
*
*---- act defproc: syn::ring::connect_outchan_to_ctrl<9> -----
* raw ports: 
*
* empty subckt
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
* end empty subckt
*---- end of process: connect_outchan_to_ctrl<9> -----
*
*---- act defproc: cell::gnor2x0<> -----
* raw ports:  in[0] in[1] out
*
.subckt _0_0cell_0_0gnor2x0 in_50_6 in_51_6 out
*.PININFO in_50_6:I in_51_6:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* out (combinational)
*
* --- end node flags ---
*
xM0_ Vdd in_50_6 #5 Vdd sky130_fd_pr__pfet_01v8  W=0.9 L=0.15 nrs=1 nrd=1 nf=1
xM1_ GND in_50_6 out GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM2_ GND in_51_6 out GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM3_ #5 in_51_6 out Vdd sky130_fd_pr__pfet_01v8  W=0.9 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: gnor2x0<> -----
*
*---- act defproc: std::gates::ortree<2,f> -----
* raw ports:  in[0] in[1] out
*
.subckt _0_0std_0_0gates_0_0ortree_32_7f_4 in_50_6 in_51_6 out
*.PININFO in_50_6:I in_51_6:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xcx0 in_50_6 in_51_6 cx0_aout _0_0cell_0_0gnor2x0
xcx1 cx0_aout out _0_0cell_0_0ginvx3
.ends
*---- end of process: ortree<2,f> -----
*
*---- act defproc: std::cells::NOR2X2<> -----
* raw ports:  A B Y
*
.subckt _0_0std_0_0cells_0_0NOR2X2 A B Y
*.PININFO A:I B:I Y:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* Y (combinational)
*
* --- end node flags ---
*
xM0_ Vdd A #5 Vdd sky130_fd_pr__pfet_01v8  W=2.25 L=0.15 nrs=1 nrd=1 nf=1
xM1_ GND A Y GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM2_ GND B Y GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM3_ #5 B Y Vdd sky130_fd_pr__pfet_01v8  W=2.25 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: NOR2X2<> -----
*
*---- act defproc: std::cells::LATCHINV<> -----
* raw ports:  CLK D q _q
*
.subckt _0_0std_0_0cells_0_0LATCHINV CLK D q __q
*.PININFO CLK:I D:I q:I __q:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* __clk (combinational)
* __q (combinational)
*
* --- end node flags ---
*
xM0_ Vdd CLK __clk Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM1_ Vdd D #7 Vdd sky130_fd_pr__pfet_01v8  W=1.5 L=0.15 nrs=1 nrd=1 nf=1
xM2_ Vdd q #8 Vdd sky130_fd_pr__pfet_01v8  W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM3_ GND CLK __clk GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM4_ GND D #5 GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM5_ GND q #10 GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM6_ #5 CLK __q GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM7_ #7 __clk __q Vdd sky130_fd_pr__pfet_01v8  W=1.5 L=0.15 nrs=1 nrd=1 nf=1
xM8_ #8 CLK __q Vdd sky130_fd_pr__pfet_01v8  W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM9_ #10 __clk __q GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: LATCHINV<> -----
*
*---- act defproc: std::cells::LATCHLO<> -----
* raw ports:  R CLK D Q
*
.subckt _0_0std_0_0cells_0_0LATCHLO R CLK D Q
*.PININFO R:I CLK:I D:I Q:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xnx __q R Q _0_0std_0_0cells_0_0NOR2X2
xl CLK D Q __q _0_0std_0_0cells_0_0LATCHINV
.ends
*---- end of process: LATCHLO<> -----
*
*---- act defproc: cell::ginvx4<> -----
* raw ports:  in[0] out
*
.subckt _0_0cell_0_0ginvx4 in_50_6 out
*.PININFO in_50_6:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* out (combinational)
*
* --- end node flags ---
*
xM0_ Vdd in_50_6 out Vdd sky130_fd_pr__pfet_01v8  W=0.6 L=0.15 nrs=1 nrd=1 nf=1
xM1_ GND in_50_6 out GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: ginvx4<> -----
*
*---- act defproc: std::gates::sigbuf<2> -----
* raw ports:  in out[0]
*
.subckt _0_0std_0_0gates_0_0sigbuf_32_4 in out_50_6
*.PININFO in:I out_50_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xcx0 in __out _0_0cell_0_0ginvx4
xcx1 __out out_50_6 _0_0cell_0_0ginvx1
.ends
*---- end of process: sigbuf<2> -----
*
*---- act defproc: syn::ring::delay_line_1<5> -----
* raw ports:  in out
*
.subckt _0_0syn_0_0ring_0_0delay__line__1_35_4 in out
*.PININFO in:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xinvs_50_6 in invs_50_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_51_6 invs_50_6_aY invs_51_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_52_6 invs_51_6_aY invs_52_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_53_6 invs_52_6_aY invs_53_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_54_6 invs_53_6_aY invs_54_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_55_6 invs_54_6_aY invs_55_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_56_6 invs_55_6_aY invs_56_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_57_6 invs_56_6_aY invs_57_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_58_6 invs_57_6_aY invs_58_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_59_6 invs_58_6_aY out _0_0std_0_0cells_0_0INVX1
.ends
*---- end of process: delay_line_1<5> -----
*
*---- act defproc: syn::ring::delay_selector<1,5> -----
* raw ports:  in out
*
.subckt _0_0syn_0_0ring_0_0delay__selector_31_75_4 in out
*.PININFO in:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xd1 in out _0_0syn_0_0ring_0_0delay__line__1_35_4
.ends
*---- end of process: delay_selector<1,5> -----
*
*---- act defproc: syn::ring::delay_line<5> -----
* raw ports:  in out
*
.subckt _0_0syn_0_0ring_0_0delay__line_35_4 in out
*.PININFO in:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xdl in out _0_0syn_0_0ring_0_0delay__selector_31_75_4
.ends
*---- end of process: delay_line<5> -----
*
*---- act defproc: syn::ring::ff_control<5> -----
* raw ports:  go.d.d[0] go.a clk1 clk2
*
.subckt _0_0syn_0_0ring_0_0ff__control_35_4 go_ad_ad_50_6 go_aa clk1 clk2
*.PININFO go_ad_ad_50_6:I go_aa:O clk1:O clk2:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xor1 go_ad_ad_50_6 or1_aB or1_aY _0_0std_0_0cells_0_0OR2X1
xinv__clk or1_aY clk1 _0_0std_0_0cells_0_0INVX1
xcapture__delay__1 or1_aY and1_aB _0_0syn_0_0ring_0_0delay__line_36_4
xc2 or1_aB and1_aB go_aa _0_0std_0_0gates_0_0ctree_32_7f_4
xcapture__delay__2 clk2 or1_aB _0_0syn_0_0ring_0_0delay__line_35_4
xand1 go_ad_ad_50_6 and1_aB clk2 _0_0std_0_0cells_0_0AND2X1
.ends
*---- end of process: ff_control<5> -----
*
*---- act defproc: syn::ring::capture_init<5,6,2,0> -----
* raw ports:  go.d.d[0] go.a din[0] din[1] dout[0] dout[1]
*
.subckt _0_0syn_0_0ring_0_0capture__init_35_76_72_70_4 go_ad_ad_50_6 go_aa din_50_6 din_51_6 dout_50_6 dout_51_6
*.PININFO go_ad_ad_50_6:I go_aa:O din_50_6:I din_51_6:I dout_50_6:O dout_51_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xx__lo__1_50_6 Reset x__lo__1_51_6_aCLK din_50_6 dmid_50_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__1_51_6 Reset x__lo__1_51_6_aCLK din_51_6 dmid_51_6 _0_0std_0_0cells_0_0LATCHLO
xfanout__tree__2 ff__ctrl_aclk2 x__lo__2_51_6_aCLK _0_0std_0_0gates_0_0sigbuf_32_4
xx__lo__2_50_6 Reset x__lo__2_51_6_aCLK dmid_50_6 dout_50_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__2_51_6 Reset x__lo__2_51_6_aCLK dmid_51_6 dout_51_6 _0_0std_0_0cells_0_0LATCHLO
xfanout__tree__1 ff__ctrl_aclk1 x__lo__1_51_6_aCLK _0_0std_0_0gates_0_0sigbuf_32_4
xff__ctrl go_ad_ad_50_6 go_aa ff__ctrl_aclk1 ff__ctrl_aclk2 _0_0syn_0_0ring_0_0ff__control_35_4
.ends
*---- end of process: capture_init<5,6,2,0> -----
*
*---- act defproc: syn::ring::selection_split<2> -----
* raw ports:  gs[0] gs[1] m1.d.d[0] m1.a co[0].d.d[0] co[0].a co[1].d.d[0] co[1].a
*
.subckt _0_0syn_0_0ring_0_0selection__split_32_4 gs_50_6 gs_51_6 m1_ad_ad_50_6 m1_aa co_50_6_ad_ad_50_6 co_50_6_aa co_51_6_ad_ad_50_6 co_51_6_aa
*.PININFO gs_50_6:I gs_51_6:I m1_ad_ad_50_6:I m1_aa:O co_50_6_ad_ad_50_6:O co_50_6_aa:I co_51_6_ad_ad_50_6:O co_51_6_aa:I
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xort co_50_6_aa co_51_6_aa m1_aa _0_0std_0_0gates_0_0ortree_32_7f_4
xands_50_6 ands_51_6_aA ands_50_6_aB co_50_6_ad_ad_50_6 _0_0std_0_0cells_0_0AND2X1
xands_51_6 ands_51_6_aA ands_51_6_aB co_51_6_ad_ad_50_6 _0_0std_0_0cells_0_0AND2X1
xcapt m1_ad_ad_50_6 ands_51_6_aA gs_50_6 gs_51_6 ands_50_6_aB ands_51_6_aB _0_0syn_0_0ring_0_0capture__init_35_76_72_70_4
.ends
*---- end of process: selection_split<2> -----
*
*---- act defproc: syn::ring::connect_inchan_to_ctrl<9> -----
* raw ports: 
*
* empty subckt
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
* end empty subckt
*---- end of process: connect_inchan_to_ctrl<9> -----
*
*---- act defproc: syn::ring::selection_merge<2> -----
* raw ports:  ci[0].d.d[0] ci[0].a ci[1].d.d[0] p1.d.d[0] p1.a
*
.subckt _0_0syn_0_0ring_0_0selection__merge_32_4 ci_50_6_ad_ad_50_6 ci_50_6_aa ci_51_6_ad_ad_50_6 p1_ad_ad_50_6 p1_aa
*.PININFO ci_50_6_ad_ad_50_6:I ci_50_6_aa:O ci_51_6_ad_ad_50_6:I p1_ad_ad_50_6:O p1_aa:I
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xort ci_50_6_ad_ad_50_6 ci_51_6_ad_ad_50_6 p1_ad_ad_50_6 _0_0std_0_0gates_0_0ortree_32_7f_4
xs p1_aa ci_50_6_aa _0_0std_0_0gates_0_0sigbuf_32_4
.ends
*---- end of process: selection_merge<2> -----
*
*---- act defproc: std::cells::NAND2X2<> -----
* raw ports:  A B Y
*
.subckt _0_0std_0_0cells_0_0NAND2X2 A B Y
*.PININFO A:I B:I Y:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* Y (combinational)
*
* --- end node flags ---
*
xM0_ Vdd A Y Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM1_ Vdd B Y Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM2_ GND A #3 GND sky130_fd_pr__nfet_01v8 W=1.5 L=0.15 nrs=1 nrd=1 nf=1
xM3_ #3 B Y GND sky130_fd_pr__nfet_01v8 W=1.5 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: NAND2X2<> -----
*
*---- act defproc: std::cells::LATCHHI<> -----
* raw ports:  S CLK D Q
*
.subckt _0_0std_0_0cells_0_0LATCHHI S CLK D Q
*.PININFO S:I CLK:I D:I Q:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xix S __s _0_0std_0_0cells_0_0INVX1
xnx __q __s Q _0_0std_0_0cells_0_0NAND2X2
xl CLK D Q __q _0_0std_0_0cells_0_0LATCHINV
.ends
*---- end of process: LATCHHI<> -----
*
*---- act defproc: syn::ring::capture_init<6,6,2,1> -----
* raw ports:  go.d.d[0] go.a din[0] din[1] dout[0] dout[1]
*
.subckt _0_0syn_0_0ring_0_0capture__init_36_76_72_71_4 go_ad_ad_50_6 go_aa din_50_6 din_51_6 dout_50_6 dout_51_6
*.PININFO go_ad_ad_50_6:I go_aa:O din_50_6:I din_51_6:I dout_50_6:O dout_51_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xx__lo__1_51_6 Reset x__hi__1_50_6_aCLK din_51_6 dmid_51_6 _0_0std_0_0cells_0_0LATCHLO
xx__hi__1_50_6 Reset x__hi__1_50_6_aCLK din_50_6 dmid_50_6 _0_0std_0_0cells_0_0LATCHHI
xx__hi__2_50_6 Reset x__hi__2_50_6_aCLK dmid_50_6 dout_50_6 _0_0std_0_0cells_0_0LATCHHI
xx__lo__2_51_6 Reset x__hi__2_50_6_aCLK dmid_51_6 dout_51_6 _0_0std_0_0cells_0_0LATCHLO
xfanout__tree__1 ff__ctrl_aclk1 x__hi__1_50_6_aCLK _0_0std_0_0gates_0_0sigbuf_32_4
xfanout__tree__2 ff__ctrl_aclk2 x__hi__2_50_6_aCLK _0_0std_0_0gates_0_0sigbuf_32_4
xff__ctrl go_ad_ad_50_6 go_aa ff__ctrl_aclk1 ff__ctrl_aclk2 _0_0syn_0_0ring_0_0ff__control_36_4
.ends
*---- end of process: capture_init<6,6,2,1> -----
*
*---- act defproc: syn::expr::blk_i0_1tmp<> -----
* raw ports:  out_50_6
*
.subckt _0_0syn_0_0expr_0_0blk_i0_1tmp out__50__6
*.PININFO out__50__6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
x__nref__0 out__50__6 _0_0std_0_0cells_0_0TIELOX1
.ends
*---- end of process: blk_i0_1tmp<> -----
*
*---- act defproc: syn::expr::blk_i0_1<> -----
* raw ports:  out[0]
*
.subckt _0_0syn_0_0expr_0_0blk_i0_1 out_50_6
*.PININFO out_50_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
x__passthru__ out_50_6 _0_0syn_0_0expr_0_0blk_i0_1tmp
.ends
*---- end of process: blk_i0_1<> -----
*
*---- act defproc: cell::g0n1n2n3naaa_0123aaox0<> -----
* raw ports:  in[0] in[1] in[2] in[3] out
*
.subckt _0_0cell_0_0g0n1n2n3naaa_0123aaox0 in_50_6 in_51_6 in_52_6 in_53_6 out
*.PININFO in_50_6:I in_51_6:I in_52_6:I in_53_6:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* out (state-holding): pup_reff=0.266667; pdn_reff=0.4
*
* --- end node flags ---
*
xM0_ Vdd in_50_6 #11 Vdd sky130_fd_pr__pfet_01v8  W=2.25 L=0.15 nrs=1 nrd=1 nf=1
xM1_ Vdd out #fb12# Vdd sky130_fd_pr__pfet_01v8  W=0.75 L=0.3 nrs=1 nrd=1 nf=1
xM2_keeper Vdd GND #13 Vdd sky130_fd_pr__pfet_01v8  W=0.45 L=1.05 nrs=1 nrd=1 nf=1
xM3_ GND in_50_6 out GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM4_ GND in_51_6 #5 GND sky130_fd_pr__nfet_01v8 W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM5_ GND out #fb12# GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.3 nrs=1 nrd=1 nf=1
xM6_keeper GND Vdd #14 GND sky130_fd_pr__nfet_01v8 W=0.45 L=1.65 nrs=1 nrd=1 nf=1
xM7_ #4 in_53_6 out GND sky130_fd_pr__nfet_01v8 W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM8_ #9 in_53_6 out Vdd sky130_fd_pr__pfet_01v8  W=3 L=0.15 nrs=1 nrd=1 nf=1
xM9_keeper #13 #fb12# out Vdd sky130_fd_pr__pfet_01v8  W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM10_keeper #14 #fb12# out GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM11_ #5 in_52_6 #4 GND sky130_fd_pr__nfet_01v8 W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM12_ #10 in_52_6 #9 Vdd sky130_fd_pr__pfet_01v8  W=3 L=0.15 nrs=1 nrd=1 nf=1
xM13_ #11 in_51_6 #10 Vdd sky130_fd_pr__pfet_01v8  W=1.5 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: g0n1n2n3naaa_0123aaox0<> -----
*
*---- act defproc: syn::ring::elem_c_paa<> -----
* raw ports:  m1.d.d[0] m1.a zero.a p1.a
*
.subckt _0_0syn_0_0ring_0_0elem_c_paa m1_ad_ad_50_6 m1_aa zero_aa p1_aa
*.PININFO m1_ad_ad_50_6:I m1_aa:O zero_aa:I p1_aa:I
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xcx0 Reset __m1__r zero_aa p1_aa m1_aa _0_0cell_0_0g0n1n2n3naaa_0123aaox0
xm1__inv m1_ad_ad_50_6 __m1__r _0_0syn_0_0ring_0_0inverter
.ends
*---- end of process: elem_c_paa<> -----
*
*---- act defproc: cell::g0n1n2n3naaa_023aox0<> -----
* raw ports:  in[0] in[1] in[2] in[3] out
*
.subckt _0_0cell_0_0g0n1n2n3naaa_023aox0 in_50_6 in_51_6 in_52_6 in_53_6 out
*.PININFO in_50_6:I in_51_6:I in_52_6:I in_53_6:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* out (state-holding): pup_reff=0.8; pdn_reff=0.666667
*
* --- end node flags ---
*
xM0_ Vdd in_50_6 #9 Vdd sky130_fd_pr__pfet_01v8  W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM1_ Vdd out #fb11# Vdd sky130_fd_pr__pfet_01v8  W=0.75 L=0.3 nrs=1 nrd=1 nf=1
xM2_keeper Vdd GND #12 Vdd sky130_fd_pr__pfet_01v8  W=0.45 L=1.8 nrs=1 nrd=1 nf=1
xM3_ GND in_50_6 out GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM4_ GND in_52_6 #4 GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM5_ GND out #fb11# GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.3 nrs=1 nrd=1 nf=1
xM6_keeper GND Vdd #13 GND sky130_fd_pr__nfet_01v8 W=0.45 L=5.325 nrs=1 nrd=1 nf=1
xM7_ #4 in_53_6 out GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM8_ #7 in_53_6 out Vdd sky130_fd_pr__pfet_01v8  W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM9_keeper #12 #fb11# out Vdd sky130_fd_pr__pfet_01v8  W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM10_keeper #13 #fb11# out GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM11_ #8 in_52_6 #7 Vdd sky130_fd_pr__pfet_01v8  W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM12_ #9 in_51_6 #8 Vdd sky130_fd_pr__pfet_01v8  W=0.75 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: g0n1n2n3naaa_023aox0<> -----
*
*---- act defproc: syn::ring::asym_c_brs<> -----
* raw ports:  A B C Y
*
.subckt _0_0syn_0_0ring_0_0asym_c_brs A B C Y
*.PININFO A:I B:I C:I Y:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xcx0 Reset A B C Y _0_0cell_0_0g0n1n2n3naaa_023aox0
.ends
*---- end of process: asym_c_brs<> -----
*
*---- act defproc: syn::ring::elem_c_ppa<> -----
* raw ports:  m1.d.d[0] m1.a data.d.d[0] data.a zero.d.d[0] p1.a
*
.subckt _0_0syn_0_0ring_0_0elem_c_ppa m1_ad_ad_50_6 m1_aa data_ad_ad_50_6 data_aa zero_ad_ad_50_6 p1_aa
*.PININFO m1_ad_ad_50_6:I m1_aa:O data_ad_ad_50_6:O data_aa:I zero_ad_ad_50_6:I p1_aa:I
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xcx0 Reset __m1__r __data__a p1_aa m1_aa _0_0cell_0_0g0n1n2n3naaa_0123aaox0
xda__inv data_aa __data__a _0_0syn_0_0ring_0_0inverter
xzr__inv zero_ad_ad_50_6 __zero__r _0_0syn_0_0ring_0_0inverter
xm1__inv m1_ad_ad_50_6 __m1__r _0_0syn_0_0ring_0_0inverter
xac __m1__r __zero__r m1_aa data_ad_ad_50_6 _0_0syn_0_0ring_0_0asym_c_brs
.ends
*---- end of process: elem_c_ppa<> -----
*
*---- act defproc: syn::ring::connect_exprblk_assign<6> -----
* raw ports: 
*
* empty subckt
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
* end empty subckt
*---- end of process: connect_exprblk_assign<6> -----
*
*---- act defproc: std::cells::NOR2X1<> -----
* raw ports:  A B Y
*
.subckt _0_0std_0_0cells_0_0NOR2X1 A B Y
*.PININFO A:I B:I Y:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* Y (combinational)
*
* --- end node flags ---
*
xM0_ Vdd A #5 Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM1_ GND A Y GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM2_ GND B Y GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM3_ #5 B Y Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: NOR2X1<> -----
*
*---- act defproc: std::cells::NAND2X1<> -----
* raw ports:  A B Y
*
.subckt _0_0std_0_0cells_0_0NAND2X1 A B Y
*.PININFO A:I B:I Y:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* Y (combinational)
*
* --- end node flags ---
*
xM0_ Vdd A Y Vdd sky130_fd_pr__pfet_01v8  W=0.6 L=0.15 nrs=1 nrd=1 nf=1
xM1_ Vdd B Y Vdd sky130_fd_pr__pfet_01v8  W=0.6 L=0.15 nrs=1 nrd=1 nf=1
xM2_ GND A #3 GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM3_ #3 B Y GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: NAND2X1<> -----
*
*---- act defproc: syn::expr::blk_0i1hw8hi0ew6i1I1w9eI0w9qBw7w13I1w13I1w9eI0w9qB_8_1tmp<> -----
* raw ports:  in__0_50_6 in__0_51_6 in__0_52_6 in__0_53_6 in__0_54_6 in__0_55_6 in__0_56_6 in__0_57_6 out_50_6
*
.subckt _0_0syn_0_0expr_0_0blk_0i1hw8hi0ew6i1I1w9eI0w9qBw7w13I1w13I1w9eI0w9qB_8_1tmp in____0__50__6 in____0__51__6 in____0__52__6 in____0__53__6 in____0__54__6 in____0__55__6 in____0__56__6 in____0__57__6 out__50__6
*.PININFO in____0__50__6:I in____0__51__6:I in____0__52__6:I in____0__53__6:I in____0__54__6:I in____0__55__6:I in____0__56__6:I in____0__57__6:I out__50__6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xg1 in____0__56__6 in____0__57__6 new__n11 _0_0std_0_0cells_0_0NOR2X1
xg5 new__n13 new__n14 new__n15 _0_0std_0_0cells_0_0NAND2X1
xg3 in____0__50__6 in____0__51__6 new__n13 _0_0std_0_0cells_0_0NOR2X1
xg0 in____0__54__6 in____0__55__6 new__n10 _0_0std_0_0cells_0_0NOR2X1
xg4 in____0__52__6 in____0__53__6 new__n14 _0_0std_0_0cells_0_0NOR2X1
xg2 new__n10 new__n11 new__n12 _0_0std_0_0cells_0_0NAND2X1
xg6 new__n12 new__n15 out__50__6 _0_0std_0_0cells_0_0NOR2X1
.ends
*---- end of process: blk_0i1hw8hi0ew6i1I1w9eI0w9qBw7w13I1w13I1w9eI0w9qB_8_1tmp<> -----
*
*---- act defproc: syn::expr::blk_0i1hw8hi0ew6i1I1w9eI0w9qBw7w13I1w13I1w9eI0w9qB_8_1<> -----
* raw ports:  in_0[0] in_0[1] in_0[2] in_0[3] in_0[4] in_0[5] in_0[6] in_0[7] out[0]
*
.subckt _0_0syn_0_0expr_0_0blk_0i1hw8hi0ew6i1I1w9eI0w9qBw7w13I1w13I1w9eI0w9qB_8_1 in__0_50_6 in__0_51_6 in__0_52_6 in__0_53_6 in__0_54_6 in__0_55_6 in__0_56_6 in__0_57_6 out_50_6
*.PININFO in__0_50_6:I in__0_51_6:I in__0_52_6:I in__0_53_6:I in__0_54_6:I in__0_55_6:I in__0_56_6:I in__0_57_6:I out_50_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
x__passthru__ in__0_50_6 in__0_51_6 in__0_52_6 in__0_53_6 in__0_54_6 in__0_55_6 in__0_56_6 in__0_57_6 out_50_6 _0_0syn_0_0expr_0_0blk_0i1hw8hi0ew6i1I1w9eI0w9qBw7w13I1w13I1w9eI0w9qB_8_1tmp
.ends
*---- end of process: blk_0i1hw8hi0ew6i1I1w9eI0w9qBw7w13I1w13I1w9eI0w9qB_8_1<> -----
*
*---- act defproc: syn::ring::connect_exprblk_assign<2> -----
* raw ports: 
*
* empty subckt
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
* end empty subckt
*---- end of process: connect_exprblk_assign<2> -----
*
*---- act defproc: syn::ring::delay_line_0<3> -----
* raw ports:  in out
*
.subckt _0_0syn_0_0ring_0_0delay__line__0_33_4 in out
*.PININFO in:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xinvs_50_6 in invs_50_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_51_6 invs_50_6_aY invs_51_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_52_6 invs_51_6_aY invs_52_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_53_6 invs_52_6_aY invs_53_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_54_6 invs_53_6_aY invs_54_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_55_6 invs_54_6_aY out _0_0std_0_0cells_0_0INVX1
.ends
*---- end of process: delay_line_0<3> -----
*
*---- act defproc: syn::ring::delay_selector<0,3> -----
* raw ports:  in out
*
.subckt _0_0syn_0_0ring_0_0delay__selector_30_73_4 in out
*.PININFO in:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xd0 in out _0_0syn_0_0ring_0_0delay__line__0_33_4
.ends
*---- end of process: delay_selector<0,3> -----
*
*---- act defproc: syn::ring::delay_line<3> -----
* raw ports:  in out
*
.subckt _0_0syn_0_0ring_0_0delay__line_33_4 in out
*.PININFO in:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xdl in out _0_0syn_0_0ring_0_0delay__selector_30_73_4
.ends
*---- end of process: delay_line<3> -----
*
*---- act defproc: syn::ring::delay_line_chan<3> -----
* raw ports:  m1.d.d[0] p1.d.d[0]
*
.subckt _0_0syn_0_0ring_0_0delay__line__chan_33_4 m1_ad_ad_50_6 p1_ad_ad_50_6
*.PININFO m1_ad_ad_50_6:I p1_ad_ad_50_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xd m1_ad_ad_50_6 p1_ad_ad_50_6 _0_0syn_0_0ring_0_0delay__line_33_4
.ends
*---- end of process: delay_line_chan<3> -----
*
*---- act defproc: syn::ring::connect_exprblk_dout<9> -----
* raw ports: 
*
* empty subckt
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
* end empty subckt
*---- end of process: connect_exprblk_dout<9> -----
*
*---- act defproc: std::cells::INVX8<> -----
* raw ports:  A Y
*
.subckt _0_0std_0_0cells_0_0INVX8 A Y
*.PININFO A:I Y:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* Y (combinational)
*
* --- end node flags ---
*
xM0_0_ Vdd A Y Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM0_1_ Vdd A Y Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM0_2_ Vdd A Y Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM0_3_ Vdd A Y Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM1_0_ GND A Y GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM1_1_ GND A Y GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM1_2_ GND A Y GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM1_3_ GND A Y GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: INVX8<> -----
*
*---- act defproc: syn::expr::blk_0i1e_2_1tmp<> -----
* raw ports:  in__0_50_6 in__0_51_6 out_50_6
*
.subckt _0_0syn_0_0expr_0_0blk_0i1e_2_1tmp in____0__50__6 in____0__51__6 out__50__6
*.PININFO in____0__50__6:I in____0__51__6:I out__50__6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xg1 new__n4 in____0__51__6 out__50__6 _0_0std_0_0cells_0_0NOR2X1
xg0 in____0__50__6 new__n4 _0_0std_0_0cells_0_0INVX8
.ends
*---- end of process: blk_0i1e_2_1tmp<> -----
*
*---- act defproc: syn::expr::blk_0i1e_2_1<> -----
* raw ports:  in_0[0] in_0[1] out[0]
*
.subckt _0_0syn_0_0expr_0_0blk_0i1e_2_1 in__0_50_6 in__0_51_6 out_50_6
*.PININFO in__0_50_6:I in__0_51_6:I out_50_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
x__passthru__ in__0_50_6 in__0_51_6 out_50_6 _0_0syn_0_0expr_0_0blk_0i1e_2_1tmp
.ends
*---- end of process: blk_0i1e_2_1<> -----
*
*---- act defproc: syn::ring::delay_line_0<4> -----
* raw ports:  in out
*
.subckt _0_0syn_0_0ring_0_0delay__line__0_34_4 in out
*.PININFO in:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xinvs_50_6 in invs_50_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_51_6 invs_50_6_aY invs_51_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_52_6 invs_51_6_aY invs_52_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_53_6 invs_52_6_aY invs_53_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_54_6 invs_53_6_aY invs_54_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_55_6 invs_54_6_aY invs_55_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_56_6 invs_55_6_aY invs_56_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_57_6 invs_56_6_aY out _0_0std_0_0cells_0_0INVX1
.ends
*---- end of process: delay_line_0<4> -----
*
*---- act defproc: syn::ring::delay_selector<0,4> -----
* raw ports:  in out
*
.subckt _0_0syn_0_0ring_0_0delay__selector_30_74_4 in out
*.PININFO in:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xd0 in out _0_0syn_0_0ring_0_0delay__line__0_34_4
.ends
*---- end of process: delay_selector<0,4> -----
*
*---- act defproc: syn::ring::delay_line<4> -----
* raw ports:  in out
*
.subckt _0_0syn_0_0ring_0_0delay__line_34_4 in out
*.PININFO in:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xdl in out _0_0syn_0_0ring_0_0delay__selector_30_74_4
.ends
*---- end of process: delay_line<4> -----
*
*---- act defproc: syn::ring::delay_line_chan<4> -----
* raw ports:  m1.d.d[0] p1.d.d[0]
*
.subckt _0_0syn_0_0ring_0_0delay__line__chan_34_4 m1_ad_ad_50_6 p1_ad_ad_50_6
*.PININFO m1_ad_ad_50_6:I p1_ad_ad_50_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xd m1_ad_ad_50_6 p1_ad_ad_50_6 _0_0syn_0_0ring_0_0delay__line_34_4
.ends
*---- end of process: delay_line_chan<4> -----
*
*---- act defproc: cell::ginvx5<> -----
* raw ports:  in[0] out
*
.subckt _0_0cell_0_0ginvx5 in_50_6 out
*.PININFO in_50_6:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* out (combinational)
*
* --- end node flags ---
*
xM0_0_ Vdd in_50_6 out Vdd sky130_fd_pr__pfet_01v8  W=1.685 L=0.15 nrs=1 nrd=1 nf=1
xM0_1_ Vdd in_50_6 out Vdd sky130_fd_pr__pfet_01v8  W=1.69 L=0.15 nrs=1 nrd=1 nf=1
xM1_0_ GND in_50_6 out GND sky130_fd_pr__nfet_01v8 W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM1_1_ GND in_50_6 out GND sky130_fd_pr__nfet_01v8 W=1.125 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: ginvx5<> -----
*
*---- act defproc: std::gates::sigbuf<6> -----
* raw ports:  in out[0]
*
.subckt _0_0std_0_0gates_0_0sigbuf_36_4 in out_50_6
*.PININFO in:I out_50_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xcx0 in __out _0_0cell_0_0ginvx1
xcx1 __out out_50_6 _0_0cell_0_0ginvx5
.ends
*---- end of process: sigbuf<6> -----
*
*---- act defproc: syn::ring::capture<6,6,6> -----
* raw ports:  go.d.d[0] go.a din[0] din[1] din[2] din[3] din[4] din[5] dout[0] dout[1] dout[2] dout[3] dout[4] dout[5]
*
.subckt _0_0syn_0_0ring_0_0capture_36_76_76_4 go_ad_ad_50_6 go_aa din_50_6 din_51_6 din_52_6 din_53_6 din_54_6 din_55_6 dout_50_6 dout_51_6 dout_52_6 dout_53_6 dout_54_6 dout_55_6
*.PININFO go_ad_ad_50_6:I go_aa:O din_50_6:I din_51_6:I din_52_6:I din_53_6:I din_54_6:I din_55_6:I dout_50_6:O dout_51_6:O dout_52_6:O dout_53_6:O dout_54_6:O dout_55_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xfanout__tree__2 ff__ctrl_aclk2 x2_55_6_aCLK _0_0std_0_0gates_0_0sigbuf_36_4
xx2_50_6 x2_55_6_aCLK dmid_50_6 dout_50_6 _0_0std_0_0cells_0_0LATCH
xx2_51_6 x2_55_6_aCLK dmid_51_6 dout_51_6 _0_0std_0_0cells_0_0LATCH
xx2_52_6 x2_55_6_aCLK dmid_52_6 dout_52_6 _0_0std_0_0cells_0_0LATCH
xx2_53_6 x2_55_6_aCLK dmid_53_6 dout_53_6 _0_0std_0_0cells_0_0LATCH
xx2_54_6 x2_55_6_aCLK dmid_54_6 dout_54_6 _0_0std_0_0cells_0_0LATCH
xx2_55_6 x2_55_6_aCLK dmid_55_6 dout_55_6 _0_0std_0_0cells_0_0LATCH
xx1_50_6 x1_55_6_aCLK din_50_6 dmid_50_6 _0_0std_0_0cells_0_0LATCH
xx1_51_6 x1_55_6_aCLK din_51_6 dmid_51_6 _0_0std_0_0cells_0_0LATCH
xx1_52_6 x1_55_6_aCLK din_52_6 dmid_52_6 _0_0std_0_0cells_0_0LATCH
xx1_53_6 x1_55_6_aCLK din_53_6 dmid_53_6 _0_0std_0_0cells_0_0LATCH
xx1_54_6 x1_55_6_aCLK din_54_6 dmid_54_6 _0_0std_0_0cells_0_0LATCH
xx1_55_6 x1_55_6_aCLK din_55_6 dmid_55_6 _0_0std_0_0cells_0_0LATCH
xfanout__tree__1 ff__ctrl_aclk1 x1_55_6_aCLK _0_0std_0_0gates_0_0sigbuf_36_4
xff__ctrl go_ad_ad_50_6 go_aa ff__ctrl_aclk1 ff__ctrl_aclk2 _0_0syn_0_0ring_0_0ff__control_36_4
.ends
*---- end of process: capture<6,6,6> -----
*
*---- act defproc: syn::ring::delay_line_2<14> -----
* raw ports:  in out
*
.subckt _0_0syn_0_0ring_0_0delay__line__2_314_4 in out
*.PININFO in:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xinvs_50_6 in invs_50_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_51_6 invs_50_6_aY invs_51_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_52_6 invs_51_6_aY invs_52_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_53_6 invs_52_6_aY invs_53_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_54_6 invs_53_6_aY invs_54_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_55_6 invs_54_6_aY invs_55_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_56_6 invs_55_6_aY invs_56_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_57_6 invs_56_6_aY invs_57_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_58_6 invs_57_6_aY invs_58_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_59_6 invs_58_6_aY invs_59_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_510_6 invs_59_6_aY invs_510_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_511_6 invs_510_6_aY invs_511_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_512_6 invs_511_6_aY invs_512_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_513_6 invs_512_6_aY invs_513_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_514_6 invs_513_6_aY invs_514_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_515_6 invs_514_6_aY invs_515_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_516_6 invs_515_6_aY invs_516_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_517_6 invs_516_6_aY invs_517_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_518_6 invs_517_6_aY invs_518_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_519_6 invs_518_6_aY invs_519_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_520_6 invs_519_6_aY invs_520_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_521_6 invs_520_6_aY invs_521_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_522_6 invs_521_6_aY invs_522_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_523_6 invs_522_6_aY invs_523_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_524_6 invs_523_6_aY invs_524_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_525_6 invs_524_6_aY invs_525_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_526_6 invs_525_6_aY invs_526_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_527_6 invs_526_6_aY out _0_0std_0_0cells_0_0INVX1
.ends
*---- end of process: delay_line_2<14> -----
*
*---- act defproc: syn::ring::delay_selector<2,14> -----
* raw ports:  in out
*
.subckt _0_0syn_0_0ring_0_0delay__selector_32_714_4 in out
*.PININFO in:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xd2 in out _0_0syn_0_0ring_0_0delay__line__2_314_4
.ends
*---- end of process: delay_selector<2,14> -----
*
*---- act defproc: syn::ring::delay_line<14> -----
* raw ports:  in out
*
.subckt _0_0syn_0_0ring_0_0delay__line_314_4 in out
*.PININFO in:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xdl in out _0_0syn_0_0ring_0_0delay__selector_32_714_4
.ends
*---- end of process: delay_line<14> -----
*
*---- act defproc: syn::ring::delay_line_chan<14> -----
* raw ports:  m1.d.d[0] p1.d.d[0]
*
.subckt _0_0syn_0_0ring_0_0delay__line__chan_314_4 m1_ad_ad_50_6 p1_ad_ad_50_6
*.PININFO m1_ad_ad_50_6:I p1_ad_ad_50_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xd m1_ad_ad_50_6 p1_ad_ad_50_6 _0_0syn_0_0ring_0_0delay__line_314_4
.ends
*---- end of process: delay_line_chan<14> -----
*
*---- act defproc: std::cells::TIEHIX1<> -----
* raw ports:  Y
*
.subckt _0_0std_0_0cells_0_0TIEHIX1 Y
*.PININFO Y:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* Y (combinational)
* x (combinational)
*
* --- end node flags ---
*
xM0_ Vdd x Y Vdd sky130_fd_pr__pfet_01v8  W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM1_ GND x x GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: TIEHIX1<> -----
*
*---- act defproc: syn::expr::blk_i1_1tmp<> -----
* raw ports:  out_50_6
*
.subckt _0_0syn_0_0expr_0_0blk_i1_1tmp out__50__6
*.PININFO out__50__6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
x__nref__0 out__50__6 _0_0std_0_0cells_0_0TIEHIX1
.ends
*---- end of process: blk_i1_1tmp<> -----
*
*---- act defproc: syn::expr::blk_i1_1<> -----
* raw ports:  out[0]
*
.subckt _0_0syn_0_0expr_0_0blk_i1_1 out_50_6
*.PININFO out_50_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
x__passthru__ out_50_6 _0_0syn_0_0expr_0_0blk_i1_1tmp
.ends
*---- end of process: blk_i1_1<> -----
*
*---- act defproc: std::gates::sigbuf<1> -----
* raw ports: 
*
* empty subckt
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
* end empty subckt
*---- end of process: sigbuf<1> -----
*
*---- act defproc: syn::ring::capture_init<6,6,1,0> -----
* raw ports:  go.d.d[0] go.a din[0] dout[0]
*
.subckt _0_0syn_0_0ring_0_0capture__init_36_76_71_70_4 go_ad_ad_50_6 go_aa din_50_6 dout_50_6
*.PININFO go_ad_ad_50_6:I go_aa:O din_50_6:I dout_50_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xx__lo__1_50_6 Reset ff__ctrl_aclk1 din_50_6 dmid_50_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__2_50_6 Reset ff__ctrl_aclk2 dmid_50_6 dout_50_6 _0_0std_0_0cells_0_0LATCHLO
xff__ctrl go_ad_ad_50_6 go_aa ff__ctrl_aclk1 ff__ctrl_aclk2 _0_0syn_0_0ring_0_0ff__control_36_4
.ends
*---- end of process: capture_init<6,6,1,0> -----
*
*---- act defproc: syn::ring::capture<6,6,2> -----
* raw ports:  go.d.d[0] go.a din[0] din[1] dout[0] dout[1]
*
.subckt _0_0syn_0_0ring_0_0capture_36_76_72_4 go_ad_ad_50_6 go_aa din_50_6 din_51_6 dout_50_6 dout_51_6
*.PININFO go_ad_ad_50_6:I go_aa:O din_50_6:I din_51_6:I dout_50_6:O dout_51_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xfanout__tree__2 ff__ctrl_aclk2 x2_51_6_aCLK _0_0std_0_0gates_0_0sigbuf_32_4
xx2_50_6 x2_51_6_aCLK dmid_50_6 dout_50_6 _0_0std_0_0cells_0_0LATCH
xx2_51_6 x2_51_6_aCLK dmid_51_6 dout_51_6 _0_0std_0_0cells_0_0LATCH
xx1_50_6 x1_51_6_aCLK din_50_6 dmid_50_6 _0_0std_0_0cells_0_0LATCH
xx1_51_6 x1_51_6_aCLK din_51_6 dmid_51_6 _0_0std_0_0cells_0_0LATCH
xfanout__tree__1 ff__ctrl_aclk1 x1_51_6_aCLK _0_0std_0_0gates_0_0sigbuf_32_4
xff__ctrl go_ad_ad_50_6 go_aa ff__ctrl_aclk1 ff__ctrl_aclk2 _0_0syn_0_0ring_0_0ff__control_36_4
.ends
*---- end of process: capture<6,6,2> -----
*
*---- act defproc: syn::expr::blk_0t_1_1tmp<> -----
* raw ports:  in__0_50_6 out_50_6
*
.subckt _0_0syn_0_0expr_0_0blk_0t_1_1tmp in____0__50__6 out__50__6
*.PININFO in____0__50__6:I out__50__6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xg0 in____0__50__6 out__50__6 _0_0std_0_0cells_0_0INVX8
.ends
*---- end of process: blk_0t_1_1tmp<> -----
*
*---- act defproc: syn::expr::blk_0t_1_1<> -----
* raw ports:  in_0[0] out[0]
*
.subckt _0_0syn_0_0expr_0_0blk_0t_1_1 in__0_50_6 out_50_6
*.PININFO in__0_50_6:I out_50_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
x__passthru__ in__0_50_6 out_50_6 _0_0syn_0_0expr_0_0blk_0t_1_1tmp
.ends
*---- end of process: blk_0t_1_1<> -----
*
*---- act defproc: syn::ring::var_access<6> -----
* raw ports: 
*
* empty subckt
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
* end empty subckt
*---- end of process: var_access<6> -----
*
*---- act defproc: syn::ring::connect_inchan_to_ctrl<8> -----
* raw ports: 
*
* empty subckt
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
* end empty subckt
*---- end of process: connect_inchan_to_ctrl<8> -----
*
*---- act defproc: syn::ring::capture<6,6,1> -----
* raw ports:  go.d.d[0] go.a din[0] dout[0]
*
.subckt _0_0syn_0_0ring_0_0capture_36_76_71_4 go_ad_ad_50_6 go_aa din_50_6 dout_50_6
*.PININFO go_ad_ad_50_6:I go_aa:O din_50_6:I dout_50_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xx2_50_6 ff__ctrl_aclk2 dmid_50_6 dout_50_6 _0_0std_0_0cells_0_0LATCH
xx1_50_6 ff__ctrl_aclk1 din_50_6 dmid_50_6 _0_0std_0_0cells_0_0LATCH
xff__ctrl go_ad_ad_50_6 go_aa ff__ctrl_aclk1 ff__ctrl_aclk2 _0_0syn_0_0ring_0_0ff__control_36_4
.ends
*---- end of process: capture<6,6,1> -----
*
*---- act defproc: syn::expr::blk_0i8I1_8_9tmp<> -----
* raw ports:  in__0_50_6 in__0_51_6 in__0_52_6 in__0_53_6 in__0_54_6 in__0_55_6 in__0_56_6 in__0_57_6 out_50_6 out_51_6 out_52_6 out_53_6 out_54_6 out_55_6 out_56_6 out_57_6 out_58_6
*
.subckt _0_0syn_0_0expr_0_0blk_0i8I1_8_9tmp in____0__50__6 in____0__51__6 in____0__52__6 in____0__53__6 in____0__54__6 in____0__55__6 in____0__56__6 in____0__57__6 out__50__6 out__51__6 out__52__6 out__53__6 out__54__6 out__55__6 out__56__6 out__57__6 out__58__6
*.PININFO in____0__50__6:I in____0__51__6:I in____0__52__6:I in____0__53__6:I in____0__54__6:I in____0__55__6:I in____0__56__6:I in____0__57__6:I out__50__6:O out__51__6:O out__52__6:O out__53__6:O out__54__6:O out__55__6:O out__56__6:O out__57__6:O out__58__6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xg1 in____0__51__6 out__51__6 _0_0std_0_0cells_0_0BUFX2
xg5 in____0__55__6 out__55__6 _0_0std_0_0cells_0_0BUFX2
xg3 in____0__53__6 out__53__6 _0_0std_0_0cells_0_0BUFX2
xg0 in____0__50__6 out__50__6 _0_0std_0_0cells_0_0BUFX2
x__nref__0 out__58__6 _0_0std_0_0cells_0_0TIELOX1
xg4 in____0__54__6 out__54__6 _0_0std_0_0cells_0_0BUFX2
xg6 in____0__56__6 out__56__6 _0_0std_0_0cells_0_0BUFX2
xg2 in____0__52__6 out__52__6 _0_0std_0_0cells_0_0BUFX2
xg7 in____0__57__6 out__57__6 _0_0std_0_0cells_0_0BUFX2
.ends
*---- end of process: blk_0i8I1_8_9tmp<> -----
*
*---- act defproc: syn::expr::blk_0i8I1_8_9<> -----
* raw ports:  in_0[0] in_0[1] in_0[2] in_0[3] in_0[4] in_0[5] in_0[6] in_0[7] out[0] out[1] out[2] out[3] out[4] out[5] out[6] out[7] out[8]
*
.subckt _0_0syn_0_0expr_0_0blk_0i8I1_8_9 in__0_50_6 in__0_51_6 in__0_52_6 in__0_53_6 in__0_54_6 in__0_55_6 in__0_56_6 in__0_57_6 out_50_6 out_51_6 out_52_6 out_53_6 out_54_6 out_55_6 out_56_6 out_57_6 out_58_6
*.PININFO in__0_50_6:I in__0_51_6:I in__0_52_6:I in__0_53_6:I in__0_54_6:I in__0_55_6:I in__0_56_6:I in__0_57_6:I out_50_6:O out_51_6:O out_52_6:O out_53_6:O out_54_6:O out_55_6:O out_56_6:O out_57_6:O out_58_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
x__passthru__ in__0_50_6 in__0_51_6 in__0_52_6 in__0_53_6 in__0_54_6 in__0_55_6 in__0_56_6 in__0_57_6 out_50_6 out_51_6 out_52_6 out_53_6 out_54_6 out_55_6 out_56_6 out_57_6 out_58_6 _0_0syn_0_0expr_0_0blk_0i8I1_8_9tmp
.ends
*---- end of process: blk_0i8I1_8_9<> -----
*
*---- act defproc: std::gates::sigbuf<8> -----
* raw ports:  in out[0]
*
.subckt _0_0std_0_0gates_0_0sigbuf_38_4 in out_50_6
*.PININFO in:I out_50_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xcx0 in __out _0_0cell_0_0ginvx1
xcx1 __out out_50_6 _0_0cell_0_0ginvx2
.ends
*---- end of process: sigbuf<8> -----
*
*---- act defproc: syn::ring::capture<6,6,8> -----
* raw ports:  go.d.d[0] go.a din[0] din[1] din[2] din[3] din[4] din[5] din[6] din[7] dout[0] dout[1] dout[2] dout[3] dout[4] dout[5] dout[6] dout[7]
*
.subckt _0_0syn_0_0ring_0_0capture_36_76_78_4 go_ad_ad_50_6 go_aa din_50_6 din_51_6 din_52_6 din_53_6 din_54_6 din_55_6 din_56_6 din_57_6 dout_50_6 dout_51_6 dout_52_6 dout_53_6 dout_54_6 dout_55_6 dout_56_6 dout_57_6
*.PININFO go_ad_ad_50_6:I go_aa:O din_50_6:I din_51_6:I din_52_6:I din_53_6:I din_54_6:I din_55_6:I din_56_6:I din_57_6:I dout_50_6:O dout_51_6:O dout_52_6:O dout_53_6:O dout_54_6:O dout_55_6:O dout_56_6:O dout_57_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xfanout__tree__2 ff__ctrl_aclk2 x2_57_6_aCLK _0_0std_0_0gates_0_0sigbuf_38_4
xx2_50_6 x2_57_6_aCLK dmid_50_6 dout_50_6 _0_0std_0_0cells_0_0LATCH
xx2_51_6 x2_57_6_aCLK dmid_51_6 dout_51_6 _0_0std_0_0cells_0_0LATCH
xx2_52_6 x2_57_6_aCLK dmid_52_6 dout_52_6 _0_0std_0_0cells_0_0LATCH
xx2_53_6 x2_57_6_aCLK dmid_53_6 dout_53_6 _0_0std_0_0cells_0_0LATCH
xx2_54_6 x2_57_6_aCLK dmid_54_6 dout_54_6 _0_0std_0_0cells_0_0LATCH
xx2_55_6 x2_57_6_aCLK dmid_55_6 dout_55_6 _0_0std_0_0cells_0_0LATCH
xx2_56_6 x2_57_6_aCLK dmid_56_6 dout_56_6 _0_0std_0_0cells_0_0LATCH
xx2_57_6 x2_57_6_aCLK dmid_57_6 dout_57_6 _0_0std_0_0cells_0_0LATCH
xx1_50_6 x1_57_6_aCLK din_50_6 dmid_50_6 _0_0std_0_0cells_0_0LATCH
xx1_51_6 x1_57_6_aCLK din_51_6 dmid_51_6 _0_0std_0_0cells_0_0LATCH
xx1_52_6 x1_57_6_aCLK din_52_6 dmid_52_6 _0_0std_0_0cells_0_0LATCH
xx1_53_6 x1_57_6_aCLK din_53_6 dmid_53_6 _0_0std_0_0cells_0_0LATCH
xx1_54_6 x1_57_6_aCLK din_54_6 dmid_54_6 _0_0std_0_0cells_0_0LATCH
xx1_55_6 x1_57_6_aCLK din_55_6 dmid_55_6 _0_0std_0_0cells_0_0LATCH
xx1_56_6 x1_57_6_aCLK din_56_6 dmid_56_6 _0_0std_0_0cells_0_0LATCH
xx1_57_6 x1_57_6_aCLK din_57_6 dmid_57_6 _0_0std_0_0cells_0_0LATCH
xfanout__tree__1 ff__ctrl_aclk1 x1_57_6_aCLK _0_0std_0_0gates_0_0sigbuf_38_4
xff__ctrl go_ad_ad_50_6 go_aa ff__ctrl_aclk1 ff__ctrl_aclk2 _0_0syn_0_0ring_0_0ff__control_36_4
.ends
*---- end of process: capture<6,6,8> -----
*
*---- act defproc: std::gates::ortree<1,f> -----
* raw ports: 
*
* empty subckt
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
* end empty subckt
*---- end of process: ortree<1,f> -----
*
*---- act defproc: cell::g0n1n2n3naaa_0123aaox1<> -----
* raw ports:  in[0] in[1] in[2] in[3] out
*
.subckt _0_0cell_0_0g0n1n2n3naaa_0123aaox1 in_50_6 in_51_6 in_52_6 in_53_6 out
*.PININFO in_50_6:I in_51_6:I in_52_6:I in_53_6:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* out (state-holding): pup_reff=0.8; pdn_reff=1
*
* --- end node flags ---
*
xM0_ Vdd in_50_6 #11 Vdd sky130_fd_pr__pfet_01v8  W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM1_ Vdd out #fb12# Vdd sky130_fd_pr__pfet_01v8  W=0.75 L=0.3 nrs=1 nrd=1 nf=1
xM2_keeper Vdd GND #13 Vdd sky130_fd_pr__pfet_01v8  W=0.45 L=2.85 nrs=1 nrd=1 nf=1
xM3_ GND in_50_6 out GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM4_ GND in_51_6 #5 GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM5_ GND out #fb12# GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.3 nrs=1 nrd=1 nf=1
xM6_keeper GND Vdd #14 GND sky130_fd_pr__nfet_01v8 W=0.45 L=5.325 nrs=1 nrd=1 nf=1
xM7_ #4 in_53_6 out GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM8_ #9 in_53_6 out Vdd sky130_fd_pr__pfet_01v8  W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM9_keeper #13 #fb12# out Vdd sky130_fd_pr__pfet_01v8  W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM10_keeper #14 #fb12# out GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM11_ #5 in_52_6 #4 GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM12_ #10 in_52_6 #9 Vdd sky130_fd_pr__pfet_01v8  W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM13_ #11 in_51_6 #10 Vdd sky130_fd_pr__pfet_01v8  W=0.75 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: g0n1n2n3naaa_0123aaox1<> -----
*
*---- act defproc: syn::ring::elem_c_paa_send<> -----
* raw ports:  m1.d.d[0] m1.a zero.d.d[0] zero.a p1.a
*
.subckt _0_0syn_0_0ring_0_0elem_c_paa_send m1_ad_ad_50_6 m1_aa zero_ad_ad_50_6 zero_aa p1_aa
*.PININFO m1_ad_ad_50_6:I m1_aa:O zero_ad_ad_50_6:O zero_aa:I p1_aa:I
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xcx0 Reset ac_aA izeroa_aout p1_aa m1_aa _0_0cell_0_0g0n1n2n3naaa_0123aaox1
xim1r m1_ad_ad_50_6 ac_aA _0_0syn_0_0ring_0_0inverter
xac ac_aA zero_aa m1_aa zero_ad_ad_50_6 _0_0syn_0_0ring_0_0asym_c_brs
xizeroa zero_aa izeroa_aout _0_0syn_0_0ring_0_0inverter
.ends
*---- end of process: elem_c_paa_send<> -----
*
*---- act defproc: syn::ring::delay_line_merge<4,2> -----
* raw ports:  m1.d.d[0] p1.d.d[0]
*
.subckt _0_0syn_0_0ring_0_0delay__line__merge_34_72_4 m1_ad_ad_50_6 p1_ad_ad_50_6
*.PININFO m1_ad_ad_50_6:I p1_ad_ad_50_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xd m1_ad_ad_50_6 p1_ad_ad_50_6 _0_0syn_0_0ring_0_0delay__line_34_4
.ends
*---- end of process: delay_line_merge<4,2> -----
*
*---- act defproc: syn::ring::var_access<1> -----
* raw ports: 
*
* empty subckt
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
* end empty subckt
*---- end of process: var_access<1> -----
*
*---- act defproc: std::cells::XOR2X1<> -----
* raw ports:  A B Y
*
.subckt _0_0std_0_0cells_0_0XOR2X1 A B Y
*.PININFO A:I B:I Y:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* __A (combinational)
* __B (combinational)
* Y (combinational)
*
* --- end node flags ---
*
xM0_ Vdd A __A Vdd sky130_fd_pr__pfet_01v8  W=0.6 L=0.15 nrs=1 nrd=1 nf=1
xM1_ Vdd B __B Vdd sky130_fd_pr__pfet_01v8  W=0.6 L=0.15 nrs=1 nrd=1 nf=1
xM2_ Vdd B #7 Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM3_ Vdd __B #8 Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM4_ GND A __A GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM5_ GND B __B GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM6_ GND __B #9 GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM7_ GND B #10 GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM8_ #7 __A Y Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM9_ #8 A Y Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM10_ #9 __A Y GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM11_ #10 A Y GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: XOR2X1<> -----
*
*---- act defproc: std::cells::XNOR2X1<> -----
* raw ports:  A B Y
*
.subckt _0_0std_0_0cells_0_0XNOR2X1 A B Y
*.PININFO A:I B:I Y:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* __A (combinational)
* __B (combinational)
* Y (combinational)
*
* --- end node flags ---
*
xM0_ Vdd A __A Vdd sky130_fd_pr__pfet_01v8  W=0.6 L=0.15 nrs=1 nrd=1 nf=1
xM1_ Vdd B __B Vdd sky130_fd_pr__pfet_01v8  W=0.6 L=0.15 nrs=1 nrd=1 nf=1
xM2_ Vdd B #7 Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM3_ Vdd __B #8 Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM4_ GND A __A GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM5_ GND B __B GND sky130_fd_pr__nfet_01v8 W=0.45 L=0.15 nrs=1 nrd=1 nf=1
xM6_ GND B #9 GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM7_ GND __B #10 GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM8_ #7 A Y Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM9_ #8 __A Y Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM10_ #9 __A Y GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM11_ #10 A Y GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: XNOR2X1<> -----
*
*---- act defproc: std::cells::NAND3X1<> -----
* raw ports:  A B C Y
*
.subckt _0_0std_0_0cells_0_0NAND3X1 A B C Y
*.PININFO A:I B:I C:I Y:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* Y (combinational)
*
* --- end node flags ---
*
xM0_ Vdd A Y Vdd sky130_fd_pr__pfet_01v8  W=0.6 L=0.15 nrs=1 nrd=1 nf=1
xM1_ Vdd B Y Vdd sky130_fd_pr__pfet_01v8  W=0.6 L=0.15 nrs=1 nrd=1 nf=1
xM2_ Vdd C Y Vdd sky130_fd_pr__pfet_01v8  W=0.6 L=0.15 nrs=1 nrd=1 nf=1
xM3_ GND A #4 GND sky130_fd_pr__nfet_01v8 W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM4_ #3 C Y GND sky130_fd_pr__nfet_01v8 W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM5_ #4 B #3 GND sky130_fd_pr__nfet_01v8 W=1.125 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: NAND3X1<> -----
*
*---- act defproc: std::cells::INVX4<> -----
* raw ports:  A Y
*
.subckt _0_0std_0_0cells_0_0INVX4 A Y
*.PININFO A:I Y:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
*
* --- node flags ---
*
* Y (combinational)
*
* --- end node flags ---
*
xM0_0_ Vdd A Y Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM0_1_ Vdd A Y Vdd sky130_fd_pr__pfet_01v8  W=1.125 L=0.15 nrs=1 nrd=1 nf=1
xM1_0_ GND A Y GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
xM1_1_ GND A Y GND sky130_fd_pr__nfet_01v8 W=0.75 L=0.15 nrs=1 nrd=1 nf=1
.ends
*---- end of process: INVX4<> -----
*
*---- act defproc: syn::expr::blk_01pi6I1_6_1_6tmp<> -----
* raw ports:  in__1_50_6 in__0_50_6 in__0_51_6 in__0_52_6 in__0_53_6 in__0_54_6 in__0_55_6 out_50_6 out_51_6 out_52_6 out_53_6 out_54_6 out_55_6
*
.subckt _0_0syn_0_0expr_0_0blk_01pi6I1_6_1_6tmp in____1__50__6 in____0__50__6 in____0__51__6 in____0__52__6 in____0__53__6 in____0__54__6 in____0__55__6 out__50__6 out__51__6 out__52__6 out__53__6 out__54__6 out__55__6
*.PININFO in____1__50__6:I in____0__50__6:I in____0__51__6:I in____0__52__6:I in____0__53__6:I in____0__54__6:I in____0__55__6:I out__50__6:O out__51__6:O out__52__6:O out__53__6:O out__54__6:O out__55__6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xg01 in____1__50__6 in____0__50__6 new__n15 _0_0std_0_0cells_0_0NAND2X1
xg02 in____1__50__6 in____0__50__6 out__50__6 _0_0std_0_0cells_0_0XOR2X1
xg05 new__n14 new__n17 new__n19 _0_0std_0_0cells_0_0NOR2X1
xg10 in____0__54__6 new__n21 out__54__6 _0_0std_0_0cells_0_0XNOR2X1
xg09 in____0__53__6 in____0__54__6 new__n19 new__n23 _0_0std_0_0cells_0_0NAND3X1
xg06 in____0__52__6 new__n17 out__52__6 _0_0std_0_0cells_0_0XNOR2X1
xg07 in____0__53__6 new__n19 new__n21 _0_0std_0_0cells_0_0NAND2X1
xg03 in____1__50__6 in____0__50__6 in____0__51__6 new__n17 _0_0std_0_0cells_0_0NAND3X1
xg11 in____0__55__6 new__n23 out__55__6 _0_0std_0_0cells_0_0XNOR2X1
xg04 in____0__51__6 new__n15 out__51__6 _0_0std_0_0cells_0_0XNOR2X1
xg08 in____0__53__6 new__n19 out__53__6 _0_0std_0_0cells_0_0XOR2X1
xg00 in____0__52__6 new__n14 _0_0std_0_0cells_0_0INVX4
.ends
*---- end of process: blk_01pi6I1_6_1_6tmp<> -----
*
*---- act defproc: syn::expr::blk_01pi6I1_6_1_6<> -----
* raw ports:  in_1[0] in_0[0] in_0[1] in_0[2] in_0[3] in_0[4] in_0[5] out[0] out[1] out[2] out[3] out[4] out[5]
*
.subckt _0_0syn_0_0expr_0_0blk_01pi6I1_6_1_6 in__1_50_6 in__0_50_6 in__0_51_6 in__0_52_6 in__0_53_6 in__0_54_6 in__0_55_6 out_50_6 out_51_6 out_52_6 out_53_6 out_54_6 out_55_6
*.PININFO in__1_50_6:I in__0_50_6:I in__0_51_6:I in__0_52_6:I in__0_53_6:I in__0_54_6:I in__0_55_6:I out_50_6:O out_51_6:O out_52_6:O out_53_6:O out_54_6:O out_55_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
x__passthru__ in__1_50_6 in__0_50_6 in__0_51_6 in__0_52_6 in__0_53_6 in__0_54_6 in__0_55_6 out_50_6 out_51_6 out_52_6 out_53_6 out_54_6 out_55_6 _0_0syn_0_0expr_0_0blk_01pi6I1_6_1_6tmp
.ends
*---- end of process: blk_01pi6I1_6_1_6<> -----
*
*---- act defproc: syn::ring::delay_line_0<2> -----
* raw ports:  in out
*
.subckt _0_0syn_0_0ring_0_0delay__line__0_32_4 in out
*.PININFO in:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xinvs_50_6 in invs_50_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_51_6 invs_50_6_aY invs_51_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_52_6 invs_51_6_aY invs_52_6_aY _0_0std_0_0cells_0_0INVX1
xinvs_53_6 invs_52_6_aY out _0_0std_0_0cells_0_0INVX1
.ends
*---- end of process: delay_line_0<2> -----
*
*---- act defproc: syn::ring::delay_selector<0,2> -----
* raw ports:  in out
*
.subckt _0_0syn_0_0ring_0_0delay__selector_30_72_4 in out
*.PININFO in:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xd0 in out _0_0syn_0_0ring_0_0delay__line__0_32_4
.ends
*---- end of process: delay_selector<0,2> -----
*
*---- act defproc: syn::ring::delay_line<2> -----
* raw ports:  in out
*
.subckt _0_0syn_0_0ring_0_0delay__line_32_4 in out
*.PININFO in:I out:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xdl in out _0_0syn_0_0ring_0_0delay__selector_30_72_4
.ends
*---- end of process: delay_line<2> -----
*
*---- act defproc: syn::ring::delay_line_chan<2> -----
* raw ports:  m1.d.d[0] p1.d.d[0]
*
.subckt _0_0syn_0_0ring_0_0delay__line__chan_32_4 m1_ad_ad_50_6 p1_ad_ad_50_6
*.PININFO m1_ad_ad_50_6:I p1_ad_ad_50_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xd m1_ad_ad_50_6 p1_ad_ad_50_6 _0_0syn_0_0ring_0_0delay__line_32_4
.ends
*---- end of process: delay_line_chan<2> -----
*
*---- act defproc: syn::ring::connect_exprblk_assign<9> -----
* raw ports: 
*
* empty subckt
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
* end empty subckt
*---- end of process: connect_exprblk_assign<9> -----
*
*---- act defproc: syn::expr::blk_0i2e_2_1tmp<> -----
* raw ports:  in__0_50_6 in__0_51_6 out_50_6
*
.subckt _0_0syn_0_0expr_0_0blk_0i2e_2_1tmp in____0__50__6 in____0__51__6 out__50__6
*.PININFO in____0__50__6:I in____0__51__6:I out__50__6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xg1 in____0__50__6 new__n4 out__50__6 _0_0std_0_0cells_0_0NOR2X1
xg0 in____0__51__6 new__n4 _0_0std_0_0cells_0_0INVX8
.ends
*---- end of process: blk_0i2e_2_1tmp<> -----
*
*---- act defproc: syn::expr::blk_0i2e_2_1<> -----
* raw ports:  in_0[0] in_0[1] out[0]
*
.subckt _0_0syn_0_0expr_0_0blk_0i2e_2_1 in__0_50_6 in__0_51_6 out_50_6
*.PININFO in__0_50_6:I in__0_51_6:I out_50_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
x__passthru__ in__0_50_6 in__0_51_6 out_50_6 _0_0syn_0_0expr_0_0blk_0i2e_2_1tmp
.ends
*---- end of process: blk_0i2e_2_1<> -----
*
*---- act defproc: syn::expr::blk_0i1eI0w5i2eI0oBn_2_1tmp<> -----
* raw ports:  in__0_50_6 in__0_51_6 out_50_6
*
.subckt _0_0syn_0_0expr_0_0blk_0i1eI0w5i2eI0oBn_2_1tmp in____0__50__6 in____0__51__6 out__50__6
*.PININFO in____0__50__6:I in____0__51__6:I out__50__6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xg0 in____0__50__6 in____0__51__6 out__50__6 _0_0std_0_0cells_0_0XNOR2X1
.ends
*---- end of process: blk_0i1eI0w5i2eI0oBn_2_1tmp<> -----
*
*---- act defproc: syn::expr::blk_0i1eI0w5i2eI0oBn_2_1<> -----
* raw ports:  in_0[0] in_0[1] out[0]
*
.subckt _0_0syn_0_0expr_0_0blk_0i1eI0w5i2eI0oBn_2_1 in__0_50_6 in__0_51_6 out_50_6
*.PININFO in__0_50_6:I in__0_51_6:I out_50_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
x__passthru__ in__0_50_6 in__0_51_6 out_50_6 _0_0syn_0_0expr_0_0blk_0i1eI0w5i2eI0oBn_2_1tmp
.ends
*---- end of process: blk_0i1eI0w5i2eI0oBn_2_1<> -----
*
*---- act defproc: syn::ring::capture_init<6,6,6,0> -----
* raw ports:  go.d.d[0] go.a din[0] din[1] din[2] din[3] din[4] din[5] dout[0] dout[1] dout[2] dout[3] dout[4] dout[5]
*
.subckt _0_0syn_0_0ring_0_0capture__init_36_76_76_70_4 go_ad_ad_50_6 go_aa din_50_6 din_51_6 din_52_6 din_53_6 din_54_6 din_55_6 dout_50_6 dout_51_6 dout_52_6 dout_53_6 dout_54_6 dout_55_6
*.PININFO go_ad_ad_50_6:I go_aa:O din_50_6:I din_51_6:I din_52_6:I din_53_6:I din_54_6:I din_55_6:I dout_50_6:O dout_51_6:O dout_52_6:O dout_53_6:O dout_54_6:O dout_55_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xx__lo__1_50_6 Reset x__lo__1_55_6_aCLK din_50_6 dmid_50_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__1_51_6 Reset x__lo__1_55_6_aCLK din_51_6 dmid_51_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__1_52_6 Reset x__lo__1_55_6_aCLK din_52_6 dmid_52_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__1_53_6 Reset x__lo__1_55_6_aCLK din_53_6 dmid_53_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__1_54_6 Reset x__lo__1_55_6_aCLK din_54_6 dmid_54_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__1_55_6 Reset x__lo__1_55_6_aCLK din_55_6 dmid_55_6 _0_0std_0_0cells_0_0LATCHLO
xfanout__tree__2 ff__ctrl_aclk2 x__lo__2_55_6_aCLK _0_0std_0_0gates_0_0sigbuf_36_4
xx__lo__2_50_6 Reset x__lo__2_55_6_aCLK dmid_50_6 dout_50_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__2_51_6 Reset x__lo__2_55_6_aCLK dmid_51_6 dout_51_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__2_52_6 Reset x__lo__2_55_6_aCLK dmid_52_6 dout_52_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__2_53_6 Reset x__lo__2_55_6_aCLK dmid_53_6 dout_53_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__2_54_6 Reset x__lo__2_55_6_aCLK dmid_54_6 dout_54_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__2_55_6 Reset x__lo__2_55_6_aCLK dmid_55_6 dout_55_6 _0_0std_0_0cells_0_0LATCHLO
xfanout__tree__1 ff__ctrl_aclk1 x__lo__1_55_6_aCLK _0_0std_0_0gates_0_0sigbuf_36_4
xff__ctrl go_ad_ad_50_6 go_aa ff__ctrl_aclk1 ff__ctrl_aclk2 _0_0syn_0_0ring_0_0ff__control_36_4
.ends
*---- end of process: capture_init<6,6,6,0> -----
*
*---- act defproc: syn::expr::blk_i2_2tmp<> -----
* raw ports:  out_50_6 out_51_6
*
.subckt _0_0syn_0_0expr_0_0blk_i2_2tmp out__50__6 out__51__6
*.PININFO out__50__6:O out__51__6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
x__nref__0 out__50__6 _0_0std_0_0cells_0_0TIELOX1
x__nref__2 out__51__6 _0_0std_0_0cells_0_0TIEHIX1
.ends
*---- end of process: blk_i2_2tmp<> -----
*
*---- act defproc: syn::expr::blk_i2_2<> -----
* raw ports:  out[0] out[1]
*
.subckt _0_0syn_0_0expr_0_0blk_i2_2 out_50_6 out_51_6
*.PININFO out_50_6:O out_51_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
x__passthru__ out_50_6 out_51_6 _0_0syn_0_0expr_0_0blk_i2_2tmp
.ends
*---- end of process: blk_i2_2<> -----
*
*---- act defproc: syn::expr::blk_0_9_9tmp<> -----
* raw ports:  in__0_50_6 in__0_51_6 in__0_52_6 in__0_53_6 in__0_54_6 in__0_55_6 in__0_56_6 in__0_57_6 in__0_58_6 out_50_6 out_51_6 out_52_6 out_53_6 out_54_6 out_55_6 out_56_6 out_57_6 out_58_6
*
.subckt _0_0syn_0_0expr_0_0blk_0_9_9tmp in____0__50__6 in____0__51__6 in____0__52__6 in____0__53__6 in____0__54__6 in____0__55__6 in____0__56__6 in____0__57__6 in____0__58__6 out__50__6 out__51__6 out__52__6 out__53__6 out__54__6 out__55__6 out__56__6 out__57__6 out__58__6
*.PININFO in____0__50__6:I in____0__51__6:I in____0__52__6:I in____0__53__6:I in____0__54__6:I in____0__55__6:I in____0__56__6:I in____0__57__6:I in____0__58__6:I out__50__6:O out__51__6:O out__52__6:O out__53__6:O out__54__6:O out__55__6:O out__56__6:O out__57__6:O out__58__6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xg1 in____0__51__6 out__51__6 _0_0std_0_0cells_0_0BUFX2
xg5 in____0__55__6 out__55__6 _0_0std_0_0cells_0_0BUFX2
xg3 in____0__53__6 out__53__6 _0_0std_0_0cells_0_0BUFX2
xg0 in____0__50__6 out__50__6 _0_0std_0_0cells_0_0BUFX2
xg4 in____0__54__6 out__54__6 _0_0std_0_0cells_0_0BUFX2
xg6 in____0__56__6 out__56__6 _0_0std_0_0cells_0_0BUFX2
xg2 in____0__52__6 out__52__6 _0_0std_0_0cells_0_0BUFX2
xg7 in____0__57__6 out__57__6 _0_0std_0_0cells_0_0BUFX2
xg8 in____0__58__6 out__58__6 _0_0std_0_0cells_0_0BUFX2
.ends
*---- end of process: blk_0_9_9tmp<> -----
*
*---- act defproc: syn::expr::blk_0_9_9<> -----
* raw ports:  in_0[0] in_0[1] in_0[2] in_0[3] in_0[4] in_0[5] in_0[6] in_0[7] in_0[8] out[0] out[1] out[2] out[3] out[4] out[5] out[6] out[7] out[8]
*
.subckt _0_0syn_0_0expr_0_0blk_0_9_9 in__0_50_6 in__0_51_6 in__0_52_6 in__0_53_6 in__0_54_6 in__0_55_6 in__0_56_6 in__0_57_6 in__0_58_6 out_50_6 out_51_6 out_52_6 out_53_6 out_54_6 out_55_6 out_56_6 out_57_6 out_58_6
*.PININFO in__0_50_6:I in__0_51_6:I in__0_52_6:I in__0_53_6:I in__0_54_6:I in__0_55_6:I in__0_56_6:I in__0_57_6:I in__0_58_6:I out_50_6:O out_51_6:O out_52_6:O out_53_6:O out_54_6:O out_55_6:O out_56_6:O out_57_6:O out_58_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
x__passthru__ in__0_50_6 in__0_51_6 in__0_52_6 in__0_53_6 in__0_54_6 in__0_55_6 in__0_56_6 in__0_57_6 in__0_58_6 out_50_6 out_51_6 out_52_6 out_53_6 out_54_6 out_55_6 out_56_6 out_57_6 out_58_6 _0_0syn_0_0expr_0_0blk_0_9_9tmp
.ends
*---- end of process: blk_0_9_9<> -----
*
*---- act defproc: syn::ring::var_access<8> -----
* raw ports: 
*
* empty subckt
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
* end empty subckt
*---- end of process: var_access<8> -----
*
*---- act defproc: syn::expr::blk_0i1e_1_1tmp<> -----
* raw ports:  in__0_50_6 out_50_6
*
.subckt _0_0syn_0_0expr_0_0blk_0i1e_1_1tmp in____0__50__6 out__50__6
*.PININFO in____0__50__6:I out__50__6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xg0 in____0__50__6 out__50__6 _0_0std_0_0cells_0_0BUFX2
.ends
*---- end of process: blk_0i1e_1_1tmp<> -----
*
*---- act defproc: syn::expr::blk_0i1e_1_1<> -----
* raw ports:  in_0[0] out[0]
*
.subckt _0_0syn_0_0expr_0_0blk_0i1e_1_1 in__0_50_6 out_50_6
*.PININFO in__0_50_6:I out_50_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
x__passthru__ in__0_50_6 out_50_6 _0_0syn_0_0expr_0_0blk_0i1e_1_1tmp
.ends
*---- end of process: blk_0i1e_1_1<> -----
*
*---- act defproc: syn::expr::blk_0i1eI0tB_1_1tmp<> -----
* raw ports:  in__0_50_6 out_50_6
*
.subckt _0_0syn_0_0expr_0_0blk_0i1eI0tB_1_1tmp in____0__50__6 out__50__6
*.PININFO in____0__50__6:I out__50__6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xg0 in____0__50__6 out__50__6 _0_0std_0_0cells_0_0INVX8
.ends
*---- end of process: blk_0i1eI0tB_1_1tmp<> -----
*
*---- act defproc: syn::expr::blk_0i1eI0tB_1_1<> -----
* raw ports:  in_0[0] out[0]
*
.subckt _0_0syn_0_0expr_0_0blk_0i1eI0tB_1_1 in__0_50_6 out_50_6
*.PININFO in__0_50_6:I out_50_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
x__passthru__ in__0_50_6 out_50_6 _0_0syn_0_0expr_0_0blk_0i1eI0tB_1_1tmp
.ends
*---- end of process: blk_0i1eI0tB_1_1<> -----
*
*---- act defproc: syn::ring::capture_init<6,6,2,0> -----
* raw ports:  go.d.d[0] go.a din[0] din[1] dout[0] dout[1]
*
.subckt _0_0syn_0_0ring_0_0capture__init_36_76_72_70_4 go_ad_ad_50_6 go_aa din_50_6 din_51_6 dout_50_6 dout_51_6
*.PININFO go_ad_ad_50_6:I go_aa:O din_50_6:I din_51_6:I dout_50_6:O dout_51_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xx__lo__1_50_6 Reset x__lo__1_51_6_aCLK din_50_6 dmid_50_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__1_51_6 Reset x__lo__1_51_6_aCLK din_51_6 dmid_51_6 _0_0std_0_0cells_0_0LATCHLO
xfanout__tree__2 ff__ctrl_aclk2 x__lo__2_51_6_aCLK _0_0std_0_0gates_0_0sigbuf_32_4
xx__lo__2_50_6 Reset x__lo__2_51_6_aCLK dmid_50_6 dout_50_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__2_51_6 Reset x__lo__2_51_6_aCLK dmid_51_6 dout_51_6 _0_0std_0_0cells_0_0LATCHLO
xfanout__tree__1 ff__ctrl_aclk1 x__lo__1_51_6_aCLK _0_0std_0_0gates_0_0sigbuf_32_4
xff__ctrl go_ad_ad_50_6 go_aa ff__ctrl_aclk1 ff__ctrl_aclk2 _0_0syn_0_0ring_0_0ff__control_36_4
.ends
*---- end of process: capture_init<6,6,2,0> -----
*
*---- act defproc: syn::expr::blk_0_2_2tmp<> -----
* raw ports:  in__0_50_6 in__0_51_6 out_50_6 out_51_6
*
.subckt _0_0syn_0_0expr_0_0blk_0_2_2tmp in____0__50__6 in____0__51__6 out__50__6 out__51__6
*.PININFO in____0__50__6:I in____0__51__6:I out__50__6:O out__51__6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xg1 in____0__51__6 out__51__6 _0_0std_0_0cells_0_0BUFX2
xg0 in____0__50__6 out__50__6 _0_0std_0_0cells_0_0BUFX2
.ends
*---- end of process: blk_0_2_2tmp<> -----
*
*---- act defproc: syn::expr::blk_0_2_2<> -----
* raw ports:  in_0[0] in_0[1] out[0] out[1]
*
.subckt _0_0syn_0_0expr_0_0blk_0_2_2 in__0_50_6 in__0_51_6 out_50_6 out_51_6
*.PININFO in__0_50_6:I in__0_51_6:I out_50_6:O out_51_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
x__passthru__ in__0_50_6 in__0_51_6 out_50_6 out_51_6 _0_0syn_0_0expr_0_0blk_0_2_2tmp
.ends
*---- end of process: blk_0_2_2<> -----
*
*---- act defproc: syn::expr::blk_0i1hw9hi0ew7i1I1w10eI0w10qBw8w14I1w14I1w10eI0w10qtB_8_1tmp<> -----
* raw ports:  in__0_50_6 in__0_51_6 in__0_52_6 in__0_53_6 in__0_54_6 in__0_55_6 in__0_56_6 in__0_57_6 out_50_6
*
.subckt _0_0syn_0_0expr_0_0blk_0i1hw9hi0ew7i1I1w10eI0w10qBw8w14I1w14I1w10eI0w10qtB_8_1tmp in____0__50__6 in____0__51__6 in____0__52__6 in____0__53__6 in____0__54__6 in____0__55__6 in____0__56__6 in____0__57__6 out__50__6
*.PININFO in____0__50__6:I in____0__51__6:I in____0__52__6:I in____0__53__6:I in____0__54__6:I in____0__55__6:I in____0__56__6:I in____0__57__6:I out__50__6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xg1 in____0__56__6 in____0__57__6 new__n11 _0_0std_0_0cells_0_0NOR2X1
xg5 new__n12 new__n13 new__n14 out__50__6 _0_0std_0_0cells_0_0NAND3X1
xg0 in____0__54__6 in____0__55__6 new__n10 _0_0std_0_0cells_0_0NOR2X1
xg3 in____0__50__6 in____0__51__6 new__n13 _0_0std_0_0cells_0_0NOR2X1
xg4 in____0__52__6 in____0__53__6 new__n14 _0_0std_0_0cells_0_0NOR2X1
xg2 new__n10 new__n11 new__n12 _0_0std_0_0cells_0_0AND2X1
.ends
*---- end of process: blk_0i1hw9hi0ew7i1I1w10eI0w10qBw8w14I1w14I1w10eI0w10qtB_8_1tmp<> -----
*
*---- act defproc: syn::expr::blk_0i1hw9hi0ew7i1I1w10eI0w10qBw8w14I1w14I1w10eI0w10qtB_8_1<> -----
* raw ports:  in_0[0] in_0[1] in_0[2] in_0[3] in_0[4] in_0[5] in_0[6] in_0[7] out[0]
*
.subckt _0_0syn_0_0expr_0_0blk_0i1hw9hi0ew7i1I1w10eI0w10qBw8w14I1w14I1w10eI0w10qtB_8_1 in__0_50_6 in__0_51_6 in__0_52_6 in__0_53_6 in__0_54_6 in__0_55_6 in__0_56_6 in__0_57_6 out_50_6
*.PININFO in__0_50_6:I in__0_51_6:I in__0_52_6:I in__0_53_6:I in__0_54_6:I in__0_55_6:I in__0_56_6:I in__0_57_6:I out_50_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
x__passthru__ in__0_50_6 in__0_51_6 in__0_52_6 in__0_53_6 in__0_54_6 in__0_55_6 in__0_56_6 in__0_57_6 out_50_6 _0_0syn_0_0expr_0_0blk_0i1hw9hi0ew7i1I1w10eI0w10qBw8w14I1w14I1w10eI0w10qtB_8_1tmp
.ends
*---- end of process: blk_0i1hw9hi0ew7i1I1w10eI0w10qBw8w14I1w14I1w10eI0w10qtB_8_1<> -----
*
*---- act defproc: syn::expr::blk_i1_2tmp<> -----
* raw ports:  out_50_6 out_51_6
*
.subckt _0_0syn_0_0expr_0_0blk_i1_2tmp out__50__6 out__51__6
*.PININFO out__50__6:O out__51__6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
x__nref__0 out__50__6 _0_0std_0_0cells_0_0TIEHIX1
x__nref__2 out__51__6 _0_0std_0_0cells_0_0TIELOX1
.ends
*---- end of process: blk_i1_2tmp<> -----
*
*---- act defproc: syn::expr::blk_i1_2<> -----
* raw ports:  out[0] out[1]
*
.subckt _0_0syn_0_0expr_0_0blk_i1_2 out_50_6 out_51_6
*.PININFO out_50_6:O out_51_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
x__passthru__ out_50_6 out_51_6 _0_0syn_0_0expr_0_0blk_i1_2tmp
.ends
*---- end of process: blk_i1_2<> -----
*
*---- act defproc: syn::ring::delay_line_chan<7> -----
* raw ports:  m1.d.d[0] p1.d.d[0]
*
.subckt _0_0syn_0_0ring_0_0delay__line__chan_37_4 m1_ad_ad_50_6 p1_ad_ad_50_6
*.PININFO m1_ad_ad_50_6:I p1_ad_ad_50_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xd m1_ad_ad_50_6 p1_ad_ad_50_6 _0_0syn_0_0ring_0_0delay__line_37_4
.ends
*---- end of process: delay_line_chan<7> -----
*
*---- act defproc: syn::expr::blk_0_1_1tmp<> -----
* raw ports:  in__0_50_6 out_50_6
*
.subckt _0_0syn_0_0expr_0_0blk_0_1_1tmp in____0__50__6 out__50__6
*.PININFO in____0__50__6:I out__50__6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xg0 in____0__50__6 out__50__6 _0_0std_0_0cells_0_0BUFX2
.ends
*---- end of process: blk_0_1_1tmp<> -----
*
*---- act defproc: syn::expr::blk_0_1_1<> -----
* raw ports:  in_0[0] out[0]
*
.subckt _0_0syn_0_0expr_0_0blk_0_1_1 in__0_50_6 out_50_6
*.PININFO in__0_50_6:I out_50_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
x__passthru__ in__0_50_6 out_50_6 _0_0syn_0_0expr_0_0blk_0_1_1tmp
.ends
*---- end of process: blk_0_1_1<> -----
*
*---- act defproc: syn::expr::blk_0i1eI0w4i2eI0oB_2_1tmp<> -----
* raw ports:  in__0_50_6 in__0_51_6 out_50_6
*
.subckt _0_0syn_0_0expr_0_0blk_0i1eI0w4i2eI0oB_2_1tmp in____0__50__6 in____0__51__6 out__50__6
*.PININFO in____0__50__6:I in____0__51__6:I out__50__6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xg0 in____0__50__6 in____0__51__6 out__50__6 _0_0std_0_0cells_0_0XOR2X1
.ends
*---- end of process: blk_0i1eI0w4i2eI0oB_2_1tmp<> -----
*
*---- act defproc: syn::expr::blk_0i1eI0w4i2eI0oB_2_1<> -----
* raw ports:  in_0[0] in_0[1] out[0]
*
.subckt _0_0syn_0_0expr_0_0blk_0i1eI0w4i2eI0oB_2_1 in__0_50_6 in__0_51_6 out_50_6
*.PININFO in__0_50_6:I in__0_51_6:I out_50_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
x__passthru__ in__0_50_6 in__0_51_6 out_50_6 _0_0syn_0_0expr_0_0blk_0i1eI0w4i2eI0oB_2_1tmp
.ends
*---- end of process: blk_0i1eI0w4i2eI0oB_2_1<> -----
*
*---- act defproc: syn::ring::capture_init<6,6,9,0> -----
* raw ports:  go.d.d[0] go.a din[0] din[1] din[2] din[3] din[4] din[5] din[6] din[7] din[8] dout[0] dout[1] dout[2] dout[3] dout[4] dout[5] dout[6] dout[7] dout[8]
*
.subckt _0_0syn_0_0ring_0_0capture__init_36_76_79_70_4 go_ad_ad_50_6 go_aa din_50_6 din_51_6 din_52_6 din_53_6 din_54_6 din_55_6 din_56_6 din_57_6 din_58_6 dout_50_6 dout_51_6 dout_52_6 dout_53_6 dout_54_6 dout_55_6 dout_56_6 dout_57_6 dout_58_6
*.PININFO go_ad_ad_50_6:I go_aa:O din_50_6:I din_51_6:I din_52_6:I din_53_6:I din_54_6:I din_55_6:I din_56_6:I din_57_6:I din_58_6:I dout_50_6:O dout_51_6:O dout_52_6:O dout_53_6:O dout_54_6:O dout_55_6:O dout_56_6:O dout_57_6:O dout_58_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xx__lo__1_50_6 Reset x__lo__1_58_6_aCLK din_50_6 dmid_50_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__1_51_6 Reset x__lo__1_58_6_aCLK din_51_6 dmid_51_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__1_52_6 Reset x__lo__1_58_6_aCLK din_52_6 dmid_52_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__1_53_6 Reset x__lo__1_58_6_aCLK din_53_6 dmid_53_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__1_54_6 Reset x__lo__1_58_6_aCLK din_54_6 dmid_54_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__1_55_6 Reset x__lo__1_58_6_aCLK din_55_6 dmid_55_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__1_56_6 Reset x__lo__1_58_6_aCLK din_56_6 dmid_56_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__1_57_6 Reset x__lo__1_58_6_aCLK din_57_6 dmid_57_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__1_58_6 Reset x__lo__1_58_6_aCLK din_58_6 dmid_58_6 _0_0std_0_0cells_0_0LATCHLO
xfanout__tree__2 ff__ctrl_aclk2 x__lo__2_58_6_aCLK _0_0std_0_0gates_0_0sigbuf_39_4
xx__lo__2_50_6 Reset x__lo__2_58_6_aCLK dmid_50_6 dout_50_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__2_51_6 Reset x__lo__2_58_6_aCLK dmid_51_6 dout_51_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__2_52_6 Reset x__lo__2_58_6_aCLK dmid_52_6 dout_52_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__2_53_6 Reset x__lo__2_58_6_aCLK dmid_53_6 dout_53_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__2_54_6 Reset x__lo__2_58_6_aCLK dmid_54_6 dout_54_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__2_55_6 Reset x__lo__2_58_6_aCLK dmid_55_6 dout_55_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__2_56_6 Reset x__lo__2_58_6_aCLK dmid_56_6 dout_56_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__2_57_6 Reset x__lo__2_58_6_aCLK dmid_57_6 dout_57_6 _0_0std_0_0cells_0_0LATCHLO
xx__lo__2_58_6 Reset x__lo__2_58_6_aCLK dmid_58_6 dout_58_6 _0_0std_0_0cells_0_0LATCHLO
xfanout__tree__1 ff__ctrl_aclk1 x__lo__1_58_6_aCLK _0_0std_0_0gates_0_0sigbuf_39_4
xff__ctrl go_ad_ad_50_6 go_aa ff__ctrl_aclk1 ff__ctrl_aclk2 _0_0syn_0_0ring_0_0ff__control_36_4
.ends
*---- end of process: capture_init<6,6,9,0> -----
*
*---- act defproc: syn::expr::blk_0_6_6tmp<> -----
* raw ports:  in__0_50_6 in__0_51_6 in__0_52_6 in__0_53_6 in__0_54_6 in__0_55_6 out_50_6 out_51_6 out_52_6 out_53_6 out_54_6 out_55_6
*
.subckt _0_0syn_0_0expr_0_0blk_0_6_6tmp in____0__50__6 in____0__51__6 in____0__52__6 in____0__53__6 in____0__54__6 in____0__55__6 out__50__6 out__51__6 out__52__6 out__53__6 out__54__6 out__55__6
*.PININFO in____0__50__6:I in____0__51__6:I in____0__52__6:I in____0__53__6:I in____0__54__6:I in____0__55__6:I out__50__6:O out__51__6:O out__52__6:O out__53__6:O out__54__6:O out__55__6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xg1 in____0__51__6 out__51__6 _0_0std_0_0cells_0_0BUFX2
xg5 in____0__55__6 out__55__6 _0_0std_0_0cells_0_0BUFX2
xg0 in____0__50__6 out__50__6 _0_0std_0_0cells_0_0BUFX2
xg3 in____0__53__6 out__53__6 _0_0std_0_0cells_0_0BUFX2
xg2 in____0__52__6 out__52__6 _0_0std_0_0cells_0_0BUFX2
xg4 in____0__54__6 out__54__6 _0_0std_0_0cells_0_0BUFX2
.ends
*---- end of process: blk_0_6_6tmp<> -----
*
*---- act defproc: syn::expr::blk_0_6_6<> -----
* raw ports:  in_0[0] in_0[1] in_0[2] in_0[3] in_0[4] in_0[5] out[0] out[1] out[2] out[3] out[4] out[5]
*
.subckt _0_0syn_0_0expr_0_0blk_0_6_6 in__0_50_6 in__0_51_6 in__0_52_6 in__0_53_6 in__0_54_6 in__0_55_6 out_50_6 out_51_6 out_52_6 out_53_6 out_54_6 out_55_6
*.PININFO in__0_50_6:I in__0_51_6:I in__0_52_6:I in__0_53_6:I in__0_54_6:I in__0_55_6:I out_50_6:O out_51_6:O out_52_6:O out_53_6:O out_54_6:O out_55_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
x__passthru__ in__0_50_6 in__0_51_6 in__0_52_6 in__0_53_6 in__0_54_6 in__0_55_6 out_50_6 out_51_6 out_52_6 out_53_6 out_54_6 out_55_6 _0_0syn_0_0expr_0_0blk_0_6_6tmp
.ends
*---- end of process: blk_0_6_6<> -----
*
*---- act defproc: syn::ring::merge_mux_ohc_opt<2,2> -----
* raw ports:  c[0] c[1] din[0][0] din[0][1] din[1][0] din[1][1] dout[0] dout[1]
*
.subckt _0_0syn_0_0ring_0_0merge__mux__ohc__opt_32_72_4 c_50_6 c_51_6 din_50_6_50_6 din_50_6_51_6 din_51_6_50_6 din_51_6_51_6 dout_50_6 dout_51_6
*.PININFO c_50_6:I c_51_6:I din_50_6_50_6:I din_50_6_51_6:I din_51_6_50_6:I din_51_6_51_6:I dout_50_6:O dout_51_6:O
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xstage__1_50_6_50_6 din_50_6_50_6 stage__1_50_6_51_6_aB din_51_6_50_6 stage__1_50_6_51_6_aD stage__1_50_6_50_6_aY _0_0std_0_0cells_0_0AOI22X1
xstage__1_50_6_51_6 din_50_6_51_6 stage__1_50_6_51_6_aB din_51_6_51_6 stage__1_50_6_51_6_aD stage__1_50_6_51_6_aY _0_0std_0_0cells_0_0AOI22X1
xfanout__tree_50_6 c_50_6 stage__1_50_6_51_6_aB _0_0std_0_0gates_0_0sigbuf_32_4
xfanout__tree_51_6 c_51_6 stage__1_50_6_51_6_aD _0_0std_0_0gates_0_0sigbuf_32_4
xstage__2_50_6 stage__1_50_6_50_6_aY dout_50_6 _0_0std_0_0gates_0_0andtree_31_7t_4
xstage__2_51_6 stage__1_50_6_51_6_aY dout_51_6 _0_0std_0_0gates_0_0andtree_31_7t_4
.ends
*---- end of process: merge_mux_ohc_opt<2,2> -----
*
*---- act defproc: ring_decomp_rowread<> -----
* raw ports:  L.d[0] L.d[1] L.d[2] L.d[3] L.d[4] L.d[5] L.d[6] L.d[7] L.r L.a R.d[0] R.d[1] R.d[2] R.d[3] R.d[4] R.d[5] R.d[6] R.d[7] R.d[8] R.r R.a
*
.subckt ring_decomp_rowread L_ad_50_6 L_ad_51_6 L_ad_52_6 L_ad_53_6 L_ad_54_6 L_ad_55_6 L_ad_56_6 L_ad_57_6 L_ar L_aa R_ad_50_6 R_ad_51_6 R_ad_52_6 R_ad_53_6 R_ad_54_6 R_ad_55_6 R_ad_56_6 R_ad_57_6 R_ad_58_6 R_ar R_aa
*.PININFO L_ad_50_6:I L_ad_51_6:I L_ad_52_6:I L_ad_53_6:I L_ad_54_6:I L_ad_55_6:I L_ad_56_6:I L_ad_57_6:I L_ar:I L_aa:O R_ad_50_6:O R_ad_51_6:O R_ad_52_6:O R_ad_53_6:O R_ad_54_6:O R_ad_55_6:O R_ad_56_6:O R_ad_57_6:O R_ad_58_6:O R_ar:O R_aa:I
*.POWER VDD Vdd
*.POWER GND GND
*.POWER NSUB GND
*.POWER PSUB Vdd
xinst__15 inst__15_ain__2_50_6 inst__15_ain__1_50_6 inst__15_ain__1_51_6 inst__15_ain__1_52_6 inst__15_ain__1_53_6 inst__15_ain__1_54_6 inst__15_ain__1_55_6 inst__13_ain__0_50_6 __ch__0__0_ad_50_6 __ch__0__0_ad_51_6 __ch__0__0_ad_52_6 __ch__0__0_ad_53_6 __ch__0__0_ad_54_6 __ch__0__0_ad_55_6 __ch__0__0_ad_56_6 __ch__0__0_ad_57_6 __ch__0__0_ad_58_6 _0_0syn_0_0expr_0_0blk_0ti012c_1_6_1_9
xblock__21 block__21_am1_ar block__21_am1_aa block__21_ap1_ad_ad_50_6 block__21_ap1_aa _0_0syn_0_0ring_0_0elem_c_itb
xdelay__expr__9 block__21_ap1_aa delay__expr__9_ap1_ad_ad_50_6 _0_0syn_0_0ring_0_0delay__line__chan_31_4
xlatch______va9__3 block__7_azero_aa block__9_azero_aa va__blk__3_adin_50_6 va__blk__3_adin_51_6 va__blk__3_adin_52_6 va__blk__3_adin_53_6 va__blk__3_adin_54_6 va__blk__3_adin_55_6 va__blk__3_adin_56_6 va__blk__3_adin_57_6 va__blk__3_adin_58_6 va__blk__4_adin_50_6 va__blk__4_adin_51_6 va__blk__4_adin_52_6 va__blk__4_adin_53_6 va__blk__4_adin_54_6 va__blk__4_adin_55_6 va__blk__4_adin_56_6 va__blk__4_adin_57_6 va__blk__4_adin_58_6 inst__7_ain__0_50_6 inst__7_ain__0_51_6 inst__7_ain__0_52_6 inst__7_ain__0_53_6 inst__7_ain__0_54_6 inst__7_ain__0_55_6 inst__7_ain__0_56_6 inst__7_ain__0_57_6 inst__7_ain__0_58_6 _0_0syn_0_0ring_0_0merge__mux__ohc__opt_32_79_4
xlatch______va9__2 block__8_adata_ad_ad_50_6 __ch__0__1_aa __ch__0__1_ad_50_6 __ch__0__1_ad_51_6 __ch__0__1_ad_52_6 __ch__0__1_ad_53_6 __ch__0__1_ad_54_6 __ch__0__1_ad_55_6 __ch__0__1_ad_56_6 __ch__0__1_ad_57_6 __ch__0__1_ad_58_6 va__blk__4_adin_50_6 va__blk__4_adin_51_6 va__blk__4_adin_52_6 va__blk__4_adin_53_6 va__blk__4_adin_54_6 va__blk__4_adin_55_6 va__blk__4_adin_56_6 va__blk__4_adin_57_6 va__blk__4_adin_58_6 _0_0syn_0_0ring_0_0capture_36_76_79_4
xblock__25 inst__11_aout_50_6 inst__12_aout_50_6 block__25_am1_ad_ad_50_6 block__24_ap1_aa block__27_am1_ad_ad_50_6 block__27_am1_aa block__28_am1_ad_ad_50_6 block__28_am1_aa _0_0syn_0_0ring_0_0selection__split_32_4
xblock__12 block__13_am1_aa block__14_am1_aa block__14_am1_ad_ad_50_6 block__12_ap1_ad_ad_50_6 block__12_ap1_aa _0_0syn_0_0ring_0_0selection__merge_32_4
xlatch______va7__0 block__17_ap1_aa block__18_azero_aa va__blk__11_adin_50_6 va__blk__11_adin_51_6 inst__1_ain__0_50_6 inst__1_ain__0_51_6 _0_0syn_0_0ring_0_0capture__init_36_76_72_71_4
xinst__10 inst__10_aout_50_6 _0_0syn_0_0expr_0_0blk_i0_1
xblock__36 block__31_ap1_ad_ad_50_6 block__31_ap1_aa block__36_azero_aa block__36_ap1_aa _0_0syn_0_0ring_0_0elem_c_paa
xblock__7 block__4_am1_aa block__6_ap1_aa block__7_azero_aa block__7_ap1_aa _0_0syn_0_0ring_0_0elem_c_paa
xblock__23 block__22_azero_aa block__22_ap1_aa block__23_adata_ad_ad_50_6 L_aa L_ar block__23_ap1_aa _0_0syn_0_0ring_0_0elem_c_ppa
xinst__11 inst__11_ain__0_50_6 inst__11_ain__0_51_6 inst__11_ain__0_52_6 inst__11_ain__0_53_6 inst__11_ain__0_54_6 inst__11_ain__0_55_6 inst__11_ain__0_56_6 inst__11_ain__0_57_6 inst__11_aout_50_6 _0_0syn_0_0expr_0_0blk_0i1hw8hi0ew6i1I1w9eI0w9qBw7w13I1w13I1w9eI0w9qB_8_1
xdelay__expr__4 block__8_ap1_aa delay__expr__4_ap1_ad_ad_50_6 _0_0syn_0_0ring_0_0delay__line__chan_31_4
xblock__9 block__5_am1_aa block__8_ap1_aa block__9_azero_aa block__7_ap1_aa _0_0syn_0_0ring_0_0elem_c_paa
xdelay__expr__8 block__12_ap1_aa delay__expr__8_ap1_ad_ad_50_6 _0_0syn_0_0ring_0_0delay__line__chan_33_4
xblock__20 block__19_azero_aa block__19_ap1_aa block__1_am1_ar block__1_am1_aa _0_0syn_0_0ring_0_0elem_c_paa
xinst__1 inst__1_ain__0_50_6 inst__1_ain__0_51_6 inst__1_aout_50_6 _0_0syn_0_0expr_0_0blk_0i1e_2_1
xdelay__expr__7 block__15_azero_ad_ad_50_6 R_ar _0_0syn_0_0ring_0_0delay__line__chan_33_4
xdelay__select__11 block__10_ap1_ad_ad_50_6 block__11_am1_ad_ad_50_6 _0_0syn_0_0ring_0_0delay__line__chan_34_4
xlatch______va15__0 delay__expr__18_ap1_ad_ad_50_6 block__38_azero_aa inst__18_aout_50_6 inst__18_aout_51_6 inst__18_aout_52_6 inst__18_aout_53_6 inst__18_aout_54_6 inst__18_aout_55_6 inst__19_ain__0_50_6 inst__19_ain__0_51_6 inst__19_ain__0_52_6 inst__19_ain__0_53_6 inst__19_ain__0_54_6 inst__19_ain__0_55_6 _0_0syn_0_0ring_0_0capture_36_76_76_4
xdelay__expr__18 block__26_ap1_aa delay__expr__18_ap1_ad_ad_50_6 _0_0syn_0_0ring_0_0delay__line__chan_314_4
xinst__16 inst__16_aout_50_6 _0_0syn_0_0expr_0_0blk_i1_1
xblock__17 block__12_ap1_ad_ad_50_6 block__12_ap1_aa block__17_azero_aa block__17_ap1_aa _0_0syn_0_0ring_0_0elem_c_paa
xlatch______va10__0 block__41_ap1_aa block__42_azero_aa va__blk__27_adin_50_6 inst__15_ain__2_50_6 _0_0syn_0_0ring_0_0capture__init_36_76_71_70_4
xblock__40 block__39_azero_aa block__39_ap1_aa block__40_azero_aa block__40_ap1_aa _0_0syn_0_0ring_0_0elem_c_paa
xblock__8 block__5_am1_ad_ad_50_6 block__5_am1_aa block__8_adata_ad_ad_50_6 __ch__0__1_aa __ch__0__1_ar block__8_ap1_aa _0_0syn_0_0ring_0_0elem_c_ppa
xblock__18 block__17_azero_aa block__17_ap1_aa block__18_azero_aa block__18_ap1_aa _0_0syn_0_0ring_0_0elem_c_paa
xlatch______va8__1 delay__expr__3_ap1_ad_ad_50_6 block__7_azero_aa inst__3_aout_50_6 inst__3_aout_51_6 va__blk__5_adin_50_6 va__blk__5_adin_51_6 _0_0syn_0_0ring_0_0capture_36_76_72_4
xinst__20 inst__15_ain__2_50_6 inst__20_aout_50_6 _0_0syn_0_0expr_0_0blk_0t_1_1
xblock__22 block__21_ap1_ad_ad_50_6 block__21_ap1_aa block__22_azero_aa block__22_ap1_aa _0_0syn_0_0ring_0_0elem_c_paa
xlatch______va10__1 delay__expr__21_ap1_ad_ad_50_6 block__41_azero_aa inst__21_aout_50_6 va__blk__27_adin_50_6 _0_0syn_0_0ring_0_0capture_36_76_71_4
xdelay__expr__19 block__38_ap1_aa delay__expr__19_ap1_ad_ad_50_6 _0_0syn_0_0ring_0_0delay__line__chan_33_4
xinst__17 inst__11_ain__0_50_6 inst__11_ain__0_51_6 inst__11_ain__0_52_6 inst__11_ain__0_53_6 inst__11_ain__0_54_6 inst__11_ain__0_55_6 inst__11_ain__0_56_6 inst__11_ain__0_57_6 __ch__0__1_ad_50_6 __ch__0__1_ad_51_6 __ch__0__1_ad_52_6 __ch__0__1_ad_53_6 __ch__0__1_ad_54_6 __ch__0__1_ad_55_6 __ch__0__1_ad_56_6 __ch__0__1_ad_57_6 __ch__0__1_ad_58_6 _0_0syn_0_0expr_0_0blk_0i8I1_8_9
xlatch______va13__0 block__23_adata_ad_ad_50_6 L_aa L_ad_50_6 L_ad_51_6 L_ad_52_6 L_ad_53_6 L_ad_54_6 L_ad_55_6 L_ad_56_6 L_ad_57_6 inst__11_ain__0_50_6 inst__11_ain__0_51_6 inst__11_ain__0_52_6 inst__11_ain__0_53_6 inst__11_ain__0_54_6 inst__11_ain__0_55_6 inst__11_ain__0_56_6 inst__11_ain__0_57_6 _0_0syn_0_0ring_0_0capture_36_76_78_4
xlatch______va16__0 delay__expr__20_ap1_ad_ad_50_6 block__40_azero_aa inst__20_aout_50_6 inst__21_ain__0_50_6 _0_0syn_0_0ring_0_0capture_36_76_71_4
xblock__37 block__36_azero_aa block__36_ap1_aa block__37_azero_ad_ad_50_6 __ch__0__1_aa block__27_am1_aa _0_0syn_0_0ring_0_0elem_c_paa_send
xdelay__select__30 block__28_am1_ad_ad_50_6 block__30_am1_ad_ad_50_6 _0_0syn_0_0ring_0_0delay__line__chan_33_4
xblock__10 block__3_ap1_ad_ad_50_6 block__10_ap1_ad_ad_50_6 _0_0syn_0_0ring_0_0delay__line__merge_34_72_4
xblock__6 block__4_am1_ad_ad_50_6 block__4_am1_aa block__6_adata_ad_ad_50_6 __ch__0__0_aa __ch__0__0_ar block__6_ap1_aa _0_0syn_0_0ring_0_0elem_c_ppa
xblock__19 block__18_azero_aa block__18_ap1_aa block__19_azero_aa block__19_ap1_aa _0_0syn_0_0ring_0_0elem_c_paa
xblock__41 block__40_azero_aa block__40_ap1_aa block__41_azero_aa block__41_ap1_aa _0_0syn_0_0ring_0_0elem_c_paa
xblock__43 block__42_azero_aa block__42_ap1_aa block__21_am1_ar block__21_am1_aa _0_0syn_0_0ring_0_0elem_c_paa
xdelay__expr__10 block__23_ap1_aa delay__expr__10_ap1_ad_ad_50_6 _0_0syn_0_0ring_0_0delay__line__chan_31_4
xdelay__expr__15 block__35_azero_ad_ad_50_6 __ch__0__0_ar _0_0syn_0_0ring_0_0delay__line__chan_33_4
xdelay__expr__21 block__40_ap1_aa delay__expr__21_ap1_ad_ad_50_6 _0_0syn_0_0ring_0_0delay__line__chan_33_4
xinst__18 inst__15_ain__2_50_6 inst__15_ain__1_50_6 inst__15_ain__1_51_6 inst__15_ain__1_52_6 inst__15_ain__1_53_6 inst__15_ain__1_54_6 inst__15_ain__1_55_6 inst__18_aout_50_6 inst__18_aout_51_6 inst__18_aout_52_6 inst__18_aout_53_6 inst__18_aout_54_6 inst__18_aout_55_6 _0_0syn_0_0expr_0_0blk_01pi6I1_6_1_6
xdelay__expr__16 block__31_ap1_aa delay__expr__16_ap1_ad_ad_50_6 _0_0syn_0_0ring_0_0delay__line__chan_31_4
xdelay__expr__20 block__39_ap1_aa delay__expr__20_ap1_ad_ad_50_6 _0_0syn_0_0ring_0_0delay__line__chan_32_4
xinst__2 inst__1_ain__0_50_6 inst__1_ain__0_51_6 inst__2_aout_50_6 _0_0syn_0_0expr_0_0blk_0i2e_2_1
xinst__6 inst__1_ain__0_50_6 inst__1_ain__0_51_6 inst__6_aout_50_6 _0_0syn_0_0expr_0_0blk_0i1eI0w5i2eI0oBn_2_1
xlatch______va11__0 block__42_ap1_aa block__21_am1_ar va__blk__28_adin_50_6 va__blk__28_adin_51_6 va__blk__28_adin_52_6 va__blk__28_adin_53_6 va__blk__28_adin_54_6 va__blk__28_adin_55_6 inst__15_ain__1_50_6 inst__15_ain__1_51_6 inst__15_ain__1_52_6 inst__15_ain__1_53_6 inst__15_ain__1_54_6 inst__15_ain__1_55_6 _0_0syn_0_0ring_0_0capture__init_36_76_76_70_4
xlatch______va9__1 block__6_adata_ad_ad_50_6 __ch__0__0_aa __ch__0__0_ad_50_6 __ch__0__0_ad_51_6 __ch__0__0_ad_52_6 __ch__0__0_ad_53_6 __ch__0__0_ad_54_6 __ch__0__0_ad_55_6 __ch__0__0_ad_56_6 __ch__0__0_ad_57_6 __ch__0__0_ad_58_6 va__blk__3_adin_50_6 va__blk__3_adin_51_6 va__blk__3_adin_52_6 va__blk__3_adin_53_6 va__blk__3_adin_54_6 va__blk__3_adin_55_6 va__blk__3_adin_56_6 va__blk__3_adin_57_6 va__blk__3_adin_58_6 _0_0syn_0_0ring_0_0capture_36_76_79_4
xlatch______va11__1 delay__expr__19_ap1_ad_ad_50_6 block__39_azero_aa inst__19_aout_50_6 inst__19_aout_51_6 inst__19_aout_52_6 inst__19_aout_53_6 inst__19_aout_54_6 inst__19_aout_55_6 va__blk__28_adin_50_6 va__blk__28_adin_51_6 va__blk__28_adin_52_6 va__blk__28_adin_53_6 va__blk__28_adin_54_6 va__blk__28_adin_55_6 _0_0syn_0_0ring_0_0capture_36_76_76_4
xinst__3 inst__3_aout_50_6 inst__3_aout_51_6 _0_0syn_0_0expr_0_0blk_i2_2
xinst__7 inst__7_ain__0_50_6 inst__7_ain__0_51_6 inst__7_ain__0_52_6 inst__7_ain__0_53_6 inst__7_ain__0_54_6 inst__7_ain__0_55_6 inst__7_ain__0_56_6 inst__7_ain__0_57_6 inst__7_ain__0_58_6 R_ad_50_6 R_ad_51_6 R_ad_52_6 R_ad_53_6 R_ad_54_6 R_ad_55_6 R_ad_56_6 R_ad_57_6 R_ad_58_6 _0_0syn_0_0expr_0_0blk_0_9_9
xblock__11 inst__5_aout_50_6 inst__6_aout_50_6 block__11_am1_ad_ad_50_6 block__3_ap1_aa block__13_am1_ad_ad_50_6 block__13_am1_aa block__14_am1_ad_ad_50_6 block__14_am1_aa _0_0syn_0_0ring_0_0selection__split_32_4
xblock__30 inst__13_aout_50_6 inst__14_aout_50_6 block__30_am1_ad_ad_50_6 block__28_am1_aa block__32_am1_ad_ad_50_6 block__32_am1_aa block__33_am1_ad_ad_50_6 block__33_am1_aa _0_0syn_0_0ring_0_0selection__split_32_4
xinst__13 inst__13_ain__0_50_6 inst__13_aout_50_6 _0_0syn_0_0expr_0_0blk_0i1e_1_1
xinst__14 inst__13_ain__0_50_6 inst__14_aout_50_6 _0_0syn_0_0expr_0_0blk_0i1eI0tB_1_1
xblock__31 block__32_am1_ad_ad_50_6 block__32_am1_aa block__33_am1_aa block__31_ap1_ad_ad_50_6 block__31_ap1_aa _0_0syn_0_0ring_0_0selection__merge_32_4
xblock__38 block__26_ap1_ad_ad_50_6 block__26_ap1_aa block__38_azero_aa block__38_ap1_aa _0_0syn_0_0ring_0_0elem_c_paa
xlatch______va8__0 block__18_ap1_aa block__19_azero_aa inst__8_ain__0_50_6 inst__8_ain__0_51_6 latch______va8__0_adout_50_6 latch______va8__0_adout_51_6 _0_0syn_0_0ring_0_0capture__init_36_76_72_70_4
xdelay__select__2 block__1_ap1_ad_ad_50_6 block__2_am1_ad_ad_50_6 _0_0syn_0_0ring_0_0delay__line__chan_33_4
xinst__8 inst__8_ain__0_50_6 inst__8_ain__0_51_6 inst__8_aout_50_6 inst__8_aout_51_6 _0_0syn_0_0expr_0_0blk_0_2_2
xlatch______va8__2 delay__expr__4_ap1_ad_ad_50_6 block__9_azero_aa inst__4_aout_50_6 inst__4_aout_51_6 va__blk__6_adin_50_6 va__blk__6_adin_51_6 _0_0syn_0_0ring_0_0capture_36_76_72_4
xinst__12 inst__11_ain__0_50_6 inst__11_ain__0_51_6 inst__11_ain__0_52_6 inst__11_ain__0_53_6 inst__11_ain__0_54_6 inst__11_ain__0_55_6 inst__11_ain__0_56_6 inst__11_ain__0_57_6 inst__12_aout_50_6 _0_0syn_0_0expr_0_0blk_0i1hw9hi0ew7i1I1w10eI0w10qBw8w14I1w14I1w10eI0w10qtB_8_1
xinst__4 inst__4_aout_50_6 inst__4_aout_51_6 _0_0syn_0_0expr_0_0blk_i1_2
xlatch______va14__0 delay__expr__10_ap1_ad_ad_50_6 block__24_azero_aa inst__10_aout_50_6 inst__13_ain__0_50_6 _0_0syn_0_0ring_0_0capture_36_76_71_4
xlatch______va14__1 delay__expr__16_ap1_ad_ad_50_6 block__36_azero_aa inst__16_aout_50_6 latch______va14__1_adout_50_6 _0_0syn_0_0ring_0_0capture_36_76_71_4
xdelay__select__25 block__24_azero_aa block__25_am1_ad_ad_50_6 _0_0syn_0_0ring_0_0delay__line__chan_37_4
xblock__2 inst__1_aout_50_6 inst__2_aout_50_6 block__2_am1_ad_ad_50_6 block__1_ap1_aa block__4_am1_ad_ad_50_6 block__4_am1_aa block__5_am1_ad_ad_50_6 block__5_am1_aa _0_0syn_0_0ring_0_0selection__split_32_4
xinst__9 inst__9_aout_50_6 _0_0syn_0_0expr_0_0blk_i1_1
xblock__26 block__27_am1_ad_ad_50_6 block__27_am1_aa block__36_ap1_aa block__26_ap1_ad_ad_50_6 block__26_ap1_aa _0_0syn_0_0ring_0_0selection__merge_32_4
xblock__42 block__41_azero_aa block__41_ap1_aa block__42_azero_aa block__42_ap1_aa _0_0syn_0_0ring_0_0elem_c_paa
xinst__21 inst__21_ain__0_50_6 inst__21_aout_50_6 _0_0syn_0_0expr_0_0blk_0_1_1
xblock__1 block__1_am1_ar block__1_am1_aa block__1_ap1_ad_ad_50_6 block__1_ap1_aa _0_0syn_0_0ring_0_0elem_c_itb
xblock__39 block__38_azero_aa block__38_ap1_aa block__39_azero_aa block__39_ap1_aa _0_0syn_0_0ring_0_0elem_c_paa
xblock__15 block__13_am1_ad_ad_50_6 block__13_am1_aa block__15_azero_ad_ad_50_6 R_aa block__14_am1_aa _0_0syn_0_0ring_0_0elem_c_paa_send
xlatch______va7__1 delay__expr__8_ap1_ad_ad_50_6 block__17_azero_aa inst__8_aout_50_6 inst__8_aout_51_6 va__blk__11_adin_50_6 va__blk__11_adin_51_6 _0_0syn_0_0ring_0_0capture_36_76_72_4
xblock__35 block__33_am1_ad_ad_50_6 block__33_am1_aa block__35_azero_ad_ad_50_6 __ch__0__0_aa block__32_am1_aa _0_0syn_0_0ring_0_0elem_c_paa_send
xinst__5 inst__1_ain__0_50_6 inst__1_ain__0_51_6 inst__5_aout_50_6 _0_0syn_0_0expr_0_0blk_0i1eI0w4i2eI0oB_2_1
xdelay__expr__3 block__6_ap1_aa delay__expr__3_ap1_ad_ad_50_6 _0_0syn_0_0ring_0_0delay__line__chan_31_4
xlatch______va9__0 block__19_ap1_aa block__1_am1_ar inst__7_ain__0_50_6 inst__7_ain__0_51_6 inst__7_ain__0_52_6 inst__7_ain__0_53_6 inst__7_ain__0_54_6 inst__7_ain__0_55_6 inst__7_ain__0_56_6 inst__7_ain__0_57_6 inst__7_ain__0_58_6 latch______va9__0_adout_50_6 latch______va9__0_adout_51_6 latch______va9__0_adout_52_6 latch______va9__0_adout_53_6 latch______va9__0_adout_54_6 latch______va9__0_adout_55_6 latch______va9__0_adout_56_6 latch______va9__0_adout_57_6 latch______va9__0_adout_58_6 _0_0syn_0_0ring_0_0capture__init_36_76_79_70_4
xblock__3 block__7_azero_aa block__7_ap1_aa block__9_azero_aa block__3_ap1_ad_ad_50_6 block__3_ap1_aa _0_0syn_0_0ring_0_0selection__merge_32_4
xinst__19 inst__19_ain__0_50_6 inst__19_ain__0_51_6 inst__19_ain__0_52_6 inst__19_ain__0_53_6 inst__19_ain__0_54_6 inst__19_ain__0_55_6 inst__19_aout_50_6 inst__19_aout_51_6 inst__19_aout_52_6 inst__19_aout_53_6 inst__19_aout_54_6 inst__19_aout_55_6 _0_0syn_0_0expr_0_0blk_0_6_6
xdelay__expr__17 block__37_azero_ad_ad_50_6 __ch__0__1_ar _0_0syn_0_0ring_0_0delay__line__chan_33_4
xlatch______va8__3 block__7_azero_aa block__9_azero_aa va__blk__5_adin_50_6 va__blk__5_adin_51_6 va__blk__6_adin_50_6 va__blk__6_adin_51_6 inst__8_ain__0_50_6 inst__8_ain__0_51_6 _0_0syn_0_0ring_0_0merge__mux__ohc__opt_32_72_4
xlatch______va12__0 delay__expr__9_ap1_ad_ad_50_6 block__22_azero_aa inst__9_aout_50_6 latch______va12__0_adout_50_6 _0_0syn_0_0ring_0_0capture_36_76_71_4
xblock__24 block__22_ap1_aa block__23_ap1_aa block__24_azero_aa block__24_ap1_aa _0_0syn_0_0ring_0_0elem_c_paa
.ends
*---- end of process: ring_decomp_rowread<> -----
