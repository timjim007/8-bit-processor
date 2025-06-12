`timescale 1ns / 1ps

module program_counter #(parameter DATA_WIDTH = 8) (
    input clk,
    input rst,
    input [DATA_WIDTH - 1: 0] pc_in,
    output [DATA_WIDTH - 1: 0] pc_out
    );
    
    reg [DATA_WIDTH - 1: 0] out_reg;
   
    
    always @(posedge clk,posedge rst)
    begin
        if(rst)
            out_reg <= 0;
    else
        out_reg <= pc_in;
    end
    
    assign pc_out = out_reg;
endmodule