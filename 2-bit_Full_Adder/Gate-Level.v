module FA_2bit_GL (
    input wire [1:0]  A,
    input wire [1:0]  B,
    input wire        Cin,
    output wire [1:0] Sum_GL,
    output wire       Cout_GL
);

    wire net1_0;
    wire net1_1;
    wire net2_0;
    wire net2_1;
    wire net3_0;
    wire net3_1;
    wire carry_1;

    // Bit 0
    xor u0 (net1_0, A[0], B[0]);
    xor u1 (Sum_GL[0], net1_0, Cin);
    and u2 (net2_0, A[0], B[0]);
    and u3 (net3_0, net1_0, Cin);
    or  u4 (carry_1, net2_0, net3_0);

    // Bit 1
    xor u5 (net1_1, A[1], B[1]);
    xor u6 (Sum_GL[1], net1_1, carry_1);
    and u7 (net2_1, A[1], B[1]);
    and u8 (net3_1, net1_1, carry_1);
    or  u9 (Cout_GL, net2_1, net3_1);

endmodule