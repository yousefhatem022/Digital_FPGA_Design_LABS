module tb;

    // Testbench inputs
    reg [1:0] A_tb;
    reg [1:0] B_tb;
    reg       Cin_tb;

    // Outputs of Gate-Level 2-bit Full Adder
    wire [1:0] Sum_GL;
    wire       Cout_GL;

    // Outputs of Structural 2-bit Full Adder
    wire [1:0] Sum_SL;
    wire       Cout_SL;

    // Outputs of Behavioral 2-bit Full Adder
    wire [1:0] Sum_BL;
    wire       Cout_BL;

    // Gate-Level Full Adder
    FA_2bit_GL GL (
        .A(A_tb),
        .B(B_tb),
        .Cin(Cin_tb),
        .Sum_GL(Sum_GL),
        .Cout_GL(Cout_GL)
    );

    // Structural Full Adder
    FA_2bit_SL SL (
        .A(A_tb),
        .B(B_tb),
        .Cin(Cin_tb),
        .Sum_SL(Sum_SL),
        .Cout_SL(Cout_SL)
    );

    // Behavioral Full Adder
    FA_2bit_BL BL (
        .A(A_tb),
        .B(B_tb),
        .Cin(Cin_tb),
        .Sum_BL(Sum_BL),
        .Cout_BL(Cout_BL)
    );

    initial begin

        // Cin = 0
        Cin_tb = 0;

        A_tb = 2'b00; B_tb = 2'b00; #10;
        $display("----------------------------------------------------------------");
        $display("Input                     : A = %b, B = %b, Cin = %b", A_tb, B_tb, Cin_tb);
        $display("Gate-Level Output         : Sum = %b, Cout = %b", Sum_GL, Cout_GL);
        $display("Structural-Level Output   : Sum = %b, Cout = %b", Sum_SL, Cout_SL);
        $display("Behavioral-Level Output   : Sum = %b, Cout = %b", Sum_BL, Cout_BL);

        A_tb = 2'b00; B_tb = 2'b01; #10;
        $display("----------------------------------------------------------------");
        $display("Input                     : A = %b, B = %b, Cin = %b", A_tb, B_tb, Cin_tb);
        $display("Gate-Level Output         : Sum = %b, Cout = %b", Sum_GL, Cout_GL);
        $display("Structural-Level Output   : Sum = %b, Cout = %b", Sum_SL, Cout_SL);
        $display("Behavioral-Level Output   : Sum = %b, Cout = %b", Sum_BL, Cout_BL);

        A_tb = 2'b00; B_tb = 2'b10; #10;
        $display("----------------------------------------------------------------");
        $display("Input                     : A = %b, B = %b, Cin = %b", A_tb, B_tb, Cin_tb);
        $display("Gate-Level Output         : Sum = %b, Cout = %b", Sum_GL, Cout_GL);
        $display("Structural-Level Output   : Sum = %b, Cout = %b", Sum_SL, Cout_SL);
        $display("Behavioral-Level Output   : Sum = %b, Cout = %b", Sum_BL, Cout_BL);

        A_tb = 2'b00; B_tb = 2'b11; #10;
        $display("----------------------------------------------------------------");
        $display("Input                     : A = %b, B = %b, Cin = %b", A_tb, B_tb, Cin_tb);
        $display("Gate-Level Output         : Sum = %b, Cout = %b", Sum_GL, Cout_GL);
        $display("Structural-Level Output   : Sum = %b, Cout = %b", Sum_SL, Cout_SL);
        $display("Behavioral-Level Output   : Sum = %b, Cout = %b", Sum_BL, Cout_BL);

        A_tb = 2'b01; B_tb = 2'b00; #10;
        $display("----------------------------------------------------------------");
        $display("Input                     : A = %b, B = %b, Cin = %b", A_tb, B_tb, Cin_tb);
        $display("Gate-Level Output         : Sum = %b, Cout = %b", Sum_GL, Cout_GL);
        $display("Structural-Level Output   : Sum = %b, Cout = %b", Sum_SL, Cout_SL);
        $display("Behavioral-Level Output   : Sum = %b, Cout = %b", Sum_BL, Cout_BL);

        A_tb = 2'b01; B_tb = 2'b01; #10;
        $display("----------------------------------------------------------------");
        $display("Input                     : A = %b, B = %b, Cin = %b", A_tb, B_tb, Cin_tb);
        $display("Gate-Level Output         : Sum = %b, Cout = %b", Sum_GL, Cout_GL);
        $display("Structural-Level Output   : Sum = %b, Cout = %b", Sum_SL, Cout_SL);
        $display("Behavioral-Level Output   : Sum = %b, Cout = %b", Sum_BL, Cout_BL);

        A_tb = 2'b01; B_tb = 2'b10; #10;
        $display("----------------------------------------------------------------");
        $display("Input                     : A = %b, B = %b, Cin = %b", A_tb, B_tb, Cin_tb);
        $display("Gate-Level Output         : Sum = %b, Cout = %b", Sum_GL, Cout_GL);
        $display("Structural-Level Output   : Sum = %b, Cout = %b", Sum_SL, Cout_SL);
        $display("Behavioral-Level Output   : Sum = %b, Cout = %b", Sum_BL, Cout_BL);

        A_tb = 2'b01; B_tb = 2'b11; #10;
        $display("----------------------------------------------------------------");
        $display("Input                     : A = %b, B = %b, Cin = %b", A_tb, B_tb, Cin_tb);
        $display("Gate-Level Output         : Sum = %b, Cout = %b", Sum_GL, Cout_GL);
        $display("Structural-Level Output   : Sum = %b, Cout = %b", Sum_SL, Cout_SL);
        $display("Behavioral-Level Output   : Sum = %b, Cout = %b", Sum_BL, Cout_BL);

        A_tb = 2'b10; B_tb = 2'b00; #10;
        $display("----------------------------------------------------------------");
        $display("Input                     : A = %b, B = %b, Cin = %b", A_tb, B_tb, Cin_tb);
        $display("Gate-Level Output         : Sum = %b, Cout = %b", Sum_GL, Cout_GL);
        $display("Structural-Level Output   : Sum = %b, Cout = %b", Sum_SL, Cout_SL);
        $display("Behavioral-Level Output   : Sum = %b, Cout = %b", Sum_BL, Cout_BL);

        A_tb = 2'b10; B_tb = 2'b01; #10;
        $display("----------------------------------------------------------------");
        $display("Input                     : A = %b, B = %b, Cin = %b", A_tb, B_tb, Cin_tb);
        $display("Gate-Level Output         : Sum = %b, Cout = %b", Sum_GL, Cout_GL);
        $display("Structural-Level Output   : Sum = %b, Cout = %b", Sum_SL, Cout_SL);
        $display("Behavioral-Level Output   : Sum = %b, Cout = %b", Sum_BL, Cout_BL);

        A_tb = 2'b10; B_tb = 2'b10; #10;
        $display("----------------------------------------------------------------");
        $display("Input                     : A = %b, B = %b, Cin = %b", A_tb, B_tb, Cin_tb);
        $display("Gate-Level Output         : Sum = %b, Cout = %b", Sum_GL, Cout_GL);
        $display("Structural-Level Output   : Sum = %b, Cout = %b", Sum_SL, Cout_SL);
        $display("Behavioral-Level Output   : Sum = %b, Cout = %b", Sum_BL, Cout_BL);

        A_tb = 2'b10; B_tb = 2'b11; #10;
        $display("----------------------------------------------------------------");
        $display("Input                     : A = %b, B = %b, Cin = %b", A_tb, B_tb, Cin_tb);
        $display("Gate-Level Output         : Sum = %b, Cout = %b", Sum_GL, Cout_GL);
        $display("Structural-Level Output   : Sum = %b, Cout = %b", Sum_SL, Cout_SL);
        $display("Behavioral-Level Output   : Sum = %b, Cout = %b", Sum_BL, Cout_BL);

        A_tb = 2'b11; B_tb = 2'b00; #10;
        $display("----------------------------------------------------------------");
        $display("Input                     : A = %b, B = %b, Cin = %b", A_tb, B_tb, Cin_tb);
        $display("Gate-Level Output         : Sum = %b, Cout = %b", Sum_GL, Cout_GL);
        $display("Structural-Level Output   : Sum = %b, Cout = %b", Sum_SL, Cout_SL);
        $display("Behavioral-Level Output   : Sum = %b, Cout = %b", Sum_BL, Cout_BL);

        A_tb = 2'b11; B_tb = 2'b01; #10;
        $display("----------------------------------------------------------------");
        $display("Input                     : A = %b, B = %b, Cin = %b", A_tb, B_tb, Cin_tb);
        $display("Gate-Level Output         : Sum = %b, Cout = %b", Sum_GL, Cout_GL);
        $display("Structural-Level Output   : Sum = %b, Cout = %b", Sum_SL, Cout_SL);
        $display("Behavioral-Level Output   : Sum = %b, Cout = %b", Sum_BL, Cout_BL);

        A_tb = 2'b11; B_tb = 2'b10; #10;
        $display("----------------------------------------------------------------");
        $display("Input                     : A = %b, B = %b, Cin = %b", A_tb, B_tb, Cin_tb);
        $display("Gate-Level Output         : Sum = %b, Cout = %b", Sum_GL, Cout_GL);
        $display("Structural-Level Output   : Sum = %b, Cout = %b", Sum_SL, Cout_SL);
        $display("Behavioral-Level Output   : Sum = %b, Cout = %b", Sum_BL, Cout_BL);

        A_tb = 2'b11; B_tb = 2'b11; #10;
        $display("----------------------------------------------------------------");
        $display("Input                     : A = %b, B = %b, Cin = %b", A_tb, B_tb, Cin_tb);
        $display("Gate-Level Output         : Sum = %b, Cout = %b", Sum_GL, Cout_GL);
        $display("Structural-Level Output   : Sum = %b, Cout = %b", Sum_SL, Cout_SL);
        $display("Behavioral-Level Output   : Sum = %b, Cout = %b", Sum_BL, Cout_BL);

        // Cin = 1
        Cin_tb = 1;

        A_tb = 2'b00; B_tb = 2'b00; #10;
        $display("----------------------------------------------------------------");
        $display("Input                     : A = %b, B = %b, Cin = %b", A_tb, B_tb, Cin_tb);
        $display("Gate-Level Output         : Sum = %b, Cout = %b", Sum_GL, Cout_GL);
        $display("Structural-Level Output   : Sum = %b, Cout = %b", Sum_SL, Cout_SL);
        $display("Behavioral-Level Output   : Sum = %b, Cout = %b", Sum_BL, Cout_BL);

        A_tb = 2'b01; B_tb = 2'b01; #10;
        $display("----------------------------------------------------------------");
        $display("Input                     : A = %b, B = %b, Cin = %b", A_tb, B_tb, Cin_tb);
        $display("Gate-Level Output         : Sum = %b, Cout = %b", Sum_GL, Cout_GL);
        $display("Structural-Level Output   : Sum = %b, Cout = %b", Sum_SL, Cout_SL);
        $display("Behavioral-Level Output   : Sum = %b, Cout = %b", Sum_BL, Cout_BL);

        A_tb = 2'b10; B_tb = 2'b10; #10;
        $display("----------------------------------------------------------------");
        $display("Input                     : A = %b, B = %b, Cin = %b", A_tb, B_tb, Cin_tb);
        $display("Gate-Level Output         : Sum = %b, Cout = %b", Sum_GL, Cout_GL);
        $display("Structural-Level Output   : Sum = %b, Cout = %b", Sum_SL, Cout_SL);
        $display("Behavioral-Level Output   : Sum = %b, Cout = %b", Sum_BL, Cout_BL);

        A_tb = 2'b11; B_tb = 2'b11; #10;
        $display("----------------------------------------------------------------");
        $display("Input                     : A = %b, B = %b, Cin = %b", A_tb, B_tb, Cin_tb);
        $display("Gate-Level Output         : Sum = %b, Cout = %b", Sum_GL, Cout_GL);
        $display("Structural-Level Output   : Sum = %b, Cout = %b", Sum_SL, Cout_SL);
        $display("Behavioral-Level Output   : Sum = %b, Cout = %b", Sum_BL, Cout_BL);

        $finish;

    end

endmodule
