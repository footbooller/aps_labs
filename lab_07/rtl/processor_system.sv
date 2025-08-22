module processor_system (
    input logic clk_i,
    input logic rst_i
    );

    logic [31:0]    instr;
    logic [31:0]    instr_addr;
    logic           stall;
    logic [31:0]    mem_rd;
    logic           mem_req;
    logic           mem_we;
    logic [2:0]     mem_size;
    logic [31:0]    mem_wd;
    logic [31:0]    mem_addr;
    logic [31:0]    read_data;

    processor_core core(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .stall_i(stall),
        .instr_i(instr),
        .mem_rd_i(read_data),

        .instr_addr_o(instr_addr),
        .mem_addr_o(mem_addr),
        .mem_size_o(),              // не подключён
        .mem_req_o(mem_req),
        .mem_we_o(mem_we),
        .mem_wd_o(mem_wd)
    );

    data_mem data_mem(
        .clk_i(clk_i),
        .mem_req_i(mem_req),
        .write_enable_i(mem_we),
        .byte_enable_i(4'b1111),
        .addr_i(mem_addr),
        .write_data_i(mem_wd),
        .read_data_o(read_data),
        .ready_o()                  // не подключён
    );

    instr_mem instr_mem(
        .read_addr_i(instr_addr),
        .read_data_o(instr)
    );

    always_ff @(posedge clk_i or posedge rst_i) begin
        if(rst_i) begin
            stall <= 1'b0; 
        end else begin
            stall <= !stall && mem_req; 
        end
    end

endmodule
