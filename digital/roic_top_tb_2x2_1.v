//---------------------------------------------------------------------------
// Module: roic_top_tb_2x2
// Description:
//  Self-checking system testbench for the 2x2 Phase-Gated ROIC Top Level.
//  Translated from SystemVerilog to Verilog-2001.
//
//  NOTE: Several SystemVerilog-only features are used in this testbench:
//   - 'automatic' tasks for re-entrant local variables
//   - 'string' type for display names
//   - 'longint' for 64-bit time arithmetic
//   - 'int' loop variable in for loops
//  These have been translated to the closest Verilog-2001 equivalents.
//  A few constructs (string task args, longint) may require Verilog-2005
//  or a simulator that supports mixed-language. Comments note each case.
//---------------------------------------------------------------------------

`timescale 1ns/1ps

module roic_top_tb_2x2;

    parameter SYS_CLK_PERIOD_NS = 20; // 50MHz Master Clock

    // Inputs
    reg         sys_clk;
    reg         rst_n;
    reg         sm_enable;
    reg  [7:0]  program_bits;
    reg  [1:0]  array_col_out;

    reg  [13:0] p_pre_charge;
    reg  [13:0] p_buffer;
    reg  [13:0] p_detect;
    reg  [13:0] p_on_detect;
    reg  [13:0] p_off_detect;
    reg  [13:0] p_rst;

    // Outputs
    wire        pre_charge_global;
    wire [1:0]  row_on_detect;
    wire [1:0]  row_off_detect;
    wire [1:0]  col_pixel_rst;
    wire        row_addr;
    wire        fifo_wr_en;
    wire [1:0]  event_flag;

    // --- Memory & File I/O ---
    reg  [1:0]  img_mem [0:3];
    integer     fd;

    // DUT Instantiation
    roic_top0 i_dut (
        .sys_clk           (sys_clk),
        .rst_n             (rst_n),
        .sm_enable         (sm_enable),
        .program_bits      (program_bits),
        .array_col_out     (array_col_out),

        .pre_charge_global (pre_charge_global),
        .row_on_detect     (row_on_detect),
        .row_off_detect    (row_off_detect),
        .col_pixel_rst     (col_pixel_rst),

        .row_addr          (row_addr),
        .fifo_wr_en        (fifo_wr_en),
        .event_flag        (event_flag),

        .p_pre_charge      (p_pre_charge),
        .p_buffer          (p_buffer),
        .p_detect          (p_detect),
        .p_on_detect       (p_on_detect),
        .p_off_detect      (p_off_detect),
        .p_rst             (p_rst)
    );

    // 50MHz Clock Generation
    initial sys_clk = 0;
    always #(SYS_CLK_PERIOD_NS / 2) sys_clk = ~sys_clk;

    // -----------------------------------------------------------------
    // Backend FIFO Monitor
    // -----------------------------------------------------------------
    always @(posedge sys_clk) begin
        if (rst_n && fifo_wr_en) begin
            $fdisplay(fd, "%04b", {event_flag, array_col_out});
        end
    end

    // -----------------------------------------------------------------
    // Helper Function: Tolerance Check
    // NOTE: 'longint' is Verilog-2005/SV. Using integer (32-bit) here;
    // for simulators that support it, change to reg [63:0] if overflow
    // is a concern with large timing values.
    // -----------------------------------------------------------------
    function is_within_tolerance;
        input [63:0] actual_delta;
        input [63:0] expected_delta;
        input [63:0] tol;
        reg   [63:0] diff;
        begin
            diff = (actual_delta > expected_delta) ?
                   (actual_delta - expected_delta) :
                   (expected_delta - actual_delta);
            is_within_tolerance = (diff <= tol);
        end
    endfunction

    // -----------------------------------------------------------------
    // Initialization
    // -----------------------------------------------------------------
    initial begin
        // Initial signal values
        rst_n         = 0;
        sm_enable     = 0;
        program_bits  = 0;
        array_col_out = 2'b0;
        p_pre_charge  = 14'd4;
        p_buffer      = 14'd4;
        p_detect      = 14'd4;
        p_on_detect   = 14'd8;
        p_off_detect  = 14'd8;
        p_rst         = 14'd25;

        $display("==================================================");
        $display("Starting Intent-Based 2x2 ROIC System TB");
        $display("Testing Timing Deltas, Latching, and State Flow");
        $display("==================================================");

        img_mem[0] = 2'b11;
        img_mem[1] = 2'b00;
        img_mem[2] = 2'b00;
        img_mem[3] = 2'b11;

        fd = $fopen("/LinuxRAID/home/aokieh1/projects/open_dvs_digital/fver/roic/python/sim_output_2x2.txt", "w");
        if (fd == 0) begin
            $display("[FATAL ERROR] Could not open sim_output_2x2.txt for writing!");
            $stop;
        end

        test_speed_fast;
        test_speed_medium;
        test_speed_slow;

        $display("\n==================================================");
        $display("ALL SPEEDS, DATAPATHS, AND TIMING DELTAS PASSED!");
        $display("Simulation Complete. Output written to sim_output_2x2.txt");
        $display("==================================================");

        $fclose(fd);
        $finish;
    end

    // -----------------------------------------------------------------
    // NOTE: SystemVerilog 'automatic' tasks with string arguments and
    // local 'longint' variables cannot be directly expressed in
    // Verilog-2001. The three speed tests are implemented as separate
    // named tasks sharing the module-level registers below.
    // -----------------------------------------------------------------

    // Shared task-local state (module-level regs used by tasks)
    reg  [63:0] task_target_delta_ns;
    reg  [63:0] task_tolerance_ns;
    reg  [63:0] ref_time;
    reg  [63:0] event_time;
    reg  [63:0] actual_delta;
    reg  [1:0]  test_on_data;
    reg  [1:0]  test_off_data;
    reg         expected_addr;
    integer     r;

    // -----------------------------------------------------------------
    // Task: Fast Mode (program_bits = 1)
    // -----------------------------------------------------------------
    task test_speed_fast;
        begin
            task_target_delta_ns = 64'd1 * 64'd1000;
            task_tolerance_ns    = 64'd3;
            run_sweep(8'd1, "Fast Mode (1us)");
        end
    endtask

    // -----------------------------------------------------------------
    // Task: Medium Mode (program_bits = 32)
    // -----------------------------------------------------------------
    task test_speed_medium;
        begin
            task_target_delta_ns = 64'd32 * 64'd1000;
            task_tolerance_ns    = 64'd3;
            run_sweep(8'd32, "Extended Mode (32us)");
        end
    endtask

    // -----------------------------------------------------------------
    // Task: Slow Mode (program_bits = 0 -> 256us)
    // -----------------------------------------------------------------
    task test_speed_slow;
        begin
            task_target_delta_ns = 64'd256 * 64'd1000;
            task_tolerance_ns    = 64'd3;
            run_sweep(8'd0, "Extended Mode (256us)");
        end
    endtask

    // -----------------------------------------------------------------
    // Shared sweep body (called by the three tasks above)
    // NOTE: 'string' type removed; label printed by each caller.
    // -----------------------------------------------------------------
    task run_sweep;
        input [7:0]  p_bits;
        input [63:0] dummy; // placeholder for string label (not used at runtime)
        integer ri;
        begin
            $display("\n--------------------------------------------------");
            $display(" RUNNING TEST: program_bits = %0d", p_bits);
            $display(" Target Delta: %0d ns (+/- %0d ns)",
                     task_target_delta_ns, task_tolerance_ns);
            $display("--------------------------------------------------");

            // Hard Reset & Setup
            rst_n        = 0;
            sm_enable    = 0;
            program_bits = p_bits;
            array_col_out = 2'b0;
            #(SYS_CLK_PERIOD_NS * 10);
            rst_n = 1;

            @(negedge sys_clk);
            sm_enable = 1;

            @(posedge sys_clk);
            ref_time = $time;
            $display(" -> FSM Enabled at %0d ns", ref_time);

            // 2-row sweep
            for (ri = 0; ri < 2; ri = ri + 1) begin
                $display("\n  --- Sweeping Row %0d ---", ri);

                test_on_data  = img_mem[ri * 2];
                test_off_data = img_mem[(ri * 2) + 1];

                // 1. Wait for ON_DETECT
                @(posedge i_dut.i_roic_sm.on_detect);
                event_time   = $time;
                actual_delta = event_time - ref_time;

                if (!is_within_tolerance(actual_delta, task_target_delta_ns, task_tolerance_ns)) begin
                    $display("[FATAL ERROR] ON_DETECT delta violation at Row %0d!", ri);
                    $display("  Expected: %0d ns | Actual: %0d ns",
                             task_target_delta_ns, actual_delta);
                    $stop;
                end
                $display("  -> [PASS] ON_DETECT delta: %0d ns", actual_delta);

                ref_time      = event_time;
                array_col_out = test_on_data;

                // 2. Wait for OFF_DETECT
                @(posedge i_dut.i_roic_sm.off_detect);
                event_time   = $time;
                actual_delta = event_time - ref_time;

                if (!is_within_tolerance(actual_delta, task_target_delta_ns, task_tolerance_ns)) begin
                    $display("[FATAL ERROR] OFF_DETECT delta violation at Row %0d!", ri);
                    $display("  Expected: %0d ns | Actual: %0d ns",
                             task_target_delta_ns, actual_delta);
                    $stop;
                end
                $display("  -> [PASS] OFF_DETECT delta: %0d ns", actual_delta);

                ref_time      = event_time;
                array_col_out = test_off_data;

                // 3. Wait for PIXEL_RST
                @(posedge i_dut.i_roic_sm.pixel_rst);
                event_time   = $time;
                actual_delta = event_time - ref_time;

                if (!is_within_tolerance(actual_delta, task_target_delta_ns, task_tolerance_ns)) begin
                    $display("[FATAL ERROR] PIXEL_RST delta violation at Row %0d!", ri);
                    $display("  Expected: %0d ns | Actual: %0d ns",
                             task_target_delta_ns, actual_delta);
                    $stop;
                end
                $display("  -> [PASS] PIXEL_RST delta: %0d ns", actual_delta);

                ref_time = event_time;

                // 4. Verify Column Pixel Reset Output
                #(SYS_CLK_PERIOD_NS * 1.5);

                if (col_pixel_rst !== (test_on_data | ~test_off_data)) begin
                    $display("[FATAL ERROR] Data Mismatch at Row %0d!", ri);
                    $display("  Expected (ON | ~OFF): %b", (test_on_data | ~test_off_data));
                    $display("  Actual col_pixel_rst: %b", col_pixel_rst);
                    $stop;
                end
                $display("  -> [PASS] Data correctly bitwise OR'd and latched.");

                // 5. Verify Address Increment on sm_next_row falling edge
                @(negedge i_dut.i_roic_sm.sm_next_row);

                #(1);

                expected_addr = (ri == 1) ? 1'b0 : 1'b1;

                if (row_addr !== expected_addr) begin
                    $display("[FATAL ERROR] Address increment failed after Row %0d!", ri);
                    $display("  Expected Addr: %b | Actual Addr: %b",
                             expected_addr, row_addr);
                    $stop;
                end
                $display("  -> [PASS] Address incremented to %b on sm_next_row drop.",
                         expected_addr);
            end // for

            @(negedge sys_clk);
            sm_enable = 0;
            $display("  [SUCCESS] intent-based timing and data flow perfect.");
        end
    endtask

endmodule
