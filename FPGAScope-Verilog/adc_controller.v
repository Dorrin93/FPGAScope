`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:18:35 10/29/2015 
// Design Name: 
// Module Name:    adc_controller 
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
module adc_controller (
input clk, rst, AMP_DOUT, AD_DOUT, full,
output SPI_MOSI, AMP_CS, SPI_SCK, AD_CONV, AMP_SHDN,
output /*reg*/ [31:0] din,
output[7:0] ledy,
output /*reg*/ wr_en
    );
	 
wire gain_enable;
wire read;

//Modul do ustawiania wzmacniacza, na zboczu opadającym zegara, zapisujemy do SPI_MOSI, gain_enable wychodzacy z kontrolera ADC mówi nam 
//ze jestesmy w odpowiednim stanie
GAIN_SETTER gain_setter(clk,rst,gain_enable,SPI_MOSI);
//Modul do zapisywania do kolejki danych z linii AD_DOUT, na narastajacym AD_CONV, full,din i wr_en zwiazane z kolejka
ADC_READER adc_reader(clk,rst,read,AD_DOUT,AD_CONV,full,din,wr_en);
//Maszyna stanow do kontroli ADC 
ADC adc(clk, rst, AMP_DOUT, SPI_SCK, AMP_CS, AD_CONV, gain_enable,read,ledy);
assign AMP_SHDN=1'b0;
endmodule
