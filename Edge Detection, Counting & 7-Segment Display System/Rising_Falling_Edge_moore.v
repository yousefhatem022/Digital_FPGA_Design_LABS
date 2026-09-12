module rising_falling_edge_moore (
    input wire clk,
    input wire rst_n,

    input wire level,
    
    output reg Rising_tick,
    output reg Falling_tick,
    output reg Edge_tick
);
    
    localparam [1:0]
        S0 = 2'b00,     // wait_for_rising_edge
        S1 = 2'b01,     // rising_edge_detected
        S2 = 2'b10,     // wait_for_falling_edge
        S3 = 2'b11;     // falling_edge_detected
    
    reg [1:0] prev_state, next_state;
    
    // State register
    always @(posedge clk or negedge rst_n) begin
        prev_state <= !rst_n ? S0 : next_state;
    end
    
    // Next-state logic
    always @(*) begin
        case (prev_state)

            S0: next_state = level ? S1 : S0;

            S1: next_state = level ? S2 : S3;

            S2: next_state = !level ? S3 : S2;

            S3: next_state = !level ? S0 : S1;

            default:
                next_state = S0;

        endcase
    end

    // Moore output logic
    always @(*) begin
        Rising_tick  = (prev_state == S1);
        Falling_tick = (prev_state == S3);
        Edge_tick    = Rising_tick | Falling_tick;
    end

endmodule