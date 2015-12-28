`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:49:04 12/08/2015
// Design Name:   top
// Module Name:   /home/lab_jos/KubaPawel/FPGAScope/tb_topDivider.v
// Project Name:  FPGAScope
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_topDivider;

	// Inputs
	reg clk;
	reg rst;
	reg AMP_DOUT;
	reg AD_DOUT;

	// Outputs
	wire TXD;
	wire SPI_MOSI;
	wire AMP_CS;
	wire SPI_SCK;
	wire AD_CONV;
	wire AMP_SHDN;
	wire [7:0] ledy;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clk(clk), 
		.rst(rst), 
		.AMP_DOUT(AMP_DOUT), 
		.AD_DOUT(AD_DOUT), 
		.TXD(TXD), 
		.SPI_MOSI(SPI_MOSI), 
		.AMP_CS(AMP_CS), 
		.SPI_SCK(SPI_SCK), 
		.AD_CONV(AD_CONV), 
		.AMP_SHDN(AMP_SHDN), 
		.ledy(ledy)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		AMP_DOUT = 0;
		AD_DOUT = 0;

		// Wait 100 ns for global reset to finish
		#100;
      rst =1;
			#5
			rst=0;
		// Add stimulus here

	end
      
	initial begin #110
		forever #1 clk = ~clk;
	end
endmodule

