`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:08:46 09/17/2015 
// Design Name: 
// Module Name:    REG_SPLITTER 
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
module REG_SPLITTER(
    input clk, rst, write, empty,
    input [31:0] dout,
	 output reg enable, rd_en,
    output [7:0] dataToSend
    );
	  
	  
	 reg [2:0] state; 
	 reg [31:0] buffer;
	 reg [1:0] split;
	 reg [7:0] register;
	 
	 always @(posedge clk,posedge rst)
		if(rst)
			register<=8'd0;
		else if(split==2'b11)
			case (state)
				3'b00: register <= {2'b0, buffer[13:8]}; //wypelniamy 2 pierwsz bity zerami, ponieważ są tam śmieciowe dane z linii AD_DOUT
				3'b01: register <= buffer[7:0];    
				3'b10: register <= {2'b0,buffer[29:24]}; //jw. 
				3'b11: register <= buffer[23:16];
				default: register <=8'b0;
			endcase
	
	
	always @(posedge clk,posedge rst)
		if(rst)
			split<=2'b11;
		else
			split<={ split[0], write };	//write z modulu UART mowi nam czy jestesmy gotowi do wysylania kolejnych danych
	

	always @(posedge clk,posedge rst)
		if(rst)
			state<=3'd4;
		else  if((split==2'b01) || (state==3'b100 || state==3'b101)) //split 'b01 czyli wlasnie skonczylismy wysylac na UART
			case (state)
				3'd0: state <= 3'd1;
				3'd1: state <= 3'd2;
				3'd2: state <= 3'd3;
				3'd3: state <= 3'd4;
				3'd4: if(!empty) state <=3'd5; //sprawdzamy czy kolejka nie pusta
				3'd5: state <= 3'd0;
				default: state<=3'd4;
			endcase
			
	always @(posedge clk,posedge rst)
		if(rst)
			enable<=0;
		else if(split == 2'b11 && (state==3'd0 || state==3'd1 || state==3'd2 || state==3'd3)) 
			enable<=1; //enable to sygnal dla UARTu aby wysylal dane, ustawiamy na 1 gdy UART skonczyl wysylac poprzednia paczke
						  //i mamy do wyslania kolejne
		else
			enable<=0;
			
			
	always @(posedge clk,posedge rst)
		if(rst)begin
			buffer<=32'b00000000111100001111111100001111;
		end
		else if(state==3'd4 && !empty) //odczyt z kolejki jesli nie jest pusta
			rd_en<=1;
		else if(state==3'd5) begin
			buffer<=dout;
			rd_en<=0;
		end 
			

		
		assign dataToSend = register;
		
	
endmodule
