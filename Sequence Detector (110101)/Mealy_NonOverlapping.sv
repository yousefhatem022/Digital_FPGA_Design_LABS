module mealy_nonoverlapping (
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
        S5 = 3'b101     // Detected '11010'
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
    // Next State + Output Logic
    //========================================
    always @(*) begin

        case (current_state)

            //================================
            // S0: No match
            //================================
            S0: begin
                if (in) begin
                    next_state = S1;
                    out = 1'b0;
                end
                else begin
                    next_state = S0;
                    out = 1'b0;
                end
            end

            //================================
            // S1: Detected "1"
            //================================
            S1: begin
                if (in) begin
                    next_state = S2;
                    out = 1'b0;
                end
                else begin
                    next_state = S0;
                    out = 1'b0;
                end
            end

            //================================
            // S2: Detected "11"
            //================================
            S2: begin
                if (in) begin
                    next_state = S2;
                    out = 1'b0;
                end
                else begin
                    next_state = S3;
                    out = 1'b0;
                end
            end

            //================================
            // S3: Detected "110"
            //================================
            S3: begin
                if (in) begin
                    next_state = S4;
                    out = 1'b0;
                end
                else begin
                    next_state = S0;
                    out = 1'b0;
                end
            end

            //================================
            // S4: Detected "1101"
            //================================
            S4: begin
                if (in) begin
                    next_state = S2;
                    out = 1'b0;
                end
                else begin
                    next_state = S5;
                    out = 1'b0;
                end
            end

            //================================
            // S5: Detected "11010"
            // Non-Overlapping:After detecting 110101, restart from S0
            //================================
            S5: begin
                if (in) begin
                    // 110101 detected
                    next_state = S0;
                    out = 1'b1;
                end
                else begin
                    next_state = S0;
                    out = 1'b0;
                end
            end

            //================================
            // Default values
            //================================
            default: begin
                next_state = S0;
                out = 1'b0;
            end

        endcase
    end

endmodule