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
