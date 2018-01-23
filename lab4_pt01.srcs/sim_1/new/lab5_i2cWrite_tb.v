`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2017 01:32:31 PM
// Design Name: 
// Module Name: lab5_i2cWrite_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module lab5_i2cWrite_tb(

    );

reg [31:0] ep04data;
    
reg clkHalf;   
reg i2cClk;    
reg i2cDriver_start;

wire [7:0] i2cDriver_DIn;
wire [1:0] i2cDInAddr   ;
wire       i2cDIn_clk   ;
 
reg [6:0] ep00data;
reg [7:0] ep01data;
reg [7:0]  ep03data;
reg [3:0] ep02data; 

wire i2cDriver_ready;

wire I2C_SCL_0;
reg I2C_SDA0_in;
wire I2C_SDA0_out;   

wire [7:0] i2cDriver_DOut;
wire [3:0] i2cDOutAddr;
wire [7:0] ep22data;
 //i2c driver                       
i2c_driver i2c_driver(
                .clk(i2cClk),         //input               clk,
                .start(i2cDriver_start),     //input               start,
                
                
//                 .dataIn(0),         //input   [7:0]       dataIn,
//                 .dataInClk(0),      //input               dataInClk,
//                 .dataInAddr(0),     //input   [3:0]       dataInAddr,
                
                
                .dataIn(i2cDriver_DIn),         //input   [7:0]       dataIn,
                .dataInClk(i2cDIn_clk),      //input               dataInClk,
                .dataInAddr({2'b0,i2cDInAddr}),     //input   [3:0]       dataInAddr,
                
                
                
                .deviceAddr(ep00data [6:0]),     //input   [7:0]       deviceAddr,
                .registAddr(ep01data [7:0]),     //input   [7:0]       registAddr,
                .readWriteB(ep03data[0] ),     //input               readWriteB,
                .byteCount(ep02data[3:0]),      //input   [3:0]       byteCount,      //Send the X most recent bytes, in order of being input
                                     //
                .flag_ready(i2cDriver_ready),     //output  reg         flag_ready,     //i2c has finished
                .flag_valid(),     //output              flag_valid,
                                      //
                .dataOut(i2cDriver_DOut),        //output  reg  [7:0]  dataOut,
                .dOutAddr(i2cDOutAddr),       //input        [3:0]  dOutAddr,
                .flag_ACKb(ep22data[0]),      //output  reg         flag_ACKb,
                                       //
                .SCL(I2C_SCL_0),            //output              SCL,
                .SDA_in(I2C_SDA0_in),         //input               SDA_in,
                .SDA_out(I2C_SDA0_out)         //output              SDA_out
                ); 
                
                
    
    
    
//The order is because i2c write: sends 
    mux4to1_withAddr i2cDriverDataMux(
             .enable(1),            //input   enable,
             .clk(clkHalf),               //input   clk,
                          //
             .in0(ep04data[7:0]),         //input   [7:0] in0,
             .in1(ep04data[15:8]),         //input   [7:0] in1,
             .in2(ep04data[23:16]),         //input   [7:0] in2,
             .in3(ep04data[31:24]),         //input   [7:0] in3,
                                //
             .out0(i2cDriver_DIn),    //output  reg [7:0] out0,  
             .outAddr(i2cDInAddr), //output  reg [1:0] outAddr,  
             .clkb(i2cDIn_clk)           //output  reg clkb      
         );   
    
    
    
    
    
    
    
    
    
    
    
    
    
    



////////
initial begin
    clkHalf = 0;
    i2cClk = 0;
    
    I2C_SDA0_in = 0;
    ep00data = 7'h48;
    ep01data = 8'h0F;
    ep02data = 4'h4;
    ep03data = 0;
    ep04data = 32'h44332211;
    
    #100
    i2cDriver_start = 1;
    #50
    i2cDriver_start = 0;
    
end


//////
always begin
    #5
        clkHalf = ~clkHalf;
end

always begin
    #2.5
        i2cClk = ~i2cClk;
end
    
    
    
endmodule
