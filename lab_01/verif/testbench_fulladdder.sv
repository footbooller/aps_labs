`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.07.2025 15:36:23
// Design Name: 
// Module Name: testbench_fulladdder
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


module testbench_fulladdder();

    logic a, b, carry_i, carry_o, sum;

    fulladder fulladder_instance(
    .a_i(a),
    .b_i(b),
    .carry_i(carry_i),
    .sum_o(sum),
    .carry_o(carry_o)
    );
    
    initial begin
        a = 1'b0; b = 1'b0; carry_i = 1'b0;
        #10;
        a = 1'b0; b = 1'b0; carry_i = 1'b1;
        #10;
        a = 1'b0; b = 1'b1; carry_i = 1'b0;
        #10;
        a = 1'b0; b = 1'b1; carry_i = 1'b1;
        #10;
        a = 1'b1; b = 1'b0; carry_i = 1'b0;
        #10;
        a = 1'b1; b = 1'b0; carry_i = 1'b1;
        #10;
        a = 1'b1; b = 1'b1; carry_i = 1'b0;
        #10;
        a = 1'b1; b = 1'b1; carry_i = 1'b1;
        #10;
    end

endmodule
