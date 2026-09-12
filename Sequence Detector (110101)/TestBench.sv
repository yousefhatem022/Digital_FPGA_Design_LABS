`timescale 1ns/1ps

module Sequence_Detector_TB;

    //==================================================
    // Testbench Signals
    //==================================================
    reg clk;
    reg rst_n;
    reg in;

    //==================================================
    // DUT Outputs
    //==================================================
    wire moore_overlap_out;
    wire moore_nonoverlap_out;

    wire mealy_overlap_out;
    wire mealy_nonoverlap_out;

    //==================================================
    // Detection Counters
    //==================================================
    integer moore_overlap_count;
    integer moore_nonoverlap_count;
    integer mealy_overlap_count;
    integer mealy_nonoverlap_count;

    //==================================================
    // DUT Instantiations
    //==================================================
    moore_overlapping MOORE_OVERLAPPING (
        .clk  (clk),
        .rst_n(rst_n),
        .in   (in),
        .out  (moore_overlap_out)
    );

    moore_nonoverlapping MOORE_NONOVERLAPPING (
        .clk  (clk),
        .rst_n(rst_n),
        .in   (in),
        .out  (moore_nonoverlap_out)
    );

    mealy_overlapping MEALY_OVERLAPPING (
        .clk  (clk),
        .rst_n(rst_n),
        .in   (in),
        .out  (mealy_overlap_out)
    );

    mealy_nonoverlapping MEALY_NONOVERLAPPING (
        .clk  (clk),
        .rst_n(rst_n),
        .in   (in),
        .out  (mealy_nonoverlap_out)
    );

    //==================================================
    // Clock Generation
    // Period = 10 ns
    //==================================================
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    //==================================================
    // Count Mealy Detections
    // Mealy output is generated on the input transition
    //==================================================
    always @(negedge clk) begin
        #1;

        if (rst_n) begin

            if (mealy_overlap_out)
                mealy_overlap_count = mealy_overlap_count + 1;

            if (mealy_nonoverlap_out)
                mealy_nonoverlap_count = mealy_nonoverlap_count + 1;

        end
    end

    //==================================================
    // Count Moore Detections
    // Moore output is generated after entering S6
    //==================================================
    always @(negedge clk) begin
        if (rst_n) begin
            #1;

            if (moore_overlap_out)
                moore_overlap_count = moore_overlap_count + 1;

            if (moore_nonoverlap_out)
                moore_nonoverlap_count = moore_nonoverlap_count + 1;
        end
    end

    //==================================================
    // Test Sequence
    //==================================================
    initial begin

        // Initialize counters
        moore_overlap_count     = 0;
        moore_nonoverlap_count  = 0;
        mealy_overlap_count     = 0;
        mealy_nonoverlap_count  = 0;

        // Initial values
        rst_n = 1'b0;
        in    = 1'b0;

        // Hold reset for two clock cycles
        repeat (1) @(posedge clk);

        // Release reset
        rst_n = 1'b1;

        //================================================
        // Input Sequence : 00111011010110101011010110101
        //================================================
        @(negedge clk); in = 1'b0;
        @(negedge clk); in = 1'b0;
        @(negedge clk); in = 1'b1;
        @(negedge clk); in = 1'b1;
        @(negedge clk); in = 1'b1;
        @(negedge clk); in = 1'b0;
        @(negedge clk); in = 1'b1;
        @(negedge clk); in = 1'b1;
        @(negedge clk); in = 1'b0;
        @(negedge clk); in = 1'b1;
        @(negedge clk); in = 1'b0;
        @(negedge clk); in = 1'b1;
        @(negedge clk); in = 1'b1;
        @(negedge clk); in = 1'b0;
        @(negedge clk); in = 1'b1;
        @(negedge clk); in = 1'b0;
        @(negedge clk); in = 1'b1;
        @(negedge clk); in = 1'b0;
        @(negedge clk); in = 1'b1;
        @(negedge clk); in = 1'b1;
        @(negedge clk); in = 1'b0;
        @(negedge clk); in = 1'b1;
        @(negedge clk); in = 1'b0;
        @(negedge clk); in = 1'b1;
        @(negedge clk); in = 1'b1;
        @(negedge clk); in = 1'b0;
        @(negedge clk); in = 1'b1;
        @(negedge clk); in = 1'b0;
        @(negedge clk); in = 1'b1;

        // Wait for final Moore detection
        repeat (2) @(posedge clk);

        //================================================
        // Verification
        //================================================
        $display("==============================================");
        $display("        SEQUENCE DETECTOR VERIFICATION        ");
        $display("==============================================");

        $display("Input Sequence: 00111011010110101011010110101");

        $display("");
        $display("Expected Results:");
        $display("Overlapping     = 4 detections");
        $display("Non-Overlapping = 2 detections");

        $display("");
        $display("Actual Results:");
        $display("Moore Overlapping     = %0d", moore_overlap_count);
        $display("Moore Non-Overlapping = %0d", moore_nonoverlap_count);
        $display("Mealy Overlapping     = %0d", mealy_overlap_count);
        $display("Mealy Non-Overlapping = %0d", mealy_nonoverlap_count);

        //================================================
        // Final Check
        //================================================
        if ((moore_overlap_count == 4) &&
            (moore_nonoverlap_count == 2) &&
            (mealy_overlap_count == 4) &&
            (mealy_nonoverlap_count == 2)) begin

            $display("");
            $display("==============================================");
            $display("              TEST PASSED                     ");
            $display("==============================================");

        end
        else begin

            $display("");
            $display("==============================================");
            $display("              TEST FAILED                     ");
            $display("==============================================");

        end

        #10;
        $finish;

    end

endmodule