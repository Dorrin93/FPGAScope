`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:45:24 09/09/2015 
// Design Name: 
// Module Name:    ADC 
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
module ADC(
    input clk, rst, AMP_DOUT,
	 output SPI_SCK,
	 output reg AMP_CS,  AD_CONV, gain_enable,read,
	 output [7:0] ledy
    );
	 
	 localparam init=3'd0,
	 write1=3'd1, 
	 write2=3'd2,
	 endWrite=3'd3, 
	 startRead=3'd4, 
	 read1=3'd5, 
	 read2=3'd6, 
	 read3=3'd7;  
	
	 reg [2:0] st;
	 reg [2:0] nst;
	
	 reg echoRegOut;
	 reg [7:0] echoReg;

	
	 /////////////////////STANY
	 always @(posedge clk, posedge rst)
		if(rst) begin
			st<=init;
		end
		else
			st<=nst;
	 ////////////////////Licznik startowy
	 reg [3:0] counter16;
	 always @(posedge clk, posedge rst)
		if(rst)
			counter16<=4'd15;
		else if(counter16==0)
			counter16<=4'd15;
		else
			counter16<=counter16-4'b1;
	 //////////////////// Licznik dla AD_OUT do 33
	 reg incIndex;
	 reg [5:0] index;
	 always @(posedge clk, posedge rst)
		if(rst)
			index<=6'd0;
		else if(st == startRead)
			index<=6'd0;
		else if(incIndex)
			index<=index+6'd1;
	//////////////////////Licznik GAIN do 7
	reg [4:0] indexGain;
	always @(posedge clk, posedge rst)
		if(rst)
			indexGain<=5'd0;
		else if(st == startRead)
			indexGain<=5'd0;
		else if(st == write2)
			indexGain<=indexGain+5'd1;

	always@(negedge clk) 
		begin

			if(st == startRead)
				AD_CONV <= 1'b1;
			else 
				AD_CONV <= 0;
		end

	 /////MASZYNA STANOW ASYNCHRONICZNA
	 always @* begin
		nst<=endWrite;
		AMP_CS<=1;
		gain_enable <= 1'b0;
		incIndex<=1'b0;
		read<=1'b0;
		echoRegOut<=0;
		
		case(st)
			init : begin
				nst <= counter16==4'b1 ? init : write1;
			end
			write1: begin //zaczynamy ustawiac wzmacniacz
				AMP_CS <= 0;
				gain_enable <= 1'b1;
				nst <= write2; 
			end
			write2: begin//ustawiamy wszystkie jego 7 bitow
				AMP_CS<=0;
				gain_enable <= 1'b1;
				
				echoRegOut<=1'b1;
				
				nst <= indexGain==5'd7 ? endWrite : write2;
			end
			endWrite: begin //stan posredni, wzmacniacz ustawiony
				nst<= startRead;
			end
			startRead: begin //zaczynamy odczyt 
				nst <= read1;
			end
			read1: begin     //stan posredni
				nst<= read2; 
			end
			read2: begin	//zapisujemy 32 bity do pamieci
				read<=1'b1;
				incIndex<=1'b1;
				nst <= (index != 6'd31) ? read2 : read3; 
			end
			read3: begin	//ostatnich 2 bitow smieci juz nigdzie nie zapisujemy
				incIndex<=1'b1;
				nst <= (index != 6'd33) ? read3 : startRead; 
			end
			
		endcase
	end
	
	//pomocnicze do zapisania echa z wzmacniacza
	always@(posedge clk, posedge rst) begin
		if(rst)
			echoReg<=8'b11111111;
		else if (echoRegOut)
			echoReg[indexGain]<=AMP_DOUT;
	end
	//zegar
	assign SPI_SCK = ((st == write2 && indexGain < 8) || /*st==read1 ||*/ st == read2 || st==read3 )? clk : 1'b0;
	
	assign ledy = echoReg;
	
endmodule
