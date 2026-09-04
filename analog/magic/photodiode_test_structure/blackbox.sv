// blackbox.sv
// photodiode_test_structure Blackbox (Mapped strictly to physical LEF:
//   photodiode_test_structure_mag.lef)
(* blackbox *)
module photodiode_test_structure (
`ifdef USE_POWER_PINS
    inout vdda1 /* verilator public */,
    inout vssa1 /* verilator public */,
`endif

    // DAC / bias config
    input dac_config_7 /* verilator public */,
    input dac_config_8 /* verilator public */,

    // Photodiode node (analog probe)
    inout vpd /* verilator public */,

    // Buffered / observed photodiode output
    output vpd_out /* verilator public */
);
endmodule
/// sta-blackbox
