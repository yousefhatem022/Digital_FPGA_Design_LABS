module memory #(
    parameter AWIDTH = 5,
    parameter DWIDTH = 8
)(
    input  wire              clk,
    input  wire              wr,
    input  wire              rd,
    input  wire [AWIDTH-1:0] addr,
    inout  wire [DWIDTH-1:0] data
);

    // Memory array
    reg [DWIDTH-1:0] mem [0:(1<<AWIDTH)-1];

    // Internal data register for write
    reg [DWIDTH-1:0] data_in;

    //==================================================
    // Memory Write
    //==================================================
    always @(posedge clk) begin
        if (wr)
            mem[addr] <= data;
    end

    //==================================================
    // Memory Read
    //==================================================
    assign data = rd ? mem[addr] : {DWIDTH{1'bz}};

endmodule