`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.07.2025 15:48:21
// Design Name: 
// Module Name: fulladder4
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


module fulladder4(
    input logic [3:0]   a_i,
    input logic [3:0]   b_i,
    input logic         carry_i,
    output logic [3:0]  sum_o,
    output logic        carry_o
    );
    
    logic [4:0] carry;

    assign carry[0] = carry_i;

    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            fulladder fulladder_instances (
                .a_i(a_i[i]),
                .b_i(b_i[i]),
                .carry_i(carry[i]),
                .sum_o(sum_o[i]),
                .carry_o(carry[i+1])
            );
        end

    endgenerate

    assign carry_o = carry[4];

endmodule
