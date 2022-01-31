/*
 * @Author: Eric Wong 
 * @Date: 2022-01-15 22:48:05 
 * @Last Modified by:   Eric Wong 
 * @Last Modified time: 2022-01-15 22:48:05 
 */

module reg_file # (
        parameter   Width   = 32,
                    N       = 32            // 32 registers
    )
    (
        input               clk ,
        input   [4:0]       a1  ,           // rd1 address
        input   [4:0]       a2  ,           // rd2 address
        input   [4:0]       a3  ,           // Write address
        input               we3 ,           // Write enable, active high
        input   [Width-1:0] wd3 ,           // Write data
        output  [Width-1:0] rd1 ,           // read data from address a1
        output  [Width-1:0] rd2             // read data from address a2
    );
    reg [Width-1:0] rf [N-1:0];             // Memory Declairation
    
    // Write Register
    always @(posedge clk) begin
        if (we3) begin
            rf[a3] <= wd3;
        end

        else begin
            rf[a3] <= rf[a3];
        end
    end

    assign rd1  =   (a1 != 5'b00000) ?      // Read the register of address a1
                    rf[a1] :
                    0;
    assign rd2  =   (a2 != 5'b00000) ?      // Read the register of address a2
                    rf[a2] :
                    0;
endmodule
