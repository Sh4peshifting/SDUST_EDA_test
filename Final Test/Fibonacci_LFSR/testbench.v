`timescale 1ns/1ns
module testbench;
reg clk_50m;
reg rst_n;
reg [7:0] sw;
wire [6:0] hex0, hex1, hex2, hex3, hex4, hex5;

top top_inst (
    .clk_50m(clk_50m),
    .rst_n(rst_n),
    .sw(sw),
    .hex0(hex0),
    .hex1(hex1),
    .hex2(hex2),
    .hex3(hex3),
    .hex4(hex4),
    .hex5(hex5)
  );

initial 
begin
        rst_n       = 1'b0;
        sw = 8'b1;
        #10 clk_50m     = 1'b0;
            rst_n       = 1'b1;
    repeat(280)
    begin
        #10 clk_50m = ~clk_50m;
    end
end

integer i;
initial begin
    $display("Time\tHEX5\tHEX4\tHEX3\tHEX2\tHEX1\tHEX0");
    #1; 
    $display("%3ds\t%h\t%h\t%h\t%h\t%h\t%h",
                $time/100, sw[7:4], sw[3:0], 
                dt_translate(hex3), dt_translate(hex2), dt_translate(hex1), dt_translate(hex0));
    for (i = 0; i < 14; i=i+1) begin
      #200;
      $display("%3ds\t%h\t%h\t%h\t%h\t%h\t%h",
               $time/100, sw[7:4], sw[3:0], 
               dt_translate(hex3), dt_translate(hex2), dt_translate(hex1), dt_translate(hex0));
    end
    
end

/*------------ translate function -------*/
function [3:0] dt_translate;
    input [6:0]   data;
    begin
    case(data)
        7'b1000000: dt_translate = 4'h0;
        7'b1111001: dt_translate = 4'h1;
        7'b0100100: dt_translate = 4'h2;
        7'b0110000: dt_translate = 4'h3;
        7'b0011001: dt_translate = 4'h4;
        7'b0010010: dt_translate = 4'h5;
        7'b0000010: dt_translate = 4'h6;
        7'b1111000: dt_translate = 4'h7;
        7'b0000000: dt_translate = 4'h8;
        7'b0011000: dt_translate = 4'h9;
        7'b0001000: dt_translate = 4'ha;
        7'b0000011: dt_translate = 4'hb;
        7'b1000110: dt_translate = 4'hc;
        7'b0100001: dt_translate = 4'hd;
        7'b0000110: dt_translate = 4'he;
        7'b0001110: dt_translate = 4'hf; 
        default: dt_translate = 4'h0;
    endcase
    end
endfunction

endmodule