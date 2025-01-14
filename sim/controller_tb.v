`timescale 1ns / 1ps

module controller_tb(
    );
    
    reg [3:0] opcode_i;
    reg flag_carry;
    reg flag_zero;
    wire [2:0] alu_op_o;
    wire en_jmp_o;
    wire we_mem_o;
    wire ld_mem_o;
    wire we_reg_o;
    wire en_immediate_o;

    // Instantiate the controller module
    controller uut (
        .opcode_i(opcode_i),
        .flag_carry(flag_carry),
        .flag_zero(flag_zero),
        .alu_op_o(alu_op_o),
        .en_jmp_o(en_jmp_o),
        .we_mem_o(we_mem_o),
        .ld_mem_o(ld_mem_o),
        .we_reg_o(we_reg_o),
        .en_immediate_o(en_immediate_o)
    );
    
    // Test case variables
    reg [3:0] opcode_list [0:11];
    integer i;

    initial begin

        // Initialize opcodes
        opcode_list[0] = 4'b0000; // ST
        opcode_list[1] = 4'b0001; // LDI
        opcode_list[2] = 4'b0010; // LD
        opcode_list[3] = 4'b0011; // JE
        opcode_list[4] = 4'b0100; // JMP
        opcode_list[5] = 4'b0101; // JNE
        opcode_list[6] = 4'b0110; // JC
        opcode_list[7] = 4'b1000; // ALU_ADD
        opcode_list[8] = 4'b1001; // ALU_SUB
        opcode_list[9] = 4'b1010; // ALU_INC
        opcode_list[10] = 4'b1011; // ALU_DEC
        opcode_list[11] = 4'b1111; // NOP

        // Default signals
        flag_carry = 0;
        flag_zero = 0;

        // Test each opcode
        for (i = 0; i < 12; i = i + 1) begin
            opcode_i = opcode_list[i];

            // Test JE (set flag_zero = 1 for testing)
            if (opcode_i == 4'b0011) flag_zero = 1;
            else flag_zero = 0;

            // Test JC (set flag_carry = 1 for testing)
            if (opcode_i == 4'b0110) flag_carry = 1;
            else flag_carry = 0;

            #10; // Wait 10 time units for output to stabilize

            // Display results
            $display("Opcode: %b, ALU Op: %b, JMP: %b, WE_MEM: %b, LD_MEM: %b, WE_REG: %b, EN_IMM: %b",
                     opcode_i, alu_op_o, en_jmp_o, we_mem_o, ld_mem_o, we_reg_o, en_immediate_o);
        end

        $stop;
    end