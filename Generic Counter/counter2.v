module counter2 #(
    parameter WIDTH = 5
)(
    input  wire             clk,
    input  wire             rst,
    input  wire             load,
    input  wire             enab,
    input  wire [WIDTH-1:0] cnt_in,
    output reg  [WIDTH-1:0] cnt_out
);

    //==================================================
    // Function: Counter Combinational Behavior
    //==================================================
    function [WIDTH-1:0] counter_next;
        input             rst;
        input             load;
        input             enab;
        input [WIDTH-1:0] cnt_in;
        input [WIDTH-1:0] cnt_out;

        begin
            if (rst)
                counter_next = {WIDTH{1'b0}};

            else if (load)
                counter_next = cnt_in;

            else if (enab)
                counter_next = cnt_out + 1'b1;

            else
                counter_next = cnt_out;
        end
    endfunction

    //==================================================
    // Sequential Logic
    //==================================================
    always @(posedge clk) begin
        cnt_out <= counter_next(
            rst,
            load,
            enab,
            cnt_in,
            cnt_out
        );
    end

endmodule