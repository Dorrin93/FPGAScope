`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:45:45 12/18/2015 
// Design Name: 
// Module Name:    UART_RECEIVER 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module UART_RECEIVER(
    input clk,
    input rst,
    input RXD,
    output reg [7:0] out,
	 output reg read
    );

    reg [14:0] clockdiv;
		reg [7:0] dataToSend;
	 wire serclock = (clockdiv == 0);
	always @(posedge clk,posedge rst) 
		begin
			if(rst)
				clockdiv<=0;
			else if (clockdiv == 434) //9600 baud - 5207
			//434
				clockdiv <= 0;
			else
				clockdiv <= clockdiv + 1;
		end

	reg [3:0] state;

	always @(posedge clk,posedge rst)
		if(rst)
			state<=4'b0000;
		else begin
		begin
			case (state)
				4'b0000: if (serclock && (~RXD)) state <= 4'b0001;
				4'b0001: if (serclock) state <= 4'b0010;    
				4'b0010: if (serclock) state <= 4'b0011;    
				4'b0011: if (serclock) state <= 4'b0100;    
				4'b0100: if (serclock) state <= 4'b0101;    
				4'b0101: if (serclock) state <= 4'b0110;    
				4'b0110: if (serclock) state <= 4'b0111;    
				4'b0111: if (serclock) state <= 4'b1000;    
				4'b1000: if (serclock) state <= 4'b1001;    
				4'b1001: if (serclock) state <= 4'b1010;   
				4'b1010: if (serclock) state <= 4'b0000;    
				default: state <= 4'b0000;			
			endcase 
		end
	end


	reg outbit;

	always @(posedge clk,posedge rst)
	begin
		if(rst)
			dataToSend <= 0;
		else if(state==4'b0010) dataToSend[0] <= RXD;    
		else if(state==4'b0011) dataToSend[1] <= RXD;    
		else if(state==4'b0100) dataToSend[2] <= RXD;    
		else if(state==4'b0101) dataToSend[3] <= RXD;    
		else if(state==4'b0111) dataToSend[4] <= RXD;    
		else if(state==4'b1000) dataToSend[5] <= RXD;    
		else if(state==4'b1001) dataToSend[6] <= RXD;    
		else if(state==4'b1010) dataToSend[7] <= RXD; 
	end
	
	always @(posedge clk,posedge rst)
	begin
		if(rst) begin
			read<=1;
			out<=0;
			end
		else if(state==4'b0000) begin
			out<=dataToSend;
			read<=1;
		end
		else
			read<=0;
	end


	assign TXD=outbit;
endmodule
