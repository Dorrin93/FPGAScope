`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:06:35 09/10/2015 
// Design Name: 
// Module Name:    adc_test 
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
module adc_test(clk,reset,spi_sck,amp_cs,spi_mosi,spi_miso,ad_conv,spi_ss_b,dac_cs,sf_ce0,fpga_init_b,amp_shdn,dac_clr,led);
 
input clk,reset;
input spi_miso;
 
output reg [7:0] led;
output reg spi_sck; 
output reg amp_cs;
output reg spi_mosi;
output reg ad_conv;
output reg amp_shdn;
output reg dac_clr;
 
output reg spi_ss_b;
output reg dac_cs;
output reg sf_ce0;
output reg fpga_init_b;
 
 
 
reg [6:0] counter;////count spi_sck for period 100 cycles
reg [4:0] counter2;////count spi_sck for period 20 cycles
reg [5:0] counter3;////count spi_sck for period 34 cycles
reg [4:0] state;
reg [1:0] state2;
reg [7:0] data;
reg [13:0] data_adc0;//assume from data to spi_miso first to test
reg [13:0] data_adc1;
reg [2:0] kire;
reg [3:0] kire_14bit;
reg [2:0] kire_adc;
 
reg [26:0] counter_led;
reg sclk;
 
reg [7:0] mem1 [0:255];// 8 bits memory with 16 location
reg [7:0] mem2 [0:255];// 8 bits memory with 16 location
reg [7:0] mem3 [0:255];// 8 bits memory with 16 location
reg [7:0] mem4 [0:255];// 8 bits memory with 16 location
reg [7:0] mem5 [0:255];// 8 bits memory with 16 location
reg [7:0] mem6 [0:255];// 8 bits memory with 16 location
 
reg [15:0] i1,i2,i3,i4,i5,i6;
 
integer m1,m2,m3,m4,m5,m6;
 
initial
begin
 
amp_cs<=1;
spi_sck=0;
counter<=0;
counter2<=0;
counter3<=0;
data=8'b00010001;
data_adc0=14'b0;
data_adc1=14'b0;
kire<=4'd7;
kire_adc<=4'd0;
kire_14bit<=4'd13;
ad_conv<=0;
led<=0;
end
 
always@(posedge clk or posedge reset)
begin
spi_ss_b<=1;
dac_cs<=1;
sf_ce0<=1;
fpga_init_b<=1;
amp_shdn<=0;
dac_clr<=0;
end
 
 
/////////////////////////counter//////////////////////////////////
always@(posedge clk or posedge reset)
begin
if(reset)
    begin
    counter<=0;
    end
else
    begin
        if(counter==7'd100)
            begin
            counter<=0;
            end
        else
            begin
            counter<=counter+1'b1;
            end
    end     
end
 
/////////////////////////counter2//////////////////////////////////
always@(posedge clk or posedge reset)
begin
if(reset)
    begin
    counter2<=0;
    end
else
    begin
        if(counter2==5'd20)
            begin
            counter2<=0;
            end
        else
            begin
            counter2<=counter2+1'b1;
            end
    end     
end
////////////////////////////for slow clock/////////////////////
 
 
always@(posedge clk or posedge reset)
begin
if(reset)
counter_led<=0;
else begin
if(counter_led==28'd5000000)
counter_led<=0;
else
counter_led<=counter_led+1;
end
end
 
 
always@(posedge clk or posedge reset)
begin
if(reset)
sclk=0;
else if(counter_led==28'd5000)
sclk=0;
else if(counter_led==28'd0)
sclk=1;
end
 
 
always@(posedge clk or posedge reset )
begin
if(reset)
    begin
    state<=0;
    end
else
    begin
        case(state)
        
        0:  
                    begin
                    amp_cs<=1;
                    ad_conv<=0;
                    kire<=4'd7;
                    kire_adc<=4'd0;
                    counter3<=6'd0;
                    if(counter==7'd20)
                    state<=1;
                    else
                    state<=0;
                    end
        
        1:  
                    begin
                    amp_cs<=0;
                    spi_sck<=0;
                    if(counter==7'd50)
                    state<=2;
                    else
                    state<=1;
                    end
        
 
        2:  
                    
                    begin
                    spi_sck<=1;
                    spi_mosi<=data[kire];//data for amplifier
                    if(counter==7'd100)
                    state<=3;
                    else
                    state<=2;
                    end
                            
                    
        3:   
 
                    begin
                    spi_sck<=0;
                    kire<=kire-1'b1;
                    if(kire==4'd0)
                    state<=4;
                    else
                    state<=1;
                    end
                    
        4:      
                    begin
                    amp_cs<=1;//disable first...amplifier
                    ad_conv<=1;
                    kire_adc<=kire_adc+1'b1;
                    if(kire_adc==4'd3)
                    state<=5;
                    else
                    state<=4;
                    end
                    
        5:          
                    begin
                    ad_conv<=0;
                    spi_sck<=0;
                    kire_adc<=kire_adc+1'b1;
                    if(kire_adc==4'd7)
                    state<=6;
                    else
                    state<=5;
                    end
                    
        6:
                    begin
                    kire_adc<=0;
                    counter3<=counter3+1'b1;
                    if(counter3==6'd2)
                    state<=9;
                    else
                  state<=7;
                    end 
                    
                    
        7:
                    begin
                    spi_sck<=1;
                    if(counter2==5'd10)
                    state<=8;
                    else
                    state<=7;
                    end
                    
        8:
                    begin
                    spi_sck<=0;
                    if(counter2==5'd20)
                    state<=6;
                    else
                    state<=8;
                   end
                    
        9:
        
                    begin
                    spi_sck<=1;
                    data_adc0[kire_14bit]<=spi_miso;
                    //spi_miso<=data_adc0[kire_14bit];
                    if(counter2==5'd10)
                    state<=10;
                    else
                    state<=9;
                    end
                    
        10: 
                    begin
                    spi_sck<=0;
                    if(counter2==5'd20)
                    state<=11;
                    else
                    state<=10;
                   end
                    
        11:
                    begin
                    kire_14bit<=kire_14bit-1'b1;
                    counter3<=counter3+1'b1;
                    if(kire_14bit==0)
                    state<=12;
                    else
                    state<=9;
                    end
        
        12:
                    begin
                    kire_14bit<=4'd13;
                    spi_sck<=1;
                    if(counter2==5'd10)
                    state<=13;
                    else
                    state<=12;
                    end
                    
        13:
                    begin
                    spi_sck<=0;
                    if(counter2==5'd20)
                    state<=14;
                    else
                    state<=13;
                   end
                    
        14:
                    begin
                    counter3<=counter3+1'b1;
                    if(counter3==6'd18)
                    state<=15;
                    else
                    state<=12;
                    end
                    
        15:
                    begin
                    
                    spi_sck<=1;
                    data_adc1[kire_14bit]<=spi_miso;
                    if(counter2==5'd10)
                    state<=16;
                    else
                    state<=15;
                    end
            
        16:         
                    begin
                    spi_sck<=0;
                    if(counter2==5'd20)
                    state<=17;
                    else
                    state<=16;
                   end
                    
        17:
                    begin
                    kire_14bit<=kire_14bit-1'b1;
                    counter3<=counter3+1'b1;
                    if(kire_14bit==0)
                    state<=18;
                    else
                    state<=15;
                    end 
 
        18:
                    begin
                    kire_14bit<=4'd13;
                    spi_sck<=1;
                    if(counter2==5'd10)
                    state<=19;
                    else
                    state<=18;
                    end
                    
        19:
                    begin
                    spi_sck<=0;
                    if(counter2==5'd20)
                    state<=20;
                    else
                    state<=19;
                   end
                    
        20:
                    begin
                    counter3<=counter3+1'b1;
                    if(counter3==6'd34)
                    state<=21;//state<=0;
                    else
                    state<=18;
                    end
        
        21:
                    begin
                    ad_conv<=0;
                    kire_adc<=kire_adc+1'b1;
                    if(kire_adc==4'd3)
                    state<=22;
                    else
                    state<=21;
                    end
                    
        22:         
                    begin
                    ad_conv<=1;
                    spi_sck<=0;
                    kire_adc<=kire_adc+1'b1;
                    if(kire_adc==4'd7)
                    state<=23;
                    else
                    state<=22;
                    end
                    
        23: 
                    begin
                    kire_adc<=0;
                    ad_conv<=0;
                    state<=0;
                    end
        endcase
    
    end     
end
 
//////////////////program untuk led run dgn slow clock/////////////////////////////
always@(posedge sclk or posedge reset)
begin
if(reset)
led<=0;
else
led<=data_adc0[13:6];
 
end
 
endmodule