`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.07.2025 11:46:56
// Design Name: 
// Module Name: CYBERcobra
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


module CYBERcobra(
    input logic         clk_i,
    input logic         rst_i,
    input logic [15:0]  sw_i,
    output logic [31:0] out_o
    );

    // счётчик команд
    logic [31:0] PC;

    // сигналы с памяти инструкций
    logic [31:0] read_data_o;

    // сигналы с алу
    logic           flag_o;
    logic [31:0]    result_o;

    // сигналы с регистрового файла
    logic [31:0]    read_data1_o;
    logic [31:0]    read_data2_o;

    logic [31:0]    WD;
    logic [1:0]     WS;

    // инстансы модулей
    instr_mem imem
    (
        .read_addr_i(PC),
        .read_data_o(read_data_o)
    );
    
    alu alu 
    (
        .a_i(read_data1_o),
        .b_i(read_data2_o),
        .alu_op_i(read_data_o[27:23]),
        .flag_o(flag_o),
        .result_o(result_o)
    );
    
    register_file register_file
    (
        .clk_i(clk_i),
        .write_enable_i(!(read_data_o[30] || read_data_o[31])),
        .write_addr_i(read_data_o[4:0]),
        .read_addr1_i(read_data_o[22:18]),
        .read_addr2_i(read_data_o[17:13]),
        .write_data_i(WD),
        .read_data1_o(read_data1_o),
        .read_data2_o(read_data2_o)
        );
    
    always_ff @(posedge clk_i or posedge rst_i) begin
        if(rst_i) begin
            PC <= 32'd0;
        end
        else begin
            case((flag_o && read_data_o[30]) || read_data_o[31])
                0: PC <= PC + 32'd4;
                1: PC <= {{22{read_data_o[12]}}, {read_data_o[12:5], 2'b0}};
            endcase
        end
    end

    assign WS = read_data_o[29:28];
    assign out_o = read_data1_o;

    always_comb begin
        case(WS)
            0: WD = {{9{read_data_o[27]}}, {read_data_o[27:5]}};
            1: WD = result_o;
            2: WD = {{16{sw_i[15]}}, {sw_i}};
            3: WD = 32'd0;
        endcase
    end

endmodule
    