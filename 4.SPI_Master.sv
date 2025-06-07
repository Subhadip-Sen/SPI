`timescale 1ns / 1ps
////////////////////////////////////////SPI Master///////////////////////////////////////////////////
module spi_master( 	
					input wr,clk,rst,
					input [7:0] addr, din,
					output [7:0] dout,
					output reg cs, mosi,
					input miso,
					output reg done, err);

	reg [16:0] din_reg;  //// <- data 0:7 -> <- addr 0 : 7 -> <- op: wr / rd ->
	reg [9:0] dout_reg;
	reg [7:0] temp_addr;
	integer count = 0;

	typedef enum bit [2:0] {idle = 0, load = 1, check_op = 2, send_data = 3, send_addr = 4, read_data = 5, error = 6} state_type;
	state_type state = idle; 

	/////////////////cs logic/////////////////
	always@(posedge clk) begin
		if(rst) begin
			state <= idle;
			count <= 0;
			cs <= 1'b1;
			mosi <= 1'b0; 
			err <= 1'b0;
			done <= 1'b0;
		end
		else begin
			case(state)
				idle: begin
					cs    <= 1'b1;
					mosi  <= 1'b0;
					state <= load;
					err <= 1'b0;
					done <= 1'b0;
				end
				
				load: begin
					din_reg <= {din, addr, wr};
					state   <= check_op;
				end

				check_op: begin
					if(wr == 1'b1 && addr < 256) begin 	//Write to slave
						cs <= 1'b0;
						state <= send_data;
						mosi  <= 1'b1;
					end
					else if (wr == 1'b0 && addr < 256) begin 	//Read from slave
						state <= send_addr;
						temp_addr <= din_reg[8:1];
						cs <= 1'b0;
						mosi  <= 1'b0;
					end
					else begin
						state <= error;
						cs <= 1'b1;
					end
				end

				send_data : begin
					if(count <= 16) begin
						count <= count + 1;
						mosi  <= din_reg[count];
						state = send_data;
					end
					else begin
						cs    <= 1'b1;
						mosi  <= 1'b0;
						count <= 0;
						done  <= 1'b1;
						state <= idle;
					end
				end

				send_addr: begin
					if(count <= 8) begin
						count <= count + 1;
						mosi  <= din_reg[count]; 	//Send address to slave
						state <= send_addr;
					end
					else begin
						count <= 0;
						cs    <= 1'b1;
						state <= read_data;	////////////////////////////////////
					end
				end

				read_data:begin
					if(count <= 9) begin
						count <= count + 1;
						dout_reg[count]  <=  miso;		//Store the data from slave
						state = read_data;
					end
					else begin
						count <= 0;
						done <= 1'b1;
						state <= idle;
					end
				end
				
				error : begin
					err   <= 1'b1;
					state <= idle;
					done  <= 1'b1;
				end
				
				default: begin
				   state <= idle;
				   count <= 0;
				end				
			endcase
		end 
	end 

	assign dout = dout_reg[9:2];
	
endmodule