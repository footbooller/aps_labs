`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.08.2025 22:36:51
// Design Name: 
// Module Name: lsu
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


module lsu(
    input logic clk_i,
    input logic rst_i,

    // интерфейс с ядром
    input  logic        core_req_i,
    input  logic        core_we_i,
    input  logic [2:0]  core_size_i,
    input  logic [31:0] core_addr_i,
    input  logic [31:0] core_wd_i,
    output logic [31:0] core_rd_o,
    output logic        core_stall_o,

    // интерфейс с памятью
    output logic        mem_req_o,
    output logic        mem_we_o,
    output logic [3:0]  mem_be_o,
    output logic [31:0] mem_addr_o,
    output logic [31:0] mem_wd_o,
    input  logic [31:0] mem_rd_i,
    input  logic        mem_ready_i 
    );

    import decoder_pkg::*;

    // вспомогательный регистр
    logic stall_reg;

    // сигналы, которые напрямую подключаются к core
    assign mem_req_o  = core_req_i;
    assign mem_we_o   = core_we_i;
    assign mem_addr_o = core_addr_i;

    // логика сигнала mem_be_o
    always_comb begin
        case(core_size_i)
            LDST_B: begin
                mem_be_o = 1 << core_addr_i[1:0]; 
            end
            LDST_H: begin
                case(core_addr_i[1])
                    1'b1: mem_be_o = 4'b1100;
                    1'b0: mem_be_o = 4'b0011;
                    default: mem_be_o = 4'b0000;
                endcase
            end
            LDST_W: begin
                mem_be_o = 4'b1111;
            end
            default: mem_be_o = 4'b0000;
        endcase
    end

    // логика сигнала mem_wd_o
    always_comb begin
         case(core_size_i)
            LDST_B: begin
                mem_wd_o = {4{core_wd_i[7:0]}};
            end
            LDST_H: begin
                mem_wd_o = {2{core_wd_i[15:0]}};
            end
            LDST_W: begin
                mem_wd_o = core_wd_i[31:0];
            end
            default: mem_wd_o = 31'b0;
        endcase
    end

    // логика сигнала core_rd_o
    always_comb begin
        case(core_size_i)
            LDST_B: begin
                case(core_addr_i[1:0])
                    2'b00: begin
                        core_rd_o =  {{24{mem_rd_i[7]}}, mem_rd_i[7:0]};
                    end
                    2'b01: begin
                        core_rd_o =  {{24{mem_rd_i[15]}}, mem_rd_i[15:8]};
                    end
                    2'b10: begin
                        core_rd_o =  {{24{mem_rd_i[23]}}, mem_rd_i[23:16]};                        
                    end
                    2'b11: begin
                        core_rd_o =  {{24{mem_rd_i[31]}}, mem_rd_i[31:24]};                        
                    end
                    default: core_rd_o = 32'b0;
                endcase
            end
            LDST_H: begin
                case(core_addr_i[1])
                    1'b0: begin
                        core_rd_o =  {{16{mem_rd_i[15]}}, mem_rd_i[15:0]};
                    end
                    1'b1: begin
                        core_rd_o =  {{16{mem_rd_i[31]}}, mem_rd_i[31:16]};
                    end
                    default: core_rd_o = 32'b0;
                endcase
            end
            LDST_W: begin
                core_rd_o = mem_rd_i;
            end
            LDST_BU: begin
                case(core_addr_i[1:0])
                    2'b00: begin
                        core_rd_o =  {24'b0, mem_rd_i[7:0]};
                    end
                    2'b01: begin
                        core_rd_o =  {24'b0, mem_rd_i[15:8]};
                    end
                    2'b10: begin
                        core_rd_o =  {24'b0, mem_rd_i[23:16]};                        
                    end
                    2'b11: begin
                        core_rd_o =  {24'b0, mem_rd_i[31:24]};                        
                    end
                    default: core_rd_o = 32'b0;
                endcase                
            end
            LDST_HU: begin
                case(core_addr_i[1])
                    1'b0: begin
                        core_rd_o =  {16'b0, mem_rd_i[15:0]};
                    end
                    1'b1: begin
                        core_rd_o =  {16'b0, mem_rd_i[31:16]};
                    end
                    default: core_rd_o = 32'b0;
                endcase      
            end    
            default: core_rd_o = 32'b0;
        endcase
    end

    // логика сигнала core_stall_o
    always_ff @(posedge clk_i or posedge rst_i) begin
        if(rst_i) begin
            stall_reg <= 0;
        end else begin
            stall_reg <= core_stall_o;
        end
    end

    assign core_stall_o = core_req_i && !(stall_reg && mem_ready_i);

endmodule