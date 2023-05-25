module lfsr ( 
	input 		clk,
	input 		rst_n,
    input wire  [7:0] sw,
	output reg 	[7:0] out			
);

always @ (posedge clk or negedge rst_n) begin
	if(!rst_n)
		out <= sw;
	else begin
        out <= {out[6:0], out[7] ^ out[5] ^ out[3]};
	end
end
endmodule