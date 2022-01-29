/*
 * @Author: Eric Wong
 * @Date: 2022-01-15 12:30
 * @Last Modified by:   Eric Wong
 * @Last Modified time: 2022-01-15 12:30
 */

module adder # (
        parameter Width = 32
    )
    (
        input   [Width-1:0] a   ,
        input   [Width-1:0] b   ,
        input               cin ,
        output  [Width-1:0] sum ,
        output              cout
    );
    assign {cout,sum} = a + b + cin;
endmodule
