module clk_divider #(
    parameter integer TICK_CYCLES = 5
)(
    input  wire clk,
    input  wire rst_n,
    output reg m_tick
);

    // Counter width
    localparam integer COUNT_WIDTH = $clog2(TICK_CYCLES);
    reg [COUNT_WIDTH-1:0] count;

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            count  <= {COUNT_WIDTH{1'b0}};
            m_tick <= 1'b0;
        end

        else begin

            if (count == TICK_CYCLES - 1) begin
                count  <= {COUNT_WIDTH{1'b0}};
                m_tick <= 1'b1;
            end

            else begin
                count  <= count + 1'b1;
                m_tick <= 1'b0;
            end

        end

    end

endmodule