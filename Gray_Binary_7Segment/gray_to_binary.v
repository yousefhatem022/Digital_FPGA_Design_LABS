module gray_to_binary #(
    parameter WIDTH = 4
)(
    input  wire [WIDTH-1:0] gray_in,
    output reg  [WIDTH-1:0] binary_out
);

    integer i;

    always @(*) begin
        //Binary MSB = Gray MSB
        binary_out[WIDTH-1] = gray_in[WIDTH-1];

        //Binary[i] = Binary[i+1] XOR Gray[i]
        for (i = WIDTH-2; i >= 0; i = i - 1) begin
            binary_out[i] = binary_out[i+1] ^ gray_in[i];
        end
    end

endmodule