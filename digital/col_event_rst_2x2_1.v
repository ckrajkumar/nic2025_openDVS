//---------------------------------------------------------------------------
// Author: Ababakar Okieh
// Date  : April 3rd, 2026
//
// Module: col_event_rst0
//
// Description:
//  Behavioral reset for analog column peripherals in OpenDVS.
//  Translated from SystemVerilog to Verilog-2001.
//---------------------------------------------------------------------------

module col_event_rst0 (
`ifdef USE_POWER_PINS
    inout vccd1,
    inout vssd1,
`endif

    input  wire        div_clk,
    input  wire        rst_n,

    // Global Control Pulses (From roic_sm)
    input  wire        sm_on_detect,
    input  wire        sm_off_detect,
    input  wire        sm_pixel_rst,
    input  wire        sm_next_row,
    input  wire        sm_detect_pulse,

    // Data FROM the Pixel Array
    input  wire [1:0]  array_col_out,

    // Output TO the Pixel Array
    output reg  [1:0]  col_pixel_rst
);

    // -----------------------------------------------------------------
    // 1. Continuously Running Bus Synchronizer
    // -----------------------------------------------------------------
    reg [1:0] col_out_m1;
    reg [1:0] col_out_m2;

    always @(posedge div_clk or negedge rst_n) begin
        if (!rst_n) begin
            col_out_m1 <= 2'd0;
            col_out_m2 <= 2'd0;
        end else begin
            col_out_m1 <= array_col_out;
            col_out_m2 <= col_out_m1;
        end
    end

    // -----------------------------------------------------------------
    // 2. Gated Latching & Logic
    // -----------------------------------------------------------------
    reg [1:0] on_pixels_reg;
    reg [1:0] off_pixels_reg;

    always @(posedge div_clk or negedge rst_n) begin
        if (!rst_n) begin
            on_pixels_reg  <= 2'd0;
            off_pixels_reg <= 2'd0;
            col_pixel_rst  <= 2'd0;
        end else begin
            // A. The Defensive Clear
            if (sm_next_row) begin
                on_pixels_reg  <= 2'd0;
                off_pixels_reg <= 2'd0;
            end
            else begin
                // B. Capture ON events
                if (sm_on_detect && sm_detect_pulse) begin
                    on_pixels_reg  <= col_out_m2;
                end

                // C. Capture OFF events
                if (sm_off_detect && sm_detect_pulse) begin
                    off_pixels_reg <= ~col_out_m2;
                end
            end

            // D. Compute Reset
            if (sm_pixel_rst) begin
                col_pixel_rst <= on_pixels_reg | off_pixels_reg;
            end else begin
                col_pixel_rst <= 2'd0;
            end
        end
    end

endmodule
