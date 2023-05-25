module counter(
    input wire clk,
    input wire rst,
    input wire pause,
    output reg [11:0] counter_ms,
    output reg [7:0] counter_sec,
    output reg [3:0] counter_min
);

reg [15:0] prescaler;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        counter_ms <= 12'b0;
        counter_sec <= 8'b0;
        counter_min <= 4'b0;
        prescaler <= 16'b0;
    end else if (!pause) begin
        prescaler <= prescaler + 1;
        if (prescaler == 50000) begin
            prescaler <= 16'b0;
            counter_ms <= counter_ms + 1;
            if (counter_ms == 1000) begin
                counter_ms <= 12'b0;
                counter_sec <= counter_sec + 1;
                if (counter_sec == 60) begin
                    counter_sec <= 8'b0;
                    counter_min <= counter_min + 1;
                    if (counter_min == 10) begin
                        counter_min <= 4'b0;
                    end
                end
            end
        end
    end
end

endmodule
