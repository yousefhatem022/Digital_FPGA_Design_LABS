module FA_2bit_SL (
    input wire [1:0] A,
    input wire [1:0] B,
    input wire       Cin,
    output wire [1:0] Sum_SL,
    output wire       Cout_SL
);

    wire S1_0;
    wire C1_0;
    wire C2_0;
    wire Carry_1;

    wire S1_1;
    wire C1_1;
    wire C2_1;

    // Bit 0
    HA_1bit HA0_1 (
        .A(A[0]),
        .B(B[0]),
        .Sum_HA(S1_0),
        .Cout_HA(C1_0)
    );

    HA_1bit HA0_2 (
        .A(S1_0),
        .B(Cin),
        .Sum_HA(Sum_SL[0]),
        .Cout_HA(C2_0)
    );

    // Carry from bit 0
    or u0 (Carry_1, C1_0, C2_0);

    // Bit 1
    HA_1bit HA1_1 (
        .A(A[1]),
        .B(B[1]),
        .Sum_HA(S1_1),
        .Cout_HA(C1_1)
    );

    HA_1bit HA1_2 (
        .A(S1_1),
        .B(Carry_1),
        .Sum_HA(Sum_SL[1]),
        .Cout_HA(C2_1)
    );

    // Final Carry
    or u1 (Cout_SL, C1_1, C2_1);

endmodule