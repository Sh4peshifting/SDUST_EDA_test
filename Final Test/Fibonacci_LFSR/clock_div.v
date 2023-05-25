module clock_div(input clk,
                 input rst,
                 output reg clk_out);
    
    parameter N = 26'd50_000_000 , WIDTH = 25;
    reg [WIDTH:0] counter;
    
    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            counter <= 0;
            clk_out <= 0;
        end
        else
        begin
            counter <= counter + 1;
        `ifdef SIM_SPEEDUP
            if (counter == 5-1) 
        `else
            if (counter >= N-1) 
        `endif
            begin
                clk_out <= ~clk_out;
                counter <= 0;
            end
        end
    end
    
endmodule
