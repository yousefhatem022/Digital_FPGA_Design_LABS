module Rising_Edge_moore (
    input wire clk,
    input wire rst,
    input wire level,
    
    output reg tick
);
    
    localparam [1:0]
        S0 = 2'b00,     //wait_for_rising_edge
        S1 = 2'b01,     //pulse / rising_edge_detected
        S2 = 2'b10;     //wait_for_falling_edge
    
    reg [1:0] prev_state, next_state;
    
    // state register
    always @(posedge clk, posedge rst)
        prev_state <= rst ? S0 : next_state;
    
    // next-state logic
    always @(*) begin
        case (prev_state)
            S0: next_state = level ? S1 : S0;

            S1: next_state = S2;

            S2: next_state = !level ? S0 : S2;

            default: 
                next_state = S0;
        endcase

    end

    //moore output logic
    always @(*) begin
        tick = (prev_state == S1);
    end

endmodule