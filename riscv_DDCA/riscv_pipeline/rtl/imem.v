/*
 * @Author: Eric Wong 
 * @Date: 2022-01-17 16:23:46 
 * @Last Modified by:   Eric Wong 
 * @Last Modified time: 2022-01-17 16:23:46 
 */

// Instruction Memory
module imem # (
        parameter Width = 32
    )
    (
        input   [Width-1:0] addr,
        output  [Width-1:0] rd
    );
    
    reg [Width-1:0] mem [63:0];                 // Currently don't know the depth of the memory

    // Initialize the memory
    // Tips: When txt and verilog file are not in the same directory, then the directory of the txt must complete
    initial begin
        $readmemh("../pattern/riscvtest.txt",mem);
    end

    assign rd = mem[addr[Width-1:2]];

    integer i;

    initial begin
        for (i = 0; i < 20;i = i+1) begin
            $display("%h",mem[i]);
        end
    end
endmodule
