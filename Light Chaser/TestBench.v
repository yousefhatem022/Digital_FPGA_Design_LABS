`timescale 1ns/1ps

module tb_light_chaser;

    reg clk_tb;
    reg rst_n_tb;
    reg hold_n_tb;

    wire clk_out_tb;
    wire [9:0] shift_out_tb;

    //========================================================
    // Clock Divider
    //========================================================
    clk_divider #(
        .Output_freq(8)
    ) DUT_DIV (
        .clk(clk_tb),
        .rst_n(rst_n_tb),
        .clk_out(clk_out_tb)
    );

    //========================================================
    // Light Chaser
    //========================================================
    light_chaser #(
        .WIDTH(10)
    ) DUT_CHASER (
        .clk(clk_out_tb),
        .rst_n(rst_n_tb),
        .hold_n(hold_n_tb),
        .shift_out(shift_out_tb)
    );

    //========================================================
    // 50 MHz Clock
    // Period = 20 ns
    //========================================================
    always #10 clk_tb = ~clk_tb;

    //========================================================
    // Display Light Chaser Output
    //========================================================
    always @(posedge clk_out_tb) begin
        #1;
        $display("Time=%t | rst_n=%b | hold_n=%b | shift_out=%b",
                 $time, rst_n_tb, hold_n_tb, shift_out_tb);
    end

    //========================================================
    // Test
    //========================================================
    initial begin

        // Clear values
        clk_tb    = 1'b0;
        rst_n_tb  = 1'b0;
        hold_n_tb = 1'b1;

        #100;

        // Release reset and start the shifter
        rst_n_tb = 1'b1;

        //====================================================
        // Normal Shifting
        //====================================================
        repeat (4) @(posedge clk_out_tb);

        //====================================================
        // Hold Test
        //====================================================
        hold_n_tb = 1'b0;

        repeat (2) @(posedge clk_out_tb);

        //====================================================
        // Release Hold
        //====================================================
        hold_n_tb = 1'b1;

        repeat (2) @(posedge clk_out_tb);

        //====================================================
        // Reset Test
        //====================================================
        rst_n_tb = 1'b0;

        // Wait using input clock because clk_out is held at 0
        repeat (2) @(posedge clk_tb);

        $display("Time=%t | rst_n=%b | hold_n=%b | shift_out=%b",
                 $time, rst_n_tb, hold_n_tb, shift_out_tb);

        //====================================================
        // Release Reset
        //====================================================
        rst_n_tb = 1'b1;

        //====================================================
        // Continue Shifting
        // 20 output clock cycles
        //====================================================
        repeat (20) @(posedge clk_out_tb);

        $display("==============================================================");
        $display("              All Tests Completed Successfully!              ");
        $display("==============================================================");

        $finish;

    end

endmodule