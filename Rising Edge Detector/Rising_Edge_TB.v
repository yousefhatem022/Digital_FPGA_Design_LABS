`timescale 1ns/1ps

module Rising_Edge_TB;

    reg clk_tb;
    reg rst_tb;
    reg level_tb;

    wire tick_moore_tb;
    wire tick_mealy_tb;

    // Moore DUT
    Rising_Edge_moore DUT_MOORE (
        .clk   (clk_tb),
        .rst   (rst_tb),
        .level (level_tb),
        .tick  (tick_moore_tb)
    );

    // Mealy DUT
    Rising_Edge_mealy DUT_MEALY (
        .clk   (clk_tb),
        .rst   (rst_tb),
        .level (level_tb),
        .tick  (tick_mealy_tb)
    );


    // Clock generation
    initial begin
        clk_tb = 1'b0;
        forever #5 clk_tb = ~clk_tb;
    end


    // Monitor
    initial begin
        $monitor(
            "Time=%0t | CLK=%b | RST=%b | LEVEL=%b | MOORE_STATE=%b | MOORE_TICK=%b | MEALY_STATE=%b | MEALY_TICK=%b | ",
            
            $time, clk_tb, rst_tb, level_tb,
            DUT_MOORE.prev_state, tick_moore_tb,
            DUT_MEALY.prev_state, tick_mealy_tb
        );
    end


    // Stimulus
    initial begin

        // Initial values
        rst_tb   = 1'b1;
        level_tb = 1'b0;
        #10;

        rst_tb = 1'b0;
        #5;

        // --------------------------------
        // Test 1: Rising Edge
        // --------------------------------
        level_tb = 1'b1;
        #20;

        // --------------------------------
        // Test 2: Falling Edge
        // --------------------------------
        level_tb = 1'b0;
        #5;

        // --------------------------------
        // Test 3: Another Rising Edge
        // --------------------------------
        level_tb = 1'b1;
        #30; // Test 4: Keep level HIGH and Make sure tick does not repeat

        // --------------------------------
        // Test 5: Falling then Rising
        // --------------------------------
        level_tb = 1'b0;
        #5;

        // --------------------------------
        // Finish
        // --------------------------------
        $finish;

    end

endmodule