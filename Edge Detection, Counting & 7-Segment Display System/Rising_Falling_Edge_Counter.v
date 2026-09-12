module rising_falling_edge_counter (
    input wire       clk,
    input wire       rst_n,
    
    input wire       R_tick,
    input wire       F_tick,
    input wire       E_tick,
    
    output reg [3:0] Rising_Count,
    output reg [3:0] Falling_Count,
    output reg [3:0] Edge_Count
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Rising_Count  <= 4'd0;
            Falling_Count <= 4'd0;
            Edge_Count    <= 4'd0;
        end
        else begin
            if (R_tick)
                Rising_Count <= Rising_Count + 1'b1;

            if (F_tick)
                Falling_Count <= Falling_Count + 1'b1;

            if (E_tick)
                Edge_Count <= Edge_Count + 1'b1;
        end
    end

endmodule