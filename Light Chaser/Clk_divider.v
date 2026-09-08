module clk_divider #(
    parameter Output_freq = 8
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_out
);

    /*
        Input Clock  = 50 MHz

        Counter value: 50,000,000 / (2 × Output_freq)

        Shift_reg: 

        For Output_freq = 8 Hz:
        50,000,000 / (2 × 8) = 3,125,000
    */

    parameter Shift_reg = 50_000_000 / (2 * Output_freq);

    reg [$clog2(Shift_reg)-1:0] counter;

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            counter <= 'd0;
            clk_out <= 1'b0;
        end

        else if (counter == Shift_reg - 1) begin
            counter <= 'd0;
            clk_out <= ~clk_out;
        end

        else begin
            counter <= counter + 1'b1;
        end

    end

endmodule