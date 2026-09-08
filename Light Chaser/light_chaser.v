module light_chaser #(
    parameter WIDTH = 10
)(
    input  wire             clk,
    input  wire             rst_n,
    input  wire             hold_n,
    output wire [WIDTH-1:0] shift_out
);

    reg [WIDTH-1:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            shift_reg <= {1'b1, {(WIDTH-1){1'b0}}};
        end

        else if (!hold_n) begin
            shift_reg <= shift_reg;
        end

        else begin
            if (shift_reg[0] == 1'b1)
                shift_reg <= {1'b1, {(WIDTH-1){1'b0}}};
            else
                shift_reg <= shift_reg >> 1;
        end

    end

    assign shift_out = shift_reg;

endmodule