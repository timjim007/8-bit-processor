`timescale 1ns / 1ps

module controller(
    input [3:0] opcode_i,
    input flag_carry,
    input flag_zero,
    output [3:0] alu_op_o,
    output en_jmp_o,
    output we_mem_o,
    output ld_mem_o,
    output we_reg_o,
    output en_immediate_o,
    output use_immediate_pc
    );
    
    `include "instructionset.v"
    
    
    assign we_mem_o = (opcode_i == `OP_ST);
    assign ld_mem_o = (opcode_i == `OP_LD);
    
    assign alu_op_o = (opcode_i[3] == 1'b1)? opcode_i[3:0] : `ALU_MOD_NOP;
    
    assign we_reg_o = (opcode_i[3] == 1'b1 | opcode_i == `OP_LD | opcode_i == `OP_LDI) ? 1'b1 : 1'b0;
    
    assign en_jmp_o = (opcode_i == `OP_JMP | opcode_i == `OP_JE | opcode_i == `OP_JNE | opcode_i == `OP_JC) ? 1'b1 : 1'b0;
    
    assign use_immediate_pc = (opcode_i == `OP_JMP) ? 1'b1 : 1'b0;
    
    assign en_immediate_o = (en_jmp_o == 1'b1 | opcode_i == `OP_LDI) ? 1'b1 : 1'b0;
    
    
    
    
endmodule