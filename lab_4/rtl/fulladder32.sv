`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.07.2025 10:18:57
// Design Name: 
// Module Name: fulladder32
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


module fulladder32(
    input logic [31:0] a_i,
    input logic [31:0] b_i,
    input logic carry_i,
    output logic [31:0] sum_o,
    output logic carry_o
    );

    logic [32:0] carry;
    assign carry[0] = carry_i;

    genvar i;
    generate;
        for (i = 0; i < 32; i++) begin
            fulladder fulladder_instances (
                .a_i(a_i[i]),
                .b_i(b_i[i]),
                .carry_i(carry[i]),
                .sum_o(sum_o[i]),
                .carry_o(carry[i+1])
            );
        end
    endgenerate

    assign carry_o = carry[32];

endmodule
// module fulladder32(
//     input logic [31:0] a_i,
//     input logic [31:0] b_i,
//     input logic carry_i,
//     output logic [31:0] sum_o,
//     output logic carry_o
//     );

//     logic [8:0] carry;
//     assign carry[0] = carry_i;

//     genvar i;
//     generate;
//         for (i = 0; i < 8; i++) begin
//             fulladder4 fulladder_instances (
//                 .a_i(a_i[4*i+3:4*i]),
//                 .b_i(b_i[4*i+3:4*i]),
//                 .carry_i(carry[i]),
//                 .sum_o(sum_o[4*i+3:4*i]),
//                 .carry_o(carry[i+1])
//             );
//         end
//     endgenerate

//     assign carry_o = carry[8];

// endmodule