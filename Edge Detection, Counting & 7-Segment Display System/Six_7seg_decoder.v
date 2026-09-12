module six_7seg_decoder (
    input wire       rst_n,

    input wire [3:0] R_count,
    input wire [3:0] F_count,
    input wire [3:0] T_count,

    output reg [6:0] R,
    output reg [6:0] R_C,
    output reg [6:0] F,
    output reg [6:0] F_C,
    output reg [6:0] t,
    output reg [6:0] t_C
);

    wire [6:0] R_count_decoded;
    wire [6:0] F_count_decoded;
    wire [6:0] T_count_decoded;

    // Decode the three counters
    seven_seg_decoder R_DEC (
        .data_in(R_count),
        .seg_out(R_count_decoded)
    );

    seven_seg_decoder F_DEC (
        .data_in(F_count),
        .seg_out(F_count_decoded)
    );

    seven_seg_decoder T_DEC (
        .data_in(T_count),
        .seg_out(T_count_decoded)
    );

    always @(*) begin

        if (!rst_n) begin

            // Display "null"
            //       gfedcba
            R   = 7'b1001000; // n
            R_C = 7'b1000001; // u

            F   = 7'b1000111; // L
            F_C = 7'b1000111; // L

            t   = 7'b1111111; // OFF
            t_C = 7'b1111111; // OFF

        end

        else begin

            // Display labels
            R   = 7'b0001000; // R
            F   = 7'b0001110; // F
            t   = 7'b0000111; // t

            // Display counter values

            R_C = R_count_decoded;
            F_C = F_count_decoded;
            t_C = T_count_decoded;

        end

    end

endmodule