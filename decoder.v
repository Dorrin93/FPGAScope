`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:43:02 01/23/2015 
// Design Name: 
// Module Name:    decoder 
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
module decoder(
	 input write, clk,rst,
    input [7:0] data,
	 output [127:0] outData
    );
	reg[127:0] register;
	reg[7:0] dataTmp;
	always @(posedge clk,posedge rst)
		if(rst)
			register={16{8'd32}};
		else if(write && data==8'h66)
			register={8'd32,register[127:8]};
		else if(write && data==8'h5a)
			register={16{8'd32}};
		else if(write)
			register={register[119:0],dataTmp};
	always @* begin
		case(data)
				8'h42://k
					dataTmp<=8'b01001011;
				8'h3c://u
					dataTmp<=8'b01010101;
				8'h32://b
					dataTmp<=8'b01000010;
				8'h1c://a
					dataTmp<=8'b01000001;
				8'h2c://t
					dataTmp<=8'b01010100;
				8'h1b://s
					dataTmp<=8'b01010011;
				8'h1a://z
					dataTmp<=8'b01011010;
				8'h15://q
					dataTmp<=8'b01010001;
				8'h1d://w
					dataTmp<=8'b01010111;
				8'h24://e
					dataTmp<=8'b01000101;
				8'h2d://r
					dataTmp<=8'b01010010;
				8'h35://y
					dataTmp<=8'd89;
				8'h43://i
					dataTmp<=8'd73;
				8'h44://o
					dataTmp<=8'd79;
				8'h4d://p
					dataTmp<=8'd80;
				8'h23://d
					dataTmp<=8'd68;
				8'h2b://f
					dataTmp<=8'd70;
				8'h34://g
					dataTmp<=8'd71;
				8'h33://h
					dataTmp<=8'd72;
				8'h3b://j
					dataTmp<=8'd74;
				8'h4b://l
					dataTmp<=8'd76;
				8'h22://x
					dataTmp<=8'd88;
				8'h2a://v
					dataTmp<=8'd86;
				8'h31://n
					dataTmp<=8'd78;
				8'h3a://m
					dataTmp<=8'd77;
				8'h21://c
					dataTmp<=8'd67;
				8'h29://space
					dataTmp<=8'd32;
				8'h16://1
					dataTmp<=8'd49;
				8'h1e://2
					dataTmp<=8'd50;
				8'h26://3
					dataTmp<=8'd51;
				8'h25://4
					dataTmp<=8'd52;
				8'h2e://5
					dataTmp<=8'd53;
				8'h36://6
					dataTmp<=8'd54;
				8'h3d://7
					dataTmp<=8'd55;
				8'h3e://8
					dataTmp<=8'd56;
				8'h46://9
					dataTmp<=8'd57;
				8'h45://0
					dataTmp<=8'd48;
				//8'h5a://enter - nie lapie nie drukowalnych
			//		dataTmp<=8'd10;
				default:
					dataTmp<=8'd57;//32
					
		endcase
	end
		
assign outData=register;
			
endmodule
