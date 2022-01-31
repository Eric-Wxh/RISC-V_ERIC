/*
 * @Author: Eric Wong 
 * @Date: 2022-01-29 13:25:37 
 * @Last Modified by:   Eric Wong 
 * @Last Modified time: 2022-01-29 13:25:37 
 */

module riscv_top # (
        parameter Width = 32
    )
    (
        input               clk,
        input               reset,
        output [Width-1:0]  WriteDataM,
        output [Width-1:0]  ALUResultM,
        output              MemWriteM
    );
    wire [31:0] InstrF;
    wire [Width-1:0] pcF;
    wire [Width-1:0] ReadDataM;
 
    riscv riscv (
        .clk        (clk        ),
        .reset      (reset      ),
        .InstrF     (InstrF     ),
        .pcF        (pcF        ),
        .ReadDataM  (ReadDataM  ),
        .ALUResultM (ALUResultM ),
        .MemWriteM  (MemWriteM  ),
        .WriteDataM (WriteDataM )
    );

    imem imem (
        .addr   (pcF    ),
        .rd     (InstrF )
    );

    dmem dmem (
        .clk        (clk        ),
        .addr       (ALUResultM ),
        .we         (MemWriteM  ),
        .wr_data    (WriteDataM ),
        .rd         (ReadDataM  )
    );
endmodule
