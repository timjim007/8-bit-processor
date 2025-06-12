`timescale 1ns / 1ps

module program_counter_tb(

    );
    
     // Testbench parameters
    parameter DATA_WIDTH = 8;

    // Testbench signals
    reg clk;
    reg rst_n;
    reg [DATA_WIDTH-1:0] pc_in;
    wire [DATA_WIDTH-1:0] pc_out;

    // Instantiate the program counter module
    program_counter #(.DATA_WIDTH(DATA_WIDTH)) uut (
        .clk(clk),
        .rst_n(rst_n),
        .pc_in(pc_in),
        .pc_out(pc_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        rst_n = 0;           // Assert reset
        pc_in = 0;

        // Apply reset
        #10;                 // Hold reset for 10ns
        rst_n = 1;           // Deassert reset

        // Test case 1: Load a value into the program counter
        #10;
        pc_in = 8'h05;       // Set pc_in to 5
        #10;
        
        // Test case 2: Increment the program counter
        pc_in = 8'h06;       // Increment pc_in to 6
        #10;

        // Test case 3: Apply another value
        pc_in = 8'hFF;       // Set pc_in to 255
        #10;

        // Test case 4: Assert reset during operation
        rst_n = 0;           // Assert reset
        #10;
        rst_n = 1;           // Deassert reset

        // End simulation
        #10;
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time = %0t | clk = %b | rst_n = %b | pc_in = %h | pc_out = %h",
                 $time, clk, rst_n, pc_in, pc_out);
    end
    
endmodule
