`timescale 1ns / 1ps

module alu #(parameter N = 8)(
    input clk,
    input rst,
    input [N-1:0] A_in,    // Input A
    input [N-1:0] B_in,    // Input B
    input [3:0] alu_op,    // ALU operation selector
    output [7:0] alu_out, // ALU result
    output carry_out,        // Carry flag
    output zero_flag
    );

    `include "instructionset.v"
    
    reg carry_o_tmp;
    reg zero_flag_tmp;
    reg [7:0] result;
    
  always @(posedge clk or posedge rst) begin
    if (rst) begin
        carry_o_tmp <= 0;
        result <= 0;
        zero_flag_tmp <= 0;
    end else begin
        case (alu_op)
            `ALU_ADD: begin
                {carry_o_tmp, result} <= A_in + B_in;
                zero_flag_tmp <= ((A_in + B_in) == 0);
            end
            `ALU_SUB: begin
                {carry_o_tmp, result} <= {1'b0, A_in} - {1'b0, B_in};
                zero_flag_tmp <= ((A_in - B_in) == 0);
            end
            `ALU_INC: begin
                {carry_o_tmp, result} <= A_in + 1;
                zero_flag_tmp <= ((A_in + 1) == 0);
            end
            `ALU_DEC: begin
                result <= A_in - 1;
                zero_flag_tmp <= ((A_in - 1) == 0);
            end
            `ALU_AND: begin
                result <= A_in & B_in;
                zero_flag_tmp <= ((A_in & B_in) == 0);
            end
            `ALU_XOR: begin
                result <= A_in ^ B_in;
                zero_flag_tmp <= ((A_in ^ B_in) == 0);
            end
            `ALU_OR: begin
                result <= A_in | B_in;
                zero_flag_tmp <= ((A_in | B_in) == 0);
            end
            `ALU_NOP: begin
                result <= A_in;         // pass through or do nothing
                zero_flag_tmp <= zero_flag_tmp;  // do not change flag!
            end
            default: begin
                result <= A_in;
                zero_flag_tmp <= zero_flag_tmp;  // default: hold previous flag
            end
        endcase

        if (alu_op != `ALU_ADD && alu_op != `ALU_INC && alu_op != `ALU_SUB)
            carry_o_tmp <= 0;
    end
end
    
    assign alu_out = result;
    assign carry_out = carry_o_tmp;
    assign zero_flag = zero_flag_tmp;
    

endmodule