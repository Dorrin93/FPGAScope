`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:44:52 12/08/2015 
// Design Name: 
// Module Name:    divider 
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
module clockDivider(
    input clk,
    input rst,
    output reg outclk
    );
/**
	Clock divider dla ADC
*/

	 reg [7:0] count; 

	 always @(posedge clk, posedge rst)
		begin
			if(rst) begin
				count <= 8'd0;
				outclk<=1'b0;
			end
			else if(count == 8'd24) begin 	//wartosc 24 wybrana na podtawie prób i testow
				count <= 8'd0;
				outclk <= ~outclk;
			end
			else
				count <=count + 1'b1;
			
		end
	

endmodule
