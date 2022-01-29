`timescale 1ns/1ps
/*
 * @Author: Eric Wong 
 * @Date: 2022-01-15 20:37:11 
 * @Last Modified by:   Eric Wong 
 * @Last Modified time: 2022-01-15 20:37:11 
 */
`define Width 32

module tb_alu;
    reg     [`Width-1:0]    A       ;
    reg     [`Width-1:0]    B       ;
    reg     [2:0]           ALUCtrl ;
    wire    [`Width-1:0]    Result  ;
    wire    [3:0]           Flags   ;

    alu uut (
        .A (A),
        .B (B),
        .ALUCtrl (ALUCtrl),
        .Result (Result),
        .Flags (Flags)
    );

    initial begin
        $fsdbDumpfile("tb_alu.fsdb");
        $fsdbDumpvars(0);
    end

    initial begin
        A = 32'd0;
        B = 32'd0;
        ALUCtrl = 3'b000;

        #20 A = 32'd4000;
        #20 B = 32'd4001;
        #20 ALUCtrl = 3'b001;
        #20 ALUCtrl = 3'b010;
        #20 ALUCtrl = 3'b011;
        #20 ALUCtrl = 3'b101;
        #20000 $finish;
    end
endmodule
