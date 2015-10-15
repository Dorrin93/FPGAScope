`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:45:24 09/09/2015 
// Design Name: 
// Module Name:    ADC 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ADC(
    input clk, rst, AMP_DOUT, AD_DOUT,
	 output reg SPI_MOSI, AMP_CS, SPI_SCK, AD_CONV,
	 output [31:0] adcReg,
	 output [7:0] ledy
    );
	 localparam init=4'd0,
	 write1=4'd1, //SPI_SCK niski
	 write2=4'd2, //SPI_SCK wysoki
	 incrementGain=4'd3,
	 write3 = 4'd4, //tutaj czekamy 20ns
	 endWrite=4'd5, //amplifier write skonczony
	 startRead=4'd6, //start odczytu z ADC
	 wait1=4'd7, //przepuszczamy 2 bity niski
	 wait2=4'd8, //wysoki
	 read1=4'd9, //read wysoki, czekamy na wyjscie
	 read2=4'd10, //read wysoki, odczyt
	 read3=4'd12, //read niski\
	 incrementOutReg=4'd11,
	 endRead1=4'd13,
	 endRead2=4'd14,
	// finish=5'd15,
	 incrementWait=4'd15;
	 
	 
	 reg after;
	 reg [3:0] st;
	 reg [3:0] nst;
	 
	 reg [2:0] counter6;
	 reg [5:0] counter10;
	 reg [3:0] counter10_2;
	 reg [4:0] counter20;
	 reg [4:0] counter30;
	 reg [5:0] counter50;
	 reg echoRegOut;
	 reg outRegReady,reset50,reset30,reset20,incRegIndex,resetOutReg,resetGain,resetWait,incGain,incWait,reset6,reset10,reset10_2;
	 reg [7:0] GAIN;
	 reg [2:0] indexGain;
	 
	 reg [7:0] echoReg;
	 reg [29:0] outReg;
	 reg [5:0] outRegIndex;
	 
	 reg [1:0] indexWait;
	 
	 //reg setGain;
	 /////////////////////GAIN
	 always @(posedge clk, posedge rst)
		if(rst) begin
			GAIN<=8'b00010001; /// 
			//indexGain<=0;
		end
		
	 /////////////////////STANY
	 always @(posedge clk, posedge rst)
		if(rst) begin
			st<=init;
		end
		else
			st<=nst;
	 ////////////////////Licznik 30 dla amplifier
	 always @(posedge clk, posedge rst)
		if(rst)
			counter30<=5'd30;
		else if(counter30==0 || reset30)
			counter30<=5'd30;
		else
			counter30<=counter30-1;
	//////////////////////		
	 always @(posedge clk, posedge rst)
		if(rst)
			counter50<=6'd50;
		else if(counter50==0 || reset50)
			counter50<=6'd50;
		else
			counter50<=counter50-1;
	//////////////////////
	 always @(posedge clk, posedge rst)
		if(rst)
			counter20<=5'd20;
		else if(counter20==0 || reset20)
			counter20<=5'd20;
		else
			counter20<=counter20-1;
	 //////////////////////
	 always @(posedge clk, posedge rst)
		if(rst)
			counter10<=6'd63;
		else if(counter10==0 || reset10)
			counter10<=6'd63;
		else
			counter10<=counter10-1;
	always @(posedge clk, posedge rst)
		if(rst)
			counter10_2<=4'd10;
		else if(counter10_2==0 ||reset10_2)
			counter10_2<=4'd10;
		else
			counter10_2<=counter10_2-1;
	 always @(posedge clk, posedge rst)
		if(rst)
			counter6<=3'd6;
		else if(counter6==0 || reset6)
			counter6<=3'd6;
		else
			counter6<=counter6-3'd1;
	 always @(posedge clk, posedge rst)
		if(rst)
			outRegIndex<=5'd0;
		else if(resetOutReg)
			outRegIndex<=5'd0;
		else if(incRegIndex)
			outRegIndex<=outRegIndex+5'd1;
	always @(posedge clk, posedge rst)
		if(rst)
			indexGain<=5'd0;
		else if(resetGain)
			indexGain<=5'd0;
		else if(incGain)
			indexGain<=indexGain+5'd1;
	always @(posedge clk, posedge rst)
		if(rst)
			indexWait<=5'd0;
		else if(resetWait)
			indexWait<=5'd0;
		else if(incWait)
			indexWait<=indexWait+5'd1;

	 /////MASZYNA STANOW ASYNCHRONICZNA
	 always @* begin
		nst=init;
		SPI_SCK=0;
		AMP_CS=1;
		reset30=0;
		reset50=0;
		reset20=0;
		reset10=0;
		reset10_2=0;
		reset6=0;
		resetOutReg=0;
		incRegIndex=0;
		incWait=0;
		incGain=0;
		resetGain=0;
		resetWait=0;
		AD_CONV=0;
		outRegReady=0;
		echoRegOut=0;
		SPI_MOSI=GAIN[indexGain];
		case(st)
			init : begin
				after=0;
				resetGain=1;
				reset30=1;
				nst=write1;
			end
			write1: begin
				after=0;
				AMP_CS=0;
				reset50=1;
				nst=counter30 ? write1 : write2;
			end
			write2: begin
				reset50=0;
				AMP_CS=0;
				SPI_SCK=1;
				after=0;
				echoRegOut=1;
				nst = counter50 ? write2 : (indexGain==3'd7) ? endWrite : incrementGain;

			end
			incrementGain: begin
				reset20=1;
				AMP_CS=0;
				nst=write3;
				incGain=1;
				after=0;
			end
			write3: begin
				reset30=1;
				reset20=0;
				after=0;
				AMP_CS=0;
				nst = counter20 ? write3 : write1 ;
			end
			endWrite: begin
				AMP_CS=1;
				resetWait=1;
				after=0;
				reset10=1;
				nst=counter30 ? endWrite : startRead;
			end
			startRead: begin
				AD_CONV=1;
				after=0;
				reset6=1;
				resetWait=1;
				nst=counter10 ? startRead : wait1;
			end
			wait1 : begin
				after=0;
				reset10_2=1;
				nst = counter6 ? wait1 : indexWait==3'd2 ? read1 : incrementWait;
			end
			incrementWait: begin
				incWait=1;
				reset20=1;
				nst=~after ? wait2 : endRead2;
				after=0;
			end
			wait2 : begin
				SPI_SCK=1;
				reset20=0;
				after=0;
				nst = counter20 ? wait2 : wait1;
			end
			read1: begin
				AD_CONV=0;
				SPI_SCK=1;
				after=0;
				reset6=1;
				nst=counter10_2 ? read1 : read2; 
			end
			read2: begin
				AD_CONV=0;
				after=0;
				outRegReady=1;
				SPI_SCK=1;
				nst = counter6 ? read2 : incrementOutReg;
			end
			incrementOutReg: begin
				AD_CONV=0;
				after=0;
				incRegIndex=1;
				reset10=1;
				nst=read3;
			end
			read3: begin
				AD_CONV=0;
				reset20=1;
				reset10_2=1;
				
				after=0;
				nst = counter10 ? read3 : outRegIndex==5'd30 ? endRead1 : read1;
			end
			endRead1: begin
				after=1;
				SPI_SCK=1;
				reset20=1;
				nst = counter10_2 ? endRead1 : incrementWait;
			end
			endRead2: begin
				reset30=1;
				after=0;
				resetOutReg=1;
				nst = counter20 ? endRead2 : indexWait==3'd0 ? endWrite : endRead1;
			end
			
		endcase
	end
	
	always@(posedge clk, posedge rst) begin
		if(rst)
			echoReg<=8'b0;
		else if (echoRegOut)
			echoReg[indexGain]<=AMP_DOUT;
	end
	always@(posedge clk, posedge rst) begin
		if(rst)
			outReg<=30'b0100100001001110;
		//else if (outRegReady)
			//outReg[outRegIndex]<=AD_DOUT;
	end
	/*
	reg [7:0] tmp;
	always@(posedge clk, posedge rst) begin
		if(rst)
			tmp<=8'd0;
		else if (~AMP_CS)
			tmp<=8'd0;
		else if (AD_DOUT)
			tmp<=tmp+1;
	end
	*/
	assign adcReg = outReg;
	assign ledy = echoReg;
	
endmodule
