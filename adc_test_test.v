`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:26:10 09/10/2015
// Design Name:   adc_test
// Module Name:   /home/lab_jos/KubaPawel/FPGAScope/adc_test_test.v
// Project Name:  FPGAScope
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: adc_test
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module adc_test_test;

	// Inputs
	reg clk;
	reg reset;
	reg spi_miso;

	// Outputs
	wire spi_sck;
	wire amp_cs;
	wire spi_mosi;
	wire ad_conv;
	wire spi_ss_b;
	wire dac_cs;
	wire sf_ce0;
	wire fpga_init_b;
	wire amp_shdn;
	wire dac_clr;
	wire [7:0] led;

	// Instantiate the Unit Under Test (UUT)
	adc_test uut (
		.clk(clk), 
		.reset(reset), 
		.spi_sck(spi_sck), 
		.amp_cs(amp_cs), 
		.spi_mosi(spi_mosi), 
		.spi_miso(spi_miso), 
		.ad_conv(ad_conv), 
		.spi_ss_b(spi_ss_b), 
		.dac_cs(dac_cs), 
		.sf_ce0(sf_ce0), 
		.fpga_init_b(fpga_init_b), 
		.amp_shdn(amp_shdn), 
		.dac_clr(dac_clr), 
		.led(led)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		spi_miso = 0;
		
		
		#5 reset = 1;
		#50 reset = 0;
        
	end
	
	initial begin
		forever #2 clk = ~clk;
	end
	
	initial begin
		forever #20 spi_miso = ~spi_miso;
	end
	
	initial #1150 $finish;
      
endmodule

