module stopwatch (clk_50M, rst, pause, oSEG_min, oSEG_sec2, oSEG_sec1, oSEG_ms3, oSEG_ms2, oSEG_ms1);
input clk_50M;
input rst;
input pause;
output wire [6:0] oSEG_min;
output wire [6:0] oSEG_sec2;
output wire [6:0] oSEG_sec1;
output wire [6:0] oSEG_ms3;
output wire [6:0] oSEG_ms2;
output wire [6:0] oSEG_ms1;

wire [11:0] ms;
wire [7:0] sec;
wire [3:0] min;

wire [3:0] ms2,ms1,ms0;
wire [3:0] sec1,sec0;
wire [3:0] min0;

reg stopwatch_resume_flag;
reg stopwatch_resume_flag_d;

counter cnt(clk_50M,rst,stopwatch_resume_flag,ms,sec,min);
SEG7_LUT seg7_min(oSEG_min,min0);
SEG7_LUT seg7_sec2(oSEG_sec2,sec1);
SEG7_LUT seg7_sec1(oSEG_sec1,sec0);
SEG7_LUT seg7_ms3(oSEG_ms3,ms2);
SEG7_LUT seg7_ms2(oSEG_ms2,ms1);
SEG7_LUT seg7_ms1(oSEG_ms1,ms0);

always @ (posedge clk_50M or negedge rst)
begin
    if (!rst) begin
        stopwatch_resume_flag <= 1'b0;
        stopwatch_resume_flag_d <= 1'b1;
    end
    else begin
        stopwatch_resume_flag_d <= pause;
        if (stopwatch_resume_flag_d && (~pause)) begin
            stopwatch_resume_flag <= ~stopwatch_resume_flag;
        end
    end
end

assign min0 = min;
assign sec1 = sec /10;
assign sec0 = sec %10;
assign ms2 = ms /100;
assign ms1 = (ms %100) /10;
assign ms0 = ms %10;

endmodule