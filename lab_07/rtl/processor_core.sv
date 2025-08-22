`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.08.2025 19:25:40
// Design Name: 
// Module Name: processor_core
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


module processor_core(
    input logic         clk_i,
    input logic         rst_i,
    input logic         stall_i,
    input logic [31:0]  instr_i,
    input logic [31:0]  mem_rd_i,

    output logic [31:0] instr_addr_o,
    output logic [31:0] mem_addr_o,
    output logic [2:0]  mem_size_o,
    output logic        mem_req_o,
    output logic        mem_we_o,
    output logic [31:0] mem_wd_o
    );

    // счётчик команд
    logic [31:0] pc;


    logic [31:0] wb_data;

    // регистры с декодера
    logic [1:0]     a_sel;
    logic [2:0]     b_sel;
    logic [4:0]     alu_op;
    logic           gpr_we;


    // регистры для работы с регистровым файлом
    logic [4:0]     write_addr;
    logic [4:0]     read_addr1;
    logic [4:0]     read_addr2;
    logic [31:0]    read_data1;
    logic           write_enable;
    logic [1:0]     wb_sel;
    logic           jal;
    logic           jalr;
    logic           branch;

    assign write_addr   = instr_i[11:07];
    assign read_addr1   = instr_i[19:15];
    assign read_addr2   = instr_i[24:20];
    assign write_enable = gpr_we && !stall_i;

    // регистры для работы с alu
    logic [31:0]    a;
    logic [31:0]    b;
    logic           flag;
    logic [31:0]    result;

    // регистры для костант
    logic [31:0] imm_I;
    logic [31:0] imm_U;
    logic [31:0] imm_S;
    logic [31:0] imm_B;
    logic [31:0] imm_J;

    // константы для всех типов команд
    assign imm_I = {{20{instr_i[31]}}, instr_i[31:20]};
    assign imm_U = {instr_i[31:12], 12'h000};
    assign imm_S = {{20{instr_i[31]}}, instr_i[31:25], instr_i[11:7]};
    assign imm_B = {{19{instr_i[31]}}, instr_i[31], instr_i[7], instr_i[30:25], instr_i[11:8], 1'b0};
    assign imm_J = {{11{instr_i[31]}}, instr_i[31], instr_i[19:12], instr_i[20], instr_i[30:21], 1'b0};

    decoder decoder(
        .fetched_instr_i(instr_i),
        .a_sel_o(a_sel),
        .b_sel_o(b_sel),
        .alu_op_o(alu_op),
        .csr_op_o(),                // не подключен
        .csr_we_o(),                // не подключен
        .mem_req_o(mem_req_o),
        .mem_we_o(mem_we_o),
        .mem_size_o(mem_size_o),
        .gpr_we_o(gpr_we),
        .wb_sel_o(wb_sel),
        .illegal_instr_o(),         // не подключен
        .branch_o(branch),
        .jal_o(jal),
        .jalr_o(jalr),
        .mret_o()                   // не подключен
    );

    register_file register_file(
        .clk_i(clk_i),
        .write_enable_i(write_enable),

        .write_addr_i(instr_i[11:7]),
        .read_addr1_i(instr_i[19:15]),
        .read_addr2_i(instr_i[24:20]),

        .write_data_i(wb_data),
        .read_data1_o(read_data1),
        .read_data2_o(mem_wd_o)
    );

    alu alu(
        .a_i(a),
        .b_i(b),
        .alu_op_i(alu_op),
        .flag_o(flag),
        .result_o(result)
    );

    assign instr_addr_o = pc;
    assign mem_addr_o   = result;

    always_ff @(posedge clk_i or posedge rst_i) begin
        if(rst_i) begin
            pc <= 32'd0;
        end else if(!stall_i) begin
            case(jalr)
                1'b0: begin
                    case(branch && flag || jal)
                        1'b0: pc <= pc + 4;
                        1'b1: begin
                            case(branch)
                                1'b0: pc <= pc + imm_J;
                                1'b1: pc <= pc + imm_B;
                            endcase
                        end 
                    endcase
                end
                1'b1:begin 
                    logic [31:0] my_sum;
                    my_sum = read_data1 + imm_I;
                    pc <= {my_sum[31:1], 1'b0};
                end
            endcase
        end
    end

    // мультиплексор по a_sel с регистрового файла
    always_comb begin
        case(a_sel)
            2'b00: a = read_data1;
            2'b01: a = pc;
            2'b10: a = 32'b0;  
            default: a = 32'b0;
        endcase
    end

    // мультиплексор на b_sel с регистрового файла
    always_comb begin
        case(b_sel)
            3'b000: b = mem_wd_o;
            3'b001: b = imm_I;
            3'b010: b = imm_U;
            3'b011: b = imm_S;
            3'b100: b = 32'd4;
            default: b = 32'b0;
        endcase
    end

    // мультиплексор на wb_sel с регистрового файла
    always_comb begin
        case(wb_sel)
            2'b00: wb_data = result;
            2'b01: wb_data = mem_rd_i;
            default: wb_data = 32'b0;
        endcase
    end

endmodule
