`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 	KubaPawel
// Engineer:  Kuba & Pawel
// 
// Create Date:    19:55:19 10/30/2014 
// Design Name: 
// Module Name:    clock_div 
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
module clock_div #(parameter div=100)(
    input clk,
    input rst,
    output reg clockdiv
    );
	localparam dl =  clog2(div);
	reg [dl-1:0] counter;
	
	always @(posedge clk, posedge rst)
		if(rst) begin
			clockdiv <= 1'b0;
			counter <={dl{1'b0}};
			end
		else if(counter==div)
					begin
						counter <={dl{1'b0}};
						clockdiv <= ~clockdiv;
					end 
				else
					counter<=counter+1;
		
	function integer clog2
		(input [31:0] div);

		for(clog2=0;div>0;clog2=clog2+1)
			div=div>>1;
	endfunction
	
endmodule
