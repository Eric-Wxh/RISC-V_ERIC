/*
 * @Author: Eric Wong 
 * @Date: 2022-01-20 15:45:21 
 * @Last Modified by:   Eric Wong 
 * @Last Modified time: 2022-01-20 15:45:21 
 */

`define Width 32
module tb_riscv;
    reg                 clk         ;
    reg                 reset       ;
    wire [(`Width)-1:0] WriteDataM  ;
    wire [(`Width)-1:0] ALUResultM  ;
    wire                MemWriteM   ;

    riscv_top dut (
        .clk        (clk        ),
        .reset      (reset      ),
        .WriteDataM (WriteDataM ),
        .ALUResultM (ALUResultM ),
        .MemWriteM  (MemWriteM  )
    );

    initial begin
        $fsdbDumpfile("tb_riscv.fsdb");
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
