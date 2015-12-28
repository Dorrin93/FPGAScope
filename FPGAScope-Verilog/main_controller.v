`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:51:58 11/27/2014 
// Design Name: 
// Module Name:    main_controller 
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

module main_controller(input clk, rst, lcd_finish, 
	output reg data_sel, DB_sel, lcd_enable, mode, reg_sel
);
	
	localparam 
	idle = 3'b000,
	init =3'b001,
	addr= 3'b010,
	addr1= 3'b011,
	ref= 3'b100,
	ref1= 3'b101;

	`define INIT_CONST_NO  3'b100
	`define LCD_INIT  1
	`define LCD_REF  0
	`define REF_DATA_NO  4'b1111
	  
	 reg [2:0] st;
	 reg [2:0] nst;
	 
	 
	 always @(posedge clk, posedge rst)
		if(rst)
			st<=idle;
		else
			st<=nst;
			/*
	always @(posedge clk, posedge rst)
		if(rst)
			st<=idle;
		else
			st<=nst;
			
	always @(posedge clk, posedge rst)
		if(rst)
			st<=idle;
		else
			st<=nst;
			*/
	always @* begin
		nst=idle;
		//lcd_cnt=2'b00;
		mode=`LCD_INIT;
		reg_sel=1'b0;
		data_sel=0;
		DB_sel=1'b1;
		lcd_enable=0;
		case(st)
			idle : begin
				lcd_enable=1;
				//lcd_cnt= 2'd3;
				//DB_sel =1;
				data_sel = 0;
				//reg_sel = 0;
				//mode=`LCD_INIT;
				nst=init;
			end
			init: begin
				lcd_enable=0;
				nst=lcd_finish?addr:init;
			end
			addr:begin
				nst=addr1;
				lcd_enable=1;
			//	lcd_cnt=0;
				DB_sel=1'b0;end
			addr1: begin
			lcd_enable=0;
			nst=lcd_finish?ref:addr1;
			DB_sel=1'b0;
			end
			ref: begin
				lcd_enable=1;
			//	lcd_cnt=`REF_DATA_NO-1;
				//DB_sel=1;
				data_sel=1;
				reg_sel=1'b1;
				mode=`LCD_REF;
				nst=ref1;
			end
			ref1: begin
			lcd_enable=0;
			mode=`LCD_REF;
			data_sel=1;
			if(lcd_finish)
				nst=addr;
			else begin
				reg_sel=1'b1;
				nst=ref1; end
			end
		endcase
	end
	

endmodule
