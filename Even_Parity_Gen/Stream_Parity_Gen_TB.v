`timescale 1ns/1ps

module stream_parity_gen_tb;

    //==================================================
    // Testbench Signals
    //==================================================
    reg clk;
    reg reset;
    reg serial_in;

    wire parity_out;
    wire valid;

    //==================================================
    // Testbench Shift Register Used for Self-Checking
    //==================================================
    reg [7:0] tb_shift_reg;

    //==================================================
    // Counters
    //==================================================
    integer pass_count;
    integer fail_count;

    //==================================================
    // DUT
    //==================================================
    stream_parity_gen DUT (
        .clk        (clk),
        .reset      (reset),
        .serial_in  (serial_in),
        .parity_out (parity_out),
        .valid      (valid)
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
    // Task: Send 8 Serial Bits
    //==================================================
    task send_byte;
        input [7:0] data;

        integer i;

        begin

            // Clear TB shift register
            tb_shift_reg = 8'b0;

            for (i = 7; i >= 0; i = i - 1) begin

                // Change input away from sampling edge
                @(negedge clk);

                serial_in = data[i];

                // Same shifting behavior as DUT
                tb_shift_reg = {tb_shift_reg[6:0], data[i]};

            end

        end
    endtask

    //==================================================
    // Task: Test All 256 Possible Bytes
    //==================================================
    task test_all_bytes;

        integer i;
        reg expected_parity;

        begin

            for (i = 0; i < 256; i = i + 1) begin

                // Send current 8-bit pattern
                send_byte(i);

                // Wait for DUT to process 8th bit
                @(posedge clk);

                // Give NBA assignments time to update
                #1;

                // Calculate expected parity from TB shift register
                expected_parity = ^tb_shift_reg;

                //==================================================
                // Self Checking
                //==================================================
                if (parity_out !== expected_parity) begin

                    $display(
                        "FAIL | Test = %3d | Data = %08b | Expected Parity = %b | Got Parity = %b",
                        i,
                        tb_shift_reg,
                        expected_parity,
                        parity_out
                    );

                    fail_count = fail_count + 1;

                end

                else begin

                    $display(
                        "PASS | Test = %3d | Data = %08b | Parity = %b",
                        i,
                        tb_shift_reg,
                        parity_out
                    );

                    pass_count = pass_count + 1;

                end

            end

        end
    endtask

    //==================================================
    // Main Test
    //==================================================
    initial begin

        // Initial values
        reset       = 1'b1;
        serial_in   = 1'b0;
        tb_shift_reg = 8'b0;

        pass_count = 0;
        fail_count = 0;

        //==================================================
        // Reset
        //==================================================
        repeat (2) @(posedge clk);

        reset = 1'b0;

        //==================================================
        // Test all 256 possible 8-bit values
        //==================================================
        test_all_bytes();

        //==================================================
        // Final Results
        //==================================================
        $display("");
        $display("==============================================");
        $display("             TEST SUMMARY");
        $display("==============================================");
        $display("Total Tests : %3d", pass_count + fail_count);
        $display("Passed      : %3d", pass_count);
        $display("Failed      : %3d", fail_count);
        $display("==============================================");

        if (fail_count == 0)
            $display("              ALL TESTS PASSED!");
        else
            $display("              SOME TESTS FAILED!");

        $display("==============================================");

        #10;
        $finish;

    end

endmodule