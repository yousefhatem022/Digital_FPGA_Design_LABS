module controller (
    input  wire [2:0] opcode ,
    input  wire [2:0] phase  ,
    input  wire       zero   ,

    output reg        sel    ,  // select instruction address to memory
    output reg        rd     ,  // enable memory output onto data bus
    output reg        ld_ir  ,  // load instruction register
    output reg        halt   ,  // halt machine
    output reg        inc_pc ,  // increment program counter
    output reg        ld_ac  ,  // load accumulator from data bus
    output reg        wr     ,  // write data bus to memory
    output reg        ld_pc  ,  // load program counter
    output reg        data_e    // enable accumulator output onto data bus
);

    wire ALUOP;
    wire HALT;
    wire SKZ;
    wire JMP;
    wire STO;

    assign ALUOP = (opcode == 3'b010) || (opcode == 3'b011) || (opcode == 3'b100) || (opcode == 3'b101); // ADD, AND, XOR or LDA
    assign HALT  = (opcode == 3'b000);
    assign SKZ   = (opcode == 3'b001);
    assign STO   = (opcode == 3'b110);
    assign JMP   = (opcode == 3'b111);
    
    always @(*) begin
        
        case (phase)
            3'd0: {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} = 9'b100000000;
            3'd1: {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} = 9'b110000000;
            3'd2: {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} = 9'b111000000;
            3'd3: {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} = 9'b111000000;

            3'd4: {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} = {3'b000, HALT, 5'b10000};
            3'd5: {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} = {1'b0, ALUOP, 7'b0000000};
            3'd6: {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} = {1'b0, ALUOP, 2'b00, SKZ&&zero, 1'b0, JMP, 1'b0, STO};
            3'd7: {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} = {1'b0, ALUOP, 3'b000, ALUOP, JMP, {2{STO}}};
        endcase
    
    end


endmodule