/*
 * @Author: Eric Wong 
 * @Date: 2022-01-20 00:27:38 
 * @Last Modified by:   Eric Wong 
 * @Last Modified time: 2022-01-20 00:27:38 
 */

module mux4 #(
        parameter Width = 32
    )    
    (
        input       [Width-1:0] data_in_0,
        input       [Width-1:0] data_in_1,
        input       [Width-1:0] data_in_2,
        input       [Width-1:0] data_in_3,
        input       [1:0]       sel,
        output reg  [Width-1:0] data_out
    );
    always @(*) begin
        case (sel)
            2'b00: begin
                data_out = data_in_0;
            end

            2'b01: begin
                data_out = data_in_1;
            end

            2'b10: begin
                data_out = data_in_2;
            end

            2'b11: begin
                data_out = data_in_3;
            end

            default: begin
                data_out = 32'd0;
            end
        endcase
    end
endmodule
