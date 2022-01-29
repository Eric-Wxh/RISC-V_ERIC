/*
 * @Author: Eric Wong 
 * @Date: 2022-01-20 01:03:50 
 * @Last Modified by:   Eric Wong 
 * @Last Modified time: 2022-01-20 01:03:50 
 */

/*
 * @Author: Eric Wong 
 * @Date: 2022-01-28 21:56:56 
 * @Last Modified by:   Eric Wong 
 * @Last Modified time: 2022-01-28 21:56:56
 * @Description: Modify input ports to support pipeline, compared to it in single riscv design
 */

module controller # (
        parameter Width = 32
    )
    (
        input       [6:0]   opcode,
        input       [2:0]   funct3,         // Instr[14:12]
        input               funct7_5,
        output  reg         Branch,         // beq
        output  reg         Jump,           // jal
        output  reg [1:0]   ResultSrc,
        output  reg         Mem_Write,
        output  reg [2:0]   ALUCtrl,
        output  reg         ALUSrc,
        output  reg [1:0]   ImmSrc,
        output  reg         Reg_Write
    );
    reg [1:0]   ALUOp   ;
    
    // Main Decoder
    always @(*) begin
        case (opcode)
            7'b000_0011: begin          // lw
                {Branch,Jump,ResultSrc,Mem_Write,ALUSrc,ImmSrc,Reg_Write,ALUOp} = {1'b0,1'b0,2'b01,1'b0,1'b1,2'b00,1'b1,2'b00};
            end

            7'b001_0011: begin          // addi
                {Branch,Jump,ResultSrc,Mem_Write,ALUSrc,ImmSrc,Reg_Write,ALUOp} = {1'b0,1'b0,2'b00,1'b0,1'b1,2'b00,1'b1,2'b10};
            end

            7'b010_0011: begin          // sw
                {Branch,Jump,ResultSrc,Mem_Write,ALUSrc,ImmSrc,Reg_Write,ALUOp} = {1'b0,1'b0,2'b00,1'b1,1'b1,2'b01,1'b0,2'b00};
            end

            7'b011_0011: begin          // R-Type Instruction
                {Branch,Jump,ResultSrc,Mem_Write,ALUSrc,ImmSrc,Reg_Write,ALUOp} = {1'b0,1'b0,2'b00,1'b0,1'b0,2'b00,1'b1,2'b10};
            end

            7'b110_0011: begin          // beq
                {Branch,Jump,ResultSrc,Mem_Write,ALUSrc,ImmSrc,Reg_Write,ALUOp} = {1'b1,1'b0,2'b00,1'b0,1'b0,2'b10,1'b0,2'b01};
            end

            7'b110_1111: begin          // jal
                {Branch,Jump,ResultSrc,Mem_Write,ALUSrc,ImmSrc,Reg_Write,ALUOp} = {1'b0,1'b1,2'b10,1'b0,1'b0,2'b11,1'b1,2'b00};
            end

            default: begin              // nop (addi x0, x0, 0)
                {Branch,Jump,ResultSrc,Mem_Write,ALUSrc,ImmSrc,Reg_Write,ALUOp} = {1'b0,1'b0,2'b00,1'b0,1'b1,2'b00,2'b1,2'b10};
            end
        endcase
    end

    // ALU Decoder
    always @(*) begin
        case (ALUOp)
            2'b00: begin                // lw, sw
                ALUCtrl = 3'b000;
            end

            2'b01: begin                // beq
                ALUCtrl = 3'b001;
            end

            2'b10: begin                // R-Type Instruction
                case (funct3)
                    3'b000: begin       // subtract
                        if ({opcode[5],funct7_5} == 2'b11) begin
                            ALUCtrl = 3'b001;
                        end

                        else begin      // add
                            ALUCtrl = 3'b000;
                        end
                    end

                    3'b010: begin       // slt
                        ALUCtrl = 3'b101;
                    end

                    3'b110: begin       // or
                        ALUCtrl = 3'b011;
                    end

                    3'b111: begin       // and
                        ALUCtrl = 3'b010;
                    end

                    default: begin
                        ALUCtrl = 3'b000;
                    end
                endcase
            end

            default: begin
                ALUCtrl = 3'b000;
            end
        endcase
    end
endmodule
