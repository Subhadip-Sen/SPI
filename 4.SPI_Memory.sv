///////////////////////////////Memory///////////////////////////////////////////////////////////////////
module spi_mem (	input logic clk,
					input logic rst,
					input logic mem_wr,
					input logic [7:0] mem_addr,
					input logic [7:0] mem_din,
					output logic [7:0] mem_dout);

    logic [7:0] mem [0:255];

	always_ff @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < 256; i++)
                mem[i] <= 8'd0;
        end 
		else if (mem_wr) begin
            mem[mem_addr] <= mem_din;
        end
    end

    assign mem_dout = mem[mem_addr];

endmodule