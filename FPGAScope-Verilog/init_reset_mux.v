`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:38:22 11/20/2014 
// Design Name: 
// Module Name:    init_reset_mux 
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
module init_reset_mux(
	input [1:0] init_sel,
		output reg [5:0] init_reset_mux
    );
	 always @ *
		case (init_sel)
			2'b00: init_reset_mux <= 6'b000001;
			2'b01: init_reset_mux <= 6'b001110;
			2'b10: init_reset_mux <= 6'b000110;
			2'b11: init_reset_mux <= 6'b111000;
		endcase


endmodule