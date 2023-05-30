# EDA复习大纲
## 名词解释  
1. EDA : **Electronic Design Automation**  电子设计自动化  
2. HDL : **Hardware Description Language**  
    硬件描述语言   具有特殊结构能够对硬件逻辑电路的功能进行描述的一种高级编程语言   
4. RTL : **Register Transfer Level** 寄存器传输  
5. FPGA : **Filed Programmable Gate Array**  现场可编程门阵列   
6. VHDL :  **Very-High-Speed Integrated Circuit Hardware Description Language**  
7. PLD : **Programmable Logic Device** 可编程逻辑器件
8. CPLD : Complex Programmable Logic Device 复杂可编程逻辑器件  
9. **乘积项**（*PLD* 技术特点）：  product term  
10. **查找表**（*FPGA* 技术特点）：LUT (Look-Up Table)  
11. 设计：design  
12. 验证：capture  
13. 综合：**Synthesis**   
综合就是把HDL语言/原理图转换成综合网表的过程，是将设计转化为FPGA可以读懂的配置文件 
14. 仿真: **Simulation**  
15. 锁存器：Latch  
16. DUT : **Device/Design Under Test**  
17. 时序电路：**sequential circuit**  
18. 组合电路：**combinational circuit**  
19. Decoder : **译码器**  
20. Tri-state output : 三态输出  
21. FSM: **finite state machine**  
***
## 语法
1. Verilog 采用的是**四值逻辑**系统，信号可取值范围为: **0, 1, x, z**  
2. verilog中**连续赋值**语句关键字是：***assign***，为***wire***类型信号赋值  
两个过程赋值语句关键字是 ***initial***(不可综合), ***always***
3. ***always***表达**组合逻辑**时，***LHS***变量不能是***wire***
### 操作符
4. 算术操作符  
    - 操作数做为一个整体值对待
    - 若任何一个操作数含X/Z，结果为X
    - 若结果与操作数信号同样宽度，则进位丢失
    ```verilog
    $display ( -3 * 5 ); // -15
    $display ( -3 / 2 ); // -1
    $display ( -3 % 2 ); // -1
    $display ( -3 + 2 ); // -1
    $display ( 2 - 3 ); // -1
    $displayh ( 32'hfffffffd / 2 ); // 7ffffffe
    $displayb ( 2 * 1'bx); // xx...(32位x)
    ```
5. 按位操作符
    - 对操作数的每一比特进行操作
    - 结果宽度与最宽操作数相同
    - 若宽度不同，则左扩展补全
    ```verilog
    $displayb ( 4'b01zx & 4'b0000 ); // 0000
    $displayb ( 4'b01zx & 4'b1100 ); // 0100
    $displayb ( 4'b01zx & 4'b1111 ); // 01xx
    $displayb ( 4'b01zx | 4'b1111 ); // 1111
    $displayb ( 4'b01zx | 4'b0011 ); // 0111
    $displayb ( 4'b01zx | 4'b0000 ); // 01xx
    $displayb ( 4'b01zx ^ 4'b1111 ); // 10xx
    $displayb ( 4'b01zx ^~ 4'b0000 ); // 10xx
    ```
6. 归约操作符
    - 操作数归约计算至1比特
    - X、Z按 ***unknown***处理
    ```verilog
    $displayb ( &4'b1110 ); // 0
    $displayb ( &4'b1111 ); // 1
    $displayb ( &4'b111z ); // x
    $displayb ( &4'b111x ); // x
    $displayb ( |4'b0000 ); // 0
    $displayb ( |4‘b0x01 ); // 1
    $displayb ( |4'b000z ); // x
    $displayb ( |4'b000x ); // x
    $displayb ( ^4'b1111 ); // 0
    $displayb ( ^4'b1110 ); // 1
    $displayb ( ^4'b111z ); // x
    $displayb ( ^4'b111x ); // x
    $displayb ( ^~4'b1111 ); // 1
    $displayb ( ^~4'b1110 ); // 0
    $displayb ( ^~4'b111z ); // x
    $displayb ( ^~4'b111x ); // x
    ```
***
7. 关系操作符  
    - 返回1比特布尔值  
    - 若任何一个操作数是X或Z，则结果是***unkown***
    ```verilog
    $displayb ( 4'b1010 < 4'b0110 ); // 0
    $displayb ( 4'b0010 <= 4'b0010 ); // 1
    $displayb ( 4'b1010 < 4'b0x10 ); // x
    $displayb ( 4'b0010 <= 4'b0x10 ); // x
    $displayb ( 4'b1010 >= 4'b1x10 ); // x
    $displayb ( 4'b1x10 > 4'b1x10 ); // x
    $displayb ( 4'b1z10 > 4'b1z10 ); // x
    ```
8. 等价操作符
    - 返回1比特布尔值
    - 若任何一个操作数是X或Z，则结果是 unkown [^仿真不符]
    - 全等、不全等(===, !===)比较***包含X、Z***
    - == **可用于描述硬件** === **仅用于仿真验证**
    ```verilog
    $displayb ( 4'b0011 == 4'b1010 ); // 0
    $displayb ( 4'b0011 != 4'b1x10 ); // 1 [^仿真不符]
    $displayb ( 4'b1010 == 4'b1x10 ); // x
    $displayb ( 4'b1011 == 4'b1x10 ); // 0 [^仿真不符]
    $displayb ( 7'b0010000 == 7'b001x000 ); // x
    $displayb ( 4'b1x10 == 4'b1x10 ); // x
    $displayb ( 4'b1z10 == 4'b1z10 ); // x

    $displayb ( 4'b01zx === 4'b01zx ); // 1
    $displayb ( 4'b01zx !== 4'b01zx ); // 0
    $displayb ( 4'b01zx === 4'b00zx ); // 0
    $displayb ( 4'b01zx !== 4'b11zx ); // 1
    ```
[^仿真不符]: 其处理方法为扩展成相同位宽，先判断有确定定义的(0或1)所在位是否相同，若“不同”即可得出“不相等”结果；再看未定义的位（含x/z的位），若存在这样的位，则结果是x

9. 逻辑操作符
    - 返回1比特布尔值
    - 若任何一个操作数是X或Z，则结果是 ***unkown***  
    如果一个操作数不为 0 或 x，它等价于逻辑 1；如果一个操作数等于 0，它等价于逻辑 0；如果最低位为 x 或 z，其他位为0，它等价于 x
    ```verilog
    $displayb ( 2'b00 && 2'b10 ); // 0
    $displayb ( 2'b01 && 2'b10 ); // 1
    $displayb ( 2'b0z && 2'b10 ); // x
    $displayb ( 2'b0x && 2'b10 ); // x
    $displayb ( 2'b1x && 2'b1z ); // 1
    $displayb ( 2'b00 || 2'b00 ); // 0
    $displayb ( 2'b01 || 2'b00 ); // 1
    $displayb ( 2'b0z || 2'b00 ); // x
    $displayb ( 2'b0x || 2'b00 ); // x
    $displayb ( 2'b0x || 2'b0z ); // x
    ```
10. 移位操作符
    - 左移或者右移若干位
    - 补零填充
    - 移出的位丢失
    ```verilog
    $displayb ( 8'b00011000 << 2 ); // 01100000
    $displayb ( 8'b00011000 >> 2 ); // 00000110
    $displayb ( 8'b00011000 >> -2 ); // 00000000
    $displayb ( 8'b00011000 >> 1'bx ); // xxxxxxxx
    ```
11. 拼接操作符
    ```verilog
    module concat;
    reg [7:0] a,b,c,d,y;
    initial begin
    a = 8'b00000011;
    b = 8'b00000100;
    c = 8'b00011000;
    d = 8'b11100000;
    y = {a[1:0],b[2], c[4:3],d[7:5]};
    $displayb(y);// 11111111
    end
    endmodule

    module replicate;
    reg [3:0] a;
    reg [7:0] y;
    initial begin
    a = 4'b1001;
    y = {{4{a[3]}},a};
    $displayb(y);// 11111001
    end
    endmodule
    ```
### 时延
所有的延时信息，在***synthesis***时，**均忽略**！延时语句**仅在仿真时**有作用

12. 仿真延时
    ```verilog
    #(1，2，3)
    //当输出为上升沿时延迟一个时间单位，输出为下降沿时延迟两个时间单位，输出为高阻态时延迟三个时间单位
    #N //rise,fall,turn-off取同一个值

    //时延例子
    //Net延时
    assign #5 out = in1 & in2;
    assign out2 = #5 in1 & in2;
    //Primitive gate实例延时
    or #(5,1) or_gate (o, i1, i2);
    ```
13. ***`timescale 1ns /100ps*** 语句中，1ns是指 **仿真时间单位** ，100ps是指 **精度**
### 系统任务
- ***$write*** : 与$display系列唯一的区别：***$display***在输出后加了**换行**
- ***$display*** : 格式化文本输出，显示执行语句时信号的即时状态值
- ***$strobe*** : 显示当前时间槽稳定状态信号值
- ***$monitor*** : 监控指定信号，当指定信号变化时，执行一次
-  ***$time***: 返回当前仿真时间，单位同`timescale指定的单位
- ***$finish*** : 仿真器退出 ModelSim会询问是否退出
- ***$stop*** : 仿真器暂停

```verilog
/*
实际仿真输出
# $display: a=0
#
# $strobe: a=1
#
# $monitor: a=1
*/
//$monitor与$strobe以任意顺序执行，不同仿真器可能按不同顺序执行
`timescale 1ns/100ps
module display_cmds;
reg a;
initial $monitor("$monitor: a=%b\n",a);
    initial begin
        $strobe("$strobe: a=%b\n",a);
        a=0;
        a<=1;
        $display("$display: a=%b\n",a);
        #1 $finish;
    end
endmodule
```
### casez，casex
对于case分支和变量的x或z
- casez：Z 或 ? 视为 don’t care
- casex：x 或 z 或 ? 视为 don’t care

### 仿真中时钟的生成
```verilog
initial begin
clk <= 0; //可确保所有0时刻 @(negedge clk)能触发
forever #10 clk <= ~clk;
end
```
## 概念
### FPGA开发基本流程 
**设计思想->设计输入->功能仿真->FPGA综合->FPGA适配->门级仿真->配置器件**
- 基于FPGA的*设计流程*大体可分为：**design设计->synthesis综合->fit适配->配置FPGA**  
    - 综合：将设计转换为FPGA的primitives网表  
    - 适配：将primitives网表安排在合适的位置  
    - 配置：将设计下载到FPGA板上  

简述使用QuartusII工具的FPGA实现、验证操作步骤。  
先对其进行功能仿真，再在QuartusII中基于*.v建立工程project，再对其进行FPGA综合， FPGA适配，门级仿真，并配置器件


### 数字仿真器工作原理
1. ***initial*** 执行**一次**，***always*****循环**执行  
***always a=b;*** -->仿真器**无限循环**  
a=b执行完成后-->检查always的敏感事件列表，由于为空，默认为成功-->继续执行always语句体，再次执行a=b，如此循环，仿真时间不能向前推进！
2. begin...end中的语句**顺序**处理，fork ... join中的语句**并行**处理
### 过程赋值
混合阻塞、非阻塞赋值  
不能这么用！**仿真**可以，**综合**工具认为是**错误**
```verilog
initial begin
    a <= b;
    c = d;
end
```
3.  阻塞赋值 按顺序执行
    - **当前**语句完整**执行完毕**后才能**执行后续**语句
    - 延迟阻塞赋值t时刻时，**先延迟**1时间单位，**再执行** a=b，而此时b取值为延迟后时刻的b值，即b(t+1)
        ```verilog
        initial begin
            #1 a = b;
        end
        ```
    - 多个延迟阻塞赋值语句，**按顺序**执行
        ```verilog
        initial begin
            #1 a = b; //a=b(t+1) 
            #1 c = d; //c=d(t+2)
        end
        ```
    - 内部延迟阻塞赋值语句，延时在赋值“=”**后**，**先计算**RHS值，并保存此值，然后**执行延迟**操作，再将先前保存的RHS值**赋**给LHS变量，a在t+1时刻得到的是t时刻b值，即***b(t)***
        ```verilog
        initial begin
            a = #1 b;
        end
        ```
    - 多个内部延迟阻塞赋值语句
        ```verilog
        initial begin
            a = #1 b;//t+1时刻，a=b(t)
            c = #1 d;//t+2时刻，c=d(t+1)
        end
        ```
4. 非阻塞赋值 非阻塞赋值在当前时间槽事件队列结束时同时执行  
体现硬件电路并行性，仿真处理过程：刚进入t时刻时，计算RHS值，保存该值，将赋值操作安排在***t时刻事件队列末尾***执行 
    ```verilog
    initial begin
       a <= b;
    end

    //语句任意交换顺序，功能不变，顺序语句表达了并行电路，不存在竞争，两值交换
    always@(posedge clk)
    begin
         a <= b;
        b <= a;
    end
    ```
    - 延迟非阻塞赋值 t时刻时，**先延时**1时间单位-->计算延时后t+1时刻RHS表达式值，并保存此值，将赋值操作a=b(t+1)**安排在t+1时刻事件队列末尾**
        ```verilog
        initial begin
            #1 a <= b;
        end
        ```
    - 内部延迟非阻塞赋值 t时刻时，**先计算RHS**，并保存此值，**将赋值操作a=b(t)安排在t+1时刻事件队列末尾**，该语句本身处理不耗时，其下一条语句（如果有的话）起始执行时间仍是t时刻
        ```verilog
        initial begin
            a <= #1 b;
        end
        ```
    - 多条内部延迟非阻塞赋值语句
        ```verilog
        initial begin
            a <= #1 b;//t+1时刻，a=b(t)
            c <= #1 d;//t+1时刻，c=d(t)
        end
        ```
***
## 仿真命令
```bash
vlib mywork          //创建物理库mywork
vmap work mywork     //映射逻辑库work至物理库mywork
vlog +acc *.v        //编译所有.v文件至work库
vsim -novopt Lab1_tb //启动仿真工具仿真Lab1_tb
add wave /*          //添加所有信号至波形窗口
run -all             //运行所有仿真
```
***
## D Latch
```verilog
module d1(clk, d, q, set, reset);
input clk, d, set, reset;
output q;
reg q;
    always@(clk or d or set or reset)
    begin
        if(reset)
            q = 1'b0;
        else if(set)
            q = 1'b1;
        else if(clk)
            q = d;
    end
endmodule
```
## DFF
```verilog
//Asynchronous set and reset FF
module arsdff (clk, d, q, set, reset);
input clk, d, set, reset;
output q;
reg q;
    always@(posedge clk or posedge set or posedge reset) begin
        if(reset)
            q <= 1'b0;
        else if(set)
            q <= 1'b1;
        else
            q<=d;
    end
endmodule

//synchronous set and reset FF
module ssrdff (clk, d, q, set, reset);
input clk, d, set, reset;
output q;
reg q;
    always@(posedge clk)
    begin
        if(reset)
            q <= 1'b0;
        else if(set)
            q <= 1'b1;
        else
            q<=d;
    end
endmodule
```

## TestBench
三种方式的TestBench
1. 简单测试
2. 自测试
3. 带测试向量文件读取的测试，测试向量文件： example.tv，格式： abc_y
    ```verilog
    000_1
    001_0
    010_0
    011_0
    100_1
    101_1
    110_0
    111_0
    ```
    ```verilog
    `timescale 1ns/100ps

    module mydesign(input a, b, c, output y);
        assign y = ( (~b) & (~c) ) | ( a & (~b) );
    endmodule

    module testbench3();
    reg a, b, c, yexpected;
    wire y;
    reg [31:0] vectornum, errors;
    reg [3:0] testvectors[10000:0];
    // instantiate device under test
    mydesign dut(a, b, c, y);
        initial begin
            $readmemb("example.tv", testvectors);
            vectornum = 0; errors = 0;
            while(1) begin
                #1; {a, b, c, yexpected} =testvectors[vectornum];
                #1; if (y !== yexpected) begin
                        $display("Error: inputs = %b", {a, b, c});
                        $display(" outputs = %b (%b expected)", y, yexpected);
                        errors = errors + 1;
                    end 
                    vectornum = vectornum + 1;
                    if (testvectors[vectornum] === 4'bx) begin
                        $display("%d tests completed with %d errors", vectornum, errors);
                        #10 $stop;
                    end
            end
        end
    endmodule
    ```
## FSM 
>有限状态机 是表示有限个状态以及在这些状态之间的转移和动作等行为的数学模型  
分为Mealy型和Moore型两类  
Mealy : 输出不仅**与当前状态有关**，还**取决于当前的输入信号** 
Moore : 输出**只与当前状态有关**，**与当前输入无关**  
常用的两种描述风格是两段式与三段式 

两段式：  
Next_State与Output混合描述
1. 时序电路部分：改变状态  
2. 组合逻辑部分：决定Next_State与输出

三段式：  
Next_State处理与Output处理分离
1. 时序
2. Next_State
3. Ouput  

FSM Encoding Style（编码风格）主要有:
- Binary Encoding
- One Hot Encoding
    ```verilog
    module example_e (input wire clk, rst, input_sig_1, input_sig_2,
                  output wire a, b);
    reg [2:0] state, next_state;
    parameter S0 = 0, S1 = 1, S2 = 2;
    assign a = (state[S0]) && (input_sig_1 || input_sig_2);
    assign b = (state[S1]);
    always @ (posedge clk or posedge rst )
        if (rst)
            state <= #1 3'b001; // S0 the initial state
        else
            state <= #1 next_state;
    always @ (state or input_sig_1 or input_sig_2)
    begin
        next_state = 3'b000;
        case (1'b1)
            state [S0]:
                if(input_sig_1)
                    next_state [S1] = 1'b1;
                else
                    next_state [S0] = 1'b1;
            state [S1]:
                if(input_sig_2)
                    next_state [S2] = 1'b1;
                else
                    next_state [S0] = 1'b1;
            state [S2]:
                next_state [S0] = 1'b1;
            default:
                next_state [S0] = 1'b1;
        endcase
    end
    endmodule
    ```
- Gray Encoding  
Binary : 二进制编码 优点是占用位数少缺点是容易带来毛刺  
Gray : 格雷码编码 优点是可减少毛刺的发生  
One Hot : 一位表达一个状态，缺点是需要更大的位宽，优点是比对时只需要比对1bit,适合高速电路设计
