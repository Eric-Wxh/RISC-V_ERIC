/*
 * @Author: Eric Wong 
 * @Date: 2022-01-15 22:54:00 
 * @Last Modified by:   Eric Wong 
 * @Last Modified time: 2022-01-15 22:54:00 
 */

module dff_adj # (
        parameter Width = 32
    )
    (
        input                   clk,
        input                   reset,
        input                   clr,                    // sync, active high
        input                   en,                     // sync, active low
        input       [Width-1:0] d,
        output reg  [Width-1:0] q
    );
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 0;
        end

        else if (clr) begin
            q <= 0;
        end

        else if (!en) begin
            q <= d;
        end

        else begin
            q <= q;
        end
    end
endmodule
