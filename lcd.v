`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:15:01 12/11/2014 
// Design Name: 
// Module Name:    lcd 
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
module lcd #(parameter d = 50000) (input clk, rst, 
input [7:0] count0, count1, count2, count3, count4, count5, count6, count7, count8, count9, count10, count11, count12, count13, count14, count15,
output E, RW, RS, output [7:0] lcd);

	 wire data_sel;
	 wire DB_sel;
	 wire [1:0]init_sel;
	 wire [3:0]mux_sel;
	 wire clkdiv;
	 LCD_controller lcdController(clkdiv,rst,data_sel,DB_sel,E,RW,RS,init_sel,mux_sel);
	 lcd_dp lcdDp(count0,count1,count2,count3,count4,count5,count6,count7,count8,count9,count10,count11,count12,count13,count14,count15,init_sel,mux_sel,data_sel,DB_sel,lcd);
	 clock_div #(.div(d)) divider(clk,rst,clkdiv);
endmodule

