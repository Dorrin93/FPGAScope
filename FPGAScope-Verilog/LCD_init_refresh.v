`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:50:26 11/27/2014 
// Design Name: 
// Module Name:    LCD_init_refresh 
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
module LCD_init_refresh(input clk, rst,lcd_enable, input mode, wr_finish, 
output reg[1:0]init_sel, output reg[3:0]  mux_sel, output reg wr_enable, lcd_finish 
    );
	localparam 
	endlcd = 2'b01,
	data =2'b10,
	data1= 2'b11,
	idle= 2'b00;
	  
	 reg [1:0] st;
	 reg [1:0] nst;
	 
	 
	`define INIT_CONST_NO  3'b100
	`define LCD_INIT  1
	`define LCD_REF  0
	`define REF_DATA_NO  4'b1111
	 always @(posedge clk, posedge rst)
		if(rst) begin
			st<=idle;
			end
		else
			st<=nst;
			
always @(posedge clk, posedge rst)			
		if(rst)
			init_sel <= 2'b0;
		else case(st)
			idle: if(mode) init_sel <= `INIT_CONST_NO-1;
			endlcd: begin
				if(mode&&init_sel)init_sel <= init_sel - 1'b1;
			end
		endcase
always @(posedge clk, posedge rst)			
		if(rst)
			mux_sel <= 4'b0;
		else case(st)
			idle: if(~mode) mux_sel <= 	`REF_DATA_NO;
			endlcd: if(~mode&&mux_sel)mux_sel <= mux_sel-1'b1;
		endcase
		
	always @* begin
		nst = idle;
		wr_enable = 1'b0;
		lcd_finish = 1'b0;

	case(st)
			idle : begin
				
				nst = lcd_enable?data:idle;
				end
			data: 
			begin
				wr_enable = 1'b1;
				nst=data1;
			end
			data1:
			begin
				wr_enable = 0;
				nst=wr_finish?endlcd:data1;
			end
			endlcd: begin
				if(mode)begin 
					if(init_sel) begin
						nst=data;
					end
					else begin
						lcd_finish=1;
						nst=idle;
					end
				end
				else begin
					if(mux_sel) begin
					
						nst=data;
					end
					else begin
						lcd_finish=1;
						nst=idle;
					end
				end
			end
		endcase
		end
	

endmodule
