/*
 * @Author: Eric Wong 
 * @Date: 2022-01-20 00:53:03 
 * @Last Modified by:   Eric Wong 
 * @Last Modified time: 2022-01-20 00:53:03 
 */

module datapath # (
        parameter Width = 32
    )
    (
        input               clk         ,
        input               reset       ,
        // Controller input
        input               PCSrc       ,
        input   [1:0]       ResultSrc   ,
        input   [2:0]       ALUCtrl     ,
        input               ALUSrc      ,
        input   [1:0]       ImmSrc      ,
        input               Reg_Write   ,
        // Controller output
        output              Zero        ,
        // Memory input
        input   [31:0]      Instr       ,
        input   [Width-1:0] rd_data     ,
        // Memory output
        output  [Width-1:0] pc          ,
        output  [Width-1:0] ALU_Result  ,
        output  [Width-1:0] Write_Data
    );
    // PC Register
    wire [Width-1:0]    pc_next;
    wire [Width-1:0]    pc_plus4;
    wire [Width-1:0]    pc_tar;
    wire [Width-1:0]    ImmExt;
    // ALU
    wire [Width-1:0]    SrcA;
    wire [Width-1:0]    SrcB;
    wire                N;                          // Negative
    wire                C;                          // Carry
    wire                V;                          //oVerflow

    wire [Width-1:0]    Result;

    pc_reg pc_reg (
        .clk        (clk    ),
        .reset      (reset  ),
        .pc_next    (pc_next),
        .pc         (pc     )
    );

    mux2 mux2_pc (
        .data_in_0  (pc_plus4   ),
        .data_in_1  (pc_tar     ),
        .sel        (PCSrc      ),
        .data_out   (pc_next    )
    );

    adder adder_pc_plus4 (
        .a      (pc         ),
        .b      (32'd4      ),
        .cin    (1'b0       ),
        .sum    (pc_plus4   ),
        .cout   (           )
    );

    extend extend_imm (
        .Instr  (Instr[Width-1:7]   ),
        .ImmSrc (ImmSrc             ),
        .ImmExt (ImmExt             )
    );

    adder adder_tar (
        .a      (pc     ),
        .b      (ImmExt ),
        .cin    (1'b0   ),
        .sum    (pc_tar ),
        .cout   (       )
    );

    reg_file reg_file (
        .clk    (clk            ),
        .a1     (Instr[19:15]   ),
        .a2     (Instr[24:20]   ),
        .a3     (Instr[11:7]    ),
        .we3    (Reg_Write      ),
        .wd3    (Result         ),
        .rd1    (SrcA           ),
        .rd2    (Write_Data     )
    );

    mux2 mux2_SrcB (
        .data_in_0  (Write_Data ),
        .data_in_1  (ImmExt     ),
        .sel        (ALUSrc     ),
        .data_out   (SrcB       )
    );

    alu alu (
        .A          (SrcA),
        .B          (SrcB),
        .ALUCtrl    (ALUCtrl),
        .Result     (ALU_Result),
        .Flags      ({N,Zero,C,V})
    );

    mux4 mux4_result (
        .data_in_0 (ALU_Result),
        .data_in_1 (rd_data),
        .data_in_2 (pc_plus4),
        .data_in_3 (32'd0),
        .sel (ResultSrc),
        .data_out (Result)
    );
endmodule
