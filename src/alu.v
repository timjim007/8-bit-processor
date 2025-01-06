`timescale 1ns / 1ps

module alu #(parameter N = 8)(
    input clk,
    input rst_n,
    input [N-1:0] A_in,    // Input A
    input [N-1:0] B_in,    // Input B
    input [3:0] alu_op,    // ALU operation selector
    output [N-1:0] alu_out, // ALU result
    output carry_out,        // Carry flag
    output zero_flag
    );

    `include "instructionset.v"
    
    reg carry_o_tmp, zero_o_tmp;
    reg [N-1:0] result;
    
    always @(posedge clk, negedge rst_n) begin
        if (~rst_n)  
        begin
            carry_o_tmp <= 0;
            zero_o_tmp <= 0; 
        end
         else 
         begin
        carry_o_tmp <= 0; 
        case (alu_op)
            `ALU_ADD: {carry_o_tmp, result} <= A_in + B_in; 
            `ALU_SUB: result <= A_in - B_in;
            `ALU_INC: {carry_o_tmp, result} <= A_in + 1;             
           `ALU_DEC: result <= A_in - 1;            
            `ALU_AND: result <= A_in & B_in;             
            `ALU_XOR: result <= A_in ^ B_in;                   
           `ALU_OR: result <= A_in | B_in;              
            `ALU_NOP: result <= A_in;               
            default: result <= A_in;                      
        endcase
        end
    end
    
    assign alu_out = result;
    assign carry_out = carry_o_tmp;
    assign zero_flag = (result == 0) ? 1 : 0;
    

endmodule