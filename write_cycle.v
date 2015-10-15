`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:29:37 11/27/2014 
// Design Name: 
// Module Name:    write_cycle 
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
module write_cycle(input clk, rst, wr_enable,reg_sel, output reg wr_finish, E_out, output RW_out, RS_out   
    );
	 localparam 
	 init = 2'b01,
	 Eout =2'b10,
	 endwr= 2'b11,
	 idle= 2'b00;
	  
	 reg [1:0] st;
	 reg [1:0] nst;
	 
	 
	 always @(posedge clk, posedge rst)
		if(rst)
			st<=idle;
		else
			st<=nst;
	always @* begin
		wr_finish=0;
		nst=idle;
		E_out=0;
		case(st)
			idle : begin
				wr_finish=0;
				nst=wr_enable?init:idle;
			end
			init: begin
				E_out=1;
				nst=Eout;
			end
			Eout:
				nst=endwr;
			endwr: begin
			E_out=0;
			wr_finish=1;
			nst=idle;
			end
		endcase
	end
	assign RS_out=reg_sel;
	assign RW_out=0;
endmodule
