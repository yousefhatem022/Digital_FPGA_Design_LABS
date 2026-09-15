module counter #(
    parameter WIDTH = 5
)(
    input  wire             clk,
    input  wire             rst,
    input  wire             load,
    input  wire             enab,
    input  wire [WIDTH-1:0] cnt_in,
    output reg  [WIDTH-1:0] cnt_out
);

    reg [WIDTH-1:0] cnt_next;

    //==================================================
    // Combinational Logic
    //==================================================
    always @(*) begin

        if (rst)
            cnt_next = {WIDTH{1'b0}};

        else if (load)
            cnt_next = cnt_in;

        else if (enab)
            cnt_next = cnt_out + 1'b1;

        else
            cnt_next = cnt_out;

    end

    //==================================================
    // Sequential Logic
    //==================================================
    always @(posedge clk) begin
        cnt_out <= cnt_next;
    end

endmodule