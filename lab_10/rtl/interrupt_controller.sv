`timescale 1ns / 1ps
module interrupt_controller(
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic        exception_i,
    input  logic        irq_req_i,
    input  logic        mie_i,
    input  logic        mret_i,

    output logic        irq_ret_o,
    output logic [31:0] irq_cause_o,
    output logic        irq_o
    );

    logic irq_h;
    logic exc_h;
    logic irq;

    assign irq = irq_o;

    assign irq_o = (irq_req_i && mie_i) && !((exception_i || exc_h) || irq_h);
    assign irq_ret_o = mret_i && !(exception_i || exc_h);
    assign irq_cause_o = 32'h80000010;

    always_ff @(posedge clk_i or posedge rst_i) begin
        if(rst_i) begin
            exc_h <= 1'b0;            
        end else begin
            exc_h <= !mret_i && (exception_i || exc_h);
        end
    end

    always_ff @(posedge clk_i or posedge rst_i) begin
        if(rst_i) begin
            irq_h <= 1'b0;
        end else begin
            irq_h <= !(mret_i && !(exception_i || exc_h)) && (irq || irq_h);
        end
    end



endmodule