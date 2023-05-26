module test (clk, rst, op, A, B, Z);
input clk;
input rst;
input [1:0] op;
input [2:0] A;
input [2:0] B;
output reg [2:0] Z;

always @(posedge clk or negedge rst)
begin
	if(~rst)begin
		Z <= 3'b000;
	end
	else begin
		case (op)
			2'b00 : Z <= A + B;
			2'b01 : Z <= A - B;
			2'b10 : Z <= A & B;
			2'b11 : Z <= A | B;
		endcase
	end
end

endmodule
