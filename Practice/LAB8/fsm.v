`timescale 1ns/100ps

module fsm (input wire clk, rst, input_sig, output wire out);
reg [3:0] state, next_state;
parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;

assign out = (state[S3]);

always @ (posedge clk or posedge rst )
    if (rst)
        state <= #1 4'b0001; // S0 the initial state
    else
        state <= #1 next_state;

always @ (state or input_sig)
begin
    next_state = 4'b0000;
    case (1'b1)
        state [S0]:
            if(input_sig)
                next_state [S1] = 1'b1;
            else
                next_state [S0] = 1'b1;
        state [S1]:
            if(input_sig)
                next_state [S2] = 1'b1;
            else
                next_state [S0] = 1'b1;
		state [S2]:
            if(!input_sig)
                next_state [S3] = 1'b1;
            else
                next_state [S2] = 1'b1;
        state [S3]:
		    if(input_sig)
                next_state [S1] = 1'b1;
            else
                next_state [S0] = 1'b1;
        default:
            next_state [S0] = 1'b1;
    endcase
end
endmodule
