`timescale 1ns/1ps

module memory_test2;

    localparam integer AWIDTH = 5;
    localparam integer DWIDTH = 8;

    reg                 clk;
    reg                 wr;
    reg                 rd;
    reg  [AWIDTH-1:0]   addr;
    wire [DWIDTH-1:0]   data;
    reg  [DWIDTH-1:0]   rdata;

    assign data = rdata;

    //==================================================
    // DUT
    //==================================================
    memory #(
        .AWIDTH(AWIDTH),
        .DWIDTH(DWIDTH)
    ) memory_inst (
        .clk  (clk),
        .wr   (wr),
        .rd   (rd),
        .addr (addr),
        .data (data)
    );

    task expect;
        input [DWIDTH-1:0] exp_data;
        if (data !== exp_data) begin
        $display("TEST FAILED");
        $display("At time %0d addr=%b data=%b", $time, addr, data);
        $display("data should be %b", exp_data);
        $finish;
        end
    else begin 
        $display("At time %0d addr=%b data=%b", $time, addr, data);
    end 
    endtask

    //==================================================
    // Task: Write Memory
    //==================================================
    task write_mem;
        input [AWIDTH-1:0] write_addr;
        input [DWIDTH-1:0] write_data;

        wr   = 1'b1;
        rd   = 1'b0;
        addr = write_addr;
        rdata = write_data;

        @(negedge clk);
    endtask

    //==================================================
    // Task: Read Memory
    //==================================================
    task read_mem;
        input [AWIDTH-1:0] read_addr;
        input [DWIDTH-1:0] expected_data;

        wr    = 1'b0;
        rd    = 1'b1;
        addr  = read_addr;
        rdata = {DWIDTH{1'bz}};

        @(negedge clk);
        expect(expected_data);
    endtask

    initial repeat (67) begin #5 clk=1; #5 clk=0; end

    //==================================================
    // Memory Verification
    //==================================================
    initial begin : TEST

        reg [AWIDTH-1:0]  test_addr;
        reg [DWIDTH-1:0]  test_data;

        // Initial values
        wr    = 1'b0;
        rd    = 1'b0;
        addr  = 'b0;
        rdata = 'bz;

        @(negedge clk);

        //================================================
        // Basic Write Tests
        //================================================
        test_addr = 0;
        test_data = -1;

        $display("Writing addr=%b data=%b", test_addr, test_data);

        write_mem(test_addr, test_data);


        test_addr = -1;
        test_data = 0;

        $display("Writing addr=%b data=%b", test_addr, test_data);

        write_mem(test_addr, test_data);

        //================================================
        // Basic Read Tests
        //================================================
        test_addr = 0;
        test_data = -1;

        $display("Reading addr=%b expected=%b", test_addr, test_data);

        read_mem(test_addr, test_data);


        test_addr = -1;
        test_data = 0;

        $display("Reading addr=%b expected=%b", test_addr, test_data);

        read_mem(test_addr, test_data);

        //================================================
        // Write Ascending Data to Descending Addresses
        //================================================
        $display("");
        $display("Writing ascending data to descending addresses");

        test_addr = -1;
        test_data = 0;

        while (test_addr) begin
            write_mem(test_addr, test_data);

            test_addr = test_addr - 1'b1;
            test_data = test_data + 1'b1;
        end

        //================================================
        // Read Ascending Data from Descending Addresses
        //================================================
        $display("");
        $display("Reading ascending data from descending addresses");

        test_addr = -1;
        test_data = 0;

        while (test_addr) begin
            read_mem(test_addr, test_data);

            test_addr = test_addr - 1'b1;
            test_data = test_data + 1'b1;
        end

        //================================================
        // Final Result
        //================================================
        $display("");
        $display("==============================================");
        $display("             MEMORY VERIFICATION              ");
        $display("==============================================");
        $display("TEST PASSED");
        $display("Errors: 0");
        $display("Warnings: 0");
        $display("==============================================");

        $finish;

    end

endmodule