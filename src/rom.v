`timescale 1ns / 1ps

module rom #(parameter DATA_WIDTH = 8)(
    input clk,
    input [DATA_WIDTH - 1: 0]addr,
    output[15: 0] instr
    );
    
    reg [15:0] mem[0:255];
    reg [15:0] tmp;
    
    always @(posedge clk)
    begin
        tmp <= mem[addr];
    end
    
    assign instr = tmp;
    