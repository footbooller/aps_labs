`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2025 23:31:06
// Design Name: 
// Module Name: decoder
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


module decoder(
    input logic  [31:0] fetched_instr_i,
    output logic [1:0]  a_sel_o,
    output logic [2:0]  b_sel_o,
    output logic [4:0]  alu_op_o,
    output logic [2:0]  csr_op_o,
    output logic        csr_we_o,
    output logic        mem_req_o,
    output logic        mem_we_o,
    output logic [2:0]  mem_size_o,
    output logic        gpr_we_o,
    output logic [1:0]  wb_sel_o,
    output logic        illegal_instr_o,
    output logic        branch_o,
    output logic        jal_o,
    output logic        jalr_o,
    output logic        mret_o
    );

    import decoder_pkg::*;

    logic [6:0] opcode;

    assign opcode = fetched_instr_i[6:0];

    always_comb begin
        a_sel_o         = 2'b0;
        b_sel_o         = 2'b0;
        alu_op_o        = 4'b0;
        csr_op_o        = 3'b0;
        csr_we_o        = 1'b0;
        mem_req_o       = 1'b0; 
        mem_we_o        = 1'b0;
        mem_size_o      = 3'b0;  
        gpr_we_o        = 1'b0;
        wb_sel_o        = 2'b0;
        illegal_instr_o = 1'b0;
        branch_o        = 1'b0;
        jal_o           = 1'b0;
        jalr_o          = 1'b0;
        mret_o          = 1'b0;
        case(opcode)
            {LOAD_OPCODE, 2'b11}: begin
                case (fetched_instr_i[14:12])
                    LDST_B: begin
                        a_sel_o         = OP_A_RS1;
                        b_sel_o         = OP_B_IMM_I;
                        alu_op_o        = ALU_ADD;
                        csr_op_o        = 3'b0;
                        csr_we_o        = 1'b0;
                        mem_req_o       = 1'b1; 
                        mem_we_o        = 1'b0;
                        mem_size_o      = LDST_B;  
                        gpr_we_o        = 1'b1;
                        wb_sel_o        = 2'b01;
                        illegal_instr_o = 1'b0;
                        branch_o        = 1'b0;
                        jal_o           = 1'b0;
                        jalr_o          = 1'b0;
                        mret_o          = 1'b0;
                    end
                    LDST_H: begin
                        a_sel_o         = OP_A_RS1;
                        b_sel_o         = OP_B_IMM_I;
                        alu_op_o        = ALU_ADD;
                        csr_op_o        = 3'b0;
                        csr_we_o        = 1'b0;
                        mem_req_o       = 1'b1; 
                        mem_we_o        = 1'b0;
                        mem_size_o      = LDST_H;  
                        gpr_we_o        = 1'b1;
                        wb_sel_o        = 2'b01;
                        illegal_instr_o = 1'b0;
                        branch_o        = 1'b0;
                        jal_o           = 1'b0;
                        jalr_o          = 1'b0;
                        mret_o          = 1'b0;
                    end
                    LDST_W: begin
                        a_sel_o         = OP_A_RS1;
                        b_sel_o         = OP_B_IMM_I;
                        alu_op_o        = ALU_ADD;
                        csr_op_o        = 3'b0;
                        csr_we_o        = 1'b0;
                        mem_req_o       = 1'b1; 
                        mem_we_o        = 1'b0;
                        mem_size_o      = LDST_W;  
                        gpr_we_o        = 1'b1;
                        wb_sel_o        = 2'b01;
                        illegal_instr_o = 1'b0;
                        branch_o        = 1'b0;
                        jal_o           = 1'b0;
                        jalr_o          = 1'b0;
                        mret_o          = 1'b0;
                    end
                    LDST_BU: begin
                        a_sel_o         = OP_A_RS1;
                        b_sel_o         = OP_B_IMM_I;
                        alu_op_o        = ALU_ADD;
                        csr_op_o        = 3'b0;
                        csr_we_o        = 1'b0;
                        mem_req_o       = 1'b1; 
                        mem_we_o        = 1'b0;
                        mem_size_o      = LDST_BU;  
                        gpr_we_o        = 1'b1;
                        wb_sel_o        = 1'b1;
                        illegal_instr_o = 1'b0;
                        branch_o        = 1'b0;
                        jal_o           = 1'b0;
                        jalr_o          = 1'b0;
                        mret_o          = 1'b0;
                    end
                    LDST_HU: begin
                        a_sel_o         = OP_A_RS1;
                        b_sel_o         = OP_B_IMM_I;
                        alu_op_o        = ALU_ADD;
                        csr_op_o        = 3'b0;
                        csr_we_o        = 1'b0;
                        mem_req_o       = 1'b1; 
                        mem_we_o        = 1'b0;
                        mem_size_o      = LDST_HU;  
                        gpr_we_o        = 1'b1;
                        wb_sel_o        = 2'b01;
                        illegal_instr_o = 1'b0;
                        branch_o        = 1'b0;
                        jal_o           = 1'b0;
                        jalr_o          = 1'b0;
                        mret_o          = 1'b0;
                    end
                    default: begin
                        illegal_instr_o = 1;
                    end
                endcase
            end
            {MISC_MEM_OPCODE, 2'b11}: begin
                case (fetched_instr_i[14:12])
                    3'b000: illegal_instr_o  = 0;
                    default: illegal_instr_o = 1;
                endcase
            end
            {OP_IMM_OPCODE, 2'b11}: begin
                case (fetched_instr_i[14:12])
                    3'b000:begin
                            a_sel_o         = OP_A_RS1;
                            b_sel_o         = OP_B_IMM_I;
                            alu_op_o        = ALU_ADD;
                            csr_op_o        = 3'b0;
                            csr_we_o        = 1'b0;
                            mem_req_o       = 1'b0; 
                            mem_we_o        = 1'b0;
                            mem_size_o      = 3'b0;
                            gpr_we_o        = 1'b1;
                            wb_sel_o        = WB_EX_RESULT;
                            illegal_instr_o = 1'b0;
                            branch_o        = 1'b0;
                            jal_o           = 1'b0;
                            jalr_o          = 1'b0;
                            mret_o          = 1'b0;
                    end
                    3'b100:begin
                            a_sel_o         = OP_A_RS1;
                            b_sel_o         = OP_B_IMM_I;
                            alu_op_o        = ALU_XOR;
                            csr_op_o        = 3'b0;
                            csr_we_o        = 1'b0;
                            mem_req_o       = 1'b0; 
                            mem_we_o        = 1'b0;
                            mem_size_o      = 3'b0;
                            gpr_we_o        = 1'b1;
                            wb_sel_o        = WB_EX_RESULT;
                            illegal_instr_o = 1'b0;
                            branch_o        = 1'b0;
                            jal_o           = 1'b0;
                            jalr_o          = 1'b0;
                            mret_o          = 1'b0;
                    end
                    3'b110:begin
                            a_sel_o         = OP_A_RS1;
                            b_sel_o         = OP_B_IMM_I;
                            alu_op_o        = ALU_OR;
                            csr_op_o        = 3'b0;
                            csr_we_o        = 1'b0;
                            mem_req_o       = 1'b0; 
                            mem_we_o        = 1'b0;
                            mem_size_o      = 3'b0;
                            gpr_we_o        = 1'b1;
                            wb_sel_o        = WB_EX_RESULT;
                            illegal_instr_o = 1'b0;
                            branch_o        = 1'b0;
                            jal_o           = 1'b0;
                            jalr_o          = 1'b0;
                            mret_o          = 1'b0;
                    end
                    3'b111:begin
                            a_sel_o         = OP_A_RS1;
                            b_sel_o         = OP_B_IMM_I;
                            alu_op_o        = ALU_AND;
                            csr_op_o        = 3'b0;
                            csr_we_o        = 1'b0;
                            mem_req_o       = 1'b0; 
                            mem_we_o        = 1'b0;
                            mem_size_o      = 3'b0;
                            gpr_we_o        = 1'b1;
                            wb_sel_o        = WB_EX_RESULT;
                            illegal_instr_o = 1'b0;
                            branch_o        = 1'b0;
                            jal_o           = 1'b0;
                            jalr_o          = 1'b0;
                            mret_o          = 1'b0;
                    end
                    3'b001:begin
                        case (fetched_instr_i[31:25])
                            7'b0: begin
                                a_sel_o         = OP_A_RS1;
                                b_sel_o         = OP_B_IMM_I;
                                alu_op_o        = ALU_SLL;
                                csr_op_o        = 3'b0;
                                csr_we_o        = 1'b0;
                                mem_req_o       = 1'b0; 
                                mem_we_o        = 1'b0;
                                mem_size_o      = 3'b0;
                                gpr_we_o        = 1'b1;
                                wb_sel_o        = WB_EX_RESULT;
                                illegal_instr_o = 1'b0;
                                branch_o        = 1'b0;
                                jal_o           = 1'b0;
                                jalr_o          = 1'b0;
                                mret_o          = 1'b0;
                            end
                        endcase
                    end
                    3'b101:begin
                        case (fetched_instr_i[31:25])
                            7'b0: begin
                                a_sel_o         = OP_A_RS1;
                                b_sel_o         = OP_B_IMM_I;
                                alu_op_o        = ALU_SRL;
                                csr_op_o        = 3'b0;
                                csr_we_o        = 1'b0;
                                mem_req_o       = 1'b0; 
                                mem_we_o        = 1'b0;
                                mem_size_o      = 3'b0;
                                gpr_we_o        = 1'b1;
                                wb_sel_o        = WB_EX_RESULT;
                                illegal_instr_o = 1'b0;
                                branch_o        = 1'b0;
                                jal_o           = 1'b0;
                                jalr_o          = 1'b0;
                                mret_o          = 1'b0;
                            end
                            7'h20: begin
                                a_sel_o         = OP_A_RS1;
                                b_sel_o         = OP_B_IMM_I;
                                alu_op_o        = ALU_SRA;
                                csr_op_o        = 3'b0;
                                csr_we_o        = 1'b0;
                                mem_req_o       = 1'b0; 
                                mem_we_o        = 1'b0;
                                mem_size_o      = 3'b0;
                                gpr_we_o        = 1'b1;
                                wb_sel_o        = WB_EX_RESULT;
                                illegal_instr_o = 1'b0;
                                branch_o        = 1'b0;
                                jal_o           = 1'b0;
                                jalr_o          = 1'b0;
                                mret_o          = 1'b0;
                            end
                        endcase
                    end
                    3'b010: begin
                        a_sel_o         = OP_A_RS1;
                        b_sel_o         = OP_B_IMM_I;
                        alu_op_o        = ALU_SLTS;
                        csr_op_o        = 3'b0;
                        csr_we_o        = 1'b0;
                        mem_req_o       = 1'b0; 
                        mem_we_o        = 1'b0;
                        mem_size_o      = 3'b0;
                        gpr_we_o        = 1'b1;
                        wb_sel_o        = WB_EX_RESULT;
                        illegal_instr_o = 1'b0;
                        branch_o        = 1'b0;
                        jal_o           = 1'b0;
                        jalr_o          = 1'b0;
                        mret_o          = 1'b0;
                    end
                    3'b011: begin
                        a_sel_o         = OP_A_RS1;
                        b_sel_o         = OP_B_IMM_I;
                        alu_op_o        = ALU_SLTU;
                        csr_op_o        = 3'b0;
                        csr_we_o        = 1'b0;
                        mem_req_o       = 1'b0; 
                        mem_we_o        = 1'b0;
                        mem_size_o      = 3'b0;
                        gpr_we_o        = 1'b1;
                        wb_sel_o        = WB_EX_RESULT;
                        illegal_instr_o = 1'b0;
                        branch_o        = 1'b0;
                        jal_o           = 1'b0;
                        jalr_o          = 1'b0;
                        mret_o          = 1'b0;
                    end
                    default: begin
                        illegal_instr_o = 1'b1;
                    end
                endcase
            end
            {AUIPC_OPCODE, 2'b11}: begin
                a_sel_o         = OP_A_CURR_PC;
                b_sel_o         = OP_B_IMM_U;
                alu_op_o        = ALU_ADD;
                csr_op_o        = 3'b0;
                csr_we_o        = 1'b0;
                mem_req_o       = 1'b0; 
                mem_we_o        = 1'b0;
                mem_size_o      = 3'b0;  
                gpr_we_o        = 1'b1;
                wb_sel_o        = WB_EX_RESULT;
                illegal_instr_o = 1'b0;
                branch_o        = 1'b0;
                jal_o           = 1'b0;
                jalr_o          = 1'b0;
                mret_o          = 1'b0;
            end
            {STORE_OPCODE, 2'b11}: begin
                case(fetched_instr_i[14:12])
                    LDST_B: begin
                        a_sel_o         = OP_A_RS1;
                        b_sel_o         = OP_B_IMM_S;
                        alu_op_o        = ALU_ADD;
                        csr_op_o        = 3'b0;
                        csr_we_o        = 1'b0;
                        mem_req_o       = 1'b1; 
                        mem_we_o        = 1'b1;
                        mem_size_o      = LDST_B;  
                        gpr_we_o        = 1'b0;
                        wb_sel_o        = WB_EX_RESULT;
                        illegal_instr_o = 1'b0;
                        branch_o        = 1'b0;
                        jal_o           = 1'b0;
                        jalr_o          = 1'b0;
                        mret_o          = 1'b0;
                    end
                    LDST_H: begin
                        a_sel_o         = OP_A_RS1;
                        b_sel_o         = OP_B_IMM_S;
                        alu_op_o        = ALU_ADD;
                        csr_op_o        = 3'b0;
                        csr_we_o        = 1'b0;
                        mem_req_o       = 1'b1; 
                        mem_we_o        = 1'b1;
                        mem_size_o      = LDST_H;  
                        gpr_we_o        = 1'b0;
                        wb_sel_o        = WB_EX_RESULT;
                        illegal_instr_o = 1'b0;
                        branch_o        = 1'b0;
                        jal_o           = 1'b0;
                        jalr_o          = 1'b0;
                        mret_o          = 1'b0;                        
                    end
                    LDST_W: begin
                        a_sel_o         = OP_A_RS1;
                        b_sel_o         = OP_B_IMM_S;
                        alu_op_o        = ALU_ADD;
                        csr_op_o        = 3'b0;
                        csr_we_o        = 1'b0;
                        mem_req_o       = 1'b1; 
                        mem_we_o        = 1'b1;
                        mem_size_o      = LDST_W;  
                        gpr_we_o        = 1'b0;
                        wb_sel_o        = WB_EX_RESULT;
                        illegal_instr_o = 1'b0;
                        branch_o        = 1'b0;
                        jal_o           = 1'b0;
                        jalr_o          = 1'b0;
                        mret_o          = 1'b0;
                    end     
                    default: begin
                        illegal_instr_o = 1;
                    end
                endcase
            end
            {OP_OPCODE, 2'b11}: begin
                case(fetched_instr_i[14:12])
                    3'b000: begin
                        case(fetched_instr_i[31:25])
                            7'b0: begin
                                a_sel_o         = OP_A_RS1;
                                b_sel_o         = OP_B_RS2;
                                alu_op_o        = ALU_ADD;
                                csr_op_o        = 3'b0;
                                csr_we_o        = 1'b0;
                                mem_req_o       = 1'b0; 
                                mem_we_o        = 1'b0;
                                mem_size_o      = 3'b0;
                                gpr_we_o        = 1'b1;
                                wb_sel_o        = WB_EX_RESULT;
                                illegal_instr_o = 1'b0;
                                branch_o        = 1'b0;
                                jal_o           = 1'b0;
                                jalr_o          = 1'b0;
                                mret_o          = 1'b0;
                            end
                            7'h20: begin
                                a_sel_o         = OP_A_RS1;
                                b_sel_o         = OP_B_RS2;
                                alu_op_o        = ALU_SUB;
                                csr_op_o        = 3'b0;
                                csr_we_o        = 1'b0;
                                mem_req_o       = 1'b0; 
                                mem_we_o        = 1'b0;
                                mem_size_o      = 3'b0;
                                gpr_we_o        = 1'b1;
                                wb_sel_o        = WB_EX_RESULT;
                                illegal_instr_o = 1'b0;
                                branch_o        = 1'b0;
                                jal_o           = 1'b0;
                                jalr_o          = 1'b0;
                                mret_o          = 1'b0;
                            end
                            default: begin
                                illegal_instr_o = 1'b1;
                            end
                        endcase
                    end
                    3'b100: begin
                        case(fetched_instr_i[31:25])
                            7'b0: begin
                                a_sel_o         = OP_A_RS1;
                                b_sel_o         = OP_B_RS2;
                                alu_op_o        = ALU_XOR;
                                csr_op_o        = 3'b0;
                                csr_we_o        = 1'b0;
                                mem_req_o       = 1'b0; 
                                mem_we_o        = 1'b0;
                                mem_size_o      = 3'b0;
                                gpr_we_o        = 1'b1;
                                wb_sel_o        = WB_EX_RESULT;
                                illegal_instr_o = 1'b0;
                                branch_o        = 1'b0;
                                jal_o           = 1'b0;
                                jalr_o          = 1'b0;
                                mret_o          = 1'b0;
                            end
                        endcase
                    end
                    3'b110: begin
                        case(fetched_instr_i[31:25])
                            7'b0: begin
                                a_sel_o         = OP_A_RS1;
                                b_sel_o         = OP_B_RS2;
                                alu_op_o        = ALU_OR;
                                csr_op_o        = 3'b0;
                                csr_we_o        = 1'b0;
                                mem_req_o       = 1'b0; 
                                mem_we_o        = 1'b0;
                                mem_size_o      = 3'b0;
                                gpr_we_o        = 1'b1;
                                wb_sel_o        = WB_EX_RESULT;
                                illegal_instr_o = 1'b0;
                                branch_o        = 1'b0;
                                jal_o           = 1'b0;
                                jalr_o          = 1'b0;
                                mret_o          = 1'b0;
                            end
                        endcase
                    end
                    3'b111: begin
                        case(fetched_instr_i[31:25])
                            7'b0: begin
                                a_sel_o         = OP_A_RS1;
                                b_sel_o         = OP_B_RS2;
                                alu_op_o        = ALU_AND;
                                csr_op_o        = 3'b0;
                                csr_we_o        = 1'b0;
                                mem_req_o       = 1'b0; 
                                mem_we_o        = 1'b0;
                                mem_size_o      = 3'b0;
                                gpr_we_o        = 1'b1;
                                wb_sel_o        = WB_EX_RESULT;
                                illegal_instr_o = 1'b0;
                                branch_o        = 1'b0;
                                jal_o           = 1'b0;
                                jalr_o          = 1'b0;
                                mret_o          = 1'b0;
                            end
                        endcase
                    end
                    3'b001: begin
                        case(fetched_instr_i[31:25])
                            7'b0: begin
                                a_sel_o         = OP_A_RS1;
                                b_sel_o         = OP_B_RS2;
                                alu_op_o        = ALU_SLL;
                                csr_op_o        = 3'b0;
                                csr_we_o        = 1'b0;
                                mem_req_o       = 1'b0; 
                                mem_we_o        = 1'b0;
                                mem_size_o      = 3'b0;
                                gpr_we_o        = 1'b1;
                                wb_sel_o        = WB_EX_RESULT;
                                illegal_instr_o = 1'b0;
                                branch_o        = 1'b0;
                                jal_o           = 1'b0;
                                jalr_o          = 1'b0;
                                mret_o          = 1'b0;
                            end
                        endcase
                    end
                    3'b101: begin
                        case(fetched_instr_i[31:25])
                            7'b0: begin
                                a_sel_o         = OP_A_RS1;
                                b_sel_o         = OP_B_RS2;
                                alu_op_o        = ALU_SRL;
                                csr_op_o        = 3'b0;
                                csr_we_o        = 1'b0;
                                mem_req_o       = 1'b0; 
                                mem_we_o        = 1'b0;
                                mem_size_o      = 3'b0;
                                gpr_we_o        = 1'b1;
                                wb_sel_o        = WB_EX_RESULT;
                                illegal_instr_o = 1'b0;
                                branch_o        = 1'b0;
                                jal_o           = 1'b0;
                                jalr_o          = 1'b0;
                                mret_o          = 1'b0;
                            end
                            7'h20: begin
                                a_sel_o         = OP_A_RS1;
                                b_sel_o         = OP_B_RS2;
                                alu_op_o        = ALU_SRA;
                                csr_op_o        = 3'b0;
                                csr_we_o        = 1'b0;
                                mem_req_o       = 1'b0; 
                                mem_we_o        = 1'b0;
                                mem_size_o      = 3'b0;
                                gpr_we_o        = 1'b1;
                                wb_sel_o        = WB_EX_RESULT;
                                illegal_instr_o = 1'b0;
                                branch_o        = 1'b0;
                                jal_o           = 1'b0;
                                jalr_o          = 1'b0;
                                mret_o          = 1'b0;
                            end
                        endcase
                    end
                    3'b010: begin
                        case(fetched_instr_i[31:25])
                            7'b0: begin
                                a_sel_o         = OP_A_RS1;
                                b_sel_o         = OP_B_RS2;
                                alu_op_o        = ALU_SLTS;
                                csr_op_o        = 3'b0;
                                csr_we_o        = 1'b0;
                                mem_req_o       = 1'b0; 
                                mem_we_o        = 1'b0;
                                mem_size_o      = 3'b0;
                                gpr_we_o        = 1'b1;
                                wb_sel_o        = WB_EX_RESULT;
                                illegal_instr_o = 1'b0;
                                branch_o        = 1'b0;
                                jal_o           = 1'b0;
                                jalr_o          = 1'b0;
                                mret_o          = 1'b0;
                            end                            
                        endcase
                    end
                    3'b011: begin
                        case(fetched_instr_i[31:25])
                            7'b0: begin
                                a_sel_o         = OP_A_RS1;
                                b_sel_o         = OP_B_RS2;
                                alu_op_o        = ALU_SLTU;
                                csr_op_o        = 3'b0;
                                csr_we_o        = 1'b0;
                                mem_req_o       = 1'b0; 
                                mem_we_o        = 1'b0;
                                mem_size_o      = 3'b0;
                                gpr_we_o        = 1'b1;
                                wb_sel_o        = WB_EX_RESULT;
                                illegal_instr_o = 1'b0;
                                branch_o        = 1'b0;
                                jal_o           = 1'b0;
                                jalr_o          = 1'b0;
                                mret_o          = 1'b0;
                            end                            
                        endcase
                    end
                    default: begin
                        illegal_instr_o = 1'b1;
                    end
                endcase
            end
            {LUI_OPCODE, 2'b11}: begin
                    a_sel_o         = OP_A_ZERO;
                    b_sel_o         = OP_B_IMM_U;
                    alu_op_o        = ALU_ADD;
                    csr_op_o        = 3'b0;
                    csr_we_o        = 1'b0;
                    mem_req_o       = 1'b0; 
                    mem_we_o        = 1'b0;
                    mem_size_o      = 3'b0;  
                    gpr_we_o        = 1'b1;
                    wb_sel_o        = WB_EX_RESULT;
                    illegal_instr_o = 1'b0;
                    branch_o        = 1'b0;
                    jal_o           = 1'b0;
                    jalr_o          = 1'b0;
                    mret_o          = 1'b0;
            end
            {BRANCH_OPCODE, 2'b11}: begin
                case(fetched_instr_i[14:12])
                    3'b000: begin
                        a_sel_o         = OP_A_RS1;
                        b_sel_o         = OP_B_RS2;
                        alu_op_o        = ALU_EQ;
                        csr_op_o        = 3'b0;
                        csr_we_o        = 1'b0;
                        mem_req_o       = 1'b0; 
                        mem_we_o        = 1'b0;
                        mem_size_o      = 3'b0;  
                        gpr_we_o        = 1'b0;
                        wb_sel_o        = WB_EX_RESULT;
                        illegal_instr_o = 1'b0;
                        branch_o        = 1'b1;
                        jal_o           = 1'b0;
                        jalr_o          = 1'b0;
                        mret_o          = 1'b0;
                    end
                    3'b001: begin
                        a_sel_o         = OP_A_RS1;
                        b_sel_o         = OP_B_RS2;
                        alu_op_o        = ALU_NE;
                        csr_op_o        = 3'b0;
                        csr_we_o        = 1'b0;
                        mem_req_o       = 1'b0; 
                        mem_we_o        = 1'b0;
                        mem_size_o      = 3'b0;  
                        gpr_we_o        = 1'b0;
                        wb_sel_o        = WB_EX_RESULT;
                        illegal_instr_o = 1'b0;
                        branch_o        = 1'b1;
                        jal_o           = 1'b0;
                        jalr_o          = 1'b0;
                        mret_o          = 1'b0;
                    end
                    3'b100: begin
                        a_sel_o         = OP_A_RS1;
                        b_sel_o         = OP_B_RS2;
                        alu_op_o        = ALU_LTS;
                        csr_op_o        = 3'b0;
                        csr_we_o        = 1'b0;
                        mem_req_o       = 1'b0; 
                        mem_we_o        = 1'b0;
                        mem_size_o      = 3'b0;  
                        gpr_we_o        = 1'b0;
                        wb_sel_o        = WB_EX_RESULT;
                        illegal_instr_o = 1'b0;
                        branch_o        = 1'b1;
                        jal_o           = 1'b0;
                        jalr_o          = 1'b0;
                        mret_o          = 1'b0;
                    end
                    3'b101: begin
                        a_sel_o         = OP_A_RS1;
                        b_sel_o         = OP_B_RS2;
                        alu_op_o        = ALU_GES;
                        csr_op_o        = 3'b0;
                        csr_we_o        = 1'b0;
                        mem_req_o       = 1'b0; 
                        mem_we_o        = 1'b0;
                        mem_size_o      = 3'b0;  
                        gpr_we_o        = 1'b0;
                        wb_sel_o        = WB_EX_RESULT;
                        illegal_instr_o = 1'b0;
                        branch_o        = 1'b1;
                        jal_o           = 1'b0;
                        jalr_o          = 1'b0;
                        mret_o          = 1'b0;
                    end
                    3'b110: begin
                        a_sel_o         = OP_A_RS1;
                        b_sel_o         = OP_B_RS2;
                        alu_op_o        = ALU_LTU;
                        csr_op_o        = 3'b0;
                        csr_we_o        = 1'b0;
                        mem_req_o       = 1'b0; 
                        mem_we_o        = 1'b0;
                        mem_size_o      = 3'b0;  
                        gpr_we_o        = 1'b0;
                        wb_sel_o        = WB_EX_RESULT;
                        illegal_instr_o = 1'b0;
                        branch_o        = 1'b1;
                        jal_o           = 1'b0;
                        jalr_o          = 1'b0;
                        mret_o          = 1'b0;
                    end
                    3'b111: begin
                        a_sel_o         = OP_A_RS1;
                        b_sel_o         = OP_B_RS2;
                        alu_op_o        = ALU_GEU;
                        csr_op_o        = 3'b0;
                        csr_we_o        = 1'b0;
                        mem_req_o       = 1'b0; 
                        mem_we_o        = 1'b0;
                        mem_size_o      = 3'b0;  
                        gpr_we_o        = 1'b0;
                        wb_sel_o        = WB_EX_RESULT;
                        illegal_instr_o = 1'b0;
                        branch_o        = 1'b1;
                        jal_o           = 1'b0;
                        jalr_o          = 1'b0;
                        mret_o          = 1'b0;
                    end
                    default: begin
                        illegal_instr_o = 1'b1;
                    end
                endcase
            end
            {JALR_OPCODE, 2'b11}: begin
                case (fetched_instr_i[14:12])
                    3'b000: begin
                        a_sel_o         = OP_A_CURR_PC;
                        b_sel_o         = OP_B_INCR;
                        alu_op_o        = ALU_ADD;
                        csr_op_o        = 3'b0;
                        csr_we_o        = 1'b0;
                        mem_req_o       = 1'b0;
                        mem_we_o        = 1'b0;
                        mem_size_o      = 3'b0;  
                        gpr_we_o        = 1'b1;
                        wb_sel_o        = WB_EX_RESULT;
                        illegal_instr_o = 1'b0;
                        branch_o        = 1'b0;
                        jal_o           = 1'b0;
                        jalr_o          = 1'b1;
                        mret_o          = 1'b0;
                    end
                
                    default: begin
                        illegal_instr_o = 1'b1;
                        jalr_o          = 1'b0;
                        gpr_we_o        = 1'b0;
                    end
                endcase
            end
            {JAL_OPCODE, 2'b11}: begin
                a_sel_o         = OP_A_CURR_PC;
                b_sel_o         = OP_B_INCR;
                alu_op_o        = ALU_ADD;
                csr_op_o        = 3'b0;
                csr_we_o        = 1'b0;
                mem_req_o       = 1'b0; 
                mem_we_o        = 1'b0;
                mem_size_o      = 3'b0;  
                gpr_we_o        = 1'b1;
                wb_sel_o        = WB_EX_RESULT;
                illegal_instr_o = 1'b0;
                branch_o        = 1'b0;
                jal_o           = 1'b1;
                jalr_o          = 1'b0;
                mret_o          = 1'b0;
            end
            {SYSTEM_OPCODE, 2'b11}: begin
                case(fetched_instr_i[14:12])
                CSR_RW: begin
                    a_sel_o         = OP_A_RS1;
                    b_sel_o         = OP_B_RS2;
                    alu_op_o        = ALU_ADD;
                    csr_op_o        = CSR_RW;
                    csr_we_o        = 1'b1;
                    mem_req_o       = 1'b0; 
                    mem_we_o        = 1'b0;
                    mem_size_o      = 3'b0;  
                    gpr_we_o        = 1'b1;
                    wb_sel_o        = WB_CSR_DATA;
                    illegal_instr_o = 1'b0;
                    branch_o        = 1'b0;
                    jal_o           = 1'b0;
                    jalr_o          = 1'b0;
                    mret_o          = 1'b0;
                end 
                CSR_RS: begin
                    a_sel_o         = OP_A_RS1;
                    b_sel_o         = OP_B_RS2;
                    alu_op_o        = ALU_ADD;
                    csr_op_o        = CSR_RS;
                    csr_we_o        = 1'b1;
                    mem_req_o       = 1'b0; 
                    mem_we_o        = 1'b0;
                    mem_size_o      = 3'b0;  
                    gpr_we_o        = 1'b1;
                    wb_sel_o        = WB_CSR_DATA;
                    illegal_instr_o = 1'b0;
                    branch_o        = 1'b0;
                    jal_o           = 1'b0;
                    jalr_o          = 1'b0;
                    mret_o          = 1'b0;
                end 
                CSR_RC: begin
                    a_sel_o         = OP_A_RS1;
                    b_sel_o         = OP_B_RS2;
                    alu_op_o        = ALU_ADD;
                    csr_op_o        = CSR_RC;
                    csr_we_o        = 1'b1;
                    mem_req_o       = 1'b0; 
                    mem_we_o        = 1'b0;
                    mem_size_o      = 3'b0;  
                    gpr_we_o        = 1'b1;
                    wb_sel_o        = WB_CSR_DATA;
                    illegal_instr_o = 1'b0;
                    branch_o        = 1'b0;
                    jal_o           = 1'b0;
                    jalr_o          = 1'b0;
                    mret_o          = 1'b0;
                end 
                CSR_RWI: begin
                    a_sel_o         = OP_A_RS1;
                    b_sel_o         = OP_B_RS2;
                    alu_op_o        = ALU_ADD;
                    csr_op_o        = CSR_RWI;
                    csr_we_o        = 1'b1;
                    mem_req_o       = 1'b0; 
                    mem_we_o        = 1'b0;
                    mem_size_o      = 3'b0;  
                    gpr_we_o        = 1'b1;
                    wb_sel_o        = WB_CSR_DATA;
                    illegal_instr_o = 1'b0;
                    branch_o        = 1'b0;
                    jal_o           = 1'b0;
                    jalr_o          = 1'b0;
                    mret_o          = 1'b0;
                end
                CSR_RSI: begin
                    a_sel_o         = OP_A_RS1;
                    b_sel_o         = OP_B_RS2;
                    alu_op_o        = ALU_ADD;
                    csr_op_o        = CSR_RSI;
                    csr_we_o        = 1'b1;
                    mem_req_o       = 1'b0; 
                    mem_we_o        = 1'b0;
                    mem_size_o      = 3'b0;  
                    gpr_we_o        = 1'b1;
                    wb_sel_o        = WB_CSR_DATA;
                    illegal_instr_o = 1'b0;
                    branch_o        = 1'b0;
                    jal_o           = 1'b0;
                    jalr_o          = 1'b0;
                    mret_o          = 1'b0;
                end
                CSR_RCI: begin
                    a_sel_o         = OP_A_RS1;
                    b_sel_o         = OP_B_RS2;
                    alu_op_o        = ALU_ADD;
                    csr_op_o        = CSR_RCI;
                    csr_we_o        = 1'b1;
                    mem_req_o       = 1'b0; 
                    mem_we_o        = 1'b0;
                    mem_size_o      = 3'b0;  
                    gpr_we_o        = 1'b1;
                    wb_sel_o        = WB_CSR_DATA;
                    illegal_instr_o = 1'b0;
                    branch_o        = 1'b0;
                    jal_o           = 1'b0;
                    jalr_o          = 1'b0;
                    mret_o          = 1'b0;
                end
                3'b000: begin
                    case(fetched_instr_i[31:20])
                        // ecall
                        12'b0: begin
                            a_sel_o         = OP_A_RS1;
                            b_sel_o         = OP_B_RS2;
                            alu_op_o        = ALU_ADD;
                            csr_op_o        = CSR_RCI;
                            csr_we_o        = 1'b0;
                            mem_req_o       = 1'b0; 
                            mem_we_o        = 1'b0;
                            mem_size_o      = 3'b0;  
                            gpr_we_o        = 1'b0;
                            wb_sel_o        = WB_CSR_DATA;
                            illegal_instr_o = 1'b1;
                            branch_o        = 1'b0;
                            jal_o           = 1'b0;
                            jalr_o          = 1'b0;
                            mret_o          = 1'b0;
                        end
                        // ebreak
                        {11'b0, 1'b1}: begin
                            a_sel_o         = OP_A_RS1;
                            b_sel_o         = OP_B_RS2;
                            alu_op_o        = ALU_ADD;
                            csr_op_o        = CSR_RCI;
                            csr_we_o        = 1'b0;
                            mem_req_o       = 1'b0; 
                            mem_we_o        = 1'b0;
                            mem_size_o      = 3'b0;  
                            gpr_we_o        = 1'b0;
                            wb_sel_o        = WB_CSR_DATA;
                            illegal_instr_o = 1'b1;
                            branch_o        = 1'b0;
                            jal_o           = 1'b0;
                            jalr_o          = 1'b0;
                            mret_o          = 1'b0;
                        end
                        // mret
                        12'b001100000010: begin
                            a_sel_o         = OP_A_RS1;
                            b_sel_o         = OP_B_RS2;
                            alu_op_o        = ALU_ADD;
                            csr_op_o        = CSR_RCI;
                            csr_we_o        = 1'b0;
                            mem_req_o       = 1'b0; 
                            mem_we_o        = 1'b0;
                            mem_size_o      = 3'b0;  
                            gpr_we_o        = 1'b0;
                            wb_sel_o        = WB_CSR_DATA;
                            illegal_instr_o = 1'b0;
                            branch_o        = 1'b0;
                            jal_o           = 1'b0;
                            jalr_o          = 1'b0;
                            mret_o          = 1'b1;
                        end
                    endcase
                end
                default: begin
                    illegal_instr_o = 1'b1;
                end  
                endcase
            end
            default: begin
                alu_op_o        = ALU_ADD;            
                csr_op_o        = 3'b0;
                csr_we_o        = 1'b0;
                mem_req_o       = 1'b0;
                mem_we_o        = 1'b0;
                gpr_we_o        = 1'b0;
                illegal_instr_o = 1'b1;
                branch_o        = 1'b0;
                jal_o           = 1'b0;
                jalr_o          = 1'b0;
                mret_o          = 1'b0;
            end        
        endcase
    end

endmodule
