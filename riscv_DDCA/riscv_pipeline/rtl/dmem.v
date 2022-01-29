/*
 * @Author: Eric Wong 
 * @Date: 2022-01-17 16:57:13 
 * @Last Modified by:   Eric Wong 
 * @Last Modified time: 2022-01-17 16:57:13 
 */

module dmem # (
        parameter Width = 32
    )
    (
        input               clk     ,
        input   [Width-1:0] addr    ,
        input               we      ,
        input   [Width-1:0] wr_data ,
        output  [Width-1:0] rd
    );
    
    reg [Width-1:0] mem [63:0];

    always @(posedge clk) begin
        if (we) begin
            mem[addr[Width-1:2]] <= wr_data;
        end

        else begin
            mem[addr[Width-1:2]] <= mem[addr[Width-1:2]];
        end
    end

    assign rd = mem[addr[Width-1:2]];
endmodule
