/*
 * @Author: Eric Wong 
 * @Date: 2022-01-28 22:20:44 
 * @Last Modified by:   Eric Wong 
 * @Last Modified time: 2022-01-28 22:20:44 
 */

module hazard (
        input       [4:0]   Rs1D        ,
        input       [4:0]   Rs2D        ,
        input       [4:0]   RdE         ,
        input       [4:0]   Rs1E        ,
        input       [4:0]   Rs2E        ,
        input               PCSrcE      ,
        input               ResultSrcE_0,
        input       [4:0]   RdM         ,
        input               RegWriteM   ,
        input       [4:0]   RdW         ,
        input               RegWriteW   ,

        output              StallF      ,
        output              StallD      ,
        output              FlushD      ,
        output              FlushE      ,
        output  reg [1:0]   ForwardAE   ,
        output  reg [1:0]   ForwardBE
    );
    wire lwStall;
    wire PCSrcE;
    //----------------------------<Forwarding to solve data hazard>----------------------------//
    // Forwarding A
    always @(*) begin
        if ((Rs1E == RdM) && RegWriteM) begin
            ForwardAE = 2'b10;
        end

        else if ((Rs1E == RdW) && RegWriteW) begin
            ForwardAE = 2'b01;
        end

        else begin
            ForwardAE = 2'b00;
        end
    end

    // Forwarding B
    always @(*) begin
        if ((Rs2E == RdM) && RegWriteM) begin
            ForwardBE = 2'b10;
        end

        else if ((Rs2E == RdW) && RegWriteW) begin
            ForwardBE = 2'b01;
        end

        else begin
            ForwardBE = 2'b00;
        end
    end

   //----------------------------<stalling to solve data & control hazard>----------------------------//
   // Although this may lead to the unecessary stall when execute J-Type or I-Type instructions, 
   // it only causes a small performance loss and save the cost.
   assign lwStall = ResultSrcE_0 && ((RdE == Rs1D) || (RdE == Rs2D));

   assign StallF = lwStall;
   assign StallD = lwStall;
   
   assign FlushD = PCSrcE;
   assign FlushE = lwStall | PCSrcE;
endmodule
