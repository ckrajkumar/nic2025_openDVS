//---------------------------------------------------------------------------
// Author: Ababakar Okieh
// Date  : April 4th, 2026 (Updated for 2x1 Array)
//
// Module: roic_top0
// Description:
//  Top-level wrapper for the Phase-Gated Neuromorphic Readout Controller.
//  Translated from SystemVerilog to Verilog-2001.
//---------------------------------------------------------------------------

module roic_top0 (
`ifdef USE_POWER_PINS
    inout vccd1,
    inout vssd1,
`endif

    // System Inputs
    input  wire        sys_clk,
    input  wire        rst_n,

    // Control Plane
    input  wire        sm_enable,
    input  wire [7:0]  program_bits,

    // Programmable Timing Inputs (Ticks)
    input  wire [13:0] p_pre_charge,
    input  wire [13:0] p_buffer,
    input  wire [13:0] p_detect,
    input  wire [13:0] p_on_detect,
    input  wire [13:0] p_off_detect,
    input  wire [13:0] p_rst,

    // Data FROM the Pixel Array (1 Column)
    input  wire [1:0]  array_col_out,

    // Analog Array Control Plane (2 Rows)
    output wire        pre_charge_global,
    output wire [1:0]  row_on_detect,
    output wire [1:0]  row_off_detect,

    // Analog Array Control Plane (1 Column)
    output wire [1:0]  col_pixel_rst,

    // Digital Backend Data Plane
    output wire        row_addr,
    output wire        fifo_wr_en,
    output wire [1:0]  event_flag
);

    // -----------------------------------------------------------------
    // Internal Interconnects
    // -----------------------------------------------------------------
    wire sm_on_detect;
    wire sm_off_detect;
    wire sm_detect_pulse;
    wire sm_pixel_rst;
    wire sm_next_row;

    // -----------------------------------------------------------------
    // 1. Continuous Pacing Micro-Sequencer (roic_sm2_2x2)
    // -----------------------------------------------------------------
    roic_sm2_2x2 i_roic_sm (
`ifdef USE_POWER_PINS
        .vccd1             (vccd1),
        .vssd1             (vssd1),
`endif
        .sys_clk           (sys_clk),
        .rst_n             (rst_n),
        .sm_enable         (sm_enable),
        .program_bits      (program_bits),

        .p_pre_charge      (p_pre_charge),
        .p_buffer          (p_buffer),
        .p_detect          (p_detect),
        .p_on_detect       (p_on_detect),
        .p_off_detect      (p_off_detect),
        .p_rst             (p_rst),

        .pre_charge_global (pre_charge_global),
        .on_detect         (sm_on_detect),
        .off_detect        (sm_off_detect),
        .detect_pulse      (sm_detect_pulse),
        .pixel_rst         (sm_pixel_rst),

        .sm_next_row       (sm_next_row),
        .row_addr          (row_addr),
        .fifo_wr_en        (fifo_wr_en),
        .event_flag        (event_flag)
    );

    // -----------------------------------------------------------------
    // 2. Physical Row Scanner
    // -----------------------------------------------------------------
    row_scanner0 i_row_scanner (
`ifdef USE_POWER_PINS
        .vccd1          (vccd1),
        .vssd1          (vssd1),
`endif
        .div_clk        (sys_clk),
        .rst_n          (rst_n),

        .sm_enable      (sm_enable),
        .sm_on_detect   (sm_on_detect),
        .sm_off_detect  (sm_off_detect),
        .sm_next_row    (sm_next_row),

        .row_on_detect  (row_on_detect),
        .row_off_detect (row_off_detect)
    );

    // -----------------------------------------------------------------
    // 3. Column Event Reset Block
    // -----------------------------------------------------------------
    col_event_rst0 i_col_event_rst (
`ifdef USE_POWER_PINS
        .vccd1          (vccd1),
        .vssd1          (vssd1),
`endif
        .div_clk          (sys_clk),
        .rst_n            (rst_n),

        .sm_on_detect     (sm_on_detect),
        .sm_off_detect    (sm_off_detect),
        .sm_pixel_rst     (sm_pixel_rst),
        .sm_next_row      (sm_next_row),
        .sm_detect_pulse  (sm_detect_pulse),

        .array_col_out    (array_col_out),
        .col_pixel_rst    (col_pixel_rst)
    );

endmodule
