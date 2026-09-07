module binary_to_7seg (
    input  wire [3:0] binary_in,
    output reg  [6:0] seg_out
);

    always @(*) begin
        case (binary_in)
            
            //7 segments pattern 
            //                 abcdefg                 
            4'h0: seg_out = 7'b0000001;
            4'h1: seg_out = 7'b1001111;
            4'h2: seg_out = 7'b0010010;
            4'h3: seg_out = 7'b0000110;
            4'h4: seg_out = 7'b1001100;
            4'h5: seg_out = 7'b0100100;
            4'h6: seg_out = 7'b0100000;
            4'h7: seg_out = 7'b0001111;
            4'h8: seg_out = 7'b0000000;
            4'h9: seg_out = 7'b0000100;

            4'hA: seg_out = 7'b0001000;
            4'hB: seg_out = 7'b1100000;
            4'hC: seg_out = 7'b0110001;
            4'hD: seg_out = 7'b1000010;
            4'hE: seg_out = 7'b0110000;
            4'hF: seg_out = 7'b0111000;

            default: seg_out = 7'b1111111;

        endcase
    end

endmodule