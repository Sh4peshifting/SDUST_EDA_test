module top (
  input wire clk_50m,
  input wire rst_n,
  input wire [7:0] sw,
  output wire [6:0] hex0,
  output wire [6:0] hex1,
  output wire [6:0] hex2,
  output wire [6:0] hex3,
  output wire [6:0] hex4,
  output wire [6:0] hex5
);

wire clk;
reg  [15:0] num;

clock_div clk_inst (
  .clk(clk_50m),
  .rst(rst_n),
  .clk_out(clk)
);

wire [7:0] lfsr_out;
lfsr  lfsr_inst (
  .clk(clk),
  .rst_n(rst_n),
  .sw(sw),
  .out(lfsr_out)
);

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    num <= 0;
  end
  else begin
    num <= num + 1;
  end  
end



// 数码管驱动模块实例化
SEG7_LUT hex_disp_inst0 (hex0, lfsr_out[3:0]);
SEG7_LUT hex_disp_inst1 (hex1, lfsr_out[7:4]);
SEG7_LUT hex_disp_inst2 (hex2, num[3:0]);
SEG7_LUT hex_disp_inst3 (hex3, num[7:4]);
SEG7_LUT hex_disp_inst4 (hex4, sw[3:0]);
SEG7_LUT hex_disp_inst5 (hex5, sw[7:4]);

endmodule