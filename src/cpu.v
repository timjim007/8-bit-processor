`timescale 1ns / 1ps

module cpu(
    input clk,
    input rst,
    input [2:0] sw,
    output [6:0] seg,
    output [3:0] an,
//   output [7:0] led_test,
//    output [7:0] alu_output,
//    output [7:0] pc_output,
//   output [3:0] alu_opcode,
//    output [3:0] instr_opcode,
    
    //Debug port
    output [7:0] debug_reg_value

    );
    
    `include "instructionset.v"
    
    
    reg [23:0] clk_div = 0;
    reg slow_clk = 0;
    
    always @(posedge clk) begin
        clk_div <= clk_div + 1;
        if (clk_div == 5_000_000) begin // ~100ms toggle at 100 MHz
            clk_div <= 0;
            slow_clk <= ~slow_clk;
        end
    end
    
    
    // Wires for program counter
wire [7:0] pc_out;
reg [7:0] pc_in;
//    assign pc_output = pc_out;
    
    // Instruction memory output
wire [15:0] instruction;
rom rom(
    .clk(slow_clk),
    .addr(pc_out),
    .instr(instruction)
);

// Pipeline registers: IF/ID
reg [15:0] ifid_instr;
reg [7:0]  ifid_pc;

always @(posedge slow_clk or posedge rst) begin
    if (rst) begin
        ifid_instr <= 0;
        ifid_pc <= 0;
    end else begin
        ifid_instr <= instruction;
        ifid_pc <= pc_out;
    end
end

// Decode
wire [2:0] rs1, rs2, rd;
wire [3:0] opcode;
wire [7:0] immediate;

//assign instr_opcode = opcode;

decoder decoder(
    .instr(ifid_instr),
    .opcode_out(opcode),
    .rs1_out(rs1),
    .rs2_out(rs2),
    .rd_out(rd),
    .immediate(immediate)
);

// Control signals
wire [3:0] alu_op;
wire we_mem, we_reg, ld_mem, en_jmp, en_immediate, use_immediate_pc;
wire flag_carry, flag_zero;

controller controller(
    .opcode_i(opcode),
    .flag_carry(flag_carry),
    .flag_zero(flag_zero),
    .alu_op_o(alu_op),
    .en_jmp_o(en_jmp),
    .we_mem_o(we_mem),
    .ld_mem_o(ld_mem),
    .we_reg_o(we_reg),
    .en_immediate_o(en_immediate),
    .use_immediate_pc(use_immediate_pc)
);

//assign alu_opcode = alu_op;

// Register File Read
wire [7:0] reg_a, reg_b;
register_file register_file(
    .clk(slow_clk),
    .rst(rst),
    .we(memwb_we_reg),
    .rs1_in(rs1),
    .rs2_in(rs2),
    .rd_in(memwb_rd),
    .data(memwb_data),
    .rs1_out(reg_a),
    .rs2_out(reg_b),
    
    //Debug port
    .debug_reg_select(sw),
    .debug_reg_value(debug_reg_value)
);

// Pipeline registers: ID/EX
reg [3:0] idex_alu_op;
reg idex_we_mem, idex_ld_mem, idex_we_reg, idex_en_jmp, idex_en_imm, idex_use_immediate_pc;
reg [7:0] idex_a, idex_b, idex_imm;
reg [2:0] idex_rd;

always @(posedge slow_clk or posedge rst) begin
    if (rst) begin
        idex_alu_op <= 0;
        idex_we_mem <= 0;
        idex_ld_mem <= 0;
        idex_we_reg <= 0;
        idex_en_jmp <= 0;
        idex_en_imm <= 0;
        idex_a <= 0;
        idex_b <= 0;
        idex_imm <= 0;
        idex_rd <= 0;
        idex_use_immediate_pc <= 0;
    end else begin
        idex_alu_op <= alu_op;
        idex_we_mem <= we_mem;
        idex_ld_mem <= ld_mem;
        idex_we_reg <= we_reg;
        idex_en_jmp <= en_jmp;
        idex_en_imm <= en_immediate;
        idex_a <= reg_a;
        idex_b <= reg_b;
        idex_imm <= immediate;
        idex_rd <= rd;
        idex_use_immediate_pc <= use_immediate_pc;
    end
end

// ALU
wire [7:0] alu_result;
wire [7:0] alu_a = idex_en_imm ? idex_imm : idex_a;


alu alu(
    .clk(slow_clk),
    .rst(rst),
    .A_in(alu_a),
    .B_in(idex_b),
    .alu_op(idex_alu_op),
    .alu_out(alu_result),
    .carry_out(flag_carry),
    .zero_flag(flag_zero)
);

//assign alu_output = alu_result;

// Pipeline registers: EX/MEM
reg [7:0] exmem_result, exmem_b;
reg [2:0] exmem_rd;
reg exmem_we_mem, exmem_ld_mem, exmem_we_reg;

always @(posedge slow_clk or posedge rst) begin
    if (rst) begin
        exmem_result <= 0;
        exmem_b <= 0;
        exmem_rd <= 0;
        exmem_we_mem <= 0;
        exmem_ld_mem <= 0;
        exmem_we_reg <= 0;
    end else begin
        exmem_result <= alu_result;
        exmem_b <= idex_b;
        exmem_rd <= idex_rd;
        exmem_we_mem <= idex_we_mem;
        exmem_ld_mem <= idex_ld_mem;
        exmem_we_reg <= idex_we_reg;
    end
end

// Memory
wire [7:0] mem_out;
ram ram(
    .clk(slow_clk),
    .we(exmem_we_mem),
    .d_in(exmem_b),
    .addr(exmem_result),
    .d_out(mem_out)
);

// Pipeline registers: MEM/WB
reg [7:0] memwb_data;
reg [2:0] memwb_rd;
reg memwb_we_reg;

always @(posedge slow_clk or posedge rst) begin
    if (rst) begin
        memwb_data <= 0;
        memwb_rd <= 0;
        memwb_we_reg <= 0;
    end else begin
        memwb_data <= exmem_ld_mem ? mem_out : exmem_result;
        memwb_rd <= exmem_rd;
        memwb_we_reg <= exmem_we_reg;
    end
end


// Program Counter
always @(posedge slow_clk or posedge rst) begin
    if (rst) begin
        pc_in <= 0;
    end else if (idex_en_jmp) begin
        if (idex_use_immediate_pc) begin
            // unconditional jump
            pc_in <= idex_imm;
        end else begin
            // conditional jump: evaluate flags
            case (idex_alu_op)
                `OP_JE:  pc_in <= (flag_zero)      ? idex_imm : pc_out + 1;
                `OP_JNE: pc_in <= (!flag_zero)     ? idex_imm : pc_out + 1;
                `OP_JC:  pc_in <= (flag_carry)     ? idex_imm : pc_out + 1;
                default:  pc_in <= pc_out + 1;
            endcase
        end
    end else begin
        pc_in <= pc_out + 1;
    end
end

program_counter pc(
    .clk(slow_clk),
    .rst(rst),
    .pc_in(pc_in),
    .pc_out(pc_out)
);




//assign led_test = debug_reg_value;

// 7-segment display
seven_segment display (
    .clk(clk),
    .value(debug_reg_value),
    .LED_out(seg),
    .an(an)
);

endmodule
