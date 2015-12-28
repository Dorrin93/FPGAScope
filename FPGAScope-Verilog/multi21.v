`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:58:04 11/20/2014 
// Design Name: 
// Module Name:    multi21 
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
module multi21(input [7:0] in0, in1, input  ctrl, output [7:0] out);
		reg [7:0] tmp;
		 always @*
				 tmp<= ctrl?in1:in0;
			 
		assign out = tmp;


endmodule
