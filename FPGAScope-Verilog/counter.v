`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:10:32 09/03/2015 
// Design Name: 
// Module Name:    counter 
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
module counter(
input clk,rst,
    output write,
	 output [7:0] lcdTmp0
    );
	 reg[7:0] register;
	 reg[7:0] data;
	 reg tmp;
	always @(posedge clk,posedge rst)
		if(rst)
			register<=8'd0;
		else if(write==8'd200)
			register<=8'd0;
		else
			register<=register+1;
	always @*
	
		if(register==200 || register==202) begin
			tmp<=1'b1;
			data<=8'h42; end
		else if (register==201) begin
			tmp<=1'b1;
			data<=8'h24; end
		else if (register<200 && register>180) begin
			tmp<=1'b1;
			data<=8'h29;
			end
		else begin
			tmp<=1'b0;
			data<=8'h1c; end
assign write=tmp;
assign lcdTmp0=data;
endmodule
