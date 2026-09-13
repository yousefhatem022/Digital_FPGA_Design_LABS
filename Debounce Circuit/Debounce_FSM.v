module debounce_fsm (
    input  wire clk,
    input  wire rst_n,
    input  wire sw,
    input  wire m_tick,
    output reg  debounced_sw
);

    localparam [3:0]
        ZERO    = 4'd0,
        WAIT1_1 = 4'd1,
        WAIT1_2 = 4'd2,
        WAIT1_3 = 4'd3,
        ONE     = 4'd4,
        WAIT0_1 = 4'd5,
        WAIT0_2 = 4'd6,
        WAIT0_3 = 4'd7;

    reg [3:0] current_state, next_state;

    //==================================================
    // State Register
    //==================================================
    always @(posedge clk or negedge rst_n) begin
        current_state <= (!rst_n) ? ZERO : next_state;
    end

    //==================================================
    // Next State Logic
    //==================================================
    always @(*) begin

        case (current_state)

            //==========================================
            // Stable 0
            //==========================================
            ZERO: begin
                if (sw)
                    next_state = WAIT1_1;
                else
                    next_state = ZERO;
            end

            //==========================================
            // Waiting for stable 1
            //==========================================
            WAIT1_1: begin
                if (!sw)
                    next_state = ZERO;
                else if (sw && m_tick)
                    next_state = WAIT1_2;
                else
                    next_state = WAIT1_1;
            end

            WAIT1_2: begin
                if (!sw)
                    next_state = ZERO;
                else if (sw && m_tick)
                    next_state = WAIT1_3;
                else
                    next_state = WAIT1_2;
            end

            WAIT1_3: begin
                if (!sw)
                    next_state = ZERO;
                else if (sw && m_tick)
                    next_state = ONE;
                else
                    next_state = WAIT1_3;
            end

            //==========================================
            // Stable 1
            //==========================================
            ONE: begin
                if (!sw)
                    next_state = WAIT0_1;
                else
                    next_state = ONE;
            end

            WAIT0_1: begin
                if (sw)
                    next_state = ONE;
                else if (!sw && m_tick)
                    next_state = WAIT0_2;
                else
                    next_state = WAIT0_1;
            end

            WAIT0_2: begin
                if (sw)
                    next_state = ONE;
                else if (!sw && m_tick)
                    next_state = WAIT0_3;
                else
                    next_state = WAIT0_2;
            end

            WAIT0_3: begin
                if (sw)
                    next_state = ONE;
                else if (!sw && m_tick)
                    next_state = ZERO;
                else
                    next_state = WAIT0_3;
            end

            default:
                next_state = ZERO;

        endcase
    end

    //==================================================
    // Moore Output Logic
    //==================================================
    always @(*) begin

        case (current_state)

            ONE,
            WAIT0_1,
            WAIT0_2,
            WAIT0_3:
                debounced_sw = 1'b1;

            default:
                debounced_sw = 1'b0;

        endcase

    end

endmodule