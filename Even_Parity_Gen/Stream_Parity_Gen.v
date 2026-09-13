module stream_parity_gen (
    input  wire clk,
    input  wire reset,
    input  wire serial_in,
    output reg  parity_out,
    output reg  valid
);

    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    //==================================================
    // Function 1: Shift Function
    //==================================================
    function  [7:0] shift_data;
        input [7:0] data;
        input       serial_bit;

        begin
            shift_data = {data[6:0], serial_bit};
        end
    endfunction

    //==================================================
    // Function 2: Even Parity Generator
    //==================================================
    function parity_gen;
        input [7:0] data;

        begin
            parity_gen = ^data;
        end
    endfunction

    //==================================================
    // Sequential Logic
    //==================================================
    always @(posedge clk) begin

        if (reset) begin
            shift_reg  <= 8'b0;
            bit_count  <= 3'b0;
            parity_out <= 1'b0;
            valid      <= 1'b0;
        end

        else begin

            valid <= 1'b0;

            if (bit_count == 3'd7) begin

                // 8th bit received
                shift_reg <= shift_data(shift_reg, serial_in);
                parity_out <= parity_gen( shift_data(shift_reg, serial_in) );

                bit_count <= 3'b0;
                valid <= 1'b1;

            end
            else begin
                shift_reg <= shift_data(shift_reg, serial_in);
                bit_count <= bit_count + 1'b1;
            end

        end

    end

endmodule