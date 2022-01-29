/*
 * @Author: Eric Wong 
 * @Date: 2022-01-20 11:44:04 
 * @Last Modified by:   Eric Wong 
 * @Last Modified time: 2022-01-20 11:44:04 
 */

module riscv_single # (
        parameter Width = 32
    )
    (
        input               clk         ,
        input               reset       ,
        // Instruction Memory
        input   [31:0]      Instr       ,
        output  [Width-1:0] pc          ,
        // Data Memory
        input   [Width-1:0] rd_data     ,
        output  [Width-1:0] ALU_Result  ,
        output              Mem_Write   ,
        output  [Width-1:0] Write_Data
    );
    
    wire PCSrc;
    wire [1:0]  ResultSrc;
    wire [2:0]  ALUCtrl;
    wire        ALUSrc;
    wire [1:0]  ImmSrc;
    wire        Reg_Write;
    wire        Zero;
    
    datapath datapath (
        .clk        (clk        ),
        .reset      (reset      ),
        
        .PCSrc      (PCSrc      ),
        .ResultSrc  (ResultSrc  ),
        .ALUCtrl    (ALUCtrl    ),
        .ALUSrc     (ALUSrc     ),
        .ImmSrc     (ImmSrc     ),
        .Reg_Write  (Reg_Write  ),
        
        .Zero       (Zero       ),
        
        .Instr      (Instr      ),
        .rd_data    (rd_data    ),
        
        .pc         (pc         ),
        .ALU_Result (ALU_Result ),
        .Write_Data (Write_Data )
    );

    controller controller (
        .opcode     (Instr[6:0]     ),
        .funct3     (Instr[14:12]   ),
        .funct7_5   (Instr[30]      ),
        .Zero       (Zero           ),
        
        .PCSrc      (PCSrc          ),
        .ResultSrc  (ResultSrc      ),
        .Mem_Write  (Mem_Write      ),
        .ALUCtrl    (ALUCtrl        ),
        .ALUSrc     (ALUSrc         ),
        .ImmSrc     (ImmSrc         ),
        .Reg_Write  (Reg_Write      )
    );
endmodule
