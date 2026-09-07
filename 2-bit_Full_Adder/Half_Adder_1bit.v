module HA_1bit (
    input wire A,
    input wire B,
    output wire Sum_HA,
    output wire Cout_HA
);

    // Sum  = A ⊕ B
    // Cout = A · B

    xor u1 (Sum_HA, A, B);
    and u2 (Cout_HA, A, B);
    
endmodule