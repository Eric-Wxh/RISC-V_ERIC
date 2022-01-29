/*
 * @Author: Eric Wong 
 * @Date: 2022-01-17 17:56:06 
 * @Last Modified by:   Eric Wong 
 * @Last Modified time: 2022-01-17 17:56:06 
 */

module extend # (
        parameter Width = 32
    )
    (
        input       [31:7]      Instr   ,
        input       [1:0]       ImmSrc  ,
        output reg  [Width-1:0] ImmExt
    );
    
    always @(*) begin
        case (ImmSrc)
            2'b00: begin            // I type
                ImmExt = {{20{Instr[31]}},Instr[31:20]};
            end

            2'b01: begin            // S type
                ImmExt = {{20{Instr[31]}},Instr[31:25],Instr[11:7]};
            end

            2'b10: begin            // B type
                ImmExt = {{20{Instr[31]}},Instr[7],Instr[30:25],Instr[11:8],1'b0};
            end

            2'b11: begin            // J type
                ImmExt = {{12{Instr[31]}},Instr[19:12],Instr[20],Instr[30:21],1'b0};
            end

            default: begin
                ImmExt = {{20{Instr[31]}},Instr[31:20]};
            end
        endcase
    end
endmodule
