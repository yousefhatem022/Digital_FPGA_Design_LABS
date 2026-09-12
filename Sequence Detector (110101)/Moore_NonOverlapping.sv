module moore_nonoverlapping (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       in,
    output reg        out
);

    // State encoding
    typedef enum logic [2:0] {
        S0 = 3'b000,    // Initial state
        S1 = 3'b001,    // Detected '1'
        S2 = 3'b010,    // Detected '11'
        S3 = 3'b011,    // Detected '110'
        S4 = 3'b100,    // Detected '1101'
        S5 = 3'b101,    // Detected '11010'
        S6 = 3'b110     // Detected '110101'
    } state_t;

    state_t current_state, next_state;

    //========================================
    // State Register
    //========================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    //========================================
    // Next State Logic
    //========================================
    always @(*) begin

        case (current_state)

            S0: next_state = in ? S1 : S0;

            S1: next_state = in ? S2 : S0;

            S2: next_state = in ? S2 : S3;

            S3: next_state = in ? S4 : S0;

            S4: next_state = in ? S2 : S5;

            S5: next_state = in ? S6 : S0;

            // Non-Overlapping:After detecting 110101, restart from S0
            S6: next_state = in ? S0 : S0;

            default:
                next_state = S0;

        endcase

    end

    //========================================
    // Moore Output Logic
    //========================================
    always @(*) begin

        out = (current_state == S6) ? 1'b1 : 1'b0;

    end

endmodule