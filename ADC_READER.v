`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:32:45 10/29/2015 
// Design Name: 
// Module Name:    ADC_READER 
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
module ADC_READER(
    input clk,
    input rst,
    input read,
    input AD_DOUT,
    output reg[31:0] adcReg
    );

	always @(posedge clk,posedge rst) 
		begin
			if(rst) begin
				adcReg<=32'b00110001001100100011001100110100;
			end
			else if(read) begin
				adcReg <= {adcReg[30:0], AD_DOUT};
			end
		end
		
		
endmodule
