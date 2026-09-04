// blackbox.sv
// pixel_test_structure Blackbox (Mapped strictly to physical LEF:
//   pixel_test_structure_mag.lef)
(* blackbox *)
module pixel_test_structure (
`ifdef USE_POWER_PINS
    inout vdda1 /* verilator public */,
    inout vssa1 /* verilator public */,
    inout vssc1 /* verilator public */,
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
/// sta-blackbox
