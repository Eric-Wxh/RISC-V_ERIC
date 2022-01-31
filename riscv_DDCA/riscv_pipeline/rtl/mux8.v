/*
 * @Author: Eric Wong 
 * @Date: 2022-01-15 15:10:18 
 * @Last Modified by:   Eric Wong 
 * @Last Modified time: 2022-01-15 15:10:18 
 */

module mux8 # (
        parameter Width = 32
    )
    (
        input       [Width-1:0] data_in_0   ,
        input       [Width-1:0] data_in_1   ,
        input       [Width-1:0] data_in_2   ,
        input       [Width-1:0] data_in_3   ,
        input       [Width-1:0] data_in_4   ,
        input       [Width-1:0] data_in_5   ,
        input       [Width-1:0] data_in_6   ,
        input       [Width-1:0] data_in_7   ,
        input       [2:0]       sel         ,
        output reg  [Width-1:0] data_out
    );
    always @(*) begin
        case (sel)
            3'b000: data_out = data_in_0;
            3'b001: data_out = data_in_1;
            3'b010: data_out = data_in_2;
            3'b011: data_out = data_in_3;
            3'b100: data_out = data_in_4;
            3'b101: data_out = data_in_5;
            3'b110: data_out = data_in_6;
            3'b111: data_out = data_in_7;
            default : data_out = data_in_0;
        endcase
    end
endmodule
