`timescale 1ns / 1ps

module seven_segment(
    input clk,
    input [7:0] value, // Value to display (alu_result)
    output reg [3:0] an,
    output reg [6:0] LED_out
    );
    
    reg [18:0] refresh_counter = 0; // Refresh rate counter
    reg [1:0] LED_select = 0;  // Active display selector
    reg [3:0] current_digit;       // Current digit to display
    
    
   // Refresh rate: 240 Hz for each digit (60 Hz full display cycle)
    always @(posedge clk) begin
        if (refresh_counter >= 416667) begin
            refresh_counter <= 0;
            LED_select <= LED_select + 1;
        end else begin
            refresh_counter <= refresh_counter + 1;
        end
    end

    
    
   // Anode activation and digit selection
    always @(*) begin
        case (LED_select)
            2'b00: begin
                an = 4'b1110;  // Rightmost digit (ones)
                current_digit = (value % 10);
            end
            2'b01: begin
                an = 4'b1101;  // Tens digit
                current_digit = (value % 100) / 10;
            end
            2'b10: begin
                an = 4'b1011;  // Hundreds digit
                current_digit = (value / 100);
            end
            2'b11: begin
                an = 4'b0111;  // Leftmost digit (unused or blank)
                current_digit = 4'b0000;
            end
    endcase 

    end

    // 7-segment encoding (Decimal to 7-segment mapping)
    always @(*) begin
        case (current_digit)
            4'h0: LED_out = 7'b0000001;
            4'h1: LED_out = 7'b1001111;
            4'h2: LED_out = 7'b0010010;
            4'h3: LED_out = 7'b0000110;
            4'h4: LED_out = 7'b1001100;
            4'h5: LED_out = 7'b0100100;
            4'h6: LED_out = 7'b0100000;
            4'h7: LED_out = 7'b0001111;
            4'h8: LED_out = 7'b0000000;
            4'h9: LED_out = 7'b0000100;
            default: LED_out = 7'b1111111; // All segments off
        endcase
    end
endmodule