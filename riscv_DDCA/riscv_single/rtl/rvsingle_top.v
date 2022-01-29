/*
 * @Author: Eric Wong 
 * @Date: 2022-01-20 01:02:01 
 * @Last Modified by:   Eric Wong 
 * @Last Modified time: 2022-01-20 01:02:01 
 */

module rvsingle_top # (
        parameter Width = 32
    )
    (
        input               clk         ,
        input               reset       ,
        output [Width-1:0]  pc          ,
        output [Width-1:0]  ALU_Result
    );
    wire [31:0]         Instr;
    wire [Width-1:0]    rd_data;
    wire                Mem_Write;
    wire [Width-1:0]    Write_Data;
    riscv_single rvsingle (
        .clk        (clk        ),
        .reset      (reset      ),
        
        .Instr      (Instr      ),
        .pc         (pc         ),
        
        .rd_data    (rd_data    ),
        .ALU_Result (ALU_Result ),
        .Mem_Write  (Mem_Write  ),
        .Write_Data (Write_Data )
    );

    imem imem (
        .addr   (pc     ),
        .rd     (Instr  )
    );

    dmem dmem (
        .clk        (clk        ),
        .addr       (ALU_Result ),
        .we         (Mem_Write  ),
        .wr_data    (Write_Data ),
        .rd         (rd_data    )
    );
endmodule
