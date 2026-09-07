module FA_2bit_BL (
    input wire [1:0]  A,
    input wire [1:0]  B,
    input wire        Cin,
    output reg  [1:0] Sum_BL,
    output reg        Cout_BL
);

    always @(*) begin
        {Cout_BL, Sum_BL} = A + B + Cin;
    end

endmodule