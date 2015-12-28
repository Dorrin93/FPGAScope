`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:26:30 09/17/2015
// Design Name:   UART
// Module Name:   /home/lab_jos/KubaPawel/FPGAScope/UART_TEST.v
// Project Name:  FPGAScope
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: UART
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module UART_TEST;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire TXD;

	// Instantiate the Unit Under Test (UUT)
	UART uut (
		.clk(clk), 
		.rst(rst), 
		.TXD(TXD)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		
		// Wait 100 ns for global reset to finish
		#100;
      #10
			rst=1;
		#10
			rst=0;
		// Add stimulus here

	end
	initial begin
		forever #2 clk = ~clk;
	end
      
endmodule

