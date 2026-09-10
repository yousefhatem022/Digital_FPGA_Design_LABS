module Rising_Edge_mealy (
    input wire clk,
    input wire rst,
    input wire level,
    
    output reg tick
);
    
    localparam [1:0]
        S0 = 2'b0,     //idle state
        S1 = 2'b1;     //wait_for_falling_edge 
    
    reg [1:0] prev_state, next_state;
    
    // state register
    always @(posedge clk, posedge rst)
        prev_state <= rst ? S0 : next_state;
    
    // next-state logic
    always @(*) begin
        
        tick = 1'b0;

        case (prev_state)
            S0: begin
                if (level) begin
                    next_state = S1;
                    tick = 1'b1;
                end

                else begin
                    next_state = S0;
                end
            end

            S1: next_state = !level ? S0 : S1;

            default: 
                next_state = S0;
        endcase

    end

endmodule