`timescale 1ns / 1ps

module register_file_tb(
    );
    
    reg clk;
    reg we;
    reg [2:0] rs1_in;
    reg [2:0] rs2_in;
    reg [2:0] rd_in;
    reg [7:0] data;
    wire [7:0] rs1_out;
    wire [7:0] rs2_out;

    // Instantiate the register file module
    register_file uut (
        .clk(clk),
        .we(we),
        .rs1_in(rs1_in),
        .rs2_in(rs2_in),
        .rd_in(rd_in),
        .data(data),
        .rs1_out(rs1_out),
        .rs2_out(rs2_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock period: 10 time units
    end
    
    // Test case variables
        integer idx;
        
    initial begin
        // Initialize inputs
        we = 0;
        rs1_in = 3'b000;
        rs2_in = 3'b000;
        rd_in = 3'b000;
        data = 8'b00000000;

        // Reset all registers by writing zeroes
        we = 1;
        for (idx = 0; idx < 8; idx = idx + 1) begin
            rd_in = idx[2:0];
            data = 8'b00000000;
            #10;
        end

        // Write data to registers
        we = 1;
        rd_in = 3'b001; data = 8'b10101010; #10;
        rd_in = 3'b010; data = 8'b11001100; #10;
        rd_in = 3'b011; data = 8'b11110000; #10;

        // Disable write
        we = 0;

        // Read data from registers
        rs1_in = 3'b001; rs2_in = 3'b010; #10;
        $display("RS1: %b, RS2: %b", rs1_out, rs2_out);

        rs1_in = 3'b011; rs2_in = 3'b001; #10;
        $display("RS1: %b, RS2: %b", rs1_out, rs2_out);

        // Test overwriting a register
        we = 1;
        rd_in = 3'b001; data = 8'b00001111; #10;
        we = 0;

        rs1_in = 3'b001; #10;
        $display("RS1 (after overwrite): %b", rs1_out);

        // End simulation
        $stop;
    end
endmodule
