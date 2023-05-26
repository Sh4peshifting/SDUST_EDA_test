`timescale 1ns/100ps

module fsm_tb();
    
    reg clk, rst, input_sig;
    wire out;
    
    fsm dut (
    .clk(clk),
    .rst(rst),
    .input_sig(input_sig),
    .out(out)
    );
    
    initial begin
        $dumpfile("wave.vcd"); //生成的vcd文件名称
        $dumpvars(0, fsm_tb); //tb模块名称
    end
    
    initial begin
        clk = 0;
        repeat(20)begin
            #5 clk = ~clk;
        end
    end
    
    initial begin
        rst       = 1;
        input_sig = 0;
        #10 rst   = 0;
    end
    
    initial begin
        #20 input_sig = 1;
        #10 input_sig = 1;
        #10 input_sig = 0;
    end
endmodule
    
    
