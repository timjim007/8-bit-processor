`timescale 1ns / 1ps

module decoder_tb(
    );
    
    //Declare signals
    reg [15:0] instr;
    wire [3:0] opcode_out;
    wire [2:0] rs1_out, rs2_out, rd_out;
    wire [7:0] immediate;

    // Instantiate the decoder module
    decoder uut (
        .instr(instr),
        .opcode_out(opcode_out),
        .rs1_out(rs1_out),
        .rs2_out(rs2_out),
        .rd_out(rd_out),
        .immediate(immediate)
    );

     initial begin
        $monitor("Time: %0t | instr: %b | opcode_out: %b | rs1_out: %b | rs2_out: %b | rd_out: %b | immediate: %b",
                 $time, instr, opcode_out, rs1_out, rs2_out, rd_out, immediate);

        // Test ADD (add rd, rs1, rs2)
        instr = 16'b0000001000101000; // opcode = 1000, rd = 001, rs1 = 010, rs2 = 000
        #10;

        // Test SUB (sub rd, rs1, rs2)
        instr = 16'b0000001000101001; // opcode = 1001, rd = 001, rs1 = 010, rs2 = 000
        #10;

        // Test INC (inc rd, rs1)
        instr = 16'b0000001000101010; // opcode = 1010, rd = 001, rs1 = 010
        #10;

        // Test DEC (dec rd, rs1)
        instr = 16'b0000001000101011; // opcode = 1011, rd = 001, rs1 = 010
        #10;

        // Test AND (and rd, rs1, rs2)
        instr = 16'b0000001000101100; // opcode = 1100, rd = 001, rs1 = 010, rs2 = 000
        #10;

        // Test OR (or rd, rs1, rs2)
        instr = 16'b0000001000101110; // opcode = 1110, rd = 001, rs1 = 010, rs2 = 000
        #10;

        // Test XOR (xor rd, rs1, rs2)
        instr = 16'b0000001000101101; // opcode = 1101, rd = 001, rs1 = 010, rs2 = 000
        #10;

        // Test NOP (nop rd, rs1)
        instr = 16'b0000001000101111; // opcode = 1111, rd = 001, rs1 = 010
        #10;

        // Test JE (je immediate)
        instr = 16'b1010101000000011; // opcode = 0011, immediate = 10101010
        #10;

        // Test JMP (jmp immediate)
        instr = 16'b1010101000000100; // opcode = 0100, immediate = 10101010
        #10;

        // Test JNE (jne immediate)
        instr = 16'b1010101000000101; // opcode = 0101, immediate = 10101010
        #10;

        // Test JC (jc immediate)
        instr = 16'b1010101000000110; // opcode = 0110, immediate = 10101010
        #10;

        // Test ST (st rs1, rs2)
        instr = 16'b0000001000100000; // opcode = 0000, rs1 = 010, rs2 = 000
        #10;

        // Test LDI (ldi rs1, immediate)
        instr = 16'b1010101000000001; // opcode = 0001, rs1 = 010, immediate = 10101010
        #10;

        // Test LD (ld rd, rs1)
        instr = 16'b0000001000100010; // opcode = 0010, rd = 001, rs1 = 010
        #10;

        $finish;
    end

endmodule


