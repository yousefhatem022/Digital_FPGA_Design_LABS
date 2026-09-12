`timescale 1ns/1ps

module top_testbench;

    //========================================
    // Inputs
    //========================================

    reg clk;
    reg rst_n;
    reg level;


    //========================================
    // Outputs
    //========================================

    wire [6:0] R;
    wire [6:0] R_C;
    wire [6:0] F;
    wire [6:0] F_C;
    wire [6:0] t;
    wire [6:0] t_C;


    //========================================
    // DUT
    //========================================

    top_module DUT (
        .clk   (clk),
        .rst_n (rst_n),
        .level (level),

        .R     (R),
        .R_C   (R_C),
        .F     (F),
        .F_C   (F_C),
        .t     (t),
        .t_C   (t_C)
    );

    //========================================
    // Monitor
    //========================================

    initial begin
        $monitor(
            "Time=%0t
             Inputs    | CLK=%b | RST_n=%b | LEVEL=%b |
             Outputs   | R=%b | R_C=%b | F=%b | F_C=%b | t=%b | t_C=%b |
            -----------------------------------------------------------------",

            $time,
            clk, rst_n, level,

            R, R_C,
            F, F_C,
            t, t_C
        );
    end

    //========================================
    // Clock Generation
    // 50 MHz
    //========================================

    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;
    end


    //========================================
    // Test Sequence
    //========================================

    initial begin

        rst_n = 1'b0;
        level = 1'b0;

        @(posedge DUT.clk_100Hz);

        rst_n = 1'b1;

        @(posedge DUT.clk_100Hz);

        // Rising
        level = 1'b1;

        @(posedge DUT.clk_100Hz);
        @(posedge DUT.clk_100Hz);

        // Falling
        level = 1'b0;

        @(posedge DUT.clk_100Hz);
        @(negedge DUT.clk_100Hz);

        // Rising
        level = 1'b1;

        @(negedge DUT.clk_100Hz);
        @(negedge DUT.clk_100Hz);

        // Falling
        level = 1'b0;

        @(negedge DUT.clk_100Hz);
        @(negedge DUT.clk_100Hz);

        $finish;

    end

endmodule