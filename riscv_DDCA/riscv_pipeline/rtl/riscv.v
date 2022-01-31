/*
 * @Author: Eric Wong 
 * @Date: 2022-01-29 11:11:13 
 * @Last Modified by:   Eric Wong 
 * @Last Modified time: 2022-01-29 11:11:13 
 */

module riscv # (
        parameter Width = 32
    )
    (
        input clk                       ,
        input reset                     ,
        // Instruction Memory
        input   [31:0]      InstrF      ,
        output  [Width-1:0] pcF         ,
        // Data Memory
        input   [Width-1:0] ReadDataM   ,
        output  [Width-1:0] ALUResultM  ,
        output              MemWriteM   ,
        output  [Width-1:0] WriteDataM
    );
    //-------------------------------<Signal Declaration>----------------------------------// 
    wire                StallF      ;
    wire [Width-1:0]    pcF_next    ;
    wire [Width-1:0]    pcPlus4F    ;

    wire                StallD      ;
    wire                FlushD      ;
    wire [31:0]         InstrD      ;
    wire [Width-1:0]    pcD         ;
    wire [Width-1:0]    pcPlus4D    ;
    wire [Width-1:0]    rd_Data1D   ;
    wire [Width-1:0]    rd_Data2D   ;
    wire [1:0]          ImmSrcD     ;
    wire [Width-1:0]    ImmExtD     ;
    wire                BranchD     ;
    wire                JumpD       ;
    wire [1:0]          ResultSrcD  ;
    wire                MemWriteD   ;
    wire [2:0]          ALUCtrlD    ;
    wire                ALUSrcD     ;
    wire                RegWriteD   ;
    wire [4:0]          Rs1D        ;
    wire [4:0]          Rs2D        ;
    wire [4:0]          RdD         ;

    wire [Width-1:0]    pcTargetE   ;
    wire                PCSrcE      ;
    wire                FlushE      ;
    wire                RegWriteE   ;
    wire [1:0]          ResultSrcE  ;
    wire                MemWriteE   ;
    wire                JumpE       ;
    wire                BranchE     ;
    wire [2:0]          ALUCtrlE    ;
    wire                ALUSrcE     ;
    wire [Width-1:0]    rd_Data1E   ;
    wire [Width-1:0]    rd_Data2E   ;
    wire [Width-1:0]    pcE         ;
    wire [4:0]          Rs1E        ;
    wire [4:0]          Rs2E        ;
    wire [4:0]          RdE         ;
    wire [Width-1:0]    ImmExtE     ;
    wire                ZeroE       ;
    wire [1:0]          ForwardAE   ;
    wire [Width-1:0]    SrcAE       ;
    wire [1:0]          ForwardBE   ;
    wire [Width-1:0]    WriteDataE  ;
    wire [Width-1:0]    SrcBE       ;
    wire [Width-1:0]    ALUResultE  ;
    wire [Width-1:0]    pcPlus4E    ;

    wire                RegWriteM   ;
    wire [1:0]          ResultSrcM  ;
    wire [4:0]          RdM         ;
    wire [Width-1:0]    pcPlus4M    ;

    wire [4:0]          RdW         ;
    wire [Width-1:0]    ResultW     ;
    wire                RegWriteW   ;
    wire [1:0]          ResultSrcW  ;
    wire [Width-1:0]    ALUResultW  ;
    wire [Width-1:0]    ReadDataW   ;
    wire [Width-1:0]    pcPlus4W    ;

    wire                N           ;
    wire                C           ;
    wire                V           ;

    assign Rs1D = InstrD[19:15];
    assign Rs2D = InstrD[24:20];
    assign RdD = InstrD[11:7];
    //----------------------------------<Instantiation>------------------------------------//
    /*
     * @ Fetch
     */
    dff_adj
    # (
        .Width(32)
    )
    pc_reg (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (1'b0       ),
        .en     (StallF     ),
        .d      (pcF_next   ),
        .q      (pcF        )
    );

    mux2 mux2_PC (
        .data_in_0  (pcPlus4F   ),
        .data_in_1  (pcTargetE  ),
        .sel        (PCSrcE     ),
        .data_out   (pcF_next   )
    );

    adder adder_plus4 (
        .a      (pcF        ),
        .b      (32'd4      ),
        .cin    (1'b0       ),
        .sum    (pcPlus4F   ),
        .cout   (           )
    );

    dff_adj
    # (
        .Width(32)
    )
    reg_InstrF (
        .clk    (clk    ),
        .reset  (reset  ),
        .clr    (FlushD ),
        .en     (StallD ),
        .d      (InstrF ),
        .q      (InstrD )
    );

    dff_adj
    # (
        .Width(32)
    )
    reg_pcF (
        .clk    (clk    ),
        .reset  (reset  ),
        .clr    (FlushD ),
        .en     (StallD ),
        .d      (pcF    ),
        .q      (pcD    )
    );
    
    dff_adj
    # (
        .Width(32)
    )
    reg_pcPlus4F (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (FlushD     ),
        .en     (StallD     ),
        .d      (pcPlus4F   ),
        .q      (pcPlus4D   )
    );
    
    /*
     * @ Decode
     */
    reg_file reg_file (
        .clk    (~clk           ),      // In order to Write back in the first half period
        .a1     (InstrD[19:15]  ),
        .a2     (InstrD[24:20]  ),
        .a3     (RdW            ),
        .wd3    (ResultW        ),
        .we3    (RegWriteW      ),
        .rd1    (rd_Data1D      ),
        .rd2    (rd_Data2D      )
    );

    extend extend (
        .Instr  (InstrD[31:7]   ),
        .ImmSrc (ImmSrcD        ),
        .ImmExt (ImmExtD        )
    );

    controller controller (
        .opcode     (InstrD[6:0]    ),
        .funct3     (InstrD[14:12]  ),
        .funct7_5   (InstrD[30]     ),
        .Branch     (BranchD        ),
        .Jump       (JumpD          ),
        .ResultSrc  (ResultSrcD     ),
        .MemWrite   (MemWriteD      ),
        .ALUCtrl    (ALUCtrlD       ),
        .ALUSrc     (ALUSrcD        ),
        .ImmSrc     (ImmSrcD        ),
        .RegWrite   (RegWriteD      )
    );

    dff_adj
    # (
        .Width (1)
    )
    reg_RegWriteD (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (FlushE     ),
        .en     (1'b0       ),
        .d      (RegWriteD  ),
        .q      (RegWriteE  )
    );

    dff_adj
    # (
        .Width (2)
    )
    reg_ResultSrcD (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (FlushE     ),
        .en     (1'b0       ),
        .d      (ResultSrcD ),
        .q      (ResultSrcE )
    );
    
    dff_adj
    # (
        .Width (1)
    )
    reg_MemWriteD (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (FlushE     ),
        .en     (1'b0       ),
        .d      (MemWriteD  ),
        .q      (MemWriteE  )
    );
    
    dff_adj
    # (
        .Width (1)
    )
    reg_JumpD (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (FlushE     ),
        .en     (1'b0       ),
        .d      (JumpD      ),
        .q      (JumpE      )
    );
    
    dff_adj
    # (
        .Width (1)
    )
    reg_BranchD (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (FlushE     ),
        .en     (1'b0       ),
        .d      (BranchD    ),
        .q      (BranchE    )
    );
    
    dff_adj
    # (
        .Width (3)
    )
    reg_ALUCtrlD (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (FlushE     ),
        .en     (1'b0       ),
        .d      (ALUCtrlD   ),
        .q      (ALUCtrlE   )
    );
    
    dff_adj
    # (
        .Width (1)
    )
    reg_ALUSrcD (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (FlushE     ),
        .en     (1'b0       ),
        .d      (ALUSrcD    ),
        .q      (ALUSrcE    )
    );
    
    dff_adj
    # (
        .Width (32)
    )
    reg_rd_Data1D (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (FlushE     ),
        .en     (1'b0       ),
        .d      (rd_Data1D  ),
        .q      (rd_Data1E  )
    );
    
    dff_adj
    # (
        .Width (32)
    )
    reg_rd_Data2D (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (FlushE     ),
        .en     (1'b0       ),
        .d      (rd_Data2D  ),
        .q      (rd_Data2E  )
    );

    dff_adj
    # (
        .Width (32)
    )
    reg_pcD (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (FlushE     ),
        .en     (1'b0       ),
        .d      (pcD        ),
        .q      (pcE        )
    );

    dff_adj
    # (
        .Width (5)
    )
    reg_Rs1D (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (FlushE     ),
        .en     (1'b0       ),
        .d      (Rs1D       ),
        .q      (Rs1E       )
    );

    dff_adj
    # (
        .Width (5)
    )
    reg_Rs2D (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (FlushE     ),
        .en     (1'b0       ),
        .d      (Rs2D       ),
        .q      (Rs2E       )
    );

    dff_adj
    # (
        .Width (5)
    )
    reg_RdD (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (FlushE     ),
        .en     (1'b0       ),
        .d      (RdD        ),
        .q      (RdE        )
    );

    dff_adj
    # (
        .Width (32)
    )
    reg_ImmExtD (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (FlushE     ),
        .en     (1'b0       ),
        .d      (ImmExtD    ),
        .q      (ImmExtE    )
    );

    dff_adj
    # (
        .Width (32)
    )
    reg_pcPlus4D (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (FlushE     ),
        .en     (1'b0       ),
        .d      (pcPlus4D   ),
        .q      (pcPlus4E   )
    );

    /*
     * @ Execute
     */
    assign PCSrcE = JumpE | (ZeroE & BranchE);

    mux4 mux4_SrcAE (
        .data_in_0  (rd_Data1E  ),
        .data_in_1  (ResultW    ),
        .data_in_2  (ALUResultM ),
        .data_in_3  (ALUResultM ),
        .sel        (ForwardAE  ),
        .data_out   (SrcAE      )
    );

    mux4 mux4_WriteDataE (
        .data_in_0  (rd_Data2E  ),
        .data_in_1  (ResultW    ),
        .data_in_2  (ALUResultM ),
        .data_in_3  (ALUResultM ),
        .sel        (ForwardBE  ),
        .data_out   (WriteDataE )
    );

    mux2 mux2_SrcB (
        .data_in_0  (WriteDataE ),
        .data_in_1  (ImmExtE    ),
        .sel        (ALUSrcE    ),
        .data_out   (SrcBE      )
    );

    alu alu (
        .A          (SrcAE          ),
        .B          (SrcBE          ),
        .ALUCtrl    (ALUCtrlE       ),
        .Result     (ALUResultE     ),
        .Flags      ({N,ZeroE,C,V}  )
    );

    adder adder_pcTargetE (
        .a      (pcE        ),
        .b      (ImmExtE    ),
        .cin    (1'b0       ),
        .sum    (pcTargetE ),
        .cout   (           )
    );

    dff_adj
    # (
        .Width (1)
    )
    reg_RegWriteE (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (1'b0       ),
        .en     (1'b0       ),
        .d      (RegWriteE  ),
        .q      (RegWriteM  )
    );

    dff_adj
    # (
        .Width (2)
    )
    reg_ResultSrcE (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (1'b0       ),
        .en     (1'b0       ),
        .d      (ResultSrcE ),
        .q      (ResultSrcM )
    );

    dff_adj
    # (
        .Width (1)
    )
    reg_MemWriteE (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (1'b0       ),
        .en     (1'b0       ),
        .d      (MemWriteE  ),
        .q      (MemWriteM  )
    );

    dff_adj
    # (
        .Width (32)
    )
    reg_ALUResultE (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (1'b0       ),
        .en     (1'b0       ),
        .d      (ALUResultE ),
        .q      (ALUResultM )
    );

    dff_adj
    # (
        .Width (32)
    )
    reg_WriteDataE (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (1'b0       ),
        .en     (1'b0       ),
        .d      (WriteDataE ),
        .q      (WriteDataM )
    );

    dff_adj
    # (
        .Width (5)
    )
    reg_RdE (
        .clk    (clk    ),
        .reset  (reset  ),
        .clr    (1'b0   ),
        .en     (1'b0   ),
        .d      (RdE    ),
        .q      (RdM    )
    );

    dff_adj
    # (
        .Width (32)
    )
    reg_pcPlus4E (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (1'b0       ),
        .en     (1'b0       ),
        .d      (pcPlus4E   ),
        .q      (pcPlus4M   )
    );
    
    /*
     * @ Memory
     */
    dff_adj
    # (
        .Width (1)
    )
    reg_RegWriteM (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (1'b0       ),
        .en     (1'b0       ),
        .d      (RegWriteM  ),
        .q      (RegWriteW  )
    );

    dff_adj
    # (
        .Width (2)
    )
    reg_ResultSrcM (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (1'b0       ),
        .en     (1'b0       ),
        .d      (ResultSrcM ),
        .q      (ResultSrcW )
    );

    dff_adj
    # (
        .Width (32)
    )
    reg_ALUResultM (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (1'b0       ),
        .en     (1'b0       ),
        .d      (ALUResultM ),
        .q      (ALUResultW )
    );

    dff_adj
    # (
        .Width (32)
    )
    reg_ReadDataM (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (1'b0       ),
        .en     (1'b0       ),
        .d      (ReadDataM  ),
        .q      (ReadDataW  )
    );

    dff_adj
    # (
        .Width (5)
    )
    reg_RdM (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (1'b0       ),
        .en     (1'b0       ),
        .d      (RdM        ),
        .q      (RdW        )
    );

    dff_adj
    # (
        .Width (32)
    )
    reg_pcPlus4M (
        .clk    (clk        ),
        .reset  (reset      ),
        .clr    (1'b0       ),
        .en     (1'b0       ),
        .d      (pcPlus4M   ),
        .q      (pcPlus4W   )
    );

    /*
     * @ Writeback
     */
    mux4 mux4_Result (
        .data_in_0  (ALUResultW ),
        .data_in_1  (ReadDataW  ),
        .data_in_2  (pcPlus4W   ),
        .data_in_3  (pcPlus4W   ),
        .sel        (ResultSrcW ),
        .data_out   (ResultW    )
    );

    /*
     * @ Hazard control
     */
    hazard hazard (
        .Rs1D           (Rs1D           ),
        .Rs2D           (Rs2D           ),
        .RdE            (RdE            ),
        .Rs1E           (Rs1E           ),
        .Rs2E           (Rs2E           ),
        .PCSrcE         (PCSrcE         ),
        .ResultSrcE_0   (ResultSrcE[0]  ),
        .RdM            (RdM            ),
        .RegWriteM      (RegWriteM      ),
        .RdW            (RdW            ),
        .RegWriteW      (RegWriteW      ),

        .StallF         (StallF         ),
        .StallD         (StallD         ),
        .FlushD         (FlushD         ),
        .FlushE         (FlushE         ),
        .ForwardAE      (ForwardAE      ),
        .ForwardBE      (ForwardBE      )
    );
endmodule
