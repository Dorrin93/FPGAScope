`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:03:04 09/30/2015
// Design Name:   REG_SPLITTER
// Module Name:   /home/lab_jos/KubaPawel/FPGAScope/regsplitter_tb.v
// Project Name:  FPGAScope
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: REG_SPLITTER
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module regsplitter_tb;

	// Inputs
	reg clk;
	reg rst;
	reg write;
	reg [31:0] adcReg;

	// Outputs
	wire enable;
	wire [7:0] register;

	// Instantiate the Unit Under Test (UUT)
	REG_SPLITTER uut (
		.clk(clk), 
		.rst(rst), 
		.write(write), 
		.adcReg(adcReg), 
		.enable(enable), 
		.register(register)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		write = 1;
		adcReg = 32'b01010111010010010100111000100000;

		// Wait 100 ns for global reset to finish
		
        
		// Add stimulus here

		
      #10
			rst=1;
		#10
			rst=0;
		
		// Add stimulus here
		#1000;
	end

	initial begin
		forever #1 clk = ~clk;
	end
	initial begin
		forever
			#10 write=~write;
     end
	 
endmodule

