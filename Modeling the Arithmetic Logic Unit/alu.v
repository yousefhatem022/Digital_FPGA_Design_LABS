module alu #(
    parameter WIDTH=8 
) (
    input  wire [WIDTH-1:0] in_a    ,
    input  wire [WIDTH-1:0] in_b    ,
    input  wire [2:0]       opcode  ,

    output wire [WIDTH-1:0] alu_out ,
    output wire             a_is_zero
);
    
    assign a_is_zero = (in_a == {WIDTH{1'b0}});
    
    assign alu_out = (opcode==3'b000) ? in_a :
                     (opcode==3'b001) ? in_a :
                     (opcode==3'b010) ? (in_a + in_b) :
                     (opcode==3'b011) ? (in_a & in_b) :
                     (opcode==3'b100) ? (in_a ^ in_b) :
                     (opcode==3'b101) ? in_b :
                     (opcode==3'b110) ? in_a :
                                        in_a ;

endmodule