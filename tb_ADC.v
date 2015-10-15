`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:08:40 09/15/2015
// Design Name:   ADC
// Module Name:   /home/lab_jos/KubaPawel/FPGAScope/tb_ADC.v
// Project Name:  FPGAScope
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ADC
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_ADC;

	// Inputs
	reg clk;
	reg rst;
	reg AD_DOUT;
	reg ADC_OUT;

	// Outputs
	wire SPI_MOSI;
	wire AMP_CS;
	wire SPI_SCK;
	wire AMP_SHDN;
	wire AD_CONV;

	// Instantiate the Unit Under Test (UUT)
	ADC uut (
		.clk(clk), 
		.rst(rst), 
		.AMP_DOUT(AMP_DOUT), 
		.AD_DOUT(AD_DOUT), 
		.SPI_MOSI(SPI_MOSI), 
		.AMP_CS(AMP_CS), 
		.SPI_SCK(SPI_SCK), 
		.AMP_SHDN(AMP_SHDN), 
		.AD_CONV(AD_CONV)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
	//	AMP_DOUT = 0;
		//ADC_OUT = 0;

		#2 rst = 1;
		#100 rst = 0;

	end
	
	initial begin
		forever #1 clk = ~clk;
	end
	
	initial begin
		#1757 AD_DOUT = 1;
		forever #54 AD_DOUT = ~AD_DOUT;
	end
	
	initial #4000 $finish;
      
endmodule

