`timescale 1ns / 1ps

module decoder(
    input [15:0] instr,
    output [3:0] opcode_out,
    output [2:0] rs1_out,
    output [2:0] rs2_out,
    output [2:0] rd_out,
    output [7:0] immediate
    );
    
    `include "instructionset.v"
    
    wire [3:0] opcode_tmp;
    
    assign opcode_tmp = instr[3:0];
    assign rs1_out = instr[6:4];
    assign rs2_out = instr[9:7];
    assign rd_out = (opcode_tmp == `OP_LDI) ? instr[6:4] : (opcode_tmp == `OP_LD) ? instr[9:7] : instr[12:10];
    assign immediate = instr[15:8];
    
    assign opcode_out = opcode_tmp;
endmodule