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
// Additional Comments: cu -l /dev/ttyS2 -s 9600 
//
//////////////////////////////////////////////////////////////////////////////////
module top(
input clk, rst, AMP_DOUT, AD_DOUT,
output TXD, 
SPI_MOSI, AMP_CS, SPI_SCK, AD_CONV,
output[7:0] ledy
    );

	 //wire [31:0] adcReg2=32'b00110001001100100011001100110100; 
	 wire [31:0] adcReg;
	 wire [7:0] dataToSend;
	 wire enable,writeUart;
	 
	 REG_SPLITTER reg_splitter(clk,rst,writeUart,adcReg,enable,dataToSend);
	 UART uart(clk,rst,enable,dataToSend,TXD,writeUart);
	 ADC adc(clk, rst, AMP_DOUT, AD_DOUT,SPI_MOSI, AMP_CS, SPI_SCK, AD_CONV, adcReg, ledy);
	 //counter count(clk,rst,write,lcdTmp0);
	 //decoder dec(write, clk,rst,lcdTmp0,outData);
	 //lcd LCD(clk,rst,outData[127:120],outData[119:112],outData[111:104],outData[103:96],outData[95:88],outData[87:80],outData[79:72],outData[71:64],outData[63:56],outData[55:48],outData[47:40],outData[39:32],outData[31:24],outData[23:16],outData[15:8],outData[7:0],E, RW, RS,lcd);

endmodule
