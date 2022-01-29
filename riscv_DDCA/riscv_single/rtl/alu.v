/*
 * @Author: Eric Wong 
 * @Date: 2022-01-15 15:23:39 
 * @Last Modified by:   Eric Wong 
 * @Last Modified time: 2022-01-15 15:23:39 
 */

module alu # (
        parameter Width = 32
    )
    (
        input   [Width-1:0] A       ,
        input   [Width-1:0] B       ,
        input   [2:0]       ALUCtrl ,
        output  [Width-1:0] Result  ,
        output  [3:0]       Flags                   // Flags = {N,Z,C,V}
    );
    wire [Width-1:0]    B_sel   ;
    wire [Width-1:0]    aANDb   ;
    wire [Width-1:0]    aORb    ;
    wire [Width-1:0]    sum     ;
    wire                cout    ;
    wire                lt      ;
    wire                N       ;                   // Negative
    wire                Z       ;                   // Zero
    wire                C       ;                   // Carry
    reg                 V       ;                   // oVerflow

    assign aANDb = A & B;
    assign aORb = A | B;
    assign lt = sum[31] ^ V;

    // oVerflow judgment
    always @(*) begin
        if (!ALUCtrl[0]) begin                      // when A+B
            V = (~(A[31] ^ B[31])) & (A[31] ^ sum[31]);
        end

        else begin                                  // when A-B
            V = (A[31] ^ B[31]) & (A[31] ^ sum[31]);
        end
    end

    assign Z = ~(|Result);                          // Result == 0, Z = 0
    assign N = Result[31];                          // Result[31] = 1, Negative
    assign C =  cout;

    assign Flags =  (!(|ALUCtrl[2:1])) ?            // Only when ALUCtrl = 3'b000 or 3'b001, Carry and oVerflow can be active
                    {N,Z,C,V} : 
                    {N,Z,1'b0,1'b0};

    //mux2
    mux2
    # (
        .Width (Width)
    )
    mux2_inst (
        .data_in_0  (B)         ,                   // ALUCtrl[0] = 0, A+B
        .data_in_1  (~B)        ,                   // ALUCtrl[0] = 1, A-B
        .sel        (ALUCtrl[0]),
        .data_out   (B_sel)
    );

    // adder32
    adder
    # (
        .Width (Width)
    )
    adder_inst (
        .a      (A),
        .b      (B_sel),
        .cin    (ALUCtrl[0]),
        .sum    (sum),
        .cout   (cout)
    );

    mux8
    # (
        .Width (Width)
    )
    mux8_inst (
        .data_in_0  (sum)                   ,       // ALUCtrl = 3'b000, Funct: Add
        .data_in_1  (sum)                   ,       // ALUCtrl = 3'b001, Funct: Sub
        .data_in_2  (aANDb)                 ,       // ALUCtrl = 3'b010, Funct: AND
        .data_in_3  (aORb)                  ,       // ALUCtrl = 3'b011, Funct: OR
        .data_in_4  (32'd0)                 ,
        .data_in_5  ({31'd0,lt})            ,       // ALUCtrl = 3'b101, Funct: SLT (if a < b, then Result = 32'd1)
        .data_in_6  (32'd0)                 ,
        .data_in_7  (32'd0)                 ,
        .sel        (ALUCtrl)               ,
        .data_out   (Result)
    );
endmodule
