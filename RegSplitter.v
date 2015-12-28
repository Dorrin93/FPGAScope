`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:20:55 11/26/2015
// Design Name:   REG_SPLITTER
// Module Name:   /home/lab_jos/KubaPawel/FPGAScope/RegSplitter.v
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

module RegSplitter;

	// Inputs
	reg clk;
	reg rst;
	reg sendingData;
	reg newData;
	reg write;
	reg [31:0] adcReg;

	// Outputs
	wire enable;
	wire [7:0] register;
	wire dataReceived;

	// Instantiate the Unit Under Test (UUT)
	REG_SPLITTER uut (
		.clk(clk), 
		.rst(rst), 
		.sendingData(sendingData), 
		.newData(newData), 
		.write(write), 
		.adcReg(adcReg), 
		.enable(enable), 
		.register(register), 
		.dataReceived(dataReceived)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		sendingData = 0;
		newData = 0;
		write = 0;
		adcReg = 0;

		// Wait 100 ns for global reset to finish
		
		#100;
			rst=1;
			
		#20
			rst=0;
      forever begin
			#2 clk=~clk;
			end
		// Add stimulus here

	end
      
	initial begin
	   #100
		forever begin #100 write = ~write;
						#100 write = ~write;
						end
	end
endmodule

