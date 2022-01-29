/*
 * @Author: Eric Wong 
 * @Date: 2022-01-17 19:35:29 
 * @Last Modified by:   Eric Wong 
 * @Last Modified time: 2022-01-17 19:35:29 
 */
`define Width  32
module tb_extend;
    reg [31:7] Instr;
    reg [1:0] ImmSrc;
    wire [(`Width)-1:0] ImmExt;

    extend dut (
        .Instr (Instr),
        .ImmSrc (ImmSrc),
        .ImmExt (ImmExt)
    );

    initial begin
        $fsdbDumpfile("tb_extend.fsdb");
        $fsdbDumpvars(0);
    end

    initial begin
        ImmSrc = 2'b00;
        Instr = 25'h124e68f;

        #20 ImmSrc = 2'b01;
        #20 ImmSrc = 2'b10;
        #1000000 $finish;
    end
endmodule
