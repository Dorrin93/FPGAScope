`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:23:51 10/29/2015 
// Design Name: 
// Module Name:    GAIN_SETTER 
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
module GAIN_SETTER #(parameter gain_reg = 8'b0001_0001)(
    input clk,
    input rst,
    input gain_enable,
    output reg SPI_MOSI
    );
	reg [7:0] gain=gain_reg;
	always @(posedge clk,posedge rst) 
		begin
			if(rst) begin
				SPI_MOSI<=1'b0;
				gain<=gain_reg;
			end
			else if(gain_enable) begin
				SPI_MOSI<=gain[7];
				gain<={ gain[6:0], 1'b0 };
			end
		end
endmodule
