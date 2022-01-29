/*
 * @Author: Eric Wong 
 * @Date: 2022-01-17 17:07:16 
 * @Last Modified by:   Eric Wong 
 * @Last Modified time: 2022-01-17 17:07:16 
 */
`define Width 32

module tb_mem;
    // imem
    reg [(`Width-1):0] addr_imem;
    wire [(`Width-1):0] rd_imem;

    // dmem
    reg clk;
    reg [(`Width-1):0] addr_dmem;
    reg we;
    reg [(`Width-1):0] wr_data;
    wire [(`Width-1):0] rd_dmem;

    imem dut_imem (
        .addr (addr_imem),
        .rd (rd_imem)
    );

    dmem dut_dmem (
        .clk (clk),
        .addr (addr_dmem),
        .we (we),
        .wr_data (wr_data),
        .rd (rd_dmem)
    );

    initial begin
        $fsdbDumpfile("tb_mem.fsdb");
        $fsdbDumpvars(0);
    end

    always #10 clk = ~clk;

    initial begin
        clk = 0;
        addr_imem = 0;
        addr_dmem = 0;
        we = 0;
        wr_data = 0;

        #21;
        repeat (20) begin
            addr_imem = addr_imem + 1;
            #20;
        end

        #100000;
        $finish;
    end
endmodule
