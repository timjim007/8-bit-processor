`timescale 1ns / 1ps

module register_file(
    input clk,
    input rst, 
    input we,
    input [2:0]rs1_in,
    input [2:0] rs2_in,
    input [2:0] rd_in,
    input [7:0] data,
    output [7:0] rs1_out,
    output [7:0] rs2_out,
    
    // Debug port
    input [2:0] debug_reg_select,
    output [7:0] debug_reg_value
    );
    
    reg [7:0] registers[7:0];
    
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all registers to 0
            for (i = 0; i < 8; i = i + 1)
                registers[i] <= 8'b0;
        end else if (we) begin
            registers[rd_in] <= data;
        end
    end

    assign rs1_out = registers[rs1_in];
    assign rs2_out = registers[rs2_in];
    assign debug_reg_value = registers[debug_reg_select];
    
    
endmodule
