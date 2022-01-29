/*
 * @Author: Eric Wong 
 * @Date: 2022-01-15 15:02:39 
 * @Last Modified by:   Eric Wong 
 * @Last Modified time: 2022-01-15 15:02:39 
 */

module mux2 # (
        parameter Width = 32
    )
    (
        input       [Width-1:0] data_in_0   ,
        input       [Width-1:0] data_in_1   ,
        input                   sel         ,
        output reg  [Width-1:0] data_out
    );
    always @(*) begin
        case (sel)
            1'b0: data_out = data_in_0;
            1'b1: data_out = data_in_1;
            default: data_out = data_in_0;
        endcase
    end
endmodule
