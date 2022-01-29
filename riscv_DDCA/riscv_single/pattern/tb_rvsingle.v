/*
 * @Author: Eric Wong 
 * @Date: 2022-01-20 15:45:21 
 * @Last Modified by:   Eric Wong 
 * @Last Modified time: 2022-01-20 15:45:21 
 */

`define Width 32
module tb_rvsingle;
    reg clk;
    reg reset;
    wire [(`Width)-1:0] pc;
    wire [(`Width)-1:0] ALU_Result;

    rvsingle_top dut (
        .clk (clk),
        .reset (reset),
        .pc (pc),
        .ALU_Result (ALU_Result)
    );

    initial begin
        $fsdbDumpfile("tb_rvsingle.fsdb");
        $fsdbDumpvars(0);
    end

    always #10 clk = ~clk;

    initial begin
        clk = 0;
        reset = 0;
        
        #21 reset = 1;
        #20 reset = 0;

        #1000 $finish;
    end
endmodule
