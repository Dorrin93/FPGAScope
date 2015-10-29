`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:20:49 10/29/2015
// Design Name:   adc_controller
// Module Name:   /home/lab_jos/KubaPawel/FPGAScope/adc_controller_tb.v
// Project Name:  FPGAScope
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: adc_controller
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module adc_controller_tb;

	// Inputs
	reg clk;
	reg rst;
	reg AMP_DOUT;
	reg AD_DOUT;

	// Outputs
	wire SPI_MOSI;
	wire AMP_CS;
	wire SPI_SCK;
	wire AD_CONV;
	wire AMP_SHDN;
	wire [31:0] adcReg;
	wire [7:0] ledy;

	// Instantiate the Unit Under Test (UUT)
	adc_controller uut (
		.clk(clk), 
		.rst(rst), 
		.AMP_DOUT(AMP_DOUT), 
		.AD_DOUT(AD_DOUT), 
		.SPI_MOSI(SPI_MOSI), 
		.AMP_CS(AMP_CS), 
		.SPI_SCK(SPI_SCK), 
		.AD_CONV(AD_CONV), 
		.AMP_SHDN(AMP_SHDN), 
		.adcReg(adcReg), 
		.ledy(ledy)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		AMP_DOUT = 0;
		AD_DOUT = 0;
		
		#10 rst = 1;
		#150 rst = 0;
	end
	
	initial begin
		forever #20 clk = ~clk;
	end
	
	initial begin
		forever #80 AD_DOUT = ~AD_DOUT;
	end
	
	initial #1000 $finish;
      
endmodule

