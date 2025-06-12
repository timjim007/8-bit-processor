module cpu_tb(
    );

    // Inputs
    reg clk;
    reg rst_n;
    reg [2:0] sw;

    // Outputs
    wire [6:0] seg;
    wire [3:0] an;
    wire [7:0] led_test;
    wire [7:0] alu_output;
    wire [7:0] pc_output;
    wire [3:0] alu_opcode;
    wire [3:0] instr_opcode;
    wire [7:0] debug_reg_value;

    // Instantiate the CPU
    cpu uut (
        .clk(clk),
        .rst_n(rst_n),
        .sw(sw),
        .seg(seg),
        .an(an),
        .led_test(led_test),
        .alu_output(alu_output),
        .pc_output(pc_output),
        .alu_opcode(alu_opcode),
        .instr_opcode(instr_opcode),
        .debug_reg_select(sw),
        .debug_reg_value(debug_reg_value)
    );

    // Clock generation: 10ns period (100 MHz)
    always #5 clk = ~clk;

    initial begin
        // Initial state
        clk = 0;
        rst_n = 0;
        sw = 3'b000;

        // Hold reset low for a short period
        #20;
        rst_n = 1;

        // Simulate switching through registers every 100ns
        #100 sw = 3'b000;  // r0
        #100 sw = 3'b001;  // r1
        #100 sw = 3'b010;  // r2
        #100 sw = 3'b011;  // r3
        #100 sw = 3'b100;  // r4
        #100 sw = 3'b101;  // r5
        #100 sw = 3'b110;  // r6
        #100 sw = 3'b111;  // r7

        // Run simulation for a while
        #1000;

        // Finish
        $finish;
    end

    // Monitor key signals
    initial begin
        $monitor("Time=%0t | PC=%d | alu_out=%d | instr_op=%b | reg_sel=%b | reg_val=%d | LED=%b | seg=%b | an=%b", 
                  $time, pc_output, alu_output, instr_opcode, sw, debug_reg_value, led_test, seg, an);
    end

endmodule
