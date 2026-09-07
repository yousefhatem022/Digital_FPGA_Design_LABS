module tb_Gray_to_7Segment;

    reg  [3:0] gray_in_tb;
    wire [3:0] binary_out_tb;
    wire [6:0] seg_out_tb;

    integer i;

    // Gray to Binary
    gray_to_binary #(
        .WIDTH(4)
    ) DUT_Gray (
        .gray_in(gray_in_tb),
        .binary_out(binary_out_tb)
    );

    // Binary to 7-Segment
    binary_to_7seg DUT_7Seg (
        .binary_in(binary_out_tb),
        .seg_out(seg_out_tb)
    );

    initial begin

        $display("==============================================================");
        $display("          Gray Code to Binary to 7-Segment Test               ");
        $display("==============================================================");
        $display(" Gray    Binary    Hexa    7-Segment");
        $display("--------------------------------------------------------------");

        // Test all 16 possible 4-bit Gray inputs
        for (i = 0; i < 16; i = i + 1) begin

            gray_in_tb = i;
            #10;

            $display(" %b     %b      %h       %b",
                     gray_in_tb, binary_out_tb, binary_out_tb, seg_out_tb);

        end

        $display("==============================================================");
        $display("              All Tests Completed");
        $display("==============================================================");

        $finish;
    end

endmodule