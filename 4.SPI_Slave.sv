///////////////////////////Slave////////////////////////
module spi_slave(
				input clk, rst, cs, miso,
				output reg mosi,
				input [7:0] mem_dout,
				output reg mem_wr,
				output reg [7:0] mem_addr,
				output reg [7:0] mem_din);
 
	reg [7:0] mem [255:0] = '{default:0};
	integer count = 0;
	reg [16:0] datain;
	reg [7:0]  dataout;

	typedef enum bit [2:0] {idle = 0, read_data = 1, get_addr = 2, send_data = 3} state_type;
	state_type state = idle;

	always@(posedge clk) begin
		if(rst) begin
			state <= idle;
			count <= 0;
			mosi  <= 0;
		end
		else begin
			case(state)
				idle: begin
					count <= 0;
					mosi  <= 0;
					datain <= 0;
					if(!cs & miso)				//Active-Low Chip-Select
						state <= read_data;
					else if(!cs & !miso)
						state <= get_addr;
					else
						state <= idle;
				end
				   					
				read_data: begin
					if(count <= 16) begin
						datain[count]     <= miso;
						count             <= count + 1;
						state             <= read_data;
					end
					else begin
						mem_wr <= 1;
					    mem_addr <= datain[8:1];
						mem_din <= datain[16:9];
						//mem[datain[7:0]]  <= datain[15:8];		//din_reg <= {din, addr, wr}
						state <= idle;
						count <= 0;
					end
				end
					
				get_addr: begin
					if(count <= 8) begin
						count <= count + 1;
						datain[count] <= miso;
						state <= get_addr;
					end
					else begin
						count <= 0;
						mem_wr <= 0;
						mem_addr <= datain[8:1];
						state <= send_data;
						//dataout <= mem[datain];
					end
				end
					   
				send_data: begin
					dataout = mem_dout;
					if(count < 8) begin
						count <= count + 1;
						mosi  <= dataout[count]; 
						state <= send_data;
					end 
					else begin
						count <= 0;
						state <= idle;
					end     
				end   
					
				default : state <= idle;
					
			endcase
		end
	end
	
endmodule