`timescale 1ns / 1ps

module ram #(parameter DATA_WIDTH = 8)(
    input clk,
    input we,
    input[DATA_WIDTH - 1: 0] d_in,
    input [DATA_WIDTH - 1: 0] addr,
    output [DATA_WIDTH - 1: 0] d_out
    );
    
    reg [DATA_WIDTH -1: 0] mem [0:255];
    
//     initial begin
//        // Load RAM 
//        $readmemb("ram_data.mem", mem);
//    end
    
    always @(posedge clk)
    begin
        if(we)
            mem[addr] <= d_in;
    end
    
    assign d_out = mem[addr];
endmodule
