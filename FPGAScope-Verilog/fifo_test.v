`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:41:42 11/30/2015
// Design Name:   fifo
// Module Name:   /home/lab_jos/KubaPawel/FPGAScope/fifo_test.v
// Project Name:  FPGAScope
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: fifo
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module fifo_test;

	// Inputs
	reg clk;
	reg rst;
	reg [31:0] din;
	reg wr_en;
	reg rd_en;

	// Outputs
	wire [31:0] dout;
	wire full;
	wire empty;

	// Instantiate the Unit Under Test (UUT)
	fifo uut (
		.clk(clk), 
		.rst(rst), 
		.din(din), 
		.wr_en(wr_en), 
		.rd_en(rd_en), 
		.dout(dout), 
		.full(full), 
		.empty(empty)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		din = 0;
		
		

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

			forever begin
			#2 clk=~clk;
			end
		// Add stimulus here

	end
     initial begin
	  wr_en = 0;
	  rd_en =0;
	   #120
		wr_en=1;
		#4
		wr_en=0;
		#10 
		rd_en=1;
		#4
		rd_en=0;
	end
      
endmodule

