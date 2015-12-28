`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:08:54 09/03/2015 
// Design Name: 
// Module Name:    top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: cu -l /dev/ttyS2 -s 115200
//
//////////////////////////////////////////////////////////////////////////////////
module top(
input clk, rst, AMP_DOUT, AD_DOUT,

output TXD, 
SPI_MOSI, AMP_CS, SPI_SCK, AD_CONV, AMP_SHDN,
output[7:0] ledy
    );

	 wire enable;
	 
	 wire [31:0] din,dout;
	 wire wr_en,rd_en,full,empty;
	 wire [7:0] dataToSend;
	 
	 //kolejka fifo z danymi wychodzacymi z adc
	 fifo adc_fifo(clk,rst,din,wr_en,rd_en,dout,full,empty); 
	 //dzielelnie danych z adc na 8 bitowe ramki i kontroluje kiedy rozpoczyna sie wysylanie UARTem
	 REG_SPLITTER reg_splitter(clk,rst,write,empty,dout,enable,rd_en,dataToSend);
	 //Wysyłanie ramek przez UART
	 UART uartTXD(clk,rst,enable,dataToSend, TXD,write);
	 
	 wire outclk; //zegar dla adc, podzielony dzielnikiem
	 clockDivider clock_divider(clk,rst,outclk);
	 adc_controller adcController(outclk, rst,AMP_DOUT, AD_DOUT, full, SPI_MOSI, AMP_CS, SPI_SCK, AD_CONV, AMP_SHDN,din,ledy,wr_en);
	 
endmodule
