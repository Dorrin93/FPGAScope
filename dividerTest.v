`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:50:10 12/08/2015
// Design Name:   clockDivider
// Module Name:   /home/lab_jos/KubaPawel/FPGAScope/dividerTest.v
// Project Name:  FPGAScope
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clockDivider
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module dividerTest;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire outclk;

	// Instantiate the Unit Under Test (UUT)
	clockDivider uut (
		.clk(clk), 
		.rst(rst), 
		.outclk(outclk)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#100;
        rst=1;
		  #5
		  rst=0;
		// Add stimulus here

	end
     initial begin #120
		forever #1 clk = ~clk;
	end
endmodule

