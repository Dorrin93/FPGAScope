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
module adc_controller(
input clk, rst, AMP_DOUT, AD_DOUT,
output SPI_MOSI, AMP_CS, SPI_SCK, AD_CONV, AMP_SHDN,
output[31:0] adcReg,
output[7:0] ledy,
output enable
    );
wire gain_enable;
wire read;

GAIN_SETTER gain_setter(clk,rst,gain_enable,SPI_MOSI);
ADC_READER adc_reader(clk,rst,read,AD_DOUT,adcReg);
ADC adc(clk, rst, AMP_DOUT, SPI_SCK, AMP_CS, AD_CONV, gain_enable,read,ledy);



assign AMP_SHDN=1'b0;

endmodule
