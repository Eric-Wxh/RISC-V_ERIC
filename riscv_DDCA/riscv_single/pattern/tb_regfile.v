/*
 * @Author: Eric Wong 
 * @Date: 2022-01-20 22:54:32 
 * @Last Modified by:   Eric Wong 
 * @Last Modified time: 2022-01-20 22:54:32 
 */

module tb_regfile;
    reg clk;
    reg [4:0] a1;
    reg [4:0] a2;
    reg [4:0] a3;
    reg we3;
    reg [31:0] wd3;
    wire [31:0] rd1;
    wire [31:0] rd2;

    reg_file dut (
        .clk (clk),
        .a1 (a1),
        .a2(a2),
        .a3(a3),
        .we3(we3),
        .wd3(wd3),
        .rd1(rd1),
        .rd2(rd2)
    );

    initial begin
        $fsdbDumpfile("tb_regfile.fsdb");
        $fsdbDumpvars(0);
    end

    always #10 clk = ~clk;

    initial begin
        clk = 0;
        a1 = 0;
        a2 = 0;
        a3 = 0;
        we3 = 0;
        wd3 = 0;

        #21;
        data_wr;

        repeat (6) begin
            #20 a1 = a1 + 1;
            #20 a2 = a2 + 1;
        end

        #1000;
        $finish;

    end

    task data_wr;
        begin
            we3 = 1;
            wd3 = 32'd400;
            #20;
            a3 = a3 + 1;

            wd3 = 32'd500;
            #20;
            a3 = a3 + 1;

            wd3 = 32'd600;
            #20;
            a3 = a3 + 1;

            wd3 = 32'd700;
            #20;
            a3 = a3 + 1;

            we3 = 0;
        end
    endtask
endmodule
