`timescale 1ns / 1ps
module csr_controller(
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic        trap_i,
    input  logic [2:0]  opcode_i,
    input  logic [11:0] addr_i,
    input  logic [31:0] pc_i,
    input  logic [31:0] mcause_i,
    input  logic [31:0] rs1_data_i,
    input  logic [31:0] imm_data_i,
    input  logic        write_enable_i,
    output logic [31:0] read_data_o,
    output logic [31:0] mie_o,
    output logic [31:0] mepc_o,
    output logic [31:0] mtvec_o
    );

    import csr_pkg::*;

    logic [31:0] mie_reg;
    logic [31:0] mtvec_reg;
    logic [31:0] mscratch_reg;
    logic [31:0] mepc_reg;
    logic [31:0] mcause_reg;
    
    logic [31:0] csr_rdata;
    logic [31:0] csr_wdata;
    logic [4:0]  enable;

    always_comb begin
        case(opcode_i)
            CSR_RW: begin
                csr_wdata = rs1_data_i;
            end 
            CSR_RS: begin
                csr_wdata = rs1_data_i | csr_rdata;
            end 
            CSR_RC: begin
                csr_wdata = !rs1_data_i & csr_rdata;
            end 
            CSR_RWI: begin
                csr_wdata = imm_data_i;
            end
            CSR_RSI: begin
                csr_wdata = imm_data_i | csr_rdata;
            end
            CSR_RCI: begin
                csr_wdata = !imm_data_i & csr_rdata;
            end
            default: csr_wdata = 32'b0;
        endcase
    end

    always_comb begin
        enable = 5'b0;
        case(addr_i)
            MIE_ADDR: begin
                enable[0] = write_enable_i;
            end
            MTVEC_ADDR: begin
                enable[1] = write_enable_i;
            end 
            MSCRATCH_ADDR: begin
                enable[2] = write_enable_i;
            end 
            MEPC_ADDR: begin
                enable[3] = write_enable_i || trap_i;
            end 
            MCAUSE_ADDR: begin
                enable[4] = write_enable_i || trap_i;
            end
            default: enable = 5'b0;
        endcase
    end

    always_comb begin
        case(addr_i)
            MIE_ADDR: begin
                csr_rdata = mie_reg;
            end
            MTVEC_ADDR: begin
                csr_rdata = mtvec_reg;
            end
            MSCRATCH_ADDR: begin
                csr_rdata = mscratch_reg;
            end
            MEPC_ADDR: begin
                csr_rdata = mepc_reg;   
            end
            MCAUSE_ADDR: begin
                csr_rdata = mcause_reg;
            end
            default: csr_rdata = 32'b0;            
        endcase
    end

    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            mie_reg <= 32'b0;
        end else if (enable[0]) begin
            mie_reg <= csr_wdata;
        end
    end

    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            mtvec_reg <= 32'b0;
        end else if (enable[1]) begin
            mtvec_reg <= csr_wdata;
        end
    end

    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            mscratch_reg <= 32'b0;
        end else if (enable[2]) begin
            mscratch_reg <= csr_wdata;
        end
    end

    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            mepc_reg <= 32'b0;
        end else begin
            if(trap_i) begin
                mepc_reg <= pc_i;
            end else if(enable[3]) begin
                mepc_reg <= csr_wdata;
            end
        end
    end

    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            mcause_reg <= 32'b0;
        end else begin
            if(trap_i) begin
                mcause_reg <= mcause_i;
            end else if(enable[4]) begin
                mcause_reg <= csr_wdata;
            end
        end
    end

    assign mie_o       = mie_reg;
    assign mtvec_o     = mtvec_reg;
    assign mepc_o      = mepc_reg;
    assign read_data_o = csr_rdata;

endmodule