/*
 * @Author: Eric Wong 
 * @Date: 2022-01-15 14:18:30 
 * @Last Modified by:   Eric Wong 
 * @Last Modified time: 2022-01-15 14:18:30 
 */

module comparator # (
        parameter Width = 32
    )
    (
        input   [Width-1:0] a   ,
        input   [Width-1:0] b   ,
        output              eq  ,
        output              neq ,
        output              lt  ,
        output              lte ,
        output              gt  ,
        output              gte
    );
    assign eq   =   (a == b) ?
                    1'b1 :
                    1'b0;

    assign neq  =   ~eq;

    assign lt   =   (a < b) ?
                    1'b1 :
                    1'b0;

    assign lte  =   (a <= b) ?
                    1'b1 :
                    1'b0;

    assign gt   =   ~lte;

    assign gte  =   ~lt;
endmodule
