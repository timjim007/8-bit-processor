`timescale 1ns / 1ps

module register_file(
    input clk,
    input we,
    input [2:0]rs1_in,
    input [2:0] rs2_in,
    input [2:0] rd_in,
    input [7:0] data,
    output [7:0] rs1_out,
    output [7:0] rs2_out
    );
    
    reg [7:0] registers[7:0];
    
    always @(posedge clk)
    begin
        if(we)
        registers[rd_in] <= data;
        
    end
    
    assign rs1_out = registers[rs1_in];
    assign rs2_out = registers[rs2_in];
    
endmodule