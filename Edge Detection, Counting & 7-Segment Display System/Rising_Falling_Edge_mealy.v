module rising_falling_edge_mealy (
    input wire clk,
    input wire rst_n,
    
    input wire level,
    
    output reg Rising_tick,
    output reg Falling_tick,
    output reg Edge_tick
);
    
    localparam [1:0]
        S0 = 2'b0,     //idle state
        S1 = 2'b1;     //wait_for_falling_edge 
    
    reg [1:0] prev_state, next_state;
    
    // state register
    always @(posedge clk, negedge rst_n)
        prev_state <= !rst_n ? S0 : next_state;
    
    // next-state logic
    always @(*) begin
        
        Rising_tick = 1'b0;
        Falling_tick = 1'b0;
        Edge_tick = 1'b0;

        case (prev_state)
            S0: begin
                if (level) begin
                    next_state = S1;
                    Rising_tick = 1'b1;
                    Edge_tick = 1'b1;
                end

                else begin
                    next_state = S0;
                end
            end

            S1: begin
                if (!level) begin
                    next_state = S0;
                    Falling_tick = 1'b1;
                    Edge_tick = 1'b1;
                end

                else begin
                    next_state = S1;
                end
            end

            default: 
                next_state = S0;
        endcase

    end

endmodule