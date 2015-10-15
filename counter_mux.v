`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:34:22 11/20/2014 
// Design Name: 
// Module Name:    counter_mux 
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
module counter_mux(
		input [7:0] count0,count1,count2, count3,count4, count5, count6, count7, count8, count9, count10, count11, count12, count13, count14, count15,
		input [3:0] mux_sel,
		output reg [7:0] counter_mux
    );
	always @*
		case(mux_sel)
			4'd15: counter_mux <= count0;
			4'd14: counter_mux <= count1;
			4'd13: counter_mux <= count2;
			4'd12: counter_mux <= count3;
			4'd11: counter_mux <= count4;
			4'd10: counter_mux <= count5;
			4'd9: counter_mux <= count6;
			4'd8: counter_mux <= count7;
			4'd7: counter_mux <= count8;
			4'd6: counter_mux <= count9;
			4'd5: counter_mux <= count10;
			4'd4: counter_mux <= count11;
			4'd3: counter_mux <= count12;
			4'd2: counter_mux <= count13;
			4'd1: counter_mux <= count14;
			4'd0: counter_mux <= count15;
			
		endcase

endmodule

