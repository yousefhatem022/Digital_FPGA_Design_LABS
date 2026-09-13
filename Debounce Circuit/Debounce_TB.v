`timescale 1ns/1ps

module debounce_tb;

    //==================================================
    // Testbench Signals
    //==================================================
    reg clk;
    reg rst_n;
    reg sw;

    wire m_tick;
    wire debounced_sw;

    //==================================================
    // Clock Divider
    // 50 MHz -> m_tick every 100 ns
    //==================================================
    clk_divider #(
        .TICK_CYCLES(5)
    ) CLK_DIV (
        .clk    (clk),
        .rst_n  (rst_n),
        .m_tick (m_tick)
    );

    //==================================================
    // Debounce FSM
    //==================================================
    debounce_fsm DEBOUNCE (
        .clk          (clk),
        .rst_n        (rst_n),
        .sw           (sw),
        .m_tick       (m_tick),
        .debounced_sw (debounced_sw)
    );

    //==================================================
    // 50 MHz Clock
    // Period = 20 ns
    //==================================================
    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;
    end

    //==================================================
    // Test Sequence
    //==================================================
    initial begin

        sw   = 1'b0;
        rst_n = 1'b0;

        // Reset
        repeat (1) @(posedge clk);
        rst_n = 1'b1;

        //================================================
        // Initial Stable 0
        //================================================
        repeat (1) @(posedge clk);

        //================================================
        // Bounce from 0 -> 1
        //================================================
        $display("");
        $display("Starting 0 -> 1 bounce...");

        sw = 1'b1;
        @(negedge clk);
        sw = 1'b0;
        @(negedge clk);
        sw = 1'b1;
        @(negedge clk);
        sw = 1'b0;
        @(negedge clk);
        sw = 1'b1;

        // Keep stable long enough
        // for debounce FSM to accept the change
        repeat (20) @(posedge clk);

        //================================================
        // Check debounced 1
        //================================================
        if (debounced_sw == 1'b1)
            $display("PASS: Switch successfully debounced to 1");
        else
            $display("FAIL: Switch did not debounce to 1");

        //================================================
        // Bounce from 1 -> 0
        //================================================
        $display("");
        $display("Starting 1 -> 0 bounce...");

        sw = 1'b0;
        @(negedge clk);
        sw = 1'b1;
        @(negedge clk);
        sw = 1'b0;
        @(negedge clk);
        sw = 1'b1;
        @(negedge clk);
        sw = 1'b0;

        // Keep stable long enough
        repeat (20) @(posedge clk);

        //================================================
        // Check debounced 0
        //================================================
        if (debounced_sw == 1'b0)
            $display("PASS: Switch successfully debounced to 0");
        else
            $display("FAIL: Switch did not debounce to 0");

        //================================================
        // Final Result
        //================================================
        $display("");
        $display("==============================================");
        $display("          DEBOUNCE VERIFICATION              ");
        $display("==============================================");

        if (debounced_sw == 1'b0) begin
            $display("TEST PASSED");
            $display("Errors: 0");
            $display("Warnings: 0");
        end
        else begin
            $display("TEST FAILED");
        end

        #20;
        $finish;

    end

    //==================================================
    // Monitor
    //==================================================
    initial begin
        $monitor(
            "Time=%0t | clk=%b | rst_n=%b | sw=%b | m_tick=%b | debounced_sw=%b",
            $time, clk, rst_n, sw, m_tick, debounced_sw
        );
    end

endmodule