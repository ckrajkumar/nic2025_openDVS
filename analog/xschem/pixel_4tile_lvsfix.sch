v {xschem version=3.4.8RC file_version=1.3}
G {}
K {LVS fix 2026-07-09: vssa1=col periphery; vssc1=pixel GndD; layout v3 GDS straps vssc1->GndD}
V {}
S {}
F {}
E {}
N -100 -600 -20 -600 {lab=vdda1}
N -100 -580 -20 -580 {lab=vssa1}
N -100 -560 -20 -560 {lab=dac_config_6}
N -100 -540 -20 -540 {lab=pre_charge_global_top_left}
N -100 -520 -20 -520 {lab=detect_pulse_global_top_left}
N -100 -500 -20 -500 {lab=ndetect_pulse_global_top_left}
N -100 -450 -20 -450 {lab=row_off_detect_top[63:0]}
N -100 -430 -20 -430 {lab=row_on_detect_top[63:0]}
N -100 -80 -20 -80 {lab=row_off_detect_bot[0:63]}
N -100 -60 -20 -60 {lab=row_on_detect_bot[0:63]}
N -100 -230 -20 -230 {lab=vdda1}
N -100 -210 -20 -210 {lab=vssa1}
N -100 -190 -20 -190 {lab=dac_config_6}
N -100 -170 -20 -170 {lab=pre_charge_global_bot_left}
N -100 -150 -20 -150 {lab=detect_pulse_global_bot_left}
N -100 -130 -20 -130 {lab=ndetect_pulse_global_bot_left}
N 80 -760 80 -680 {lab=dac_config_0}
N 100 -760 100 -680 {lab=dac_config_5}
N 120 -760 120 -680 {lab=dac_config_3}
N 140 -760 140 -680 {lab=dac_config_4}
N 160 -760 160 -680 {lab=dac_config_1}
N 180 -760 180 -680 {lab=dac_config_2}
N 40 -760 40 -680 {lab=col_event_rst_top_left[0:63]}
N 60 -760 60 -680 {lab=array_col_top_left[0:63]}
N 340 -760 340 -680 {lab=col_event_rst_top_right[0:63]}
N 360 -760 360 -680 {lab=array_col_top_right[0:63]}
N 120 20 120 100 {lab=col_event_rst_bot_left[0:63]}
N 140 20 140 100 {lab=array_col_bot_left[0:63]}
N 420 20 420 100 {lab=col_event_rst_bot_right[0:63]}
N 440 20 440 100 {lab=array_col_bot_right[0:63]}
N 380 -760 380 -680 {lab=dac_config_0}
N 400 -760 400 -680 {lab=dac_config_5}
N 420 -760 420 -680 {lab=dac_config_3}
N 440 -760 440 -680 {lab=dac_config_4}
N 460 -760 460 -680 {lab=dac_config_1}
N 480 -760 480 -680 {lab=dac_config_2}
N -100 -480 -20 -480 {lab=vssc1}
N -100 -110 -20 -110 {lab=vssc1}
C {pixel_layout_tile.sym} 130 -500 0 0 {name=x1}
C {pixel_layout_tile.sym} 430 -500 0 0 {name=x2}
C {pixel_layout_tile_bot.sym} 130 -160 0 0 {name=x3}
C {pixel_layout_tile_bot.sym} 430 -160 0 0 {name=x4}
C {iopin.sym} -400 -640 0 1 {name=p1 lab=vdda1}
C {lab_wire.sym} -90 -600 0 0 {name=p2 sig_type=std_logic lab=vdda1}
C {lab_wire.sym} -90 -580 0 0 {name=p3 sig_type=std_logic lab=vssa1}
C {lab_wire.sym} -90 -560 0 0 {name=p4 sig_type=std_logic lab=dac_config_6}
C {lab_wire.sym} -90 -540 0 0 {name=p5 sig_type=std_logic lab=pre_charge_global_top_left}
C {lab_wire.sym} -90 -520 0 0 {name=p6 sig_type=std_logic lab=detect_pulse_global_top_left}
C {lab_wire.sym} -90 -500 0 0 {name=p7 sig_type=std_logic lab=ndetect_pulse_global_top_left}
C {lab_wire.sym} -90 -450 0 0 {name=p8 sig_type=std_logic lab=row_off_detect_top[63:0]}
C {lab_wire.sym} -90 -430 0 0 {name=p9 sig_type=std_logic lab=row_on_detect_top[63:0]}
C {lab_wire.sym} -90 -230 0 0 {name=p10 sig_type=std_logic lab=vdda1}
C {lab_wire.sym} -90 -210 0 0 {name=p11 sig_type=std_logic lab=vssa1}
C {lab_wire.sym} -90 -190 0 0 {name=p12 sig_type=std_logic lab=dac_config_6}
C {lab_wire.sym} -90 -170 0 0 {name=p13 sig_type=std_logic lab=pre_charge_global_bot_left}
C {lab_wire.sym} -90 -150 0 0 {name=p14 sig_type=std_logic lab=detect_pulse_global_bot_left}
C {lab_wire.sym} -90 -130 0 0 {name=p15 sig_type=std_logic lab=ndetect_pulse_global_bot_left}
C {lab_wire.sym} -90 -80 0 0 {name=p16 sig_type=std_logic lab=row_off_detect_bot[0:63]}
C {lab_wire.sym} -90 -60 0 0 {name=p17 sig_type=std_logic lab=row_on_detect_bot[0:63]}
C {lab_wire.sym} 80 -700 3 1 {name=p18 sig_type=std_logic lab=dac_config_0}
C {lab_wire.sym} 40 -700 3 1 {name=p25 sig_type=std_logic lab=col_event_rst_top_left[0:63]}
C {lab_wire.sym} 60 -700 3 1 {name=p24 sig_type=std_logic lab=array_col_top_left[0:63]}
C {lab_wire.sym} 340 -700 3 1 {name=p26 sig_type=std_logic lab=col_event_rst_top_right[0:63]}
C {lab_wire.sym} 360 -700 3 1 {name=p27 sig_type=std_logic lab=array_col_top_right[0:63]}
C {lab_wire.sym} 120 40 3 0 {name=p28 sig_type=std_logic lab=col_event_rst_bot_left[0:63]}
C {lab_wire.sym} 140 40 3 0 {name=p29 sig_type=std_logic lab=array_col_bot_left[0:63]}
C {lab_wire.sym} 420 40 3 0 {name=p30 sig_type=std_logic lab=col_event_rst_bot_right[0:63]}
C {lab_wire.sym} 440 40 3 0 {name=p31 sig_type=std_logic lab=array_col_bot_right[0:63]}
C {iopin.sym} -400 -620 0 1 {name=p32 lab=vssa1}
C {iopin.sym} -400 -560 0 1 {name=p33 lab=dac_config_0}
C {iopin.sym} -400 -540 0 1 {name=p34 lab=dac_config_1}
C {iopin.sym} -400 -520 0 1 {name=p35 lab=dac_config_2}
C {iopin.sym} -400 -500 0 1 {name=p36 lab=dac_config_3}
C {iopin.sym} -400 -480 0 1 {name=p37 lab=dac_config_4}
C {iopin.sym} -400 -460 0 1 {name=p38 lab=dac_config_5}
C {iopin.sym} -400 -440 0 1 {name=p39 lab=dac_config_6}
C {iopin.sym} -400 -380 0 1 {name=p41 lab=pre_charge_global_bot_left}
C {iopin.sym} -400 -320 0 1 {name=p42 lab=row_off_detect_top[63:0]}
C {iopin.sym} -400 -300 0 1 {name=p43 lab=row_on_detect_top[63:0]}
C {iopin.sym} -400 -120 0 1 {name=p44 lab=row_off_detect_bot[0:63]}
C {iopin.sym} -400 -100 0 1 {name=p45 lab=row_on_detect_bot[0:63]}
C {iopin.sym} -400 -360 0 1 {name=p46 lab=detect_pulse_global_top_left}
C {iopin.sym} -400 -340 0 1 {name=p47 lab=ndetect_pulse_global_top_left}
C {iopin.sym} -400 -180 0 1 {name=p49 lab=pre_charge_global_bot_left}
C {iopin.sym} -400 -160 0 1 {name=p54 lab=detect_pulse_global_bot_left}
C {iopin.sym} -400 -140 0 1 {name=p55 lab=ndetect_pulse_global_bot_left}
C {lab_wire.sym} 160 -700 3 1 {name=p19 sig_type=std_logic lab=dac_config_1}
C {lab_wire.sym} 180 -700 3 1 {name=p20 sig_type=std_logic lab=dac_config_2}
C {lab_wire.sym} 120 -700 3 1 {name=p21 sig_type=std_logic lab=dac_config_3}
C {lab_wire.sym} 140 -700 3 1 {name=p22 sig_type=std_logic lab=dac_config_4}
C {lab_wire.sym} 100 -700 3 1 {name=p23 sig_type=std_logic lab=dac_config_5}
C {lab_wire.sym} 380 -700 3 1 {name=p40 sig_type=std_logic lab=dac_config_0}
C {lab_wire.sym} 460 -700 3 1 {name=p48 sig_type=std_logic lab=dac_config_1}
C {lab_wire.sym} 480 -700 3 1 {name=p50 sig_type=std_logic lab=dac_config_2}
C {lab_wire.sym} 420 -700 3 1 {name=p51 sig_type=std_logic lab=dac_config_3}
C {lab_wire.sym} 440 -700 3 1 {name=p52 sig_type=std_logic lab=dac_config_4}
C {lab_wire.sym} 400 -700 3 1 {name=p53 sig_type=std_logic lab=dac_config_5}
C {iopin.sym} -400 -280 0 1 {name=p56 lab=array_col_top_left[0:63]}
C {iopin.sym} -400 -260 0 1 {name=p57 lab=array_col_top_right[0:63]}
C {iopin.sym} -400 -80 0 1 {name=p58 lab=array_col_bot_left[0:63]}
C {iopin.sym} -400 -60 0 1 {name=p59 lab=array_col_bot_right[0:63]}
C {iopin.sym} -400 -240 0 1 {name=p60 lab=col_event_rst_top_left[0:63]}
C {iopin.sym} -400 -220 0 1 {name=p61 lab=col_event_rst_top_right[0:63]}
C {iopin.sym} -400 -40 0 1 {name=p62 lab=col_event_rst_bot_left[0:63]}
C {iopin.sym} -400 -20 0 1 {name=p63 lab=col_event_rst_bot_right[0:63]}
C {lab_wire.sym} -90 -480 0 0 {name=p64 sig_type=std_logic lab=vssc1}
C {lab_wire.sym} -90 -110 0 0 {name=p65 sig_type=std_logic lab=vssc1}
C {iopin.sym} -400 -600 0 1 {name=p66 lab=vssc1}
