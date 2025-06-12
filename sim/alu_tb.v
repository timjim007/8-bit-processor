`timescale 1ns / 1ps

 module alu_tb(

    );
    
    //Declare signals
    localparam BITS = 8;
    
    reg clk,rst_n;
    reg [BITS-1:0] A_in, B_in;    // Inputs to the ALU
    reg [3:0] alu_op;          // ALU operation selector
    wire [BITS-1:0] alu_out;      // ALU result
    wire carry_out, zero_flag;            
    
    // Instantiate unit under test
    alu #(.N(BITS)) uut (
        .clk(clk),
        .rst_n(rst_n),
        .A_in(A_in),
        .B_in(B_in),
        .alu_op(alu_op),
        .alu_out(alu_out),
        .carry_out(carry_out),
        .zero_flag(zero_flag)
    );
    
     // Clock generation
    always #5 clk = ~clk; // 10ns clock period
    
    // Test procedure
    initial begin
        // Initialize inputs
        clk = 0;
        rst_n = 0;
        A_in = 0;
        B_in = 0;
        alu_op = 0;

        // Reset the ALU
        #10 rst_n = 1;

        // Test ALU operations
        // Test ADD
        #10 A_in = 8'h0A; B_in = 8'h05; alu_op = `ALU_ADD;
        #10 $display("ADD: A=%h, B=%h, Out=%h, Carry=%b, Zero=%b", A_in, B_in, alu_out, carry_out, zero_flag);

        // Test SUB
        #10 A_in = 8'h0A; B_in = 8'h05; alu_op = `ALU_SUB;
        #10 $display("SUB: A=%h, B=%h, Out=%h, Carry=%b, Zero=%b", A_in, B_in, alu_out, carry_out, zero_flag);

        // Test INC
        #10 A_in = 8'hFF; alu_op = `ALU_INC;
        #10 $display("INC: A=%h, Out=%h, Carry=%b, Zero=%b", A_in, alu_out, carry_out, zero_flag);

        // Test DEC
        #10 A_in = 8'h01; alu_op = `ALU_DEC;
        #10 $display("DEC: A=%h, Out=%h, Carry=%b, Zero=%b", A_in, alu_out, carry_out, zero_flag);

        // Test AND
        #10 A_in = 8'hAA; B_in = 8'h55; alu_op = `ALU_AND;
        #10 $display("AND: A=%h, B=%h, Out=%h, Carry=%b, Zero=%b", A_in, B_in, alu_out, carry_out, zero_flag);

        // Test XOR
        #10 A_in = 8'hAA; B_in = 8'h55; alu_op = `ALU_XOR;
        #10 $display("XOR: A=%h, B=%h, Out=%h, Carry=%b, Zero=%b", A_in, B_in, alu_out, carry_out, zero_flag);

        // Test OR
        #10 A_in = 8'hAA; B_in = 8'h55; alu_op = `ALU_OR;
        #10 $display("OR: A=%h, B=%h, Out=%h, Carry=%b, Zero=%b", A_in, B_in, alu_out, carry_out, zero_flag);

        // Test NOP
        #10 A_in = 8'hFF; alu_op = `ALU_NOP;
        #10 $display("NOP: A=%h, Out=%h, Carry=%b, Zero=%b", A_in, alu_out, carry_out, zero_flag);

        // Finish simulation
        #10 $stop;
    end

    
endmodule
