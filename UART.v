`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:17:02 09/17/2015 
// Design Name: 
// Module Name:    UART 
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
module UART(
    input clk, rst,
	 input enable,
	 input [7:0] dataToSend,
    output TXD, 
	 output reg write
    );
	 reg [14:0] clockdiv;

	 wire serclock = (clockdiv == 0);
	always @(posedge clk,posedge rst) 
		begin
			if(rst)
				clockdiv<=0;
			else if (clockdiv == 5207) //9600 baud - 5207
											 //921600
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
				4'b0000: if (enable) state <= 4'b0001;
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
			outbit<=1;
		else begin
		case (state)
         4'b0000: outbit <= 1;              // idle
         4'b0001: outbit <= 0;              // Start bit
         4'b0010: outbit <= dataToSend[0];        // Bit 0
         4'b0011: outbit <= dataToSend[1];        // Bit 1
         4'b0100: outbit <= dataToSend[2];        // Bit 2
         4'b0101: outbit <= dataToSend[3];        // Bit 3
         4'b0110: outbit <= dataToSend[4];        // Bit 4
         4'b0111: outbit <= dataToSend[5];        // Bit 5
         4'b1000: outbit <= dataToSend[6];        // Bit 6
         4'b1001: outbit <= dataToSend[7];        // Bit 7
         4'b1010: outbit <= 1;          // Stop bit
         default: outbit <= 1;          
		endcase end
	end
	
	always @(posedge clk,posedge rst)
	begin
		if(rst)
			write<=1;
		else if(state==4'b0000)
			write<=1;
		else 
			write<=0;
		
	end

	assign TXD=outbit;
endmodule
