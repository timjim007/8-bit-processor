`timescale 1ns / 1ps

module cpu(
    input clk,
    input rst_n,
    output [6:0] seg,
    output [3:0] an
    );
    
wire [2:0] rs1;
wire [2:0] rs2;
wire [2:0] rd;
wire [2:0] alu_op;
wire we_mem;
wire we_reg;
wire ld_mem;
wire en_jmp;
wire en_immediate;
wire [7:0] immediate;

/*
====================Controller====================
*/

controller controller (
    .opcode_i(opcode),
    .flag_carry(flag_carry),
    .flag_zero(flag_zero),
    .alu_op_o(alu_op),
    .en_jmp_o(en_jmp),
    .we_mem_o(we_mem),
    .ld_mem_o(ld_mem),
    .we_reg_o(we_reg),
    .en_immediate_o(en_immediate)
    
);

wire [3:0] opcode;
/*
====================DECODER====================
*/
decoder decoder(
    .instr(instruction),
    .opcode_out(opcode),
    .rs1_out(rs1),
    .rs2_out(rs2),
    .rd_out(rd),
    .immediate(immediate)
 );
 
wire [7:0] a;
wire [7:0] b;
wire [7:0] reg_val;

assign reg_val = (ld_mem == 1'b1) ? mem_out: alu_result;
 /*
====================REGISTER FILE====================
*/
register_file register_file(
     .clk(clk),
     .we(we_reg),
     .rs1_in(rs1),
     . rs2_in(rs2),
     . rd_in(rd),
     . data(reg_val),
     . rs1_out(a),
     . rs2_out(b)

);

wire[7:0] mem_out;
/*
====================DATA MEMORY====================
*/
ram ram(
     .clk(clk),
     .we(we_mem),
     .d_in(b),
     .addr(alu_result),
     .d_out(mem_out)
);

wire[15:0] instruction;
/*
====================INSTRUCTION MEMORY====================
*/
rom rom(
    .clk(clk),
    .addr(pc_out),
    .instr(instruction)

);

wire[7:0] pc_out;
wire [7:0] pc_in;

assign pc_in = (en_jmp == 1'b1) ? alu_result : pc_out +1;
/*
====================PROGRAM COUNTER====================
*/
program_counter pc(
    .clk(clk),
    .rst_n(rst_n),
    .pc_in(pc_in),
    .pc_out(pc_out)
);

wire flag_carry;
wire flag_zero;
wire alu_result;

wire [7:0] a_tmp;

assign a_tmp = (en_immediate == 1'b1) ? immediate : a;
/*
====================ALU====================
*/
alu alu(
    .clk(clk),
    .rst_n(rst_n),
    .A_in(a_tmp),    
    .B_in(b),    
    .alu_op(alu_op),    
    .alu_out(alu_result), 
    .carry_out(flag_carry),        
    .zero_flag(flag_zero)
);

/*
====================7-segment display====================
*/
seven_segment display (
        .clk(clk),
        .value(alu_result), // Display the ALU result
        .LED_out(seg),
        .an(an)
    );

endmodule
