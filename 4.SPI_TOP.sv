//////////////////////////////////////////////Top Module/////////////////////////////////////////////////////
module top(
			input wr,clk,rst,
			input [7:0] addr, din,
			output [7:0] dout,
			output done, err);
			
	wire cs, mosi_miso, miso_mosi;
	wire mem_wr;
  	wire [7:0] mem_addr;
	wire [7:0] mem_dout;
	wire [7:0] mem_din;
	 
	spi_master master (.wr(wr), .clk(clk), .rst(rst), .addr(addr), .din(din), .dout(dout), .cs(cs), .mosi(mosi_miso), 
						.miso(miso_mosi), .done(done), .err(err));
	
	spi_slave  slave (.clk(clk), .rst(rst), .cs(cs), .miso(mosi_miso), .mosi(miso_mosi),  // mosi_miso - master out slave in
						.mem_wr(mem_wr), .mem_addr(mem_addr), .mem_din(mem_din), .mem_dout(mem_dout));						   // miso_mosi - master in slave out
						 
	spi_mem    mery (.clk(clk), .rst(rst), .mem_wr(mem_wr), .mem_addr(mem_addr), .mem_din(mem_din), .mem_dout(mem_dout));
	 
endmodule				