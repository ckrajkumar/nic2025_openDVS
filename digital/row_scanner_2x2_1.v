//---------------------------------------------------------------------------
// Author: Ababakar Okieh
// Date  : April 3rd, 2026
//
// Module: row_scanner0
//
// Description:
//  A 2-row token-ring scanner and routing decoder for the OpenDVS array.
//  Translated from SystemVerilog to Verilog-2001.
//---------------------------------------------------------------------------

module row_scanner0 (
`ifdef USE_POWER_PINS
    inout vccd1,
    inout vssd1,
`endif

    input  wire        div_clk,
    input  wire        rst_n,
    input  wire        sm_enable,

    // Global Control Pulses (From roic_sm)
    input  wire        sm_on_detect,
    input  wire        sm_off_detect,

    // Shift Trigger
    input  wire        sm_next_row,

    // 2-bit buses to the physical Imager Array
    output reg  [1:0]  row_on_detect,
    output reg  [1:0]  row_off_detect
);

    // -----------------------------------------------------------------
    // 1. THE SHIFT TOKEN (Registered)
    // -----------------------------------------------------------------
    reg [1:0] row_token;

    always @(posedge div_clk or negedge rst_n) begin
        if (!rst_n) begin
            row_token <= 2'b01;
        end
        else if (!sm_enable) begin
            row_token <= 2'b01;
        end
        else if (sm_next_row) begin
            row_token <= {row_token[0], row_token[1]};
        end
    end

    // -----------------------------------------------------------------
    // 2. COMBINATIONAL ARRAY DRIVERS
    // -----------------------------------------------------------------
    // Note: SV 'for' loop with genvar-like int replaced with
    // explicit per-bit assignments.
    always @(*) begin
        row_on_detect  = 2'b00;
        row_off_detect = 2'b00;

        if (row_token[0]) begin
            row_on_detect[0]  = sm_on_detect;
            row_off_detect[0] = sm_off_detect;
        end

        if (row_token[1]) begin
            row_on_detect[1]  = sm_on_detect;
            row_off_detect[1] = sm_off_detect;
        end
    end

endmodule
