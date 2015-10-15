`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:43:26 11/27/2014 
// Design Name: 
// Module Name:    LCD_controller 
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
module LCD_controller(input clk, rst,
output data_sel, DB_sel, E_out,RW_out,RS_out,
output [1:0] init_sel, output[3:0] mux_sel);


main_controller mainController(clk,rst,lcd_finish,data_sel,DB_sel,lcd_enable,mode,reg_sel);
LCD_init_refresh lcdInitRefresh(clk,rst,lcd_enable,mode,wr_finish,init_sel,mux_sel,wr_enable,lcd_finish);
write_cycle writeCycle(clk,rst,wr_enable,reg_sel,wr_finish,E_out,RW_out,RS_out);
endmodule
