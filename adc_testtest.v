`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:27:03 12/07/2015
// Design Name:   adc_controller
// Module Name:   /home/lab_jos/KubaPawel/FPGAScope/adc_testtest.v
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

module adc_testtest;

	// Inputs
	reg clk;
	reg rst;
	reg AMP_DOUT;
	reg AD_DOUT;
	reg full;

	// Outputs
	wire SPI_MOSI;
	wire AMP_CS;
	wire SPI_SCK;
	wire AD_CONV;
	wire AMP_SHDN;
	wire [31:0] din;
	wire [7:0] ledy;
	wire wr_en;

	// Instantiate the Unit Under Test (UUT)
	adc_controller uut (
		.clk(clk), 
		.rst(rst), 
		.AMP_DOUT(AMP_DOUT), 
		.AD_DOUT(AD_DOUT), 
		.full(full), 
		.SPI_MOSI(SPI_MOSI), 
		.AMP_CS(AMP_CS), 
		.SPI_SCK(SPI_SCK), 
		.AD_CONV(AD_CONV), 
		.AMP_SHDN(AMP_SHDN), 
		.din(din), 
		.ledy(ledy), 
		.wr_en(wr_en)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		AMP_DOUT = 0;
		AD_DOUT = 1;
		full = 0;

		// Wait 100 ns for global reset to finish
		#100;
       rst = 1;
		#10
			rst=0;
		// Add stimulus here
		
		forever
			#4
			AD_DOUT=~AD_DOUT;
		
							
		
	end
	initial begin
		clk =0;
		#112
     forever   begin
						#2 clk = ~clk;
							
		end
	end
			
		
endmodule

