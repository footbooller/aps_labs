`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.07.2025 15:19:15
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench();
    logic a, b, sum, carry;

    half_adder DUT(
    .a_i(a),
    .b_i(b),
    .sum_o(sum),
    .carry_o(carry)
    );

    initial begin
        a = 1'b0; b = 1'b0;
        #10;
        a = 1'b0; b = 1'b1;
        #10;
        a = 1'b1; b = 1'b0;
        #10;
        a = 1'b1; b = 1'b1;
        #10;
    end

endmodule
