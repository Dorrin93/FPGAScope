`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:32:45 10/29/2015 
// Design Name: 
// Module Name:    ADC_READER 
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
module ADC_READER(
    input clk,
    input rst,
    input read,
    input AD_DOUT,
	 input AD_CONV,
	 input full, 
    output reg[31:0] din,
	 output reg wr_en
    );

	reg[31:0] adcReg;
	always @(negedge clk, posedge rst) 
		begin
			if(rst) begin
				adcReg<=32'b0;
			end
			else if(read) begin
				adcReg <= {adcReg[30:0], AD_DOUT}; //zapisujemy 32 bity
			end
		end
		
	
	always @(posedge clk,posedge rst) 
	
		if(rst) begin
			din<=32'b0;
			wr_en<=0;
		end
		else if(AD_CONV && (!full)) begin //jesli kolejka pelna to tracimy te paczke danych bezpowrotnie
			din<=adcReg;
			wr_en<=1;	//sygnal do kolejki aby zapisac wartosc z din
		end
		else if(!AD_CONV)
			wr_en<=0;
		
endmodule
