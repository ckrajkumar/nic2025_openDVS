(* blackbox *)
module pixel_test_structure_mag (
`ifdef USE_POWER_PINS
    inout vdda2 /* verilator public */,
    inout vssa2 /* verilator public */,
    inout vssd2 /* verilator public */,
`endif

    // Row select / detect controls
    input [1:0] rowReadON /* verilator public */,
    input [1:0] rowReadOFF /* verilator public */,

    // Pixel reset
    input [1:0] pixRst /* verilator public */,

    // DAC / bias config (pins present in LEF; no dac_config_6)
    input dac_config_0 /* verilator public */,
    input dac_config_1 /* verilator public */,
    input dac_config_2 /* verilator public */,
    input dac_config_3 /* verilator public */,
    input dac_config_4 /* verilator public */,
    input dac_config_5 /* verilator public */,
    input dac_config_7 /* verilator public */,

    // Buffered analog observes
    output vsf_buf /* verilator public */,
    output vdiff_buff /* verilator public */,
    output vpr_buff /* verilator public */,
    output vpd_buff /* verilator public */,

    // Digital readout
    output [1:0] readOut /* verilator public */
);
endmodule

module photodiode_test_structure_mag (
`ifdef USE_POWER_PINS
    inout vdda2 /* verilator public */,
    inout vssa2 /* verilator public */,
`endif

    // DAC / bias config
    input dac_config_7 /* verilator public */,
    input dac_config_8 /* verilator public */,

    // Buffered / observed photodiode output
    output vpd_out /* verilator public */
);
endmodule
