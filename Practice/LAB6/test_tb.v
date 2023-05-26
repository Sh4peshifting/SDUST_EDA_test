`timescale 1ns/100ps
module test_tb();
    reg clk;
    reg rst;
    reg  [1:0]  op;
    reg  [2:0] A,B,Zexpected;
    wire [2:0]   Z;
    reg  [31:0] vectornum, errors;
    reg  [10:0]  testvectors[10000:0];
    // instantiate device under test
    test test(clk, rst, op, A, B, Z);
    
    initial
    begin
        clk = 0;
        rst = 1;
        $dumpfile ("dump.vcd");
        $dumpvars;
    end
    
    initial begin
        clk = 0;
        repeat(20)begin
            #1 clk = ~clk;
        end
    end
    
    initial
    begin
        
        $readmemb("example.tv", testvectors);
        vectornum = 0; errors = 0;
        repeat(10) begin
            #1;
            {op,A,B,Zexpected} = testvectors[vectornum];
            #1;
            if (Z !== Zexpected) begin
                $display("Error: inputs = %b", {op,A,B});
                $display("  outputs     = %b (%b expected)", Z, Zexpected);
                errors                  = errors + 1;
            end
            
            vectornum = vectornum + 1;
            if (testvectors[vectornum] === 10'bx) begin
                $display("%d tests completed with %d errors", vectornum, errors);
                #10  $stop;
            end
        end
    end
endmodule
