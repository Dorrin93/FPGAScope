`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:19:17 11/20/2014 
// Design Name: 
// Module Name:    lcd_dp 
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
module lcd_dp(
	input [7:0] count0, count1, count2, count3, count4, count5, count6, count7, count8, count9, count10, count11, count12, count13, count14, count15,
		input [1:0] init_set, input[3:0] mux_sel,
		input data_sel,
		DB_sel,
		output [7:0] DB_out
    );	
	 wire [7:0] countermux;
	 wire [7:0] data_outx;
	 wire [5:0] initresetmux;
	 counter_mux counterMux(count0,count1,count2,count3, count4, count5, count6, count7, count8, count9, count10, count11, count12, count13, count14, count15,mux_sel,countermux);
	 init_reset_mux initResetMux(init_set,initresetmux);
	 multi21 multi2(8'hc0,data_outx,DB_sel,DB_out); //cc
	 multi21 multi1({2'b00,initresetmux},{countermux},data_sel,data_outx);
	// assign DB_out = DB_sel ? data_outx : 8'hcc;

endmodule
