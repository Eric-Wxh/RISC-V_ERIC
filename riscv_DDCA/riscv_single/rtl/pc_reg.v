/*
 * @Author: Eric Wong 
 * @Date: 2022-01-15 22:54:00 
 * @Last Modified by:   Eric Wong 
 * @Last Modified time: 2022-01-15 22:54:00 
 */

module pc_reg # (
        parameter Width = 32
    )
    (
        input                   clk,
        input                   reset,                  // Active high
        input       [Width-1:0] pc_next,
        output reg  [Width-1:0] pc
    );
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 0;
        end

        else begin
            pc <= pc_next;
        end
    end
endmodule
