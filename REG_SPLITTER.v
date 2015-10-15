`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:08:46 09/17/2015 
// Design Name: 
// Module Name:    REG_SPLITTER 
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
module REG_SPLITTER(
    input clk, rst, write,
    input [31:0] adcReg,
	 output reg enable,
    output reg [7:0] register
    );
	  
	 reg [1:0] state;
	 
	 
	 always @(posedge clk,posedge rst)
		if(rst)
			register<=8'd0;
		else if(write)
			case (state)
				2'b00: register <= adcReg[31:24];
				2'b01: register <= adcReg[23:16];    
				2'b10: register <= adcReg[15:8];    
				2'b11: register <= adcReg[7:0];    
			endcase
			
	always @(posedge clk,posedge rst)
		if(rst)
			state<=0;
		else if(write)
			case (state)
				2'b00: state <= 2'd1;
				2'b01: state <= 2'd2;
				2'b10: state <= 2'd3;
				2'b11: state <= 2'd0;
			endcase
			
	always @(posedge clk,posedge rst)
		if(rst)
			enable<=0;
		else if(write)
			enable<=1;
		
			
		
	
endmodule
